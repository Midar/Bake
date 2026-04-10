#import "Bake.h"
#import "Compiler.h"
#import "DependencySolver.h"
#import "ObjCCompiler.h"
#import "Target.h"
#import "IngredientProducer.h"

#import "CompilationFailedException.h"
#import "LinkingFailedException.h"
#import "MissingDependencyException.h"
#import "MissingIngredientException.h"
#import "WrongVersionException.h"

OF_APPLICATION_DELEGATE(Bake)

@implementation Bake
- (void)applicationDidFinishLaunching: (OFNotification *)notification
{
	OFFileManager *fileManager = [OFFileManager defaultManager];
	OFArray *arguments;
	OFSet *conditions;
	DependencySolver *dependencySolver;
	bool install;
	OFString *prefix = @"/usr/local";
	OFString *bindir = [prefix stringByAppendingString: @"/bin"];

	arguments = [OFApplication arguments];
	install = [arguments containsObject: @"--install"];

	if ([arguments containsObject: @"--produce-ingredient"]) {
		IngredientProducer *producer =
		    [[IngredientProducer alloc] init];

		for (OFString *argument in arguments)
			if (![argument isEqual: @"--produce-ingredient"])
				[producer parseArgument: argument];

		[OFStdOut writeLine:
		    [[producer ingredient] JSONRepresentation]];

		[OFApplication terminate];
	}

	[self findRecipe];

	@try {
		_recipe = [[Recipe alloc] init];
	} @catch (OFOpenItemFailedException *e) {
		[OFStdErr writeLine: @"Error: Could not find Recipe!"];
		[OFApplication terminateWithStatus: 1];
	} @catch (OFInvalidJSONException *e) {
		[OFStdErr writeFormat: @"Error: Malformed Recipe in line "
				       @"%zd!\n", [e line]];
		[OFApplication terminateWithStatus: 1];
	} @catch (WrongVersionException *e) {
		[OFStdErr writeLine: @"Error: Recipe version too new!"];
		[OFApplication terminateWithStatus: 1];
	}

	// FIXME
	conditions = [OFSet setWithObjects: @"objc_gcc_compatible",
					    @"true",
					    nil];

	_verbose = ([arguments containsObject: @"--_verbose"] ||
	    [arguments containsObject: @"-v"]);
	_rebake = ([arguments containsObject: @"--rebake"] ||
	    [arguments containsObject: @"-r"]);

	dependencySolver = [[[DependencySolver alloc] init] autorelease];

	for (Target *target in [_recipe targets])
		[dependencySolver addTarget: target];

	@try {
		[dependencySolver solve];
	} @catch (MissingDependencyException *e) {
		[OFStdErr writeFormat: @"Error: Target %@ is missing, but "
				       @"specified as dependency!\n",
				       [e dependencyName]];
		[OFApplication terminateWithStatus: 1];
	}

	for (Target *target in [dependencySolver targetOrder]) {
		size_t i = 0;
		bool link = false;

		[target resolveConditionals: conditions];

		@try {
			[target addIngredients];
		} @catch (MissingIngredientException *e) {
			[OFStdErr writeFormat: @"Error: Ingredient %@ "
					       @"missing!\n",
					       [e ingredientName]];
			[OFApplication terminateWithStatus: 1];
		}

		for (OFString *file in [target files]) {
			if (![self shouldRebuildFile: file
					      target: target]) {
				i++;
				continue;
			}

			link = true;

			if (!_verbose)
				[OFStdOut writeFormat: @"\r%@: %zd/%zd",
						       [target name], i,
						       [[target files] count]];

			@try {
				Compiler *compiler =
				    [Compiler compilerForFile: file
						       target: target];

				[compiler compileFile: file
					       target: target];
			} @catch (CompilationFailedException *e) {
				[OFStdOut writeString: @"\n"];
				[OFStdErr writeFormat:
				    @"Failed to compile file %@!\n"
				    @"Command was:\n%@\n", file, [e command]];
				[OFApplication terminateWithStatus: 1];
			}

			i++;

			if (!_verbose)
				[OFStdOut writeFormat: @"\r%@: %zd/%zd",
						       [target name], i,
						       [[target files] count]];
		}

		if (link || ([[target files] count] > 0 &&
		    ![fileManager fileExistsAtPath:
		    [[ObjCCompiler sharedCompiler]
		    outputFileForTarget: target]])) {
			if (!_verbose)
				[OFStdOut writeFormat:
				    @"\r%@: %zd/%zd (linking)",
				    [target name], i, [[target files] count]];

			@try {
				/*
				 * FIXME: Need to find out which compiler a
				 *	  target needs to link!
				 */
				[[ObjCCompiler sharedCompiler]
				    linkTarget: target
				    extraFlags: nil];
			} @catch (LinkingFailedException *e) {
				[OFStdOut writeString: @"\n"];
				[OFStdErr writeFormat:
				    @"Failed to link target %@!"
				    @"Command was:\n%@\n",
				    [target name], [e command]];
				[OFApplication terminateWithStatus: 1];
			}

			if (!_verbose)
				[OFStdOut writeFormat:
				    @"\r%@: %zd/%zd (successful)\n",
				    [target name], i, [[target files] count]];
		} else
			[OFStdOut writeFormat: @"%@: Already up to date\n",
					       [target name]];

		if (install && [[target files] count] > 0) {
			OFString *file = [[ObjCCompiler sharedCompiler]
			    outputFileForTarget: target];
			OFString *destination = [bindir
			    stringByAppendingPathComponent:
			    [file lastPathComponent]];

			[OFStdOut writeFormat: @"Installing: %@ -> %@\n",
					       file, destination];

			if (![fileManager directoryExistsAtPath: bindir])
				[fileManager createDirectoryAtPath: bindir
						     createParents: true];

			[fileManager copyItemAtPath: file
					     toPath: destination];
		}
	}

	[OFApplication terminate];
}

- (void)findRecipe
{
	OFFileManager *fileManager = [OFFileManager defaultManager];
	OFString *oldPath = [fileManager currentDirectoryPath];

	while (![fileManager fileExistsAtPath: @"Recipe"]) {
		// FIXME
		[fileManager changeCurrentDirectoryPath: @".."];

		/* We reached the file system root */
		if ([[fileManager currentDirectoryPath] isEqual: oldPath])
			break;

		oldPath = [fileManager currentDirectoryPath];
	}
}

- (bool)shouldRebuildFile: (OFString*)file
		   target: (Target*)target
{
	OFFileManager *fileManager = [OFFileManager defaultManager];
	Compiler *compiler;
	OFString *objectFile;
	OFDate *sourceDate, *objectDate;

	if (_rebake)
		return true;

	compiler = [Compiler compilerForFile: file
				      target: target];
	objectFile = [compiler objectFileForSource: file
					    target: target];

	if (![fileManager fileExistsAtPath: objectFile])
		return true;

	sourceDate = [[fileManager attributesOfItemAtPath: file]
	    fileModificationDate];
	objectDate = [[fileManager attributesOfItemAtPath: objectFile]
	    fileModificationDate];

	return ([objectDate compare: sourceDate] == OFOrderedAscending);
}

- (bool)verbose
{
	return _verbose;
}
@end

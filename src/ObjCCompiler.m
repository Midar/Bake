#import "ObjCCompiler.h"
#import "Bake.h"

#import "CompilationFailedException.h"
#import "LinkingFailedException.h"

static ObjCCompiler *sharedCompiler = nil;

@implementation ObjCCompiler
+ sharedCompiler
{
	if (sharedCompiler == nil)
		sharedCompiler = [[ObjCCompiler alloc] init];

	return sharedCompiler;
}

- init
{
	self = [super init];

	_program = @"clang";

	return self;
}

- (void)compileFile: (OFString*)file
	     target: (Target*)target
{
	OFFileManager *fileManager = [OFFileManager defaultManager];
	OFMutableString *command = [OFMutableString stringWithFormat: @"%@ -c",
								      _program];
	OFString *objectFile = [self objectFileForSource: file
						  target: target];
	OFString *dir = [objectFile stringByDeletingLastPathComponent];

	if (![fileManager directoryExistsAtPath: dir])
		[fileManager createDirectoryAtPath: dir
				     createParents: true];

	if ([target debug])
		[command appendString: @" -g"];

	if ([target includeDirs] != nil && [[target includeDirs] count] > 0) {
		[command appendString: @" -I"];
		[command appendString:
		    [[target includeDirs] componentsJoinedByString: @" -I"]];
	}

	if ([target defines] != nil && [[target defines] count] > 0) {
		[command appendString: @" -D"];
		[command appendString:
		    [[target defines] componentsJoinedByString: @" -D"]];
	}

	if ([target objCFlags] != nil) {
		[command appendString: @" "];
		[command appendString:
		    [[target objCFlags] componentsJoinedByString: @" "]];
	}

	[command appendFormat: @" -o %@ %@", objectFile, file];

	if ([(Bake*)[[OFApplication sharedApplication] delegate] verbose])
		[OFStdOut writeLine: command];

	if (system([command cStringWithEncoding: [OFLocale encoding]]))
		@throw [CompilationFailedException
		    exceptionWithCommand: command];
}

- (void)linkTarget: (Target*)target
	extraFlags: (OFString*)extraFlags
{
	OFFileManager *fileManager = [OFFileManager defaultManager];
	OFMutableString *command = [OFMutableString stringWithString: _program];
	OFString *outputFile = [self outputFileForTarget: target];
	OFString *dir = [outputFile stringByDeletingLastPathComponent];

	if (![fileManager directoryExistsAtPath: dir])
		[fileManager createDirectoryAtPath: dir
				     createParents: true];

	if ([target debug])
		[command appendString: @" -g"];

	if (extraFlags != nil) {
		[command appendString: @" "];
		[command appendString: extraFlags];
	}

	[command appendFormat: @" -o %@", outputFile];

	for (OFString *file in [target files]) {
		[command appendString: @" "];
		[command appendString:
		    [self objectFileForSource: file
				       target: target]];
	}

	if ([target libDirs] != nil && [[target libDirs] count] > 0) {
		[command appendString: @" -L"];
		[command appendString:
		    [[target libDirs] componentsJoinedByString: @" -L"]];
	}

	if ([target libs] != nil && [[target libs] count] > 0) {
		[command appendString: @" -l"];
		[command appendString:
		    [[target libs] componentsJoinedByString: @" -l"]];
	}

	if ([(Bake*)[[OFApplication sharedApplication] delegate] verbose])
		[OFStdOut writeLine: command];

	if (system([command cStringWithEncoding: [OFLocale encoding]]))
		@throw [LinkingFailedException exceptionWithCommand: command];
}
@end

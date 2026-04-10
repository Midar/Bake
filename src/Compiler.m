#import "Compiler.h"
#import "ObjCCompiler.h"

@implementation Compiler
+ (Compiler *)compilerForFile: (OFString *)file target: (OFString *)target
{
	if ([file hasSuffix: @".m"])
		return [ObjCCompiler sharedCompiler];

	return nil;
}

- (OFString *)objectFileForSource: (OFString *)file target: (Target *)target
{
	return [OFString pathWithComponents: [OFArray arrayWithObjects:
	    @"pastries", target.name, [file stringByAppendingString: @".o"],
	    nil]];
}

- (OFString *)outputFileForTarget: (Target *)target
{
	return [OFString pathWithComponents: [OFArray arrayWithObjects:
	    @"pastries", target.name, target.name.lastPathComponent, nil]];
}

- (void)compileFile: (OFString *)file target: (Target *)target
{
	OF_UNRECOGNIZED_SELECTOR
}

- (void)linkTarget: (Target *)target extraFlags: (OFString *)extraFlags
{
	OF_UNRECOGNIZED_SELECTOR
}
@end

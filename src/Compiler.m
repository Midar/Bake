#import "Compiler.h"
#import "ObjCCompiler.h"

@implementation Compiler
+ (Compiler*)compilerForFile: (OFString*)file
		      target: (OFString*)target
{
	if ([file hasSuffix: @".m"])
		return [ObjCCompiler sharedCompiler];

	return nil;
}

- (OFString*)objectFileForSource: (OFString*)file
			  target: (Target*)target
{
	file = [file stringByAppendingString: @".o"];
	return [OFString pathWithComponents: [OFArray arrayWithObjects:
	    @"pastries", [target name], file, nil]];
}

- (OFString*)outputFileForTarget: (Target*)target
{
	OFString *last = [[target name] lastPathComponent];
	return [OFString pathWithComponents: [OFArray arrayWithObjects:
	    @"pastries", [target name], last, nil]];
}

- (void)compileFile: (OFString*)file
	     target: (Target*)target
{
	OF_UNRECOGNIZED_SELECTOR
}

- (void)linkTarget: (Target*)target
	extraFlags: (OFString*)extraFlags
{
	OF_UNRECOGNIZED_SELECTOR
}
@end

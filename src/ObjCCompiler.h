#import "Compiler.h"

@interface ObjCCompiler: Compiler
{
	OFString *_program;
}

+ sharedCompiler;
@end

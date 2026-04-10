#import "Compiler.h"

@interface ObjCCompiler: Compiler
{
	OFString *_program;
}

+ (instancetype)sharedCompiler;
@end

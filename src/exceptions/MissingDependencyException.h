#import <ObjFW/ObjFW.h>

@interface MissingDependencyException: OFException
{
	OFString *_dependencyName;
}

@property (readonly, copy, nonatomic) OFString *dependencyName;

+ (instancetype)exceptionWithDependencyName: (OFString *)dependencyName;
- (instancetype)initWithDependencyName: (OFString *)dependencyName;
@end

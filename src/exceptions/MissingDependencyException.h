#import <ObjFW/ObjFW.h>

@interface MissingDependencyException: OFException
{
	OFString *_dependencyName;
}

@property (readonly, copy, nonatomic) OFString *dependencyName;

+ exceptionWithDependencyName: (OFString*)dependencyName;
- initWithDependencyName: (OFString*)dependencyName;
@end

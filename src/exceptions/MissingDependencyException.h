#import <ObjFW/ObjFW.h>

@interface MissingDependencyException: OFException
{
	OFString *_dependencyName;
}

+ exceptionWithDependencyName: (OFString*)dependencyName;
- initWithDependencyName: (OFString*)dependencyName;
- (OFString*)dependencyName;
@end

#import "MissingDependencyException.h"

@implementation MissingDependencyException
+ exceptionWithDependencyName: (OFString*)dependencyName
{
	return [[[self alloc] initWithDependencyName: dependencyName]
	    autorelease];
}

- initWithDependencyName: (OFString*)dependencyName_
{
	self = [super init];

	@try {
		dependencyName = [dependencyName_ copy];
	} @catch (id e) {
		[self release];
		@throw e;
	}

	return self;
}

- init
{
	OF_INVALID_INIT_METHOD
}

- (void)dealloc
{
	[dependencyName release];

	[super dealloc];
}

- (OFString*)dependencyName
{
	return dependencyName;
}
@end

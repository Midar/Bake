#import "MissingDependencyException.h"

@implementation MissingDependencyException
+ exceptionWithDependencyName: (OFString*)dependencyName
{
	return [[[self alloc] initWithDependencyName: dependencyName]
	    autorelease];
}

- initWithDependencyName: (OFString*)dependencyName
{
	self = [super init];

	@try {
		_dependencyName = [dependencyName copy];
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
	[_dependencyName release];

	[super dealloc];
}

- (OFString*)dependencyName
{
	return _dependencyName;
}
@end

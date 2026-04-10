#import "MissingDependencyException.h"

@implementation MissingDependencyException
@synthesize dependencyName = _dependencyName;

+ (instancetype)exceptionWithDependencyName: (OFString *)dependencyName
{
	return [[[self alloc] initWithDependencyName: dependencyName]
	    autorelease];
}

- (instancetype)initWithDependencyName: (OFString *)dependencyName
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

- (instancetype)init
{
	OF_INVALID_INIT_METHOD
}

- (void)dealloc
{
	[_dependencyName release];

	[super dealloc];
}
@end

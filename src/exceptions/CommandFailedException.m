#import "CommandFailedException.h"

@implementation CommandFailedException
@synthesize command = _command;

+ (instancetype)exceptionWithCommand: (OFString *)command
{
	return [[[self alloc] initWithCommand: command] autorelease];
}

- (instancetype)initWithCommand: (OFString *)command
{
	self = [super init];

	@try {
		_command = [command copy];
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
	[_command release];

	[super dealloc];
}
@end

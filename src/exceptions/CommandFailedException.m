#import "CommandFailedException.h"

@implementation CommandFailedException
+ exceptionWithCommand: (OFString*)command
{
	return [[[self alloc] initWithCommand: command] autorelease];
}

- initWithCommand: (OFString*)command
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

- init
{
	OF_INVALID_INIT_METHOD
}

- (void)dealloc
{
	[_command release];

	[super dealloc];
}

- (OFString*)command
{
	return _command;
}
@end

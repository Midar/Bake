#import "CommandFailedException.h"

@implementation CommandFailedException
+ exceptionWithCommand: (OFString*)command
{
	return [[[self alloc] initWithCommand: command] autorelease];
}

- initWithCommand: (OFString*)command_
{
	self = [super init];

	@try {
		command = [command_ copy];
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
	[command release];

	[super dealloc];
}

- (OFString*)command
{
	return command;
}
@end

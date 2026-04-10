#import <ObjFW/ObjFW.h>

@interface CommandFailedException: OFException
{
	OFString *_command;
}

+ exceptionWithCommand: (OFString*)command;
- initWithCommand: (OFString*)command;
- (OFString*)command;
@end

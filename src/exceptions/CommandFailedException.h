#import <ObjFW/ObjFW.h>

@interface CommandFailedException: OFException
{
	OFString *command;
}

+ exceptionWithCommand: (OFString*)command;
- initWithCommand: (OFString*)command;
- (OFString*)command;
@end

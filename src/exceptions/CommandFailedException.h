#import <ObjFW/ObjFW.h>

@interface CommandFailedException: OFException
{
	OFString *_command;
}

@property (readonly, copy, nonatomic) OFString *command;

+ exceptionWithCommand: (OFString*)command;
- initWithCommand: (OFString*)command;
@end

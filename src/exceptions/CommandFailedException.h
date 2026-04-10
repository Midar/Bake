#import <ObjFW/ObjFW.h>

@interface CommandFailedException: OFException
{
	OFString *_command;
}

@property (readonly, copy, nonatomic) OFString *command;

+ (instancetype)exceptionWithCommand: (OFString *)command;
- (instancetype)initWithCommand: (OFString *)command;
@end

#import "IngredientProducer.h"

@implementation IngredientProducer
- (instancetype)init
{
	self = [super init];

	@try {
		void *pool = objc_autoreleasePoolPush();
		OFDictionary *info;

		info = [OFDictionary
		    dictionaryWithObject: [OFNumber numberWithInt: 1]
				  forKey: @"version"];
		_ingredient = [[OFMutableDictionary alloc]
		    initWithObject: info
			    forKey: @"ingredient"];

		objc_autoreleasePoolPop(pool);
	} @catch (id e) {
		[self release];
		@throw e;
	}

	return self;
}

- (void)dealloc
{
	[_ingredient release];

	[super dealloc];
}

- (void)parseArgument: (OFString *)argument
{
	argument = argument.stringByDeletingEnclosingWhitespaces;

#define ADD_TO_ARRAY(array, object)					\
	do {								\
		id tmp;							\
									\
		if ((tmp = [_ingredient objectForKey: array]) != nil)	\
			[tmp addObject: object];			\
		else {							\
			tmp = [OFMutableArray arrayWithObject: object];	\
			[_ingredient setObject: tmp			\
					forKey: array];			\
		}							\
	} while(0);

	if ([argument hasPrefix: @"-I"])
		ADD_TO_ARRAY(@"includedirs", [argument substringFromIndex: 2])
	else if ([argument hasPrefix: @"-D"])
		ADD_TO_ARRAY(@"defines", [argument substringFromIndex: 2])
	else if ([argument hasPrefix: @"-L"])
		ADD_TO_ARRAY(@"libdirs", [argument substringFromIndex: 2])
	else if ([argument hasPrefix: @"-l"])
		ADD_TO_ARRAY(@"libs", [argument substringFromIndex: 2])
	else if ([argument isEqual: @"-g"])
		[_ingredient setObject: [OFNumber numberWithBool: true]
				forKey: @"debug"];
	else
		ADD_TO_ARRAY(@"objcflags", argument)

#undef ADD_TO_ARRAY
}

- (OFDictionary *)ingredient
{
	return [[_ingredient copy] autorelease];
}
@end

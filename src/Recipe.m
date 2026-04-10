#import "Recipe.h"
#import "Target.h"
#import "WrongVersionException.h"

@implementation Recipe
@synthesize targets = _targets;

- (instancetype)init
{
	self = [super init];

	@try {
		void *pool = objc_autoreleasePoolPush();
		OFDictionary *recipe = [OFString
		    stringWithContentsOfFile: @"Recipe"].objectByParsingJSON;
		id tmp;

		if (![recipe isKindOfClass: [OFDictionary class]])
			@throw [OFInvalidFormatException exception];

		if ((tmp = [recipe objectForKey: @"recipe"]) == nil)
			@throw [OFInvalidFormatException exception];

		if ((tmp = [tmp objectForKey: @"version"]) != nil) {
			if (![tmp isKindOfClass: [OFNumber class]] ||
			    [tmp intValue] != 1)
				// FIXME: Include file name
				@throw [WrongVersionException exception];
		} else
			[OFStdErr writeLine: @"Warning: Recipe is lacking a "
					     @"version!"];

		[self populateFromDictionary: recipe];

		if ((tmp = [recipe objectForKey: @"targets"]) != nil &&
		    [tmp isKindOfClass: [OFDictionary class]]) {
			_targets = [[OFMutableDictionary alloc] init];

			for (OFString *name in tmp) {
				OFDictionary *info = [tmp objectForKey: name];

				if (![info isKindOfClass: [OFDictionary class]])
					continue;

				Target *target = [[[Target alloc] initWithName:
				    name] autorelease];
				[target populateFromDictionary: info];
				[target inheritBuildinfo: self];

				[_targets setObject: target forKey: name];
			}

			[_targets makeImmutable];
		}

		objc_autoreleasePoolPop(pool);
	} @catch (id e) {
		[self release];
		@throw e;
	}

	return self;
}

- (void)dealloc
{
	[_targets release];

	[super dealloc];
}
@end

#import "Recipe.h"
#import "Target.h"
#import "WrongVersionException.h"

@implementation Recipe
- init
{
	self = [super init];

	@try {
		void *pool = objc_autoreleasePoolPush();
		OFDictionary *recipe = [[OFString
		    stringWithContentsOfFile: @"Recipe"] objectByParsingJSON];
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
			OFEnumerator *keyEnumerator, *objectEnumerator;
			OFString *name;
			OFDictionary *info;
			Target *target;

			targets = [[OFMutableDictionary alloc] init];
			keyEnumerator = [tmp keyEnumerator];
			objectEnumerator = [tmp objectEnumerator];

			while ((name = [keyEnumerator nextObject]) != nil &&
			    (info = [objectEnumerator nextObject]) != nil) {
				if (![info isKindOfClass: [OFDictionary class]])
					continue;

				target = [[[Target alloc] initWithName:
				    name] autorelease];
				[target populateFromDictionary: info];
				[target inheritBuildinfo: self];

				[targets setObject: target
					    forKey: name];
			}
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
	[targets release];

	[super dealloc];
}

- (OFDictionary*)targets
{
	return targets;
}
@end

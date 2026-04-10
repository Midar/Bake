#import "Ingredient.h"

#import "MissingIngredientException.h"
#import "WrongVersionException.h"

// FIXME
#define INGREDIENTS_DIR @"/usr/local/libdata/bake/ingredients"

static OFMutableDictionary *ingredients = nil;

@implementation Ingredient
+ ingredientWithName: (OFString*)name
{
	void *pool;
	Ingredient *ingredient;
	OFString *path;

	if (ingredients == nil)
		ingredients = [[OFMutableDictionary alloc] init];

	if ((ingredient = [ingredients objectForKey: name]) != nil)
		return ingredient;

	pool = objc_autoreleasePoolPush();

	if ((path = [Ingredient findIngredient: name]) == nil)
		@throw [MissingIngredientException
		    exceptionWithIngredientName: name];

	ingredient = [[[Ingredient alloc] initWithFile: path] autorelease];
	[ingredients setObject: ingredient
			forKey: name];

	objc_autoreleasePoolPop(pool);

	return ingredient;
}

+ findIngredient: (OFString*)name
{
	OFFileManager *fileManager = [OFFileManager defaultManager];
	OFString *path;

	name = [name stringByAppendingString: @".ingredient"];

	path = [@"ingredients" stringByAppendingPathComponent: name];
	if ([fileManager fileExistsAtPath: path])
		return path;

	path = [INGREDIENTS_DIR stringByAppendingPathComponent: name];
	if ([fileManager fileExistsAtPath: path])
		return path;

	return nil;
}

- initWithFile: (OFString*)file
{
	self = [super init];

	@try {
		void *pool = objc_autoreleasePoolPush();
		OFDictionary *ingredient = [[OFString
		    stringWithContentsOfFile: file] objectByParsingJSON];
		id tmp;

		if (![ingredient isKindOfClass: [OFDictionary class]])
			@throw [OFInvalidFormatException exception];

		if ((tmp = [ingredient objectForKey: @"ingredient"]) == nil)
			@throw [OFInvalidFormatException exception];

		if ((tmp = [tmp objectForKey: @"version"]) != nil) {
			if (![tmp isKindOfClass: [OFNumber class]] ||
			    [tmp intValue] != 1)
				// FIXME: Include file name
				@throw [WrongVersionException class];
		} else
			[OFStdErr writeFormat: @"Warning: Ingredient %@ is "
					       @"lacking a version!", file];

		[self populateFromDictionary: ingredient];

		objc_autoreleasePoolPop(pool);
	} @catch (id e) {
		[self release];
		@throw e;
	}

	return self;
}

- (void)dealloc
{
	[name release];

	[super dealloc];
}

- (OFString*)name
{
	return name;
}
@end

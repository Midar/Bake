#import "Target.h"
#import "Ingredient.h"

@implementation Target
@synthesize name = _name;

- (instancetype)init
{
	OF_INVALID_INIT_METHOD
}

- (instancetype)initWithName: (OFString*)name
{
	self = [super init];

	@try {
		_name = [name copy];
	} @catch (id e) {
		[self release];
		@throw e;
	}

	return self;
}

- (void)dealloc
{
	[_name release];

	[super dealloc];
}

- (void)populateFiles: (id)fileList
{
	if ([fileList isKindOfClass: [OFArray class]]) {
		if (_files != nil)
			[_files addObjectsFromArray: fileList];
		else
			_files = [fileList mutableCopy];
	} else if ([fileList isKindOfClass: [OFDictionary class]]) {
		void *pool = objc_autoreleasePoolPush();

		if (_files == nil)
			_files = [[OFMutableArray alloc] init];

		for (OFString *dir in fileList) {
			OFArray *filesInDir = [fileList objectForKey: dir];

			if (![dir isKindOfClass: [OFString class]] ||
			    ![filesInDir isKindOfClass: [OFArray class]])
				continue;

			if ([dir isEqual: @""]) {
				[_files addObjectsFromArray: filesInDir];
				continue;
			}

			for (OFString *file in filesInDir)
				[_files addObject:
				    [dir stringByAppendingPathComponent: file]];
		}

		objc_autoreleasePoolPop(pool);
	}
}

- (void)populateFromDictionary: (OFDictionary *)info
{
	id tmp;

	[super populateFromDictionary: info];

	if ((tmp = [info objectForKey: @"files"]) != nil)
		[self populateFiles: tmp];

	if ((tmp = [info objectForKey: @"dependencies"]) != nil &&
	    [tmp isKindOfClass: [OFArray class]])
		_dependencies = [tmp mutableCopy];
}

- (void)resolveConditionals: (OFSet *)conditions
{
	void *pool = objc_autoreleasePoolPush();

	for (OFDictionary *dict in _conditionals) {
		OFString *condition = [dict objectForKey: @"if"];
		OFDictionary *info = [dict objectForKey: @"then"];

		if (condition == nil || info == nil)
			continue;

		if (![condition isKindOfClass: [OFString class]] ||
		    ![info isKindOfClass: [OFDictionary class]])
			continue;

		if ([conditions containsObject: condition]) {
			Buildinfo *buildinfo;
			OFArray *extraFiles;

			buildinfo = [[[Buildinfo alloc] init] autorelease];
			[buildinfo populateFromDictionary: info];
			[self inheritBuildinfo: buildinfo];

			extraFiles = [info objectForKey: @"files"];
			if (extraFiles != nil)
				[self populateFiles: extraFiles];
		}
	}

	objc_autoreleasePoolPop(pool);
}

- (void)addIngredients
{
	void *pool = objc_autoreleasePoolPush();

	for (OFString *ingredientName in _ingredients)
		[self inheritBuildinfo:
		    [Ingredient ingredientForName: ingredientName]];

	objc_autoreleasePoolPop(pool);
}

- (OFArray*)files
{
	return [[_files copy] autorelease];
}

- (OFArray*)dependencies
{
	return [[_dependencies copy] autorelease];
}
@end

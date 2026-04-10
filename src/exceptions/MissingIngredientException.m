#import "MissingIngredientException.h"

@implementation MissingIngredientException
@synthesize ingredientName = _ingredientName;

+ (instancetype)exceptionWithIngredientName: (OFString *)ingredientName
{
	return [[[self alloc] initWithIngredientName: ingredientName]
	    autorelease];
}

- (instancetype)initWithIngredientName: (OFString *)ingredientName
{
	self = [super init];

	@try {
		_ingredientName = [ingredientName copy];
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
	[_ingredientName release];

	[super dealloc];
}
@end

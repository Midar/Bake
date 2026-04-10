#import "MissingIngredientException.h"

@implementation MissingIngredientException
+ exceptionWithIngredientName: (OFString*)ingredientName
{
	return [[[self alloc] initWithIngredientName: ingredientName]
	    autorelease];
}

-  initWithIngredientName: (OFString*)ingredientName_
{
	self = [super init];

	@try {
		ingredientName = [ingredientName_ copy];
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
	[ingredientName release];

	[super dealloc];
}

- (OFString*)ingredientName
{
	return ingredientName;
}
@end

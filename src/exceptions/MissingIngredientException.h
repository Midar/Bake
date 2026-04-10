#import <ObjFW/ObjFW.h>

@interface MissingIngredientException: OFException
{
	OFString *_ingredientName;
}

+ exceptionWithIngredientName: (OFString*)ingredientName;
- initWithIngredientName: (OFString*)ingredientName;
- (OFString*)ingredientName;
@end

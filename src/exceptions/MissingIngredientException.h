#import <ObjFW/ObjFW.h>

@interface MissingIngredientException: OFException
{
	OFString *_ingredientName;
}

@property (readonly, copy, nonatomic) OFString *ingredientName;

+ exceptionWithIngredientName: (OFString*)ingredientName;
- initWithIngredientName: (OFString*)ingredientName;
@end

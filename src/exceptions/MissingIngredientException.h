#import <ObjFW/ObjFW.h>

@interface MissingIngredientException: OFException
{
	OFString *_ingredientName;
}

@property (readonly, copy, nonatomic) OFString *ingredientName;

+ (instancetype)exceptionWithIngredientName: (OFString *)ingredientName;
- (instancetype)initWithIngredientName: (OFString *)ingredientName;
@end

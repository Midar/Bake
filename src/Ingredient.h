#import "Buildinfo.h"

@interface Ingredient: Buildinfo
{
	OFString *_name;
}

@property (readonly, copy, nonatomic) OFString *name;

+ (Ingredient *)ingredientForName: (OFString *)name;
+ (OFString *)findIngredient: (OFString *)name;
- (instancetype)initWithFile: (OFString *)file;
@end

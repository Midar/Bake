#import "Buildinfo.h"

@interface Ingredient: Buildinfo
{
	OFString *_name;
}

@property (readonly, copy, nonatomic) OFString *name;

+ ingredientWithName: (OFString*)name;
+ (OFString*)findIngredient: (OFString*)name;
- initWithFile: (OFString*)file;
@end

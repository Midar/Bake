#import "Buildinfo.h"

@interface Ingredient: Buildinfo
{
	OFString *_name;
}

+ ingredientWithName: (OFString*)name;
+ (OFString*)findIngredient: (OFString*)name;
- initWithFile: (OFString*)file;
- (OFString*)name;
@end

#import <ObjFW/ObjFW.h>

#import "Recipe.h"
#import "Target.h"

@interface Bake: OFObject <OFApplicationDelegate>
{
	Recipe *_recipe;
	bool _verbose, _rebake;
}

@property (readonly, nonatomic) bool verbose;

- (void)findRecipe;
- (bool)shouldRebuildFile: (OFString *)file target: (Target *)target;
@end

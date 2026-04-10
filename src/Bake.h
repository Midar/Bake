#import <ObjFW/ObjFW.h>

#import "Recipe.h"
#import "Target.h"

@interface Bake: OFObject <OFApplicationDelegate>
{
	Recipe *_recipe;
	BOOL _verbose, _rebake;
}

- (void)findRecipe;
- (BOOL)shouldRebuildFile: (OFString*)file
		   target: (Target*)target;
- (BOOL)verbose;
@end

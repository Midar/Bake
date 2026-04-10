#import <ObjFW/ObjFW.h>

#import "Target.h"

@interface DependencyNode: OFObject
{
	Target *_target;
	unsigned _visited;
	bool _inTargetOrder;
}

- initWithTarget: (Target*)target;
- (void)visit;
- (Target*)target;
- (bool)isInTargetOrder;
- (void)setInTargetOrder: (bool)inList;
@end

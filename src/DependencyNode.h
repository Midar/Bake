#import <ObjFW/ObjFW.h>

#import "Target.h"

@interface DependencyNode: OFObject
{
	Target *_target;
	unsigned _visited;
	BOOL _inTargetOrder;
}

- initWithTarget: (Target*)target;
- (void)visit;
- (Target*)target;
- (BOOL)isInTargetOrder;
- (void)setInTargetOrder: (BOOL)inList;
@end

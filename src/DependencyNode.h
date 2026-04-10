#import <ObjFW/ObjFW.h>

#import "Target.h"

@interface DependencyNode: OFObject
{
	Target *_target;
	unsigned _visited;
	bool _inTargetOrder;
}

@property (readonly, retain, nonatomic) Target *target;
@property (getter=isInTargetOrder, nonatomic) bool inTargetOrder;

- initWithTarget: (Target*)target;
- (void)visit;
@end

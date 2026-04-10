#import <ObjFW/ObjFW.h>

#import "DependencyNode.h"
#import "Target.h"

@interface DependencySolver: OFObject
{
	OFMutableDictionary *_nodes;
	OFMutableArray *_targetOrder;
}

- (void)addTarget: (Target*)target;
- (void)solve;
- (OFArray*)targetOrder;
@end

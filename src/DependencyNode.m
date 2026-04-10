#import "DependencyNode.h"

#import "CircularDependencyException.h"

@implementation DependencyNode
@synthesize target = _target, inTargetOrder = _inTargetOrder;

- initWithTarget: (Target*)target
{
	self = [super init];

	_target = [target retain];

	return self;
}

- (void)visit
{
	if (++_visited > 1)
		@throw [CircularDependencyException exception];
}
@end

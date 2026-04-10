#import "DependencyNode.h"

#import "CircularDependencyException.h"

@implementation DependencyNode
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

- (Target*)target
{
	return _target;
}

- (bool)isInTargetOrder
{
	return _inTargetOrder;
}

- (void)setInTargetOrder: (bool)inTargetOrder
{
	_inTargetOrder = inTargetOrder;
}
@end

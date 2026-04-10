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

- (BOOL)isInTargetOrder
{
	return _inTargetOrder;
}

- (void)setInTargetOrder: (BOOL)inTargetOrder
{
	_inTargetOrder = inTargetOrder;
}
@end

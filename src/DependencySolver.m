#include <assert.h>

#import "DependencySolver.h"

#import "MissingDependencyException.h"

@implementation DependencySolver
- (instancetype)init
{
	self = [super init];

	@try {
		_nodes = [[OFMutableDictionary alloc] init];
		_targetOrder = [[OFMutableArray alloc] init];
	} @catch (id e) {
		[self release];
		@throw e;
	}

	return self;
}

- (void)dealloc
{
	[_nodes release];
	[_targetOrder release];

	[super dealloc];
}

- (void)addTarget: (Target *)target
{
	void *pool = objc_autoreleasePoolPush();
	DependencyNode *node;

	node = [[[DependencyNode alloc] initWithTarget: target] autorelease];

	[_nodes setObject: node forKey: target.name];

	objc_autoreleasePoolPop(pool);
}

- (void)solveDependenciesForNode: (DependencyNode *)node
{
	void *pool = objc_autoreleasePoolPush();

	[node visit];

	for (OFString *dependencyName in node.target.dependencies) {
		DependencyNode *dependency;

		if ((dependency = [_nodes objectForKey: dependencyName]) == nil)
			@throw [MissingDependencyException
			    exceptionWithDependencyName: dependencyName];

		if (!dependency.inTargetOrder)
			[self solveDependenciesForNode: dependency];
	}

	[_targetOrder addObject: node.target];
	node.inTargetOrder = true;

	objc_autoreleasePoolPop(pool);
}

- (void)solve
{
	void *pool = objc_autoreleasePoolPush();

	for (DependencyNode *node in _nodes)
		if (!node.inTargetOrder)
			[self solveDependenciesForNode: node];

	objc_autoreleasePoolPop(pool);
}

- (OFArray *)targetOrder
{
	return [[_targetOrder copy] autorelease];
}
@end

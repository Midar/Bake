#include <assert.h>

#import "DependencySolver.h"

#import "MissingDependencyException.h"

@implementation DependencySolver
- init
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

- (void)addTarget: (Target*)target
{
	void *pool = objc_autoreleasePoolPush();
	DependencyNode *node;

	node = [[[DependencyNode alloc] initWithTarget: target] autorelease];

	[_nodes setObject: node
		   forKey: [target name]];

	objc_autoreleasePoolPop(pool);
}

- (void)solveDependenciesForNode: (DependencyNode*)node
{
	void *pool = objc_autoreleasePoolPush();
	OFEnumerator *enumerator;
	OFString *dependencyName;

	[node visit];

	enumerator = [[[node target] dependencies] objectEnumerator];
	while ((dependencyName = [enumerator nextObject]) != nil) {
		DependencyNode *dependency;

		if ((dependency = [_nodes objectForKey: dependencyName]) == nil)
			@throw [MissingDependencyException
			    exceptionWithDependencyName: dependencyName];

		if (![dependency isInTargetOrder])
			[self solveDependenciesForNode: dependency];
	}

	[_targetOrder addObject: [node target]];
	[node setInTargetOrder: YES];

	objc_autoreleasePoolPop(pool);
}

- (void)solve
{
	void *pool = objc_autoreleasePoolPush();
	OFEnumerator *enumerator = [_nodes objectEnumerator];
	DependencyNode *node;

	while ((node = [enumerator nextObject]) != nil)
		if (![node isInTargetOrder])
			[self solveDependenciesForNode: node];

	objc_autoreleasePoolPop(pool);
}

- (OFArray*)targetOrder
{
	return [[_targetOrder copy] autorelease];
}
@end

#include <assert.h>

#import "DependencySolver.h"

#import "MissingDependencyException.h"

@implementation DependencySolver
- init
{
	self = [super init];

	@try {
		nodes = [[OFMutableDictionary alloc] init];
		targetOrder = [[OFMutableArray alloc] init];
	} @catch (id e) {
		[self release];
		@throw e;
	}

	return self;
}

- (void)dealloc
{
	[nodes release];
	[targetOrder release];

	[super dealloc];
}

- (void)addTarget: (Target*)target
{
	void *pool = objc_autoreleasePoolPush();
	DependencyNode *node;

	node = [[[DependencyNode alloc] initWithTarget: target] autorelease];

	[nodes setObject: node
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

		if ((dependency = [nodes objectForKey: dependencyName]) == nil)
			@throw [MissingDependencyException
			    exceptionWithDependencyName: dependencyName];

		if (![dependency isInTargetOrder])
			[self solveDependenciesForNode: dependency];
	}

	[targetOrder addObject: [node target]];
	[node setInTargetOrder: YES];

	objc_autoreleasePoolPop(pool);
}

- (void)solve
{
	void *pool = objc_autoreleasePoolPush();
	OFEnumerator *enumerator = [nodes objectEnumerator];
	DependencyNode *node;

	while ((node = [enumerator nextObject]) != nil)
		if (![node isInTargetOrder])
			[self solveDependenciesForNode: node];

	objc_autoreleasePoolPop(pool);
}

- (OFArray*)targetOrder
{
	return [[targetOrder copy] autorelease];
}
@end

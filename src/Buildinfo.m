#import "Buildinfo.h"

@implementation Buildinfo
@synthesize ingredients = _ingredients, debug = _debug, objC = _objcC;
@synthesize objCFlags = _objCFlags, includeDirs = _includeDirs;
@synthesize defines = _defines, libs = _libs, libDirs = _libDirs;
@synthesize conditionals = _conditionals;

- (void)populateFromDictionary: (OFDictionary *)info
{
	id tmp;

#define KEEP_IF_KIND_IS(var, name, keep, kind)		\
	if ((tmp = [info objectForKey: name]) != nil &&	\
	    [tmp isKindOfClass: [kind class]])		\
		var = [tmp keep];

	KEEP_IF_KIND_IS(_ingredients, @"ingredients", retain, OFArray)
	_debug = [[info objectForKey: @"debug"] boolValue];
	KEEP_IF_KIND_IS(_objC, @"objc", copy, OFString)
	KEEP_IF_KIND_IS(_objCFlags, @"objcflags", mutableCopy, OFArray)
	KEEP_IF_KIND_IS(_includeDirs, @"includedirs", mutableCopy, OFArray)
	KEEP_IF_KIND_IS(_defines, @"defines", mutableCopy, OFArray)
	KEEP_IF_KIND_IS(_libs, @"libs", mutableCopy, OFArray)
	KEEP_IF_KIND_IS(_libDirs, @"libdirs", mutableCopy, OFArray)
	KEEP_IF_KIND_IS(_conditionals, @"conditional", mutableCopy, OFArray)

#undef KEEP_IF_KIND_IS
}

- (void)inheritBuildinfo: (Buildinfo *)info
{
	id tmp;

#define INHERIT_ARRAY(var)					\
	if ((tmp = [info var]) != nil) {			\
		if (_##var != nil)				\
			[_##var insertObjectsFromArray: tmp	\
					       atIndex: 0];	\
		else						\
			_##var = [tmp mutableCopy];		\
	}

	INHERIT_ARRAY(ingredients)

	_debug |= [info debug];

	if ((tmp = info.objC) != nil) {
		[_objC release];
		_objC = [tmp copy];
	}

	INHERIT_ARRAY(objCFlags)
	INHERIT_ARRAY(includeDirs)
	INHERIT_ARRAY(defines)
	INHERIT_ARRAY(libs)
	INHERIT_ARRAY(libDirs)
	INHERIT_ARRAY(conditionals)

#undef INHERIT_ARRAY
}

- (void)dealloc
{
	[_ingredients release];
	[_objC release];
	[_objCFlags release];
	[_includeDirs release];
	[_defines release];
	[_libs release];
	[_libDirs release];
	[_conditionals release];

	[super dealloc];
}
@end

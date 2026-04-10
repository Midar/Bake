#import <ObjFW/ObjFW.h>

@interface Buildinfo: OFObject
{
	OFMutableArray *_ingredients;
	bool _debug;
	OFString *_objC;
	OFMutableArray *_objCFlags, *_includeDirs, *_defines, *_libs, *_libDirs;
	OFMutableArray *_conditionals;
}

- (void)populateFromDictionary: (OFDictionary*)info;
- (void)inheritBuildinfo: (Buildinfo*)info;
- (OFArray*)ingredients;
- (bool)debug;
- (OFString*)objC;
- (OFArray*)objCFlags;
- (OFArray*)includeDirs;
- (OFArray*)defines;
- (OFArray*)libs;
- (OFArray*)libDirs;
- (OFArray*)conditionals;
@end

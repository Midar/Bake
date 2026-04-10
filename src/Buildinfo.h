#import <ObjFW/ObjFW.h>

@interface Buildinfo: OFObject
{
	OFMutableArray *_ingredients;
	bool _debug;
	OFString *_objC;
	OFMutableArray *_objCFlags, *_includeDirs, *_defines, *_libs, *_libDirs;
	OFMutableArray *_conditionals;
}

@property (readonly, copy, nonatomic) OFArray *ingredients;
@property (readonly, nonatomic) bool debug;
@property (readonly, copy, nonatomic) OFString *objC;
@property (readonly, copy, nonatomic) OFArray *objCFlags;
@property (readonly, copy, nonatomic) OFArray *includeDirs;
@property (readonly, copy, nonatomic) OFArray *defines;
@property (readonly, copy, nonatomic) OFArray *libs;
@property (readonly, copy, nonatomic) OFArray *libDirs;
@property (readonly, copy, nonatomic) OFArray *conditionals;

- (void)populateFromDictionary: (OFDictionary *)info;
- (void)inheritBuildinfo: (Buildinfo *)info;
@end

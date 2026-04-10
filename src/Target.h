#import "Buildinfo.h"

@interface Target: Buildinfo
{
	OFString *_name;
	OFMutableArray *_files;
	OFMutableArray *_dependencies;
	bool _sharedLib, _staticLib;
	unsigned _sharedLibMajor, _sharedLibMinor;
	bool _install;
	OFDictionary *_installHeaders;
}

- initWithName: (OFString*)name;
- (void)resolveConditionals: (OFSet*)conditions;
- (void)addIngredients;
- (OFString*)name;
- (OFArray*)files;
- (OFArray*)dependencies;
@end

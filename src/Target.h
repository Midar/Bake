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

@property (readonly, copy, nonatomic) OFString *name;
@property (readonly, copy, nonatomic) OFArray *files;
@property (readonly, copy, nonatomic) OFArray *dependencies;

- (instancetype)initWithName: (OFString *)name;
- (void)resolveConditionals: (OFSet *)conditions;
- (void)addIngredients;
@end

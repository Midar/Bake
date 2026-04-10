#import "Buildinfo.h"

@interface Recipe: Buildinfo
{
	OFMutableDictionary *_targets;
}

@property (readonly, copy, nonatomic) OFDictionary *targets;
@end

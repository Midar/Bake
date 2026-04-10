#import "Buildinfo.h"

@interface Recipe: Buildinfo
{
	OFMutableDictionary *_targets;
}

- (OFDictionary*)targets;
@end

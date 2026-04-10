#import <ObjFW/ObjFW.h>

@interface IngredientProducer: OFObject
{
	OFMutableDictionary *_ingredient;
}

- (void)parseArgument: (OFString*)argument;
- (OFDictionary*)ingredient;
@end

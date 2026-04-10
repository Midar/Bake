#import <ObjFW/ObjFW.h>

@interface IngredientProducer: OFObject
{
	OFMutableDictionary *_ingredient;
}

@property (readonly, copy, nonatomic) OFDictionary *ingredient;

- (void)parseArgument: (OFString *)argument;
@end

#import "Card.h"
#import "cocos2d.h"

@implementation Card

@synthesize is_flipped;
@synthesize is_matched;
@synthesize value;
@synthesize front_sprite;
@synthesize back_sprite;
@synthesize _table_location;

+ (id)newFromValue:(int)n
{
    if(n > 0)
    {
        //This is important. Autoreleasing this object for return so we don't hold onto it.
        Card *new_card = [[[Card alloc] init] autorelease];
        new_card.front_sprite = [CCSprite spriteWithFile:[NSString stringWithFormat:@"card-%i.png", n]];
        new_card.back_sprite  =	[CCSprite spriteWithFile:@"card-back.png"];
        new_card.value = n;
		// ???
        //new_card._table_location = CGRectMake(100,100, 300,400); //hackety!
        return new_card;
    } else {
        return NULL;
    }
}

- (id)init
{
    [super init];
    is_flipped = NO;
    return self;
}

- (void) release
{
    [super release];
}

- (void) flip
{
    is_flipped = is_flipped ? NO : YES;
}

- (CCSprite *)getCurrentView
{
	if (is_flipped) {
		return front_sprite;
	} else {
		return back_sprite;
	}

}

@end


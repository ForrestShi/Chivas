
// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "LayoutParameters.h"



@class HUDLayer;
@class Card;

// GameLayer Layer
@interface GameLayer : CCLayer
{
    HUDLayer        *hud;
    NSMutableArray  *deck;
    BOOL            in_match;
    Card            *first_card;
    Card            *second_card;
    int             score;
	
	BOOL		    readyPlay;
	
	NSTimer*	    checkResultTimer;
	
	CCSprite*		resultSprite;
	
}
@property (nonatomic, retain) HUDLayer          *hud;
@property (nonatomic, retain) NSMutableArray    *deck;
@property (nonatomic, retain) Card              *first_card;
@property (nonatomic, retain) Card              *second_card;
@property (nonatomic, assign) BOOL		        readyPlay;
@property (nonatomic, retain) NSTimer*	    checkResultTimer;
@property (nonatomic, retain) CCSprite*		resultSprite;


// returns a Scene that contains the gamelayer and hud as children
+ (id) scene;
- (void)initializeDeck;
- (void)shuffleDeck;
- (void)dealDeck;
- (void)flipCard:(Card *)card;
- (BOOL)inMatch;
- (void)resetScore;
@end

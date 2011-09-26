#import "cocos2d.h"

@class GameLayer;

// HUDLayer Layer
@interface HUDLayer : CCLayer
{
    GameLayer   *game;
    CGRect      shuffle_rect;
    CCLabel       *score_label;
}
@property (nonatomic, retain) GameLayer *game;
@property (nonatomic, retain) CCLabel *score_label;

- (void) setScore:(int)score;
- (void) writeScore:(NSString *)scoreString;
@end

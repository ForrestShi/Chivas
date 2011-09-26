/*
 *  LayoutParameters.h
 *  ChivasPR
 *
 *  Created by forrest on 10-8-8.
 *  Copyright 2010 __MyCompanyName__. All rights reserved.
 *
 */

// ALog always displays output regardless of the DEBUG setting
#define MYLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

//sand 
#define SAND1_X 0
#define SAND1_Y 0
#define SAND2_X 828
#define SAND2_Y 488
#define SAND1_W 229
#define SAND1_H 225
#define SAND2_W 196
#define SAND2_H 280

//leaf
#define LEAF1_X 19
#define LEAF1_Y 92
#define LEAF1_W 79
#define LEAF1_H 73

#define LEAF2_X 0
#define LEAF2_Y 185
#define LEAF2_W 94
#define LEAF2_H 113

#define LEAF3_X 947
#define LEAF3_Y 386
#define LEAF3_W 85
#define LEAF3_H 90

#define LEAF4_X 923
#define LEAF4_Y 556
#define LEAF4_W 102
#define LEAF4_H 95

//chivas big
#define CHIVAS_BIG_X 380
#define CHIVAS_BIG_Y 44
#define CHIVAS_BIG_W 285
#define CHIVAS_BIG_H 56

//chivas small
#define CHIVAS_SMALL_X 707
#define CHIVAS_SMALL_Y 44
#define CHIVAS_SMALL_W 171 
#define CHIVAS_SMALL_H 34

//title
#define TITLE_X 380
#define TITLE_Y 44
#define TITLE_W 215
#define TITLE_H 32 


//coverflow view 
#define COVERFLOW_X 56 //106 
#define COVERFLOW_Y 120 //180 
#define COVERFLOW_WIDTH 906 //820 
#define COVERFLOW_HEIGHT 516 //462 



//each image item size 
#define COVERFLOW_PIC_W 263
#define COVERFLOW_PIC_H 393


//video playback
#define VIDEO_X 110
#define VIDEO_Y 180
#define VIDEO_W 801
#define VIDEO_H 450 


//age matters
#define AGEMATTER_X (122-COVERFLOW_X) 
#define AGEMATTER_Y (74-COVERFLOW_Y + CENTERBACKGROUND_Y)
#define AGEMATTER_W 279
#define AGEMATTER_H 416
#define AGEMATTER_INFO_X (461-COVERFLOW_X) 
#define AGEMATTER_INFO_Y (87-COVERFLOW_Y+ CENTERBACKGROUND_Y)
#define AGEMATTER_INFO_W 351
#define AGEMATTER_INFO_H 300

#define CENTERBACKGROUND_X 57
#define CENTERBACKGROUND_Y 117
#define CENTERBACKGROUND_W 913
#define CENTERBACKGROUND_H 594


#define AGE_W 800
#define AGE_H 478


//multiple images
#define IMAGE1_X (206 -COVERFLOW_X) 
#define IMAGE1_Y (187 -COVERFLOW_Y)
#define IMAGE2_X (567 -COVERFLOW_X) 
#define IMAGE2_Y IMAGE1_Y
#define IMAGE3_X IMAGE1_X
#define IMAGE3_Y (415-COVERFLOW_Y)
#define IMAGE4_X IMAGE2_X
#define IMAGE4_Y IMAGE3_Y
#define IMAGE_W 248
#define IMAGE_H 197

#define DETAILIMAGE_X 224 - COVERFLOW_X
#define DETAILIMAGE_Y 167 - COVERFLOW_Y
#define DETAILIMAGE_W 588
#define DETAILIMAGE_H 479

//game view  相对于coverflow 左上角
#define GAME_X 88 
#define GAME_Y 34 
#define GAME_W 731
#define GAME_H 468 

//TODO
//game crop background
// 
#define CROP_BACK_X 88
#define CROP_BACK_Y 33
// matching-game-back.png width height 
#define CROP_BACK_W 731
#define CROP_BACK_H 468

#define FIRST_CARD_CENTER_X  169 //(211 - GAME_X)
#define FIRST_CARD_CENTER_Y 155 //(247 - GAME_Y)

#define PREBUTTON_X (COVERFLOW_X + 83*0.75)

#define BACKBUTTON_X 816
#define BACKBUTTON_Y 650 
#define BACKBUTTON_W 83 //TODO
#define BACKBUTTON_H 29  //TODO

//----------- GAME ------------

#define DECK_SIZE   8
#define CARD_WIDTH  164
#define CARD_HEIGHT 226

#define PROMOPAGE_X 120
#define PROMOPAGE_Y 58
#define PROMOPAGE_W 728
#define PROMOPAGE_H 383

@protocol BackButtonDelegate

- (void) onClickBackButton;
- (void) onClickNextButton;
- (void) onClickPreButton;

@end


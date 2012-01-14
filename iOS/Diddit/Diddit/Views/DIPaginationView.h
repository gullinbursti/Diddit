//
//  DIPaginationView.h
//  Diddit
//
//  Created by Matthew Holcombe on 01.10.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DIPaginationView : UIView {
	int _curPage;
	int _totPages;
	
	UIImageView *_onImgView;
}

-(id)initWithTotal:(int)total coords:(CGPoint)pos;
-(void)updToPage:(int)page;
@end

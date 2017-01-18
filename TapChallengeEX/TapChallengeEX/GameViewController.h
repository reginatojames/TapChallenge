//
//  ViewController.h
//  TapChallengeEX
//
//  Created by Reginato James on 13/01/17.
//  Copyright © 2017 Reginato James. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScoreTableViewController.h"

@interface GameViewController : UIViewController <ScoreTableViewDelegate>

@property (nonatomic, weak) IBOutlet UILabel * tapsCountLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;

-(IBAction)buttonPressed:(id)sender;

-(IBAction)tapGestureRecognizerDidRecognizeTap:(id)sender;

@end


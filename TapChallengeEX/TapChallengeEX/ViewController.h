//
//  ViewController.h
//  TapChallengeEX
//
//  Created by Reginato James on 13/01/17.
//  Copyright © 2017 Reginato James. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (nonatomic, weak) IBOutlet UILabel * tapsCountLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;

-(IBAction)buttonPressed:(id)sender;

@end


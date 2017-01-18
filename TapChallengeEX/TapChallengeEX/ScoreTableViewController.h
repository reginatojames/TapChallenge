//
//  ScoreTableViewController.h
//  TapChallengeEX
//
//  Created by Reginato James on 18/01/17.
//  Copyright © 2017 Reginato James. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ScoreTableViewDelegate <NSObject>

///richiedo i risultati al chiamamnte e alla classe che conforma al mio protocollo
-(NSArray *) scoreTableViewFetchResults;

///informo che ho terminato i fetch dei dati
-(void)scoreTableViewDidFetchResults;

@end

@interface ScoreTableViewController : UITableViewController

@property (nonatomic, strong) NSArray *scoresArray;

@property (nonatomic, unsafe_unretained) id <ScoreTableViewDelegate> delegate;

@end

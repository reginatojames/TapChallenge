//
//  ViewController.m
//  TapChallengeEX
//
//  Created by Reginato James on 13/01/17.
//  Copyright © 2017 Reginato James. All rights reserved.
//

#import "GameViewController.h"
#import "ScoreTableViewController.h"

#define GameTimer 1
#define GameTime 3
#define FirstAppLaunch @"FirstAppLaunch"

#define Defaults [NSUserDefaults standardUserDefaults]
#define Results @"UserScore"


@interface GameViewController () {
    int _tapsCount;
    int _timeCount;
    
    NSTimer *_gameTimer;
}

@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.tapsCountLabel.minimumScaleFactor = 0.5;
    [self.tapsCountLabel setAdjustsFontSizeToFitWidth:true];
    [self initializeGame];
    
    //setto il navigation bar title
    self.title = @"Tap Challenge";
    
    //creo un pulsante per la navigationBar
    UIBarButtonItem *scoreButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(scoreButtonPressed)];
    
    //imposto il pulsante alla dedstra della mia navigation bar
    self.navigationItem.rightBarButtonItem = scoreButtonItem;
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    if([self firstAppLaunch]){
        [Defaults setBool:true forKey:FirstAppLaunch];
        [Defaults synchronize];
    }else{
        if([self risultati].count > 0){
            NSNumber *value = [self risultati].lastObject;
            [self mostraUltimoRisultato:value.intValue];
        }
    }
        
}

-(void)initializeGame {
    _tapsCount = 0;
    _timeCount = GameTime;
    
    [self.tapsCountLabel setText:@"Tap to Play"];
    [self.timeLabel setText:[NSString stringWithFormat:@"Ti restano - %i sec", _timeCount]];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

-(void)scoreButtonPressed{
    ScoreTableViewController *tableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ScoreTableViewController"];
    
    //pèrendo i risukltati e li passo alla tableview
    //NSArray *resultsArray = [self risultati];
    //[tableViewController setScoresArray:resultsArray];
    
    //boh
    tableViewController.delegate = self;
    
    //pusho all'interno dello stack del mio navigationController un nuovo viewController
    [self.navigationController pushViewController:tableViewController animated:true];
}

-(IBAction)tapGestureRecognizerDidRecognizeTap:(id)sender{
    // loggo in console il valore dei taps effettuati
    NSLog(@"buttonPressed: %i", _tapsCount);
    
    // questo è un commento singleline
    /*
     questo è un commento multiline
     */
    
    // creo il timer solo se serve
    if (_gameTimer == nil) {
        _gameTimer = [NSTimer scheduledTimerWithTimeInterval:GameTimer target:self selector:@selector(timerTick) userInfo:nil repeats:true];
    }
    
    // incremento il mio taps counter
    _tapsCount++;
    
    // aggiorno il valore della label
    [self.tapsCountLabel setText:[NSString stringWithFormat:@"%i", _tapsCount]];
}

-(IBAction)buttonPressed:(id)sender {
//
}

-(void)timerTick {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    _timeCount--;
    
    [self.timeLabel setText:[NSString stringWithFormat:@"Ti restano - %i sec", _timeCount]];
    
    if (_timeCount == 0) {
        [_gameTimer invalidate];
        _gameTimer = nil;
        
        NSString *message = [NSString stringWithFormat:@"Hai fatto %i Taps!", _tapsCount];
        UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:@"Game Over" message:message preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //salvo i dati utenti
            [self salvaRisultato];
            
            [self initializeGame];
        }];
        
        [alertViewController addAction:okAction];
        [self presentViewController:alertViewController animated:true completion:nil];
    }
}

#pragma mark - UI

-(void)mostraUltimoRisultato:(int)risultato{
    //voglio che un UIAlertController mi mostri al primo avvio dell'app il precedente risultato del mio utente
    NSString *messagePrimo = [NSString stringWithFormat:@"Hai fatto %i Taps l'ultima volta!", risultato];
    UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:@"Ben Tornato" message:messagePrimo preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //salvo i dati utenti
        [self salvaRisultato];
        
        [self initializeGame];
    }];
    
    [alertViewController addAction:okAction];
    [self presentViewController:alertViewController animated:true completion:nil];
}


#pragma mark - Persistenza

-(NSArray *)risultati{
    //ricavo i dati salvati dagli UserDefaults
    NSArray *array = [Defaults objectForKey:Results];
    
    if(array == nil){
        array = @[];//inizializzo un array statico
    }
    
    //leggo la variabile
    NSLog(@"VALORE DAGLI USERDAEFAULTS: %@", array);
    
    return array;
}

-(void)salvaRisultato{
    NSMutableArray *array = [[Defaults objectForKey:Results] mutableCopy];
    if(array == nil){
        //array = [[NSMutableArra
        //old wayy alloc] init].mutableCopy;
        
        //new way
        array = @[].mutableCopy;
    }
    //old way
    //NSNumber *number = [NSNumber numberWithInt:_tapsCount];
    
    //new way
    [array addObject:@(_tapsCount)];
    
    NSLog(@"mio array -> %@", array);
    
    NSArray *arrayToBeSaved = [array sortedArrayUsingComparator:^NSComparisonResult(NSNumber *obj1, NSNumber *obj2) {
        int value1 = obj1.intValue;
        int value2 = obj2.intValue;
        
        if(value1 == value2){
            return NSOrderedSame;
        }
        
        if(value1 < value2){
            return NSOrderedAscending;
        }
        
        return NSOrderedDescending;
    }];
    
    [Defaults setObject:arrayToBeSaved forKey:Results];
    [Defaults synchronize];
}

-(bool)firstAppLaunch{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"FirstAppLaunch"];
}

#pragma mark - ScoreTableViewDelegate

-(NSArray *)scoreTableViewFetchResults{
    return [self risultati];
}

-(void)scoreTableViewDidFetchResults{
    
}

@end

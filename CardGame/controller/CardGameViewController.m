//
//  CardGameViewController.m
//  CardGame
//
//  Created by Henry on 1/26/13.
//  Copyright (c) 2013 Henry. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCard.h"
#import "PlayingCardDeck.h"
#import "QuartzCore/QuartzCore.h"
#import "GameResult.h"

@interface CardGameViewController()
@property (strong, nonatomic) GameResult *gameResult;

@end

@implementation CardGameViewController


-(GameResult*) gameResult{
    if(!_gameResult){
        _gameResult = [[GameResult alloc]initWithGameName:self.gameName];
    }
    return _gameResult;
}

-(CardMatchingGame*) game{
    if(!_game){
        _game = [[CardMatchingGame alloc]initWithWithCardCount:[self.cardButtons count] usingDeck:self.deck withMatchCardNumber:self.numberOfMatchedCardInGame];
    }
    return _game;
}

-(void) setCardButtons:(NSArray *)cardButtons{
    _cardButtons = cardButtons;
    [self updateUI];    
}

- (void)setFlipCount:(int)flipCount{
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %i",self.flipCount];
}


- (void)updateUI{
    
}

- (IBAction)flipCard:(UIButton *)sender {
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    self.gameResult.score = self.game.score;
    [self updateUI];
    self.flipCount++;
}

- (IBAction)dealButtonClicked:(id)sender {
    self.game = nil;
    self.deck = nil;
    self.gameResult = nil;
    self.flipCount = 0;
    [self updateUI];
}

+ (NSString*) getFlipResultString:(CardMatchingGame*)game{
    NSString *lastFlipResult = @"";
    NSMutableArray *resultString = [[NSMutableArray alloc]init];
    
    if(game.pointsEarnInLastOperation == FLIP_PENALTY ){
        
        Card *flippedCard = [game.cardsInlastOperation lastObject];
        [resultString addObjectsFromArray:@[@"Flipped up",flippedCard.contents]];
        
    }else if(game.pointsEarnInLastOperation > 0){
        
        [resultString addObject:@"Matched"];
        for(Card *matchedCard in game.cardsInlastOperation){
            [resultString addObject:matchedCard.contents];
            if(![[game.cardsInlastOperation lastObject] isEqual:matchedCard]){
                [resultString addObject:@"&"];
            }
        }
        [resultString addObject:[NSString stringWithFormat:@" for %d points", game.pointsEarnInLastOperation]];
        
        
    }else if(game.pointsEarnInLastOperation < 0){
        
        for(Card *matchedCard in game.cardsInlastOperation){
            [resultString addObject:matchedCard.contents];
            if(![[game.cardsInlastOperation lastObject] isEqual:matchedCard]){
                [resultString addObject:@" & "];
            }
        }
        [resultString addObject:@" don't mach!"];
        [resultString addObject:[NSString stringWithFormat:@" %d points penalty!", abs(game.pointsEarnInLastOperation)]];
        
    }
    lastFlipResult = [resultString componentsJoinedByString:@" "];
    return lastFlipResult;
}

-(NSString*) gameName{
    return @"";
}


@end

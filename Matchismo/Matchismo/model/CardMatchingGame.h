//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Chris Johnson Bidler on 2/8/13.
//  Copyright (c) 2013 Chris Johnson Bidler. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"
#import "Card.h"

@interface CardMatchingGame : NSObject

@property (readonly, nonatomic) int score;
@property (readonly, nonatomic, strong) NSString *lastFlipMessage;

// This is the class designated initializer
- (id) initWithCardCount:(NSUInteger)count
               usingDeck:(Deck *)deck
              matchCount:(NSUInteger)matchCount;

- (void)flipCardAtIndex:(NSUInteger)index;

- (Card *)cardAtIndex:(NSUInteger)index;

@end

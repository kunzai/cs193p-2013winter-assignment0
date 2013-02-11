//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Chris Johnson Bidler on 2/8/13.
//  Copyright (c) 2013 Chris Johnson Bidler. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()

@property (readwrite, nonatomic) int score;
@property (readwrite, strong, nonatomic) NSString *lastFlipMessage;
@property (strong, nonatomic) NSMutableArray *cards; // of Card
@property (nonatomic) NSUInteger numberToMatch;

@end

@implementation CardMatchingGame

- (NSMutableArray *)cards
{
    if (!_cards) {
        _cards = [[NSMutableArray alloc] init];
    }
    return _cards;
}

- (id) init { return nil; } // Not the designated initializer, fail.
- (id) initWithCardCount:(NSUInteger)count
               usingDeck:(Deck *)deck
              matchCount:(NSUInteger)matchCount
{
    self = [super init];
    self.numberToMatch = matchCount;
    if (self) {
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (card) {
                self.cards[i] = card;
            } else {
                self = nil;
                break;
            }
        }
    }
    
    return self;
}

- (Card *) cardAtIndex:(NSUInteger)index
{
    return index < [self.cards count] ? self.cards[index] : nil;
}

#define MATCH_BONUS 2
#define MISMATCH_PENALTY 2
#define FLIP_COST 1
/*
 * flipCardAtIndex accepts an arbitrary number of cards to match,
 * scaling MATCH_BONUS by the number required for a match.
 * So, for a match-2 game, MATCH_BONUS is 4, while for a match-3,
 * it is 6.
 */
-(void) flipCardAtIndex:(NSUInteger)index
{
    self.lastFlipMessage = nil;
    Card *card = [self cardAtIndex:index];
    
    if (card && !card.unplayable) {
        if (!card.faceUp) {
            NSMutableArray *cardsToMatch = [[NSMutableArray alloc] init];
            
            // Collect the other face-up cards in array to match
            for (Card *otherCard in self.cards) {
                if (!otherCard.unplayable && otherCard.faceUp) {
                    [cardsToMatch addObject:otherCard];
                }
            }
            NSLog(@"flipCardAtIndex found %d face-up cards", [cardsToMatch count]);
            
            // If our card  + other face-up cards == match count, check for a match
            if ([cardsToMatch count] == self.numberToMatch - 1) {
                if ([card match:cardsToMatch]) {
                    [cardsToMatch insertObject:card atIndex:0]; // Add our card for message output
                    self.score += [card match:cardsToMatch] * MATCH_BONUS * self.numberToMatch; // MATCH_BONUS scales with match type
                    card.unplayable = YES;
                    for (Card * matchedCard in cardsToMatch) {
                        matchedCard.unplayable = YES;
                    }
                    self.lastFlipMessage = [NSString stringWithFormat:@"Match! %@ - gain %d points",
                                            [cardsToMatch componentsJoinedByString:@", "],
                                            [card match:cardsToMatch] * MATCH_BONUS * self.numberToMatch];
                                        
                } else {
                    for (Card *card in self.cards) {
                        if (!card.unplayable) {
                            card.faceUp = NO;
                        }
                    }
                    self.score -= MISMATCH_PENALTY;
                    self.lastFlipMessage = [NSString stringWithFormat:@"Mismatch: %@ do not match. Lose %d points.",
                                            [cardsToMatch componentsJoinedByString:@", "],
                                            MISMATCH_PENALTY];
                }
            } else {
                self.score -= FLIP_COST;
                if (!self.lastFlipMessage) {
                    self.lastFlipMessage = [NSString stringWithFormat:@"Flipped up %@", card.contents];
                }
            }
        }
        card.faceUp = !card.faceUp;
    }
}



@end

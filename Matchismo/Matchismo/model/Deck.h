//
//  Deck.h
//  Matchismo
//
//  Created by Chris Johnson Bidler on 1/29/13.
//  Copyright (c) 2013 Chris Johnson Bidler. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject

-(void) addCard:(Card *)card atTop:(BOOL)atTop;

-(Card *)drawRandomCard;

@end

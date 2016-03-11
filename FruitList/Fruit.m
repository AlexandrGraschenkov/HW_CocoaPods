//
//  Fruit.m
//  FruitList
//
//  Created by Эдуард Рязапов on 27.02.16.
//  Copyright © 2016 Эдуард Рязапов. All rights reserved.
//

#import "Fruit.h"

@implementation Fruit

+ (instancetype)fruitWithDictionary: (NSDictionary *)dictionary {
    Fruit *fruit = [Fruit new];
    fruit.fruitName = dictionary[@"title"];
    fruit.thumb = [NSURL URLWithString:dictionary[@"thumb"]];
    fruit.img = [NSURL URLWithString:dictionary[@"img"]];
    return fruit;
}

@end

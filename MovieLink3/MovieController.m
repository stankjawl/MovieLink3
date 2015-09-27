//
//  MovieController.m
//  MovieLink3
//
//  Created by Douglas Goodwin on 9/26/15.
//  Copyright © 2015 Dr.G. All rights reserved.
//

#import "MovieController.h"
#import "NetworkController.h"
#import "Actor.h"
#import "MoviesWithActor.h"
#import "CastFromMovie.h"

@interface MovieController ()

@property (nonatomic, strong) NSArray *actorSearchResults;
@property (nonatomic, strong) NSArray *moviesWithActorArray;
@property (nonatomic, strong) NSArray *actorsFromMovieArray;


@end

@implementation MovieController


//  This will get Actors from Search
- (void) getActorIDAndName:(NSString *)searchTerm completion:(void (^) (BOOL success)) completion {
    
    NSURLSession *newSession = [NSURLSession sharedSession];
    NSURL *urlPath = [NSURL URLWithString:[NetworkController getActorID:@{@"term":searchTerm}]];
    
    NSURLSessionDataTask *dataTask = [newSession dataTaskWithURL:urlPath completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
            completion(NO);
        } else {
            
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            NSArray *resultsArray = responseDictionary[@"results"];
            if (resultsArray.count > 0) {
                NSMutableArray *actorMutableArray = [NSMutableArray new];
                
                for (NSDictionary *dictionary in resultsArray) {
                    Actor *actor = [[Actor alloc] initWithDictionary:dictionary];
                    
                    [actorMutableArray addObject:actor];
                }
                self.actorSearchResults = actorMutableArray;
            }
            completion(YES);
        }
    }];
    [dataTask resume];
}


//  This will get an actors list of movies
- (void) getMoviesWithActorWithID:(NSString *)searchTerm completion:(void (^) (BOOL success)) completion {
    
    NSURLSession *newSession = [NSURLSession sharedSession];
    NSURL *urlPath = [NSURL URLWithString:[NetworkController getMoviesWithActor:@{@"term":searchTerm}]];
    
    NSURLSessionDataTask *dataTask = [newSession dataTaskWithURL:urlPath completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
            completion(NO);
        } else {
            
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            NSArray *castArray = responseDictionary[@"cast"];
            if (castArray.count > 0) {
                NSMutableArray *castMutableArray = [NSMutableArray new];
                
                for (NSDictionary *dictionary in castArray) {
                    MoviesWithActor *movies = [[MoviesWithActor alloc] initWithDictionary:dictionary];
                    
                    [castMutableArray addObject:movies];
                }
                self.moviesWithActorArray = castMutableArray;
            }
            completion(YES);
        }
    }];
    [dataTask resume];
}


// This will get Actors from a movie using the Movie ID
- (void) getActorsFromMovieWithID:(NSString *)searchTerm completion:(void (^) (BOOL success)) completion {
    
    NSURLSession *newSession = [NSURLSession sharedSession];
    NSURL *urlPath = [NSURL URLWithString:[NetworkController getCastFromMovie:@{@"term":searchTerm}]];
    
    NSURLSessionDataTask *dataTask = [newSession dataTaskWithURL:urlPath completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
            completion(NO);
        } else {
            
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            NSArray *castArray = responseDictionary[@"cast"];
            if (castArray.count > 0) {
                NSMutableArray *castMutableArray = [NSMutableArray new];
                
                for (NSDictionary *dictionary in castArray) {
                    CastFromMovie *movies = [[CastFromMovie alloc] initWithDictionary:dictionary];
                    
                    [castMutableArray addObject:movies];
                }
                self.actorsFromMovieArray = castMutableArray;
            }
            completion(YES);
        }
    }];
    [dataTask resume];
}





@end

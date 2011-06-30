//
//  openEarsPlugin.mm
//  rhymble
//
//  Created by Richard Telep on 6/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "openEarsPlugin.h"

@implementation openEarsPlugin


/*
 *  ++++++++++++++++++++++++++++++++++++++++
 *  Fields
 *  ++++++++++++++++++++++++++++++++++++++++
 */  
@synthesize audio_session_manager;
-(AudioSessionManager *) audio_session_manager{
    if (audio_session_manager == nil){
        audio_session_manager = [[AudioSessionManager alloc] init];
    }
    return audio_session_manager;
}

@synthesize pocket_sphinx_controller;
-(PocketsphinxController *) pocket_sphinx_controller{
    if (pocket_sphinx_controller == nil){
        pocket_sphinx_controller = [[PocketsphinxController alloc] init];
    }
    return pocket_sphinx_controller;
}

@synthesize openears_events_observer;
-(OpenEarsEventsObserver *) openears_events_observer{
    if (openears_events_observer == nil){
        openears_events_observer = [[OpenEarsEventsObserver alloc] init];
    }
    return openears_events_observer;
}

@synthesize flite_controller;
-(FliteController *) flite_controller{
    if (flite_controller == nil){
        flite_controller = [[FliteController alloc] init];
    }
    return flite_controller;
}

@synthesize current_language_model;
@synthesize current_dictionary;

/*
 *  ++++++++++++++++++++++++++++++++++++++++
 *  AudioSessionManager methods
 *  ++++++++++++++++++++++++++++++++++++++++
 */  


-(void)startAudioSession:(NSArray *)arguments withDict:(NSDictionary *)options{
    
    // Start AudioSessionManager
    [self.audio_session_manager startAudioSession];

    // This class will be the delegate of the OpenEarsEventsObserver object.
    [self.openears_events_observer setDelegate:self];


}

/*
 *  ++++++++++++++++++++++++++++++++++++++++
 *  Log
 *  ++++++++++++++++++++++++++++++++++++++++
 */

-(void)log:(NSString*)msg withDict:(NSMutableDictionary *)options{
    NSLog(@"%@",msg);
}


/*  
 *  ++++++++++++++++++++++++++++++++++++++++
 *  PocketsphinxController methods
 *  ++++++++++++++++++++++++++++++++++++++++
 */

-(void)pocketsphinxControllerStartListeningWithLanguageModelAtPath:(NSArray *)arguments withDict:(NSDictionary *)options{
    self.current_language_model = [NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle] resourcePath], [arguments objectAtIndex:0]];
    self.current_dictionary = [NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle] resourcePath], [arguments objectAtIndex:1]];
    [self.pocket_sphinx_controller startListeningWithLanguageModelAtPath:self.current_language_model dictionaryAtPath:self.current_dictionary languageModelIsJSGF:NO];
}

-(void)pocketsphinxControllerChangeLanguageModelToFile:(NSArray *) arguments withDict:(NSDictionary *)options{
    self.current_language_model = [NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle] resourcePath], [arguments objectAtIndex:0]];
    self.current_dictionary = [NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle] resourcePath], [arguments objectAtIndex:1]];
    [self.pocket_sphinx_controller changeLanguageModelToFile:self.current_language_model withDictionary:self.current_dictionary];
}

-(void)pocketsphinxControllerStopListening:(NSArray *)arguments withDict:(NSDictionary *)options{
    [self.pocket_sphinx_controller stopListening];
}

-(void)pocketsphinxControllerSuspendRecognition:(NSArray *)arguments withDict:(NSDictionary *)options{
    [self.pocket_sphinx_controller suspendRecognition];
}

-(void)pocketsphinxControllerResumeRecognition:(NSArray *)arguments withDict:(NSDictionary *)options{
    [self.pocket_sphinx_controller resumeRecognition];
}

/*
 *  ++++++++++++++++++++++++++++++++++++++++
 *  FliteController methods
 *  ++++++++++++++++++++++++++++++++++++++++
 */

-(void)fliteControllerSay:(NSString *)phrase withDict:(NSDictionary *)options{
    NSString* phrase_out = [[NSString alloc] initWithFormat:@"%@",phrase];
    NSLog(phrase_out);
    [self.flite_controller say:phrase_out withVoice:@"cmu_us_slt"];
    [phrase_out release];
}

/*
 *  ++++++++++++++++++++++++++++++++++++++++
 *  OpenEarsEventsObserver delegate methods
 *  ++++++++++++++++++++++++++++++++++++++++
 */

- (void) pocketsphinxDidReceiveHypothesis:(NSString *)hypothesis recognitionScore:(NSString *)recognitionScore utteranceID:(NSString *)utteranceID {
    NSLog(@"Pocketsphinx received a hypothesis is %@ with a score of %@ and an ID of %@", hypothesis, recognitionScore, utteranceID);
    NSString* jsString = [[NSString alloc] initWithFormat:@"window.plugins.openEarsPlugin.callbacks.pocketsphinxDidReceiveHypothesis(\"%@\",%@,%@);",hypothesis,recognitionScore,utteranceID];
    [self writeJavascript:jsString];
	[jsString release];
}

// This doesn't appear to be working:
//- (void) pocketsphinxDidChangeLanguageModelToFile:(NSString *)newLanguageModelPathAsString andDictionary:(NSString *)newDictionaryPathAsString {
//	NSLog(@"Pocketsphinx is now using the following language model: \n%@ and the following dictionary: %@",newLanguageModelPathAsString,newDictionaryPathAsString);
//    NSString* jsString = [[NSString alloc] initWithFormat:@"window.plugins.openEarsPlugin.callbacks.pocketsphinxDidChangeLanguageModelToFile(\"%@\");",newDictionaryPathAsString];
//    NSLog(jsString);
//    [self writeJavascript:jsString];
//	[jsString release];
//}

        // There are numerous other methods to implement here.


/*
 *  ++++++++++++++++++++++++++++++++++++++++
 *  Cleanup
 *  ++++++++++++++++++++++++++++++++++++++++
 */

-(void) dealloc {
    [audio_session_manager release];
    [pocket_sphinx_controller release];
    openears_events_observer.delegate = nil;
    [openears_events_observer release];
    [current_language_model release];
    [current_dictionary release];
    [super dealloc];
}




@end

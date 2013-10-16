/**
 * ...
 * @author shoe[box]
 */
#include <HypVideo.h>
#import <MediaPlayer/MediaPlayer.h>
#import <UIKit/UIKit.h>
#import <UIKit/UIApplication.h>
//
    typedef void( *FunctionType)( );
    extern "C"{
        void HypVideo_dispatch_event( const char *sEvent , const char *sArg );
    }

//Interface
    @interface MovieLayer : UIViewController<UIGestureRecognizerDelegate>{
        IBOutlet MPMoviePlayerViewController *videoPlayer;
    }
        @property(nonatomic,retain)IBOutlet MPMoviePlayerViewController *videoPlayer;
        @property(nonatomic,retain)NSTimer *pollPlayerTimer;
        @property int orientation;
    @end

//Implementation

    @implementation MovieLayer

        @synthesize videoPlayer;
        @synthesize pollPlayerTimer;
        @synthesize orientation;

        -(id) init {
            self = [ super init ];
            return self;
        }

        -(void) dealloc {
            [self close];
            [super dealloc];
        }

        -(void) close{
            NSLog(@"HypVideo ::: close");
            [self endPlayerPolling];
             [[[[UIApplication sharedApplication] keyWindow] rootViewController] dismissMoviePlayerViewControllerAnimated];
            //[videoPlayer stop];
            //[videoPlayer.view removeFromSuperview];
        }

        -(void) open:(NSString*)NSVideoPath{

             NSURL*NSVideoURL=[NSURL URLWithString:NSVideoPath];
            self.videoPlayer =  [[MPMoviePlayerViewController alloc] initWithContentURL:NSVideoURL];
            [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentMoviePlayerViewControllerAnimated:videoPlayer];
            //[[[UIApplication sharedApplication] keyWindow] setRootViewController:self];
            /*[[[[UIApplication sharedApplication] keyWindow] rootViewController] presentMoviePlayerViewControllerAnimated:
            //
                UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture)];
                tapGestureRecognizer.delegate = self;

            //
                NSLog( @"open >> " );


            //
                if( videoPlayer == nil )
                    videoPlayer = [[MPMoviePlayerViewController alloc] initWithContentURL:NSVideoURL ];
                    videoPlayer.shouldAutoplay = YES;
                    videoPlayer.backgroundView.hidden = NO;
                    videoPlayer.controlStyle = MPMovieControlStyleEmbedded;//MPMovieControlStyleEmbedded;

             //
                [videoPlayer.view addGestureRecognizer:tapGestureRecognizer];
                //[videoPlayer setScalingMode:MPMovieScalingModeFill];

            //


            //
                [[[UIApplication sharedApplication] keyWindow] addSubview:videoPlayer.view];
                [videoPlayer setFullscreen:YES animated:NO];
            */
                 [[NSNotificationCenter defaultCenter]   addObserver:self
                                                        selector:@selector(moviePlayBackDidFinish:)
                                                        name:MPMoviePlayerPlaybackDidFinishNotification
                                                        object:videoPlayer.moviePlayer];
                [self beginPlayerPolling];

               // [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentMoviePlayerViewControllerAnimated:player];
        }

        - (void) moviePlayBackDidFinish:(NSNotification*)notification {
            NSString *str = [[[notification userInfo] valueForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey] stringValue];
            NSLog(@"moviePlayBackDidFinish >> %@",str);
            [self close];
            HypVideo_dispatch_event( "onComplete" , [str UTF8String] );
        }

        - (void) beginPlayerPolling {
            pollPlayerTimer = [NSTimer scheduledTimerWithTimeInterval:0.01
                                            target:self
                                            selector:@selector(PollPlayerTimer_tick:)
                                            userInfo:nil
                                            repeats:YES];

        }

        - (void) PollPlayerTimer_tick:(NSObject *)sender {
            //NSLog(@"PollPlayerTimer_tick %o",videoPlayer.moviePlayer.playbackState);
            if (videoPlayer.moviePlayer.playbackState == MPMoviePlaybackStatePlaying) {
                HypVideo_dispatch_event( "onPositionChanged", [[NSString stringWithFormat:@"%f",videoPlayer.moviePlayer.currentPlaybackTime*1000] UTF8String] );
            }

        }

        - (void) endPlayerPolling {
            if (pollPlayerTimer != nil) {
                [pollPlayerTimer invalidate];
                pollPlayerTimer = nil;
            }
        }

        //iOS 6

        -(BOOL)shouldAutorotate{
            NSLog(@"shouldAutorotate");
            return YES;
        }

        -(NSInteger)supportedInterfaceOrientations{
            NSLog(@"supportedInterfaceOrientations");
            if( orientation == 1 ) {
                return UIInterfaceOrientationMaskLandscape;
            } else if ( orientation == 2 ){
                return UIInterfaceOrientationMaskPortrait;
            }
            return UIInterfaceOrientationMaskLandscape
                    || UIInterfaceOrientationMaskPortrait;
        }

        //iOS 5

        - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
            if( orientation == 1) {
                return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft
                        || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
            } else if( orientation == 2) {
                return (interfaceOrientation == UIInterfaceOrientationPortrait);
            }
            return YES;
        }



        #pragma mark - gesture delegate
        // this allows you to dispatch touches
        - (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
            return YES;
        }
        // this enables you to handle multiple recognizers on single view
        - (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
            return YES;
        }

        - ( void ) handleTap : ( UITapGestureRecognizer *) recognizer {
            NSLog(@"moviePlayBackDidFinish >> ");
        }

    @end

namespace hypvideo{

    static MovieLayer *instance;

    void play_remote( const char *sURL, int orientation ){

        //
            NSString *NSVideoPath = [NSString stringWithUTF8String:sURL ];
            NSLog(@"play_remote >> %@",NSVideoPath);

        //
            if( instance == nil )
                instance = [MovieLayer alloc];

            instance.orientation = orientation;
            [instance open:NSVideoPath];
    }

    void dispose( ){
        [instance close];
        if( instance != nil )
            instance = nil;
    }


}
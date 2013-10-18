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
        static const char* const PLAYBACK_COMPLETE  = "HypVideoEvent_PLAYBACK_COMPLETE";
        static const char* const PLAYBACK_ERROR     = "HypVideoEvent_PLAYBACK_ERROR";
        static const char* const PLAYBACK_INFO      = "HypVideoEvent_PLAYBACK_INFO";
        static const char* const PLAYBACK_PAUSE     = "HypVideoEvent_PLAYBACK_PAUSE";
        static const char* const PLAYBACK_PLAY      = "HypVideoEvent_PLAYBACK_PLAY";
        static const char* const PLAYBACK_SEEK      = "HypVideoEvent_PLAYBACK_SEEK";
        static const char* const PLAYBACK_STOP      = "HypVideoEvent_PLAYBACK_STOP";
    }

//Interface
    @interface HypVideo : UIViewController<UIGestureRecognizerDelegate>{
        IBOutlet MPMoviePlayerViewController *videoPlayer;
    }
        +(HypVideo *) getInstance;
        -(void) playRemote_video:(NSString*)nsVideo_path;
        @property(nonatomic,strong)IBOutlet MPMoviePlayerViewController *videoPlayer;

    @end

//Implementation

    @implementation HypVideo



        @synthesize videoPlayer;

        /**
        * Return the singleton instance of the class
        *
        * @public
        * @return    instance ( HypVideo )
        */
        +(HypVideo *) getInstance{
            static HypVideo *instance;
            @synchronized( self ){

                if( !instance ){
                    instance = [[HypVideo alloc] init];
                    NSLog(@"create instance");
                }

                return instance;
            }
        }

        /**
        * Class intitialization
        *
        * @public
        * @return    void
        */
        -(id ) init{
            if( self == [super init]){
                NSLog(@"init");
            }
            return self;
        }

        /**
        * Deallocation
        *
        * @public
        * @return    void
        */
        -( void ) dealloc{
            if( self.videoPlayer != nil )
                [self.videoPlayer dealloc];

            [super dealloc];
        }

        /**
        * Play a remote video by it's path
        *
        * @public
        * @return    void
        */
        -(void) playRemote_video:(NSString*)nsVideo_path{
            NSLog(@"playRemote_video");
            //Path to URL
                NSURL *nsVideoURL = [NSURL URLWithString:nsVideo_path];

            //The video player
                self.videoPlayer = [MPMoviePlayerViewController alloc];
                [self.videoPlayer initWithContentURL:nsVideoURL];

            //Listeners
                 [[NSNotificationCenter defaultCenter] addObserver:self
                                                          selector:@selector(playbackFinished:)
                                                              name:MPMoviePlayerPlaybackDidFinishNotification
                                                            object:self.videoPlayer.moviePlayer];

                 [[NSNotificationCenter defaultCenter] addObserver:self
                                                          selector:@selector(onPlayback_state_changed:)
                                                              name:MPMoviePlayerPlaybackStateDidChangeNotification
                                                            object:self.videoPlayer.moviePlayer];
                 NSLog(@"listeners ok");
            //
                [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentMoviePlayerViewControllerAnimated:self.videoPlayer];

            //Autoplay
                [self.videoPlayer.moviePlayer prepareToPlay];
                [self.videoPlayer.moviePlayer play];

        }

        - (void) removeListeners{
            if( self.videoPlayer != nil ){
                [[NSNotificationCenter defaultCenter] removeObserver:self
                                                                name:MPMoviePlayerPlaybackDidFinishNotification
                                                              object:self.videoPlayer.moviePlayer];

                [[NSNotificationCenter defaultCenter] removeObserver:self
                                                                name:MPMoviePlayerPlaybackStateDidChangeNotification
                                                              object:self.videoPlayer.moviePlayer];
            }
        }

        /**
        * Playback's done
        *
        * @public
        * @return    void
        */
         - (void) playbackFinished:(NSNotification*)notification {
            NSLog(@"playbackFinished");
            //Reason
                NSNumber *resultValue = [[notification userInfo] objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
                MPMovieFinishReason reason = [resultValue intValue];
                if (reason == MPMovieFinishReasonPlaybackError){

                    //There is an error ?
                        NSError *mediaPlayerError = [[notification userInfo] objectForKey:@"error"];

                    //If a knowed error
                        if (mediaPlayerError)
                            HypVideo_dispatch_event( PLAYBACK_ERROR, [[mediaPlayerError localizedDescription] UTF8String]);
                        else
                            HypVideo_dispatch_event( PLAYBACK_ERROR , "" );
                }else{
                    //Playback completed
                        HypVideo_dispatch_event( PLAYBACK_COMPLETE , "" );
                }

            //Cleaning
                [[[[UIApplication sharedApplication] keyWindow] rootViewController] dismissMoviePlayerViewControllerAnimated];
                [self removeListeners];
                //if( self.videoPlayer != nil )
                //  [self.videoPlayer release];

        }

        /**
        * Playback state changed
        *
        * @public
        * @return    void
        */
        - (void) onPlayback_state_changed:(NSNotification *)notification{
            NSLog(@"onPlayback_state_changed");
            switch( self.videoPlayer.moviePlayer.playbackState ){

                case MPMoviePlaybackStatePlaying:
                    HypVideo_dispatch_event( PLAYBACK_PLAY , "" );
                    break;

                case MPMoviePlaybackStatePaused:
                    HypVideo_dispatch_event( PLAYBACK_PAUSE , "" );
                    break;

                case MPMoviePlaybackStateStopped:
                case MPMoviePlaybackStateInterrupted:
                    HypVideo_dispatch_event( PLAYBACK_STOP , "" );
                    break;

                case MPMoviePlaybackStateSeekingForward:
                case MPMoviePlaybackStateSeekingBackward:
                    //NSLog(@"seek %f", self.videoPlayer.moviePlayer.currentPlaybackTime );
                    HypVideo_dispatch_event( PLAYBACK_SEEK , [[NSString stringWithFormat:@"%f", self.videoPlayer.moviePlayer.currentPlaybackTime] UTF8String] );
                    break;
            }
        }

    @end

namespace hypvideo{

    static HypVideo *instance;

    void playRemote( const char *sVideo_path ){

        //The video path
            NSString *nsVideo_path = [NSString stringWithUTF8String:sVideo_path];

        //Playing it
            [[HypVideo getInstance] playRemote_video:nsVideo_path];

    }


}
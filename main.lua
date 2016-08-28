display.setStatusBar( display.HiddenStatusBar )

local ads = require "ads"
local composer = require "composer"
composer.gotoScene( "start", {effect = "zoomInOutFade", } )


ads.init( "vungle", "53c5f2345de79cf30600000a", vungleListener )
ads.init( "crossinstall", "WjCk", crossListener )
--ads.init( "iads", "com.yourcompany.yourapp", iAdsListener )



local bannerAppID = "ca-app-pub-8387419053882656/4108544725"
local interstitialAppID = "ca-app-pub-8387419053882656/2492210725"

ads.init( "admob", bannerAppID, admobListener )





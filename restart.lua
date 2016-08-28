local composer = require( "composer" )
local scene = composer.newScene()


local ads = require "ads"

local sWidth = display.contentWidth 
local sHeight = display.contentHeight
local bHeight = math.round(sWidth * 0.15625)
local bannerAppID = "ca-app-pub-8387419053882656/4108544725"
local interstitialAppID = "ca-app-pub-8387419053882656/2492210725"

local mydata = require( "mydata" )
local score = require( "score" )



local function admobListener( event )
    if (  event.isError ) then
    	--ads:setCurrentProvider( "iAds" )
    	--ads.show( "banner", { x=0, y=0 } )
    	ads:setCurrentProvider( "crossinstall" )
        ads.show( "banner", "top", { x=0, y= sHeight - bHeight, w= sWidth, h= bHeight , timeout=10 } )


        
    end
end



local function vungleListener( event )
    if ( event.type == "adStart" and event.isError ) then
    	ads:setCurrentProvider( "admob" )
        ads.show( "banner", { x=0, y=0, appID=bannerAppID, testMode=false } )

        
    end
end

local function crossListener( event )
    if (  event.isError ) then


        
    end
end

local function iAdsListener( event )
   if ( event.isError ) then
   		ads:setCurrentProvider( "crossinstall" )
        ads.show( "banner", "top", { x=0, y= sHeight - bHeight, w= sWidth, h= bHeight , timeout=10 } )
      
   end
   
end






-- background

function restartGame(event)
     if event.phase == "ended" then
		saveScore()
		composer.gotoScene("start", {effect = "fromLeft"})
     end
end

function showStart()
	startTransition = transition.to(restart,{time=200, alpha=1})
	scoreTextTransition = transition.to(scoreText,{time=600, alpha=1})
	scoreTextTransition = transition.to(bestText,{time=600, alpha=1})
end

function showScore()
	scoreTransition = transition.to(scoreBg,{time=600, y=display.contentCenterY,onComplete=showStart})
end

function showGameOver()
	fadeTransition = transition.to(gameOver,{time=200, alpha=1,onComplete=showScore})
end

function loadScore()
    
	local prevScore = score.load()
	if prevScore ~= nil then
		if prevScore <= mydata.score then
			score.set(mydata.score)
		else 
			score.set(prevScore)
		end
	else 
		score.set(mydata.score)
	end
end

function saveScore()
	score.save()
end

---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------

-- local forward references should go here

---------------------------------------------------------------------------------

-- "scene:create()"
function scene:create( event )

   local sceneGroup = self.view

   -- Initialize the scene here.
   -- Example: add display objects to "sceneGroup", add touch listeners, etc.
   
    background = display.newImageRect("bg.png",900,1425)
	background.anchorX = 0.5
	background.anchorY = 1.0
	background.x = display.contentCenterX
	background.y = display.contentHeight 
	sceneGroup:insert(background)
	
	gameOver = display.newImageRect("gameOver.png",500,100)
	gameOver.anchorX = 0.5
	gameOver.anchorY = 0.5
	gameOver.x = display.contentCenterX 
	gameOver.y = display.contentCenterY - 400
	gameOver.alpha = 0
	sceneGroup:insert(gameOver)
	
	scoreBg = display.newImageRect("overlay.png",500,375)
	scoreBg.anchorX = 0.5
	scoreBg.anchorY = 0.5
	
    scoreBg.x = display.contentCenterX
    scoreBg.y = display.contentHeight + 500
    sceneGroup:insert(scoreBg)
	
	restart = display.newImageRect("play.png",255,70)
	restart.anchorX = 0.5
	restart.anchorY = 1
	restart.x = display.contentCenterX
	restart.y = display.contentCenterY + 400
	restart.alpha = 0
	sceneGroup:insert(restart)
	
	scoreText = display.newText(mydata.score,display.contentCenterX + 90,
	display.contentCenterY - 80, "04b19", 60)
	scoreText.anchorX = 1
	scoreText:setFillColor(0,0,0)
	scoreText.alpha = 0 
	sceneGroup:insert(scoreText)
	
	bestText = score.init({
	fontSize = 60,
	font = "04b19",
	x = display.contentCenterX + 90,
	y = display.contentCenterY + 60,
	maxDigits = 7,
	leadingZeros = false,
	filename = "scorefile.txt",
	})
	bestScore = score.get()
	bestText.text = bestScore
	bestText.alpha = 0
	bestText.anchorX = 1
	bestText:setFillColor(0,0,0)
	sceneGroup:insert(bestText)
end

-- "scene:show()"
function scene:show( event )

   local sceneGroup = self.view
   local phase = event.phase

   if ( phase == "will" ) then
      -- Called when the scene is still off screen (but is about to come on screen).
   elseif ( phase == "did" ) then
      -- Called when the scene is now on screen.
      -- Insert code here to make the scene come alive.
      -- Example: start timers, begin animation, play audio, etc.
	composer.removeScene("game")
	restart:addEventListener("touch", restartGame)
	showGameOver()
	--saveScore()
	loadScore()

	local randomAd = math.random(13)


	if (randomAd == 1) then
        ads:setCurrentProvider( "vungle" )
        ads.show( "interstitial")
    elseif (randomAd ==2 ) then
     	ads:setCurrentProvider("admob")
        ads.show( "interstitial", { appID=interstitialAppID, testMode=false} )
    elseif (randomAd ==3 ) then
     	ads:setCurrentProvider("admob")
        ads.show( "interstitial", { appID=interstitialAppID, testMode=false} )
    else
    	ads:setCurrentProvider( "admob" )
        ads.show( "banner", { x=0, y=0, appID=bannerAppID, testMode=false } )

	end
	  
   end
end

-- "scene:hide()"
function scene:hide( event )

   local sceneGroup = self.view
   local phase = event.phase

   if ( phase == "will" ) then
      -- Called when the scene is on screen (but is about to go off screen).
      -- Insert code here to "pause" the scene.
      -- Example: stop timers, stop animation, stop audio, etc.
	  
		restart:removeEventListener("touch", restartGame)
		transition.cancel(fadeTransition)
		transition.cancel(scoreTransition)
		transition.cancel(scoreTextTransition)
		transition.cancel(startTransition)
	  
   elseif ( phase == "did" ) then
      -- Called immediately after scene goes off screen.
   end
end

-- "scene:destroy()"
function scene:destroy( event )

   local sceneGroup = self.view

   -- Called prior to the removal of scene's view ("sceneGroup").
   -- Insert code here to clean up the scene.
   -- Example: remove display objects, save state, etc.
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

---------------------------------------------------------------------------------

return scene














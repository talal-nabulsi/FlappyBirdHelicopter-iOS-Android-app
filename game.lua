

local composer = require( "composer" )
local scene = composer.newScene()

local physics = require "physics"
physics.start()
physics.setGravity( 0, 70 )
physics.setDrawMode( "normal" )

local mydata = require( "mydata" )

local sound = audio.loadStream( "sound.mp3" )
local smash = audio.loadStream("smash.mp3")
local gameStarted = false

--local sfx = require("sfx")
---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------

-- local forward references should go here

---------------------------------------------------------------------------------
local function change() 

	audio.stop(soundChannel2)
	audio.dispose( smash )

	

	composer.gotoScene( "restart", {effect = "zoomInOut", time = 500} )

end

function onCollision( event )
	if ( event.phase == "began" ) then
		--audio.play(smash)

		--timer.performWithDelay( 1000, changeScene)
        Runtime:removeEventListener("collision", onCollision)

        player:setLinearVelocity(0 , 0)
        physics.setGravity( 0, 70 )


        --player.bodyType = "static"
        Runtime:removeEventListener("touch", flyUp)
	    timer.cancel(addColumnTimer)
	    timer.cancel(moveColumnTimer)
	    timer.cancel(addCloudTimer)
	    timer.cancel(moveCloudTimer)
	    transition.cancel(m1)
	    transition.cancel(m2)
	    Runtime:removeEventListener("enterFrame", platform)
	    Runtime:removeEventListener("enterFrame", platform2)





		audio.stop(soundChannel)
		audio.dispose( sound )

		delayTimer = timer.performWithDelay( 1000, change )

		soundChannel2 = audio.play(smash)


		


        --transition.to( group, { time=5000, onComplete=change() } )

	    --composer.gotoScene( "restart", {effect = "zoomInOut", time = 500} )
	    --change()


		
	end
end

function platformScroller(self,event)
	
	if self.x < (-900 + (self.speed*3)) then
		self.x = 900
	else 
		self.x = self.x - self.speed
	end
	
end



function flyUp(event)
	
    if event.phase == "began" then
       
		if gameStarted == false then
			 player.bodyType = "dynamic"
			 instructions.alpha = 0
			 tb.alpha = 1
			 addColumnTimer = timer.performWithDelay(1500, addColumns, -1)
			 moveColumnTimer = timer.performWithDelay(50, moveColumns, -1)
			 addCloudTimer = timer.performWithDelay( 4000, addCloud, 1 )
			 moveCloudTimer = timer.performWithDelay( 30, moveCloud, -1 )
			 --scoreTimer = timer.performWithDelay( 3000, scoreUp, -1 )
			 gameStarted = true
			 --player:applyLinearImpulse(0, -10, player.x, player.y)
			 player:setLinearVelocity(0 , -350)
	         physics.setGravity( 0, 0 )
	         --player.rotation = -20
	         local angular2 = transition.to( player, { rotation= -20, time=100,} )
	         player:setFrame(2)

	         soundChannel =audio.play(sound)
	         --player:play()



		else 
        --player:setLinearVelocity( 0, 0 )
	    --player:applyLinearImpulse(0, -10, player.x , player.y )
	    player:setLinearVelocity(0 , -390)
	    physics.setGravity( 0, 0 )
	    --player.rotation = -20
	    local angular = transition.to( player, { rotation= -20, time=100,} )

	    soundChannel = audio.play(sound)
	    --player:play()
	    player:setFrame(2)

	    


        end

    elseif event.phase == "ended" or event.phase == "cancelled" then
        physics.setGravity( 0, 100 )
        
        local angular3 = transition.to( player, { rotation= 20, time=100,} )
        --audio.rewind(soundChannel)
        audio.stop(soundChannel)
        player:pause()
        player:setFrame(1)





	end
end

function scoreUp()
	mydata.score = mydata.score +1
	tb.text = mydata.score
	tb2.text = mydata.score
end

function moveColumns()
		for a = elements.numChildren,1,-1  do
			--[[if(elements[a].x < display.contentCenterX - 170) then
				if elements[a].scoreAdded == false then
					mydata.score = mydata.score + 1
					tb.text = mydata.score
					tb2.text = mydata.score
					elements[a].scoreAdded = true
				end
			end
			if(elements[a].x > -100) then
				elements[a].x = elements[a].x - 15]]--

			if (elements[a].x < -75) then
			
			
				elements:remove(elements[a])

			elseif (elements[a].x < 230) then
				if elements[a].scoreAdded == false then
					mydata.score = mydata.score + 1
					tb.text = mydata.score
					tb2.text = mydata.score
					elements[a].scoreAdded = true
				end
			end	
		end
end


function moveCloud()
		for a = cloudGroup.numChildren,1,-1  do
			
			if(cloudGroup[a].x > -300) then
				cloudGroup[a].x = cloudGroup[a].x - 15

			else 
				height2 = math.random(display.contentCenterY - 600, display.contentCenterY-200)

				cloudGroup[a].x = display.contentWidth + 100
	            cloudGroup[a].y = height2
			end	
		end
end

function addColumns()
	
	height = math.random(display.contentCenterY - 370, display.contentCenterY + 300)

    randomInt = math.random(3)

  
    	
	topColumn = display.newImageRect(pipeSheet,randomInt, 130,800)
	topColumn.anchorX = 0.5
	topColumn.anchorY = 0.5
	topColumn.rotation = 180
	topColumn.x = display.contentWidth + 100
	topColumn.y = height - 610
	topColumn.scoreAdded = false
	physics.addBody(topColumn, "static", {density=1, bounce=0.1, friction=.2})
	local m1 = transition.to( topColumn, { time=2000, x = -100, } )
	


	elements:insert(topColumn)


    randomInt = math.random(3)
	bottomColumn = display.newImageRect(pipeSheet, randomInt, 130,800)
	bottomColumn.anchorX = 0.5
	bottomColumn.anchorY = 0
	bottomColumn.x = display.contentWidth + 100
	bottomColumn.y = height + 120
	physics.addBody(bottomColumn, "static", {density=1, bounce=0.1, friction=.2})
    local m2 = transition.to( bottomColumn, { time=2000, x = -100,  } )

	elements:insert(bottomColumn)

end	


function addCloud()
	local clouds = {"cloud.png", "cloud2.png"}
	local randomCloud = clouds[math.random(1,2)]
	cloud = display. newImageRect(randomCloud, 300, 250)
	cloud.anchorX = 0
	cloud.anchorY = 0

	cloud.x = display.contentWidth + 75
	cloud.y = height2
	
	cloudGroup:insert(cloud)

end



local function checkMemory()
   collectgarbage( "collect" )
   --local memUsage_str = string.format( "MEMORY = %.3f KB", collectgarbage( "count" ) )
   --print( memUsage_str, "TEXTURE = "..(system.getInfo("textureMemoryUsed") / (1024 * 1024) ) )
end


-- "scene:create()"
function scene:create( event )

   local sceneGroup = self.view
   
   gameStarted = false
   mydata.score = 0
   

   -- Initialize the scene here.
   -- Example: add display objects to "sceneGroup", add touch listeners, etc.
   
    local background = display.newImage("bg.png")
	sceneGroup:insert(background)

    bg = display.newImageRect('bg.png',900,1425)
	bg.anchorX = 0
	bg.anchorY = 1
	bg.x = 0
	bg.y = display.contentHeight
	bg.speed = 4
	sceneGroup:insert(bg)

	cloudGroup = display.newGroup()
	cloudGroup.anchorChildren = true
	cloudGroup.anchorX = 0
	cloudGroup.anchorY = 1
	cloudGroup.x = 0
	cloudGroup.y = 0
	sceneGroup:insert(cloudGroup)


    
    elements = display.newGroup()
	elements.anchorChildren = true
	elements.anchorX = 0
	elements.anchorY = 1
	elements.x = 0
	elements.y = 0
	sceneGroup:insert(elements)

	ground = display.newImageRect('ground.png',900,200)
	ground.anchorX = 0
	ground.anchorY = 1
	ground.x = 0
	ground.y = display.contentHeight
	physics.addBody(ground, "static", {density=.1, bounce=0.1, friction=.2})

	sceneGroup:insert(ground)


	ground2 = display.newImageRect('ground.png',900,200)
	ground2.anchorX = 0
	ground2.anchorY = 1
	ground2.x = 0
	ground2.y = -50
	physics.addBody(ground2, "static", {density=.1, bounce=0.1, friction=.2})

	sceneGroup:insert(ground2)

	platform = display.newImageRect('platform.png',900,53)
	platform.anchorX = 0
	platform.anchorY = 1
	platform.x = 0
	platform.y = display.viewableContentHeight - 156
	--physics.addBody(platform, "static", {density=.1, bounce=0.1, friction=.2})
	platform.speed = 7
	sceneGroup:insert(platform)

	platform2 = display.newImageRect('platform.png',905,53)
	platform2.anchorX = 0
	platform2.anchorY = 1
	platform2.x = 895
	platform2.y = display.viewableContentHeight - 156
	--physics.addBody(platform2, "static", {density=.1, bounce=0.1, friction=.2})
	platform2.speed = 7
	sceneGroup:insert(platform2)
	
	p_options = 
	{
		-- Required params
		width = 144,
		height = 94,
		numFrames = 2,
		-- content scaling
		sheetContentWidth = 288,
		sheetContentHeight = 94,
	}

	playerSheet = graphics.newImageSheet( "bat.png", p_options )
	player = display.newSprite( playerSheet, { name="player", start=1, count=2, time=100 } )
	player.anchorX = 0.5
	player.anchorY = 0.5
	player.x = display.contentCenterX - 150
	player.y = display.contentCenterY
	playerShape = { 35,40, 35,-20, -35,-20, -35, 40 }

	physics.addBody(player, "static", {density=.1, bounce=0.1, friction=1, shape=playerShape})
	player:applyForce(0, -300, player.x, player.y)
	--player:play()
	sceneGroup:insert(player)

	piptions =
	{

		width = 50,
		height = 256,
		numFrames = 3,
		sheetContentWidth = 150,
		sheetContentHeight = 256,
    }

	pipeSheet = graphics.newImageSheet( "pipeSprite.png",  piptions )

	tb2 = display.newText(mydata.score,100,
	100, "04b19", 100)
	tb2:setFillColor(0,0,0)
	tb2.alpha = 1
	tb2.anchorX = 0.5
	tb2.anchorY = 0.5
	sceneGroup:insert(tb2)

	tb = display.newText(mydata.score,99,
	99, "04b19", 80)
	tb:setFillColor(1,1,1)
	tb.alpha = 1
	tb.anchorX = 0.5
	tb.anchorY = 0.5
	sceneGroup:insert(tb)

	
	
	instructions = display.newImageRect("instructions.png",400,328)
	instructions.anchorX = 0.5
	instructions.anchorY = 0.5
	instructions.x = display.contentCenterX + 100
	instructions.y = display.contentCenterY
	sceneGroup:insert(instructions)
	
   
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
	  
	composer.removeScene("start")
	Runtime:addEventListener("touch", flyUp)

	platform.enterFrame = platformScroller
	Runtime:addEventListener("enterFrame", platform)

	platform2.enterFrame = platformScroller
	Runtime:addEventListener("enterFrame", platform2)
    
    Runtime:addEventListener("collision", onCollision)
   
    --memTimer = timer.performWithDelay( 1000, checkMemory, 0 )
	  
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
	


	timer.cancel(delayTimer)
	--timer.cancel(memTimer)
	transition.cancel(angular)
	transition.cancel(angular2)
	transition.cancel(angular3)
	--timer.cancel(scoreTimer)
	  
	  
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














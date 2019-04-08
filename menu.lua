
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local function gotoGame()
    composer.gotoScene( "level1" )
end

local function gotoHighScores()
    composer.gotoScene( "highscores" )
end




-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
    local background2 = display.newImageRect( sceneGroup, "background2.jpg", 600, 400 )
    background2.x = display.contentCenterX
    background2.y = display.contentCenterY

    local myText = display.newText( "Grandma!", display.contentCenterX, 50, native.systemFont, 60 )
    myText:setFillColor( 1, 0.70, 0.80 )

    local playButton = display.newText( sceneGroup, "Play", display.contentCenterX, 150, native.systemFont, 50 )
    playButton:setFillColor( 1, 1, 1 )

    local highScoresButton = display.newText( sceneGroup, "High Scores", display.contentCenterX, 230, native.systemFont, 44 )
    highScoresButton:setFillColor( 1,1,1 )

    playButton:addEventListener( "tap", gotoGame )
    


end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen

	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen

	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene

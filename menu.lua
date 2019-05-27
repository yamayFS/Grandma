
local composer = require( "composer" )

local scene = composer.newScene()
composer.recycleOnSceneChange=true

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local function gotoGame()
	composer.gotoScene( "selecaoFase", { time = 800, effect="crossFade" } )
end

local function gotoHighScores()
    composer.gotoScene( "highscores" )
end

local musicTrack



-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	
	local sceneGroup = self.view



	musicTrack = audio.loadStream( "music/musica-menu.mp3" )




	-- Code here runs when the scene is first created but has not yet appeared on screen
    local background2 = display.newImageRect( sceneGroup, "img/background-cidade.png", 600, 400 )
    background2.x = display.contentCenterX
	background2.y = display.contentCenterY
	
	local backGrandma = display.newImageRect (sceneGroup, "img/biggrandma.png", 250,280)
	backGrandma.x = display.contentCenterX +180
	backGrandma.y = display.contentCenterY +30

    local logoNome = display.newImageRect( sceneGroup,"img/nome.png",300,100  )
	logoNome.x = display.contentCenterX -20
	logoNome.y = display.contentCenterY -100

    local playButton = display.newText( sceneGroup, "Play", display.contentCenterX, 180, native.systemFont, 50 )
    playButton:setFillColor( 1, 1, 1 )

    

    playButton:addEventListener( "tap", gotoGame )
    


end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase
	print('SHOWWWW')

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		audio.play( musicTrack, { channel=1, loops=-1 } )
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
		audio.stop( 1 )
		-- Code here runs immediately after the scene goes entirely off screen
		
	end
end


-- destroy()
function scene:destroy( event )
	print('DESTROYYY')
	local sceneGroup = self.view
	audio.dispose( musicTrack )
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

local composer = require( "composer" )
local scene = composer.newScene()
 
local widget = require( "widget" )
 
-- Require "global" data table
-- This will contain relevant data like the current level, max levels, number of stars earned, etc.
local myData = require( "mydata" )
 

 
-- Button handler to cancel the level selection and return to the menu
local function handleCancelButtonEvent( event )
    if ( "ended" == event.phase ) then
        composer.gotoScene( "menu", { effect="crossFade", time=333 } )
    end
end
 
-- Button handler to go to the selected level
local function handleLevelSelect( event )
    if ( "ended" == event.phase ) then
        -- 'event.target' is the button and '.id' is a number indicating which level to go to.  
        -- The 'game' scene will use this setting to determine which level to load.
        -- This could be done via passed parameters as well.
        myData.settings.currentLevel = event.target.id
 
        -- Purge the game scene so we have a fresh start
        composer.removeScene( "level1", false )
        composer.removeScene( "level2", false )

        
 
        -- Go to the game scene
        composer.gotoScene( "level" .. tostring(event.target.id), { effect="crossFade", time=333 } )


    end
end
 
-- Declare the Composer event handlers
-- On scene create...
function scene:create( event )
    local sceneGroup = self.view
 
    -- Create background
    local background = display.newRect( 0, 0, display.contentWidth, display.contentHeight )
    background:setFillColor( 1 )
    background.x = display.contentCenterX -20
    background.y = display.contentCenterY
    background:scale( 1.2, 20 )
    sceneGroup:insert( background )

    local nomeFase = display.newImageRect("img/fase.png",300,80)
    nomeFase.x = display.contentCenterX
    nomeFase.y = display.contentCenterY -100
    sceneGroup:insert( nomeFase )

    -- Use a scrollView to contain the level buttons (for support of more than one full screen).
    -- Since this will only scroll vertically, lock horizontal scrolling.
    local levelSelectGroup = widget.newScrollView({
        width = 400,
        height = 100,
        
        
    })
 
    -- 'xOffset', 'yOffset' and 'cellCount' are used to position the buttons in the grid.
    local xOffset = 50
    local yOffset = 24
    local cellCount = 1
 
    -- Define the array to hold the buttons
    local buttons = {}
 
    -- Read 'maxLevels' from the 'myData' table. Loop over them and generating one button for each.
    for i = 1, myData.maxLevels do
        -- Create a button
        buttons[i] = widget.newButton({
            label = tostring( i ),
            id = tostring( i ),
            onEvent = handleLevelSelect,
            emboss = false,
            shape="roundedRect",
            width = 48,
            height = 32,
            fontSize = 18,
            labelColor = { default = { 1, 1, 1 }, over = { 0.5, 0.5, 0.5 } },
            cornerRadius = 8,
            labelYOffset = -3, 
            fillColor = { default={ 1, 0.70, 0.80 }, over={ 1, 0.70, 0.80 } },
            strokeColor = { default={ 1, 0.70, 0.80 }, over={ 1, 0.70, 0.80 } },
            strokeWidth = 2
        })
        -- Position the button in the grid and add it to the scrollView
        buttons[i].x = xOffset
        buttons[i].y = yOffset
        levelSelectGroup:insert( buttons[i] )
 
        -- Check to see if the player has achieved (completed) this level.
        -- The '.unlockedLevels' value tracks the maximum unlocked level.
        -- First, however, check to make sure that this value has been set.
        -- If not set (new user), this value should be 1.
 
        -- If the level is locked, disable the button and fade it out.
        if ( myData.settings.unlockedLevels == nil ) then
            myData.settings.unlockedLevels = 1
        end
        if ( i <= myData.settings.unlockedLevels ) then
            buttons[i]:setEnabled( true )
            buttons[i].alpha = 1.0
        else 
            buttons[i]:setEnabled( false ) 
            buttons[i].alpha = 0.5 
        end 

        -- Compute the position of the next button.
        -- This tutorial draws 5 buttons across.
        -- It also spaces based on the button width and height + initial offset from the left.
        xOffset = xOffset + 75
        cellCount = cellCount + 1
        if ( cellCount > 5 ) then
            cellCount = 1
            xOffset = 64
            yOffset = yOffset + 45
        end
    end
 
    -- Place the scrollView into the scene and center it.
    sceneGroup:insert( levelSelectGroup )
    levelSelectGroup.x = display.contentCenterX
    levelSelectGroup.y = display.contentCenterY
 
    -- Create a cancel button for return to the menu scene.
    local doneButton = widget.newButton({
        id = "button1",
        label = "Voltar",
        onEvent = handleCancelButtonEvent
    })
    doneButton.x = display.contentCenterX
    doneButton.y = display.contentHeight - 20
    sceneGroup:insert( doneButton )
end
 
-- On scene show...
function scene:show( event )
    local sceneGroup = self.view
 
    if ( event.phase == "did" ) then
    end
end
 
-- On scene hide...
function scene:hide( event )
    local sceneGroup = self.view
 
    if ( event.phase == "will" ) then
    end
end
 
-- On scene destroy...
function scene:destroy( event )
    local sceneGroup = self.view   
end
 
-- Composer scene listeners
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
return scene
 
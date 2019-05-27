local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local physics = require( "physics")
physics.start()
physics.setGravity( 0,0)




local backGroup = display.newGroup()  -- Display group for the background image
local mainGroup = display.newGroup()  -- Display group for the ship, asteroids, lasers, etc.
local uiGroup = display.newGroup()    -- Display group for UI objects like the score


local setaCima
local setaBaixo
local setaDireita
local setaEsquerda

local veiculoLoopTimer
local coinLoop

local moveLeft = 0
local moveRight = 0
local moveDown = 0
local moveUp = 0

local touchFunction = function(e)
    print("entrou")
    
    if e.phase == "began"  then
        if e.target.myName == "right" then
            moveRight = 28
            velhinha.x = velhinha.x + moveRight
        else
            moveLeft = -28
            velhinha.x = velhinha.x + moveLeft         
        end
        
    elseif e.phase == "moved"  then
        if e.target.myName == "right" then     
            moveRight = 28
            velhinha.x = velhinha.x + moveRight
        else
            moveLeft = -28
            velhinha.x = velhinha.x + moveLeft
        end
        
    end
end


local function movimento(direcao, personagem)

    if ( direcao.myName == "up" ) then
        if( personagem.y - 28 > 0 ) then
            personagem.y = personagem.y - 28
        end
    elseif ( direcao.myName == "right" ) then
        if( personagem.x + 28 < display.contentWidth ) then
            personagem.x = personagem.x + 28
        end
    elseif ( direcao.myName == "down" ) then
        if( personagem.y + 28 < display.contentHeight) then
            personagem.y = personagem.y + 28
        end
    elseif (direcao.myName == "left") then
        if ( personagem.x > 0 ) then
            personagem.x = personagem.x - 28
        end
    end
end

--------------------------time remaining----------------------------------
local secondsLeft = 60  -- 10 minutes * 60 seconds

local clockText = display.newText( uiGroup, "00:60", display.contentCenterX, 25,display.contentWidth,-50, native.systemFont, 30 )
clockText:setFillColor( 0.7, 0.7, 1 )

-----------------------------------------------------------------------

local function updateTime( event )

    -- Decrement the number of seconds
    secondsLeft = secondsLeft - 1

    -- Time is tracked in seconds; convert it to minutes and seconds
    local minutes = math.floor( secondsLeft / 60 )
    local seconds = secondsLeft % 60

    -- Make it a formatted string
    local timeDisplay = string.format( "%02d:%02d", minutes, seconds )

    -- Update the text object
    clockText.text = timeDisplay
end

local countDownTimer = timer.performWithDelay( 1000, updateTime, secondsLeft )
------------------------------------------------------------------------------------------------------

local function gotoNextLevel()
	composer.gotoScene( "level3", { time=800, effect="crossFade" } )
end

local function gotoBack()
	composer.gotoScene( "menu", { time=800, effect="crossFade" } )
end


local function onCollision( event ) 

    if ( event.phase == "began" ) then

        local obj1 = event.object1
        local obj2 = event.object2
        

        if ( ( obj1.myName == "velhinha" and obj2.myName == "carro1" ) or
            ( obj1.myName == "carro1" and obj2.myName == "velhinha" ) or
            ( obj1.myName == "carro2" and obj2.myName == "velhinha" ) or 
            ( obj1.myName == "velhinha" and obj2.myName == "carro2" ))
            then
                display.remove (obj2)
                display.remove (setaBaixo)
                display.remove (setaCima)
                display.remove (setaEsquerda)
                display.remove (setaDireita)
                local myText = display.newText(mainGroup, "Game Over!", display.contentCenterX, 150, native.systemFont, 60 )
                myText:setFillColor( 1, 1, 1 )
                local menuButton = display.newText( mainGroup,"Voltar", display.contentCenterX, 250, native.systemFont, 30  )
                menuButton:setFillColor( 1, 1, 1 )
                menuButton:addEventListener( "tap", gotoBack )
                

            
        end
        
    end
    if ( event.phase == "began" ) then
        local obj1 = event.object1
        local obj2 = event.object2

        if ( ( obj1.myName == "velhinha" and obj2.myName == "calcada3" ) or
            ( obj1.myName == "calcada3" and obj2.myName == "velhinha" ) or
            ( obj1.myName == "calcada3" and obj2.myName == "velhinha" ) or 
            ( obj1.myName == "velhinha" and obj2.myName == "calcada3" ))
            then
                
                local myText = display.newText(mainGroup, "Congratulations!", display.contentCenterX, 150, native.systemFont, 60 )
                myText:setFillColor( 1, 1, 1 )
                local menuButton = display.newText( mainGroup,"Voltar", display.contentCenterX, 250, native.systemFont, 30  )
                menuButton:setFillColor( 1, 1, 1 )
                menuButton:addEventListener( "tap", gotoBack )
        end
    end
    if ( event.phase == "began" ) then
        local obj1 = event.object1
        local obj2 = event.object2

        -- If guy collides with coin, remove coin
        if(event.object1.myName == "velhinha" and event.object2.myName == "coin") then
            event.object2:removeSelf();
        end
        -- Remove coin when it reaches the ground
        if(event.object1.myName == "velhinha" and event.object2.myName == "coin") then
                event.object2:removeSelf();
        end
    end
end


-- local function createCoin()
-- 	coin = display.newCircle(mainGroup, math.random(0,600), math.random(0,400), math.random(10,10) )
-- 	coin:setFillColor(math.random(245,255),math.random(210,223),7)
-- 	coin:setStrokeColor(0,0,0)
-- 	physics.addBody( coin, "dynamic" )
-- 	coin.myName = "coin"
-- end

-- Load the background-------------------------------------------------------------------------------------------
local background = display.newImageRect (backGroup,"img/background.png", 600, 400)
background.x = display.contentCenterX
background.y = display.contentCenterY

local rua = display.newImageRect(mainGroup,"img/rua.jpg", 90, 30)
rua.x = display.contentCenterX
rua.y = display.contentHeight -65
rua.rotation = 90
rua:scale( 0.8, 18.9 )

local rua1 = display.newImageRect(mainGroup,"img/rua.jpg", 80, 40)
rua1.x = display.contentCenterX
rua1.y = display.contentHeight -162
rua1.rotation = 90
rua1.myName = "rua1"
rua1:scale( 0.8, 18.9 )

local rua2 = display.newImageRect(mainGroup,"img/rua.jpg", 80, 40)
rua2.x = display.contentCenterX
rua2.y = display.contentHeight -255
rua2.rotation = 90
rua2.myName = "rua2"
rua2:scale( 0.8, 18.9 )

local calcada = display.newImageRect(mainGroup,"img/calcada.jpg", 39, 30)
calcada.x = display.contentCenterX
calcada.y = display.contentHeight -11
calcada.rotation = 90
calcada:scale( 1, 20.9 )

local calcada1 = display.newImageRect(mainGroup,"img/calcada.jpg", 39, 30)
calcada1.x = display.contentCenterX
calcada1.y = display.contentHeight -116
calcada1.rotation = 90
calcada1.myName = "calcada1"
calcada1:scale( 0.8, 20.9 )

local calcada2 = display.newImageRect(mainGroup,"img/calcada.jpg", 39, 30)
calcada2.x = display.contentCenterX
calcada2.y = display.contentHeight -208
calcada2.rotation = 90
calcada2.myName = "calcada2"
calcada2:scale( 0.8, 20 )

local calcada3 = display.newImageRect(mainGroup,"img/calcada.jpg", 39, 30)
calcada3.x = display.contentCenterX
calcada3.y = display.contentHeight -302
calcada3.rotation = 90
calcada3.myName = "calcada3"
local offsetRectParams = { halfWidth=280, halfHeight=10, angle=90 }
physics.addBody(calcada3, { box=offsetRectParams , isSensor=true})
calcada3:scale( 1, 20 )

local velhinha = display.newImageRect (mainGroup,"img/grandma3.png", 30, 30)
velhinha.x = display.contentCenterX
velhinha.y = display.contentHeight - 20
physics.addBody( velhinha, {radius = 10 , isSensor=true})
velhinha.myName = "velhinha"

-- SETAS --------------------------------------------------------------------
setaCima = display.newImageRect(mainGroup,"img/arrow.png", 50,30)
setaCima.x = 12
setaCima.y = 260
setaCima.rotation = 360
setaCima.myName = "up"
local andarCima = function() return movimento(setaCima,velhinha) end
setaCima:addEventListener("tap", andarCima)

setaDireita = display.newImageRect(mainGroup,"img/arrow.png",45,30)
setaDireita.x = 45
setaDireita.y = 290
setaDireita.rotation = 90
setaDireita.myName = "right"
local andarDireita = function() return movimento(setaDireita,velhinha) end
setaDireita:addEventListener("tap", andarDireita)


setaEsquerda = display.newImageRect(mainGroup,"img/arrow.png",45,30)
setaEsquerda.x = -25
setaEsquerda.y = 290
setaEsquerda.rotation = 270
setaEsquerda.myName = "left"
local andarEsquerda = function() return movimento(setaEsquerda,velhinha) end
setaEsquerda:addEventListener("tap", andarEsquerda)



-----------------------------------------gera veiculos----------------------------------------
local function geraVeiculos()

    local carro1 = display.newImageRect(mainGroup,"img/naveVerde.png",30, 50)
    carro1.x = display.contentWidth - 1
    carro1.y = display.contentHeight - 85
    carro1.rotation = 270
    carro1.myName = "carro1"
    physics.addBody(carro1, { radius = 10,isSensor=true})
    --carro1:setLinearVelocity (-100,0)
    transition.to( carro1, { x=-100, time = 3000, onComplete = function() display.remove( carro1 ) end } )

    local carro1 = display.newImageRect(mainGroup,"img/naveVerde.png",30, 50)
    carro1.x = display.contentWidth - 1
    carro1.y = display.contentHeight - 180
    carro1.rotation = 270
    carro1.myName = "carro1"
    physics.addBody(carro1, { radius = 10,isSensor=true})
    --carro1:setLinearVelocity (-100,0)
    transition.to( carro1, { x=-90, time = 2000, onComplete = function() display.remove( carro1 ) end } )

    local carro1 = display.newImageRect(mainGroup,"img/naveVerde.png",30, 50)
    carro1.x = display.contentWidth - 1
    carro1.y = display.contentHeight - 270
    carro1.rotation = 270
    carro1.myName = "carro1"
    physics.addBody(carro1, { radius = 10,isSensor=true})
    --carro1:setLinearVelocity (-100,0)
    transition.to( carro1, { x=-200, time = 1500, onComplete = function() display.remove( carro1 ) end } )

    local carro2 = display.newImageRect(mainGroup,"img/naveAzul.png",30, 50)
    carro2.x = display.contentWidth - 550
    carro2.y = display.contentHeight - 50
    carro2.rotation = - 270
    carro2.myName = "carro1"
    physics.addBody(carro2, {radius = 10, isSensor=true})
    --carro2:setLinearVelocity (100,0)
    transition.to( carro2, { x=display.contentWidth + 100, time = 3000, onComplete = function() display.remove( carro2 ) end } )

    local carro2 = display.newImageRect(mainGroup,"img/naveAzul.png",30, 50)
    carro2.x = display.contentWidth - 550
    carro2.y = display.contentHeight - 240
    carro2.rotation = - 270
    carro2.myName = "carro1"
    physics.addBody(carro2, { radius = 10,radius = 10,isSensor=true})
    --carro2:setLinearVelocity (100,0)
    transition.to( carro2, { x=display.contentWidth + 70, time = 3000, onComplete = function() display.remove( carro2 ) end } )

    local carro2 = display.newImageRect(mainGroup,"img/naveAzul.png",30, 50)
    carro2.x = display.contentWidth - 550
    carro2.y = display.contentHeight - 150
    carro2.rotation = - 270
    carro2.myName = "carro1"
    physics.addBody(carro2, {radius = 10, isSensor=true})
    --carro2:setLinearVelocity (100,0)
    transition.to( carro2, { x=display.contentWidth + 170, time = 3000, onComplete = function() display.remove( carro2 ) end } )

    local carro3 = display.newImageRect(mainGroup,"img/naveAmarela.png",40, 30)
    carro3.x = display.contentWidth  + 100
    carro3.y = display.contentHeight - 85
    carro3.myName = "carro1"
    carro3.rotation = 270
    physics.addBody(carro3, { radius = 10,isSensor=true})
    --carro3:setLinearVelocity (-100,0)
    transition.to( carro3, { x=-100, time = 4000, onComplete = function() display.remove( carro3 ) end } )

    local carro3 = display.newImageRect(mainGroup,"img/naveAmarela.png",50, 40)
    carro3.x = display.contentWidth  + 100
    carro3.y = display.contentHeight - 180
    carro3.myName = "carro1"
    carro3.rotation = 270
    physics.addBody(carro3, { radius= 10, isSensor=true})
    --carro3:setLinearVelocity (-100,0)
    transition.to( carro3, { x=-200, time = 4000, onComplete = function() display.remove( carro3 ) end } )

    local carro3 = display.newImageRect(mainGroup,"img/naveAmarela.png",50, 40)
    carro3.x = display.contentWidth  + 100
    carro3.y = display.contentHeight - 275
    carro3.myName = "carro1"
    carro3.rotation = 270
    physics.addBody(carro3, { radius = 10, isSensor=true})
    --carro3:setLinearVelocity (-100,0)
    transition.to( carro3, { x=-300, time = 4000, onComplete = function() display.remove( carro3 ) end } )

    local caminhao = display.newImageRect(mainGroup,"img/naveCinza.png",40, 35)
    caminhao.x = display.contentWidth - 700
    caminhao.y = display.contentHeight - 50
    caminhao.myName = "carro1"
    caminhao.rotation = 90
    physics.addBody(caminhao, { radius = 10, isSensor=true})
    --caminhao:setLinearVelocity (100,0)
    transition.to( caminhao, { x=display.contentWidth + 100, time = 4000, onComplete = function() display.remove( caminhao ) end } )
    
    local caminhao = display.newImageRect(mainGroup,"img/naveCinza.png",40, 35)
    caminhao.x = display.contentWidth - 700
    caminhao.y = display.contentHeight - 150
    caminhao.myName = "carro1"
    caminhao.rotation = 90
    physics.addBody(caminhao, {radius = 10,  isSensor=true})
    --caminhao:setLinearVelocity (100,0)
    transition.to( caminhao, { x=display.contentWidth + 250, time = 4000, onComplete = function() display.remove( caminhao ) end } )

    local caminhao = display.newImageRect(mainGroup,"img/naveCinza.png",40, 35)
    caminhao.x = display.contentWidth - 700
    caminhao.y = display.contentHeight - 240
    caminhao.myName = "carro1"
    caminhao.rotation = 90
    physics.addBody(caminhao, {radius = 10,  isSensor=true})
    --caminhao:setLinearVelocity (100,0)
    transition.to( caminhao, { x=display.contentWidth + 50, time = math.random(3000,5000), onComplete = function() display.remove( caminhao ) end } )
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen

    physics.pause()  -- Temporarily pause the physics engine
    sceneGroup:insert( backGroup )
    sceneGroup:insert( mainGroup )
    sceneGroup:insert( uiGroup )

   

end

-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)
        
	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
		physics.start()
        Runtime:addEventListener( "collision", onCollision )
       
        coinLoop = timer.performWithDelay( 7000, createCoin, 0 )
     

        veiculoLoopTimer = timer.performWithDelay(math.random(1000,2500), geraVeiculos, 0 )
		--gameLoopTimer = timer.performWithDelay( 500, gameLoop, 0 )
	end
end

-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)
        timer.cancel( veiculoLoopTimer )
        

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
        Runtime:removeEventListener( "collision", onCollision )
        physics.pause()
       

		composer.removeScene( "level1" )
	end
end

-- destroy()
function scene:destroy( event )

    local sceneGroup = self.view
    timer.cancel(coinLoop)
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
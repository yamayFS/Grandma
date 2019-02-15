-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here
local physics = require( "physics")
physics.start()
physics.setGravity( 0,0)
physics.setDrawMode("hybrid")

local velhinha

local background = display.newImageRect ("background.png", 600, 400)
background.x = display.contentCenterX
background.y = display.contentCenterY

local rua = display.newImageRect("rua.jpg", 90, 30)
rua.x = display.contentCenterX
rua.y = display.contentHeight -70
rua.rotation = 90
rua:scale( 0.8, 18.9 )

local calcada = display.newImageRect("calcada.jpg", 39, 30)
calcada.x = display.contentCenterX
calcada.y = display.contentHeight -15
calcada.rotation = 90
calcada:scale( 1, 20.9 )

local carro1 = display.newImageRect("carro1.png",30, 50)
carro1.x = display.contentWidth - 1
carro1.y = display.contentHeight - 85
carro1.rotation = 90
carro1.myName = "carro1"
physics.addBody(carro1, {radius=20, isSensor=true})
carro1:setLinearVelocity (-100,0)


local velhinha = display.newImageRect ("velhinha.png", 30, 30)
velhinha.x = display.contentCenterX
velhinha.y = display.contentHeight - 30
physics.addBody( velhinha, { radius=10, isSensor=true})
velhinha.myName = "velhinha"


local function walkingVelhinha( event )
    local velhinha = event.target
    local phase = event.phase

    if ("began" == phase ) then
        display.currentStage:setFocus ( velhinha)
        velhinha.touchOffsetX = event.y - velhinha.y
    
    elseif ("moved" == phase) then
        velhinha.y = event.y - velhinha.touchOffsetX

    elseif ( "cancelled" == phase or "ended" == phase) then 
        display.currentStage:setFocus(nil)
    end
    return true
end



local function restaurarVelhinha() --Incompleto
    velhinha.isBodyActive = false
    velhinha.x = display.contentCenterX
    velhinha.y = display.contentHeight - 30

    
    transition.to( velhinha, {alpha=1, time=4000,
        onComplete = function()
            velhinha.isBodyActive = true
            died = false
        end
    })
end

local function onCollision( event ) 

    if ( event.phase == "began" ) then

        local obj1 = event.object1
        local obj2 = event.object2

        if ( ( obj1.myName == "velhinha" and obj2.myName == "carro1" ) or
            ( obj1.myName == "carro1" and obj2.myName == "velhinha" ) )
            then
                display.remove (obj2)
                local myText = display.newText( "Game Over!", display.contentCenterX, 150, native.systemFont, 60 )
                myText:setFillColor( 1, 1, 1 )

                --velhinha.alpha = 0
                --timer.performWithDelay( 1000, restoreShip )

        end
    end
end




Runtime:addEventListener( "collision", onCollision )
velhinha:addEventListener("touch", walkingVelhinha)
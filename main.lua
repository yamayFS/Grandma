
local physics = require( "physics")
physics.start()
physics.setGravity( 0,0)
physics.setDrawMode( "hybrid" )


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
physics.addBody(carro1, { isSensor=true})
carro1:setLinearVelocity (-100,0)

local carro2 = display.newImageRect("carro2.png",30, 50)
carro2.x = display.contentWidth - 550
carro2.y = display.contentHeight - 50
carro2.rotation = - 90
carro2.myName = "carro2"
physics.addBody(carro2, { isSensor=true})
carro2:setLinearVelocity (100,0)


local velhinha = display.newImageRect ("velhinha.png", 30, 30)
velhinha.x = display.contentCenterX
velhinha.y = display.contentHeight - 20
physics.addBody( velhinha, { isSensor=true})
velhinha.myName = "velhinha"




-- local function walkingVelhinha( event )
--     local velhinha = event.target
--     local phase = event.phase

--     if ("began" == phase ) then
--         display.currentStage:setFocus ( velhinha)
--         velhinha.touchOffsetX = event.y - velhinha.y
    
--     elseif ("moved" == phase) then
--         velhinha.y = event.y - velhinha.touchOffsetX

--     elseif ( "cancelled" == phase or "ended" == phase) then 
--         display.currentStage:setFocus(nil)
--     end
--     return true
-- end
local moveLeft = 0
local moveRight = 0
local moveDown = 0
local moveUp = 0

local touchFunction = function(e)
    print("entrou")
    
    if e.phase == "began"  then
        if e.target.myName == "right" then
            moveRight = 10
            velhinha.x = velhinha.x + moveRight
        else
            moveLeft = -10
            velhinha.x = velhinha.x + moveLeft         
        end
        
    elseif e.phase == "moved"  then
        if e.target.myName == "right" then     
            moveRight = 10
            velhinha.x = velhinha.x + moveRight
        else
            moveLeft = -10
            velhinha.x = velhinha.x + moveLeft
        end
        
    end
end


local function movimento(direcao, personagem)

    if ( direcao.myName == "up" ) then
        if( personagem.y - 20 > 0 ) then
            personagem.y = personagem.y - 20
        end
    elseif ( direcao.myName == "right" ) then
        if( personagem.x + 20 < display.contentWidth ) then
            personagem.x = personagem.x + 20
        end
    elseif ( direcao.myName == "down" ) then
        if( personagem.y + 20 < display.contentHeight) then
            personagem.y = personagem.y + 20
        end
    elseif (direcao.myName == "left") then
        if ( personagem.x > 0 ) then
            personagem.x = personagem.x - 20
        end
    end
end



local setaCima = display.newImage("arrow.png")
setaCima.x = 10
setaCima.y = 270
setaCima.rotation = 360
setaCima.myName = "up"
local andarCima = function() return movimento(setaCima,velhinha) end
setaCima:addEventListener("tap", andarCima)

local setaDireita = display.newImage("arrow.png")
setaDireita.x = 35
setaDireita.y = 285
setaDireita.rotation = 90
setaDireita.myName = "right"
local andarDireita = function() return movimento(setaDireita,velhinha) end
setaDireita:addEventListener("tap", andarDireita)

local setaBaixo = display.newImage("arrow.png")
setaBaixo.x = 10
setaBaixo.y = 300
setaBaixo.rotation = 180
setaBaixo.myName = "down"
local andarBaixo = function() return movimento(setaBaixo,velhinha) end
setaBaixo:addEventListener("tap", andarBaixo)

local setaEsquerda = display.newImage("arrow.png")
setaEsquerda.x = -15
setaEsquerda.y = 285
setaEsquerda.rotation = 270
setaEsquerda.myName = "left"
local andarEsquerda = function() return movimento(setaEsquerda,velhinha) end
setaEsquerda:addEventListener("tap", andarEsquerda)


-- Botoes
--[[local arrow = {}

arrow[1] = display.newImage("arrow.png")
arrow[1].x = 10
arrow[1].y = 270
arrow[1].rotation = 360
arrow[1].myName = "up"

arrow[2] = display.newImage("arrow.png")
arrow[2].x = 10
arrow[2].y = 300
arrow[2].rotation = 180
arrow[2].myName = "down"

arrow[3] = display.newImage("arrow.png")
arrow[3].x = -15
arrow[3].y = 285
arrow[3].rotation = 270
arrow[3].myName = "left"

arrow[4] = display.newImage("arrow.png")
arrow[4].x = 35
arrow[4].y = 285
arrow[4].rotation = 90
arrow[4].myName = "right"

local j=1
for j=1, #arrow do
    arrow[j]:addEventListener("touch", touchFunction)
end
]]--







-- local function restaurarVelhinha() --Incompleto
--     velhinha.isBodyActive = false
--     velhinha.x = display.contentCenterX
--     velhinha.y = display.contentHeight - 30

    
--     transition.to( velhinha, {alpha=1, time=4000,
--         onComplete = function()
--             velhinha.isBodyActive = true
--             died = false
--         end
--     })
-- end

local function onCollision( event ) 

    if ( event.phase == "began" ) then

        local obj1 = event.object1
        local obj2 = event.object2
        local obj3 = event.object3

        if ( ( obj1.myName == "velhinha" and obj2.myName == "carro1" ) or
            ( obj1.myName == "carro1" and obj2.myName == "velhinha" ) or
            ( obj1.myName == "carro2" and obj2.myName == "velhinha" ) or 
            ( obj1.myName == "velhinha" and obj2.myName == "carro2" ))
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
-- velhinha:addEventListener("touch", walkingVelhinha)
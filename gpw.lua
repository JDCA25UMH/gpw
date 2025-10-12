

 Controls("touch")
 cursor("point")
 
---------------------------------------------------------------
  local game={
   state = {
    menu= true,
    running=false
    }
  }
  
  local buttons = {
   colors ={
     red=0.6,
     green=0.6,
     blue=0.6
     },
   
  restart={}
  }
  
--------------------------------------------

  Disparo= {}
  Disparo.__index = Disparo
  
 function Disparo.new(x,y)
  local instance = setmetatable({},
  Disparo)
  instance.x = x
  instance.y = y
 return instance
  end
  
  sw,sh = screenSize()
  shot = Disparo.new(sw/12+12, sh-20)

  puedeDisparar = true
  TiempoDisparoMax = 10
  timerDisparo = TiempoDisparoMax

 balas = {}

 
 nuevaBala = {
 
 x= shot.x,
 y=shot.y
 }

 table.insert(balas,nuevaBala)

 if timerDisparo < 0 then
  puedeDisparar = true
 else
  puedeDisparar = false
  timerDisparo = timerDisparo -1
 end
 
-----------------------------------------------
function _init()

 bt = button("Player")

 bt_2= button("Settings")
 
end
--------------------------------------------------

function button(texto)

 sw,sh= screenSize()
 mx,my = getMPos()
 
 xw= 10
 yh =10
return {
 
 texto = texto,
 buton_x=xw-3,
 buton_y=yh-3,
 width =width or 50,
 height=height or 10,
 buton_2y=yh+20-3,
 
  draw= function(self,texto)
   self.texto = texto or self.texto
  end,
  
  rtgl_uno = function(self,buton_x,
  buton_y)
  
  if(mx>= self.buton_x) and 
   (mx <= self.buton_x+ self.width)then
  if(my >= self.buton_y)and
   (my <= self.buton_y + self.height) then
    color(3) 
    rect(xw-3,yh-3,50,10)
   
  end
  end
  end, 
    rtgl_dos = function(self,
    buton_x, buton_2y)
  if(mx>=self.buton_x)and
  (mx<= self.buton_x + self.width)then
  if (my>=self.buton_2y)and
  (my<=self.buton_2y + self.height)then
  color(3)
  rect(xw-3,yh+20-3,50,10)


  end
  end
 end
}
end


function buton_restart(func,buton_color,
 text_color, width, height)
  mx , my = getMPos()
 return {
 func= func or function() print("none")end,
 text_color=text_color or {r=0,g=0,b=0},
 buton_color = buton_color or {r=1,g=1,b=1},
 width= width or 100,
 height = height or 100,
 text= "No Text",
 buton_x = 0,
 buton_y= 0,
 text_x=0,
 text_y=0,
  
 draw = function (self, text, buton_x,
 buton_y, text_x, text_y)
 
 self.text= text or self.text
 self.buton_x = buton_x or self.buton_x
 self.buton_y = buton_y or self.buton_y

   rect(self.buton_x, self.buton_y, 
  self.width, self.height)
  end,
  
  checkPressed= function (self,mx,my )
  
  if(mx>=self.buton_x)and
  (mx<=self.buton_x + self.width) then
  if(my>= self.buton_y)and
  (my<= self.buton_y + self.height)then
  Presion = true
  self.func()
  end
  end
  
  end
 }
end
----------------------------------------------------------
function H()
if game.state["running"]and Presion then
velocidad = 3
for i= #balas, 1, -1 do
balas[i].y = balas[i].y -velocidad
if balas[i].y< 0 then
 table.remove(balas,i)
end
end
elseif game.state["menu"]then
velocidad = 0 
for i = #balas,1,-1 do
balas[i].y = balas[i].y -velocidad
end
end

end

---------------------------------------------------------
 buttons.restart.restart_01=
 buton_restart(H,{r=buttons.colors["red"],
 g=buttons.colors["green"],
 b= buttons.colors["blue"]},
 {r=0,g=0,b=0},40,10 ) 


----------------------------------------------

function _update60()

sw,sh = screenSize()
mx,my = getMPos()

H()
end

function _mousepressed(mx,my)
 xw=10
 yh=10
 
 buton_x, buton_y=xw-3,
 yh-3
 
 buttons.restart.restart_01.buton_x,
 buttons.restart.restart_01.buton_y
  = sw/12, sh-12
 
 enx = (mx>= buton_x)and
 (mx<= buton_x+50)
 
 eny = (my>= buton_y) and
 (my<= buton_y+ 10)

 if enx and eny then
 game.state["menu"]=false
 game.state["running"]=true
end

 buttons.restart.restart_01:checkPressed(mx,my)
end
-----------------------------------------------------

function _draw()

if game.state["menu"]then 
  clear()
  bt:rtgl_uno()

  bt:draw()
  color(7)
  print(bt.texto,xw,yh)

  bt_2:rtgl_dos()
  color(7)
  print(bt_2.texto,xw,yh+20)

elseif game.state["running"]then
 
  sw,sh = screenSize()
  clear()
  color(5)
  buttons.restart.restart_01:draw(
  "Restart",sw/12,sh-12,10,10)
  color(7)

  print("Restart",sw/12+2,sh-10)

 
  for i,bala in ipairs(balas)do
   Sprite(1,bala.x,bala.y)
  end
  
  
end

end

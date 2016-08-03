love.graphics.setDefaultFilter('nearest','nearest')
debug = true
battleScene = {width=180, height=192, bg=love.graphics.newImage('backgrounds/battle_background.png')}
healthbars = {height = 42, width=battleScene.width, y=160, bg= love.graphics.newImage('backgrounds/healthbg.png')}
ui = {width= battleScene.width, height=battleScene.width*16/9-healthbars.y-healthbars.height, x=0, y=healthbars.y+healthbars.height, bg= love.graphics.newImage('backgrounds/battleui.png')}
scale = 2*love.window.getPixelScale()
friendScale = 1.6
enemyScale = 1
function lambda(v,str)
	local funcstr = "local func = function ("..v..")"
		.."return ("..str..") end \n"
		.."return func"
	return loadstring(funcstr)()
end
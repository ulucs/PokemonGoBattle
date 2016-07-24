debug = true
battleScene = {width=180, height=192}
healthbars = {height = 41, width=battleScene.width, y=160}
ui = {width= battleScene.width, height=battleScene.width*16/9-healthbars.y-healthbars.height, x=0, y=healthbars.y+healthbars.height}
scale = 2*love.window.getPixelScale()
friendScale = 1.6
enemyScale = 1
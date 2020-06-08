push = require 'push/push'
Class = require 'hump/class'
require 'Paddle'
require 'Ball'
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243
PADDLE_SPEED = 200
love.window.setTitle("It's Time For Pong!")


function love.load()
gamestate = 'start'
GAME_FINISHED = false
Keypress = true
main_Theme = love.audio.newSource("music/Cyborg Ninja.mp3", "static")
main_Theme:setVolume(.10)
love.graphics.setDefaultFilter('nearest', 'nearest')
smallFont = love.graphics.newFont('fonts/font.ttf', 15)
scoreFont = love.graphics.newFont('fonts/font.ttf', 32)
FPSFONT = love.graphics.newFont('fonts/font.ttf', 8)
love.graphics.setFont(smallFont)
math.randomseed(os.time())

push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT,
WINDOW_WIDTH, WINDOW_HEIGHT, {
fullscreen = false, resizable = false,
vsync = true})

player1Score = 0
player2Score = 0
player1 = Paddle(10, 30, 5, 20)
player2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT -30, 5, 20)
ball = Ball(VIRTUAL_WIDTH/2 -2, VIRTUAL_HEIGHT/2 -2, 4, 4)
servingPlayer = 1

end

function love.update(dt)

  if player1Score == 5 or player2Score == 5 then
    gameIsFinished()
  end

  if gamestate == 'serve' then
    ball.dy = math.random(-50, 50)
  -- maybe error here
    if servingPlayer == 1 then
      ball.dx = math.random(140,200)
    else
      ball.dx = -math.random(140,200)
    end

  elseif gamestate == 'play' then
          if ball:collides(player1) then
              ball.dx = -ball.dx * 1.1
              ball.x = player1.x + 5
              if ball.dy < 0 then
                  ball.dy = -math.random(10, 150)
              else
                  ball.dy = math.random(10, 150)
              end
            end

          if ball:collides(player2) then
              ball.dx = -ball.dx * 1.1
              ball.x = player2.x - 4

              if ball.dy < 0 then
                  ball.dy = -math.random(10, 150)
              else
                  ball.dy = math.random(10, 150)
              end
          end

          if ball.y <= 0 then
              ball.y = 0
              ball.dy = -ball.dy
          end

          if ball.y >= VIRTUAL_HEIGHT - 4 then
              ball.y = VIRTUAL_HEIGHT - 4
              ball.dy = -ball.dy
          end
          if ball.x < 0 then
            servingPlayer = 1
            player2Score = player2Score + 1
            ball:reset()
            gamestate = 'serve'
          end
          if ball.x > VIRTUAL_WIDTH - 10 then
            servingPlayer = 2
            player1Score = player1Score + 1
            ball:reset()
            gamestate = 'serve'
            end
          end

  if love.keyboard.isDown('w') then
    player1.dy = -PADDLE_SPEED
  elseif love.keyboard.isDown('s') then
    player1.dy = PADDLE_SPEED
  else player1.dy = 0
  end

  if love.keyboard.isDown('up') then
      player2.dy = -PADDLE_SPEED
  elseif love.keyboard.isDown('down') then
      player2.dy = PADDLE_SPEED
  else
      player2.dy = 0
  end

  if gamestate == 'play' then
    ball:update(dt)
  end
    player1:update(dt)
    player2:update(dt)
  end

  function love.keypressed(key)

  if key == 'escape' then
    love.event.quit()
  elseif key == 'space' and GAME_FINISHED == false and Keypress == true then
    if gamestate == 'start' then
        gamestate = 'serve'
        main_Theme:play()
     elseif gamestate == 'serve' then
        gamestate = 'play'
          end
        end

      if key == 'r' and GAME_FINISHED == false and Keypress == false then
        love.graphics.clear()
        player1Score = 0
        player2Score = 0
        Keypress = true
        main_Theme:stop()
        gamestate = 'start'
      end
    end
function love.draw ()

 push:apply("start")
 love.graphics.clear(.16, .18, .20, 1)
 love.graphics.setFont(scoreFont)
 love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50,
     VIRTUAL_HEIGHT / 3)
 love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30,
     VIRTUAL_HEIGHT / 3)

     love.graphics.setFont(smallFont)
    if gamestate == 'start' then
    love.graphics.printf("HELLO PONG!", 0, 20, VIRTUAL_WIDTH, "center")
    love.graphics.printf("PRESS SPACE TO BEGIN", 0, 40, VIRTUAL_WIDTH, "center")
  elseif gamestate == 'serve' then
      love.graphics.setFont(smallFont)
      love.graphics.printf('Player ' .. tostring(servingPlayer) .. "'s serve!",
          0, 10, VIRTUAL_WIDTH, 'center')
      love.graphics.printf('Press Space to serve!', 0, 20, VIRTUAL_WIDTH, 'center')
  elseif gamestate == 'play' then
    -- no UI messages to display in play
      end

          if GAME_FINISHED == true and player1Score > player2Score  then
            love.graphics.clear(.16, .18, .20, 1)
            love.graphics.setFont(scoreFont)
            love.graphics.printf("PLAYER 1 WINS", 0, 20, VIRTUAL_WIDTH, "center")
            love.graphics.setFont(smallFont)
            love.graphics.printf("PRESS 'R' TO PLAY AGAIN", 0, 200, VIRTUAL_WIDTH, "center")
            gameRestart()
          end
          if GAME_FINISHED == true and player2Score > player1Score then
            love.graphics.clear(.16, .18, .20, 1)
            love.graphics.setFont(scoreFont)
            love.graphics.printf("PLAYER 2 WINS", 0, 20, VIRTUAL_WIDTH, "center")
            love.graphics.setFont(smallFont)
            love.graphics.printf("PRESS 'R' TO PLAY AGAIN", 0, 200, VIRTUAL_WIDTH, "center")
            gameRestart()
          end

player1:render()
player2:render()
ball:render()
displayFPS()

push:apply('end')
  end



function displayFPS()
  love.graphics.setFont(FPSFONT)
  love.graphics.setColor(0, 1, 0, 1)
  love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
end

function gameIsFinished()
  GAME_FINISHED = true
  Keypress = false
  end

  function gameRestart()
    GAME_FINISHED = false
    end

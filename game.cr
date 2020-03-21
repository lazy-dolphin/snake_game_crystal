include Random

BORDER_LENGTH = 20
BORDER_WIDTH = 20

INIT_SNAKE_DIR = :right
INIT_SNAKE_TAIL = {
	:r => BORDER_LENGTH // 2,
	:c => BORDER_WIDTH // 2
}
INIT_SNAKE_HEAD = {
	:r => INIT_SNAKE_TAIL[:r],
	:c => INIT_SNAKE_TAIL[:c] + 1,
}

CONTROLS = {
	"h" => :left,
	"j" => :down,
	"k" => :up,
	"l" => :right
}

class Snake
	getter coords_list
	getter food
	def initialize
		@dir = INIT_SNAKE_DIR
		@coords_list = [] of Hash(Symbol, Int32)
		@coords_list = [INIT_SNAKE_TAIL, INIT_SNAKE_HEAD]
		@food = Food.new
	end
	def input_dir
		# This function is supposed to stop the code from running for 1 seconds meanwhile the user can enter the character ch. After 2 seconds the code continues to run and @dir is updated to CONTROLS[ch]. If the user either enters the opposite direction to previous direction or nothing, @dir retains its original value. As a temporary solution, I am using gets to take the input.
		@dir = CONTROLS[gets]
	end
	def update
		# Need help reducing this code.
		input_dir
		case @dir
		when :left
			@coords_list << {
				:r => @coords_list[-1][:r],
				:c => @coords_list[-1][:c] - 1
			}
		when :down
			@coords_list << {
				:r => @coords_list[-1][:r] + 1,
				:c => @coords_list[-1][:c]
			}
		when :up
			@coords_list << {
				:r => @coords_list[-1][:r] - 1,
				:c => @coords_list[-1][:c]
			}
		when :right
			@coords_list << {
				:r => @coords_list[-1][:r],
				:c => @coords_list[-1][:c] + 1
			}
		end
		if @coords_list[-1] == food.coords
			@food.update
		else
			@coords_list.shift
		end
	end
end

class Food
	getter coords
	def initialize
		@coords = Hash(Symbol, Int32).new
		update
	end
	def update
		@coords[:r] = rand(BORDER_LENGTH - 2) + 1
		@coords[:c] = rand(BORDER_WIDTH - 2) + 1
	end
end

class Game
	def initialize
		@game_over = false
		@snake = Snake.new
		system "clear"
	end
	def game_over?
		if (
			@snake.coords_list[-1][:r] == 0 ||
			@snake.coords_list[-1][:c] == 0 ||
			@snake.coords_list[-1][:r] == BORDER_LENGTH - 1 ||
			@snake.coords_list[-1][:c] == BORDER_WIDTH - 1
		)
			@game_over = true
		end
	end
	# Need help with replacing below functions with something more efficient.
	def draw_upper_border
		print "╔"
		(BORDER_WIDTH - 2).times do
			print "═"
		end
		puts "╗"
	end
	def draw_lower_border
		print "╚"
		(BORDER_WIDTH - 2).times do
			print "═"
		end
		puts "╝"
	end
	def draw_middle_area
		1.to(BORDER_LENGTH - 2) do |i|
			print "║"
			1.to(BORDER_WIDTH - 2) do |j|
				if @snake.coords_list.includes?({:r => i, :c => j})
					print "*"
				elsif @snake.food.coords == {:r => i, :c => j}
					print "#"
				else
					print " "
				end
			end
			puts "║"
		end
	end
	def draw
		until @game_over
			print "\033[0;0H"
			draw_upper_border
			draw_middle_area
			draw_lower_border
			@snake.update
			game_over?
		end
	end
end

game = Game.new
game.draw


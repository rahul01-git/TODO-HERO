TODO_FILE = "todos.txt"

def clear_screen
    system("cls")  #for windows
    system("clear")  #for mac/linux
end

def format(title)
    puts "\e[1;34m#{title}\e[0m".center(60, '-')
end

def show_message(message)
    puts message.center(50, '-')
end

def get_valid_integer(prompt, max_value)
    loop do
        print prompt
        input = gets.chomp.to_i
        return input if input > 0 && input <= max_value

        puts "Invalid input! Please enter a number between 1 and #{max_value}."
    end
end

def handle_file_operation(file, operation_message)
    clear_screen
    puts format(operation_message)
    file.rewind
    lines = file.readlines
    lines.each_with_index do |line, index|
        puts "#{index + 1}) #{line}"
    end
    lines
end

def add_todo(file)
    clear_screen
    puts format(" Add Todo ")
    print "Title: "
    title = gets.chomp
    file.puts(title)
    show_message("Todo Added ✅")
end

def view_todos(file)
    clear_screen
    count = 0
    puts format(" Todos 📃 ")
    file.rewind
    file.each_with_index do |line, index|
        puts "#{index + 1}) #{line}"
        count+=1
    end
    show_message(" Count: #{count} ")
end

def delete_todo(file)
    lines = handle_file_operation(file, " Delete Todo ")
    id = get_valid_integer("Enter id: ", lines.size)
    lines.delete_at(id - 1)
    File.open(TODO_FILE, "w") do |f|
        lines.each { |line| f.puts(line) }
    end
    show_message("Todo Deleted ✅")
end

def update_todo(file)
    lines = handle_file_operation(file, " Update Todo ")
    id = get_valid_integer("Enter id: ", lines.size)
    print "Enter new title: "
    title = gets.chomp
    lines[id - 1] = title
    File.open(TODO_FILE, "w") do |f|
        lines.each { |line| f.puts(line) }
    end
    show_message("Todo Updated ✅")
end

def todo_manager
    file = File.new(TODO_FILE, "a+")
    
    loop do
        clear_screen
        puts format(" TODO HERO ")
        puts "a) View Todos"
        puts "b) Add Todo"
        puts "c) Update Todo"
        puts "d) Delete Todo"
        puts "q) Quit"
        print "Make a choice (a/b/c/d/q): "
        choice = gets.chomp
        case choice
        when 'a' then view_todos(file)
        when 'b' then add_todo(file)
        when 'c' then update_todo(file)
        when 'd' then delete_todo(file)
        when 'q'
            break
        else
            puts '❌ Wrong input !!'
        end

        print "Continue (y/n): "
        continue = gets.chomp.downcase
        break if continue == 'n'
    end

    file.close
end

todo_manager

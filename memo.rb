require "csv"

def menu()
  puts "1 → 新規でメモを作成する / 2 → 既存のメモを編集する / 3 → メモアプリを終了する"
  num = gets.to_i
  return num
end

def write_memo()
  puts "メモしたい内容を記入してください"
  puts "完了したらctrl + Dを押します"
  memo = STDIN.read
  CSV.open("#{$file_name}.csv","w") do |csv|
    csv.puts ["#{memo}"]
  end
  puts "\n#{$file_name}.csvを作成しました"
end

def display_memo()
  puts "現在の内容"
  CSV.foreach("#{$file_name}.csv") do |row|
    puts row
  end
end

def exit_memo()
  puts "メモアプリを終了します"
  exit
end

dir_name = 'csv'
unless Dir.exists? dir_name then
  Dir.mkdir dir_name
end
Dir.chdir dir_name

loop do
  input_number = menu()
  if input_number == 1 then
    puts "拡張子を除いたファイル名を入力してください"
    $file_name = gets.chomp
    if File.exist?("#{$file_name}.csv") then
      puts "同じファイル名が存在します"
      display_memo()
      puts "上書きしてもよろしいですか？"
      puts "yes/no"
      break_flag = 0
      loop do
        input_yn = gets.chomp
        if input_yn == "yes" then
          puts "上書きします"
          break
        elsif input_yn == "no" then
          break_flag = 1
          break
        else
          puts "yes no を入力してください"
          next
        end
      end
    end
    if break_flag == 1 then
      puts "メニューへ戻ります"
    else
      write_memo()
    end
  elsif input_number == 2 then
    puts "存在するファイル名を表示します"
    Dir.glob('./*.csv').each do |fn|
      puts fn[2,99]
    end
    puts "拡張子を除いた編集したいファイル名を入力してください"
    $file_name = gets.chomp
    begin
      display_memo()
    rescue
      puts "入力されたファイルはありません"
      loop do
        puts "1 → 入力したファイル名で新たに作成する / 2 → メニューへ戻る / 3 → メモアプリを終了する"
        select_number = gets.to_i
        if select_number == 1 then
          write_memo()
          break
        elsif select_number == 2 then
          break
        elsif select_number == 3 then
          exit_memo()
        else
          puts "1 2 3 を入力してください"
        end
      end
      next
    end
    puts "1 → 内容を上書きする / 2 → 追記する / 3 → メモアプリを終了する"
    select_number = gets.to_i
    loop do
      if select_number == 1 then
        write_memo()
        break
      elsif select_number == 2 then
        puts "追記したい内容を記入してください"
        puts "完了したらctrl + Dを押します"
        memo = STDIN.read
        CSV.open("#{$file_name}.csv", 'a') do |csv|
          csv.puts ["#{memo}"]
        end
        puts "\n#{$file_name}.csvに追記しました"
        break
      elsif select_number == 3 then
        exit_memo()
      else
        puts "1 2 3 を入力してください"
      end
    end
  elsif input_number == 3 then
    exit_memo()
  else
    puts "1 2 3 を入力してください"
  end
end
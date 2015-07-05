require 'date'
class LibraryManager

# 1. Бибилиотека в один момент решила ввести жесткую систему штрафов (прямо как на rubybursa :D).
# За каждый час опоздания со здачей книги читатель вынужден заплатить пеню 0,1% от стоимости. 
# Необходимо реализовать метод, который будет считать эту сумму в зависимости от даты выдачи и 
# текущего времени. По работе с датой-временем информацию можно посмотреть 
# тут http://ruby-doc.org/stdlib-2.2.2/libdoc/date/rdoc/DateTime.html
# 
# Входящие параметры метода 
# - стоимость книги в центах, 
# - дата и время возврата (момент, когда книга должна была быть сдана, в формате DateTime)
# Возвращаемое значение 
# - пеня в центах
def penalty(price, issue_datetime)
	timeOld = DateTime.parse(issue_datetime).new_offset(0)
	timeNow = DateTime.now.new_offset(0)
	expired = (timeNow - timeOld).to_i * 24
	penalty = (expired * (price.to_f * 0.001)).to_i
end


# 2. Известны годы жизни двух писателей. Год рождения, год смерти. Посчитать, могли ли они чисто 
# теоретически встретиться. Даже если один из писателей был в роддоме - это все равно считается встречей. 
# Помните, что некоторые писатели родились и умерли до нашей эры - в таком случае годы жизни будут просто 
# приходить со знаком минус.
# 
# Входящие параметры метода 
# - год рождения первого писателя, 
# - год смерти первого писателя, 
# - год рождения второго писателя, 
# - год смерти второго писателя.
# Возвращаемое значение 
# - true или false
def could_meet_each_other?(year_of_birth_first, year_of_death_first, year_of_birth_second, year_of_death_second) 
 range = year_of_birth_first.to_i..year_of_death_first
 range.include?(year_of_birth_second)||range.include?(year_of_death_second)
end

# 3. Исходя из жесткой системы штрафов за опоздания со cдачей книг, читатели начали задумываться - а 
# не дешевле ли будет просто купить такую же книгу... Необходимо помочь читателям это выяснить. За каждый 
# час опоздания со здачей книги читатель вынужден заплатить пеню 0,1% от стоимости.
# 
# Входящий параметр метода 
# - стоимость книги в центах 
# Возвращаемое значение 
# - число полных дней, нак которые необходимо опоздать со здачей, чтобы пеня была равна стоимости книги.
def days_to_buy(price) 
	h = 0	
	loop do
		penalty = h * (price.to_f * 0.001)
  		h += 1
  		break if penalty > price 
	end 
	days = (h/24).to_i
end


# 4. Для удобства иностранных пользователей, имена авторов книг на украинском языке нужно переводить в 
# транслит. Транслитерацию должна выполняться согласно официальным 
# правилам http://kyivpassport.com/transliteratio/

# Входящий параметр метода 
# - имя и фамилия автора на украинском. ("Іван Франко") 
# Возвращаемое значение 
# - имя и фамилия автора транслитом. ("Ivan Franko")
def author_translit (ukr_name)
	finChar = Array.new()
	i = 0
	letters = { "а" => "a", "б" => "b", "в" => "v", "г" => "h", "ґ" => "g", "д" => "d", "е" => "e","є" => "ie", "ж" => "zh",
	"з" => "z", "и" => "y", "і" => "i", "ї" => "i", "й" => "i", "к" => "k", "л" => "l", "м" => "m", "н" => "n",
	"о" => "o", "п" => "p", "р" => "r", "с" => "s", "т" => "t", "у" => "u", "ф" => "f", "х" => "h", "ц" => "ts",
	"ч" => "ch", "ш" => "sh", "щ" => "shch", "ю" => "iu", "я" => "ia", "\s" => "\s", "А" => "A", "Б" => "B", "В" => "V", "Г" => "H", "Ґ" => "G", "Д" => "D", "Е" => "E","Є" => "Ye", "Ж" => "Zh",
	"З" => "Z", "И" => "Y", "І" => "I", "Ї" => "Yi", "Й" => "Y", "К" => "K", "Л" => "L", "М" => "M", "Н" => "N",
	"О" => "O", "П" => "P", "Р" => "R", "С" => "S", "Т" => "T", "У" => "U", "Ф" => "F", "Х" => "H", "Ц" => "Ts",
	"Ч" => "Ch", "Ш" => "Sh", "Щ" => "Shch", "Ю" => "Yu", "Я" => "Ya"} 
	lettersArray = ukr_name.chars.to_a
	lettersArray.each{|char| finChar[i] = letters[char] 
	i +=1}
	finChar.join
end

#5. Читатели любят дочитывать книги во что-бы то ни стало. Необходимо помочь им просчитать сумму штрафа, 
# который придеться заплатить чтобы дочитать книгу, исходя из количества страниц, текущей страницы и 
# скорости чтения за час.
# 
# Входящий параметр метода 
# - Стоимость книги в центах
# - DateTime сдачи книги (может быть как в прошлом, так и в будущем)
# - Количество страниц в книге
# - Текущая страница
# - Скорость чтения - целое количество страниц в час.
# Возвращаемое значение 
# - Пеня в центах или 0 при условии что читатель укладывается в срок здачи.
def penalty_to_finish(price, issue_datetime, pages_quantity, current_page, reading_speed)

   	t = (pages_quantity.to_i - current_page.to_i)/reading_speed.to_i 
   	timeOld = DateTime.parse(issue_datetime).new_offset(0)
	timeNow = DateTime.now.new_offset(0)
	timeToRead = timeNow + (t/24.0)
	bill = 0
	if timeToRead > timeOld 
		bill = (timeToRead- timeOld).to_i * 24 * price.to_i * 0.001 
	end
	bill.to_i
end

end

#a = LibraryManager.new
#puts a.penalty('1400', '2015-07-02 19:07:14') 
#puts a.could_meet_each_other?(1950, 1980, 1981, 2000) 
#puts a.days_to_buy(1400)
#puts a.author_translit("Ваня Петров")
#puts a.penalty_to_finish('1400', '2015-07-24 12:18:14', '348', '25', '5')
 
############################################################
#
#  Name:        Sean Glover
#  Assignment:  Final Project - Morse Code Translator
#  Date:        03/12/2013
#  Class:       CIS 282
#  Description: Convert text to morse code and then convert back to text
#
############################################################

# method for displaying menu options
def menu
  puts
  puts "1. Translate Text from file to Morse Code"
  puts "2. Print Morse Code from file to screen"
  puts
  puts "3. Quit"
  puts
  print "Enter your option: "
end

# method to translate either morse code to text or text to morse code
def translate(alphabet, words_array, direction)
  # string of morse code translation
  translated_text = ""

  # option when translating from text to morse code
  if direction == "txt->mc"
    # loop through text array to find morse code translation
    words_array.each do |character|

      # condition to handle spaces in text
      if character == " "
        # push "WAIT" morse code and space at end of character
        translated_text << alphabet["WAIT"] << " "
      else
        # push morse code and space at end of character
        translated_text << alphabet[character] << " "
      end
    end

    # condition when translating from morse code to text
  else
    # loop through array to find morse code translation
    words_array.each do |character|

      # loop through alphabet hash to compare value
      alphabet.each do |key, value|
        # condition to populate the key when the character is not WAIT
        if value == character and key != "WAIT"
          translated_text << key

          # condition to add carriage return after period
          translated_text << "\n" if key == "."

          # condition to add space when the character is WAIT
        elsif value == character and key == "WAIT"
          translated_text << " "
        end
      end
    end
  end

  return translated_text # text returned for printing to screen and/or flat file
end

# method to write to flat file
def write_file(filename, translated_text)
  # update flat file
  coded_file = File.open(filename, "w")

  # write morse code to file
  coded_file.puts translated_text

  # close translated to morse code file
  coded_file.close
end

# method to read file and set string to split on
def read_file(alphabet, read_file, split_string, direction, write_file)
  line = ""

  # open test file to translate
  words_file = File.open(read_file)

  # loop through file, capitalize and add text to string
  while ! words_file.eof?
    line += words_file.gets.chomp.upcase
  end

  # populate array by splitting all characters in string
  data_array = line.split(split_string)

  # close text file
  words_file.close

  # invoke translate method for translation
  translated_text = translate(alphabet, data_array, direction)

  # invoke write method to write out to flat file
  write_file(write_file, translated_text)

  return translated_text # string returned for printing to screen
end

# hash for alphabet to morse code translation
alphabet = {}

# open file and initialize hash
alphabet_file = File.open("MorseCodeAlphabet.txt")

# loop through file for hash population
while ! alphabet_file.eof?
  # read each line from file
  line = alphabet_file.gets.chomp
  # split on comma separated values
  data_array = line.split(" ")
  # populate hash with values from file
  alphabet[data_array[0]] = data_array[1]
end

# close file
alphabet_file.close

user_option = ""

# loop for menu option until user quits
while user_option != 3
  menu
  user_option = gets.to_i

  # option to read to translate text to morse code
  if user_option == 1
    # invoke read method for reading file
    words_array = read_file(alphabet, "morse_code_text_to_translate.txt", "", "txt->mc", "morse_code_translated.txt")

  # option to print text to screen and translate morse code to text
  elsif user_option == 2
    # invoke read method for reading file
    translated_text = read_file(alphabet, "morse_code_translated.txt", " ", "txt<-mc", "translate.txt")

    # print translated text to screen
    print translated_text

  # error condition when invalid option selected
  elsif user_option != 3
    puts "That is not a valid option."
  end
end


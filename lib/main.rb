dictionary = File.open("dictionary.txt", "r")
dictionary_contents = File.read("dictionary.txt")

# Select a word between 5 and 12 characters
word = dictionary_contents.split(' ').select { |word| word.length >= 5 && word.length <= 12}.sample

puts word
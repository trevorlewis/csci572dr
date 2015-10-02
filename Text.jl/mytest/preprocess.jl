using Text

# preprocess the plain text files generated using WikiExtractor
# by combining all the files into a single TSV file
# such that the first column contains the language of the text in the second column

for file in readdir("data")
	for line in filelines("data/$(file)")		
		if search(line, '<') != 1 && strip(line) != ""
			println(split(file, "-")[1] * "\t" * strip(line))
		end
	end
end

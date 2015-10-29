Integrating Tika with MIT Lincoln Lab’s Text.jl library for language detection and translation
====================


Prerequisites
----------
- `Julia` - http://julialang.org *(Note: currently using v0.3.11)*
- `Text.jl` - https://github.com/mit-nlp/Text.jl
- `HttpServer.jl` - https://github.com/JuliaWeb/HttpServer.jl


Files
----------
- `list.txt`  
This file contains the ISO 639-1 Codes of languages one on each line.

- `download.sh`  
This file is used to download the Wikipedia database XML dump of the languages listed in the `list.txt` file and then extract plain text from the dumps using `WikiExtractor.py` (https://github.com/bwbaugh/wikipedia-extractor)
> **Usage:**  
> download.sh  

- `preprocess.sh`  
This file is used to preprocess the plain text files generated using `WikiExtractor.py` by combining 'n' random lines of each file into a single TSV file such that the first column contains the language of the text in the second column.
> **Usage:**  
> preprocess.sh [options]  
> **Options:**  
> -f, --file : output file name  
> -n, --num : number of lines for each file  
> **Example:**  
> preprocess.sh -f=text.tsv -n=10000  

- `lidHttpServer.jl`  
This file is used to train the model for language detection using the file generated using `preprocess.sh` and start a Julia HTTP Server on the localhost port 8000. The language of the text to be detected should be sent as a PUT request data and the Server will give a JSON reply of the language ISO 639-1 Code.
> **Usage:**  
> julia lidHttpServer.jl  
> **To start the server in the background:**  
> nohup julia lidHttpServer.jl & echo $! > pid  
*Where,*  
& *is used to run in background*  
nohup *is used to ignore the hangup signal*  
pid *is a file which contains the pid of the process so that we can kill the process later using the pid.*  
**To test the language detection Julia HTTP Server:**  
> curl -X PUT -d "enter some text here" http://127.0.0.1:8000  
*(Note: it returns an incorrect result for text of smaller length like Hello World etc)*  

- `lidHttpClient.java`  
This file is used to test the language detection Julia HTTP Server.


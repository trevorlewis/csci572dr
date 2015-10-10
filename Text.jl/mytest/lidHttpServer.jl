using Text
using Base.Test, Stage, Ollam, DataStructures
using HttpServer
using URIParser
using Codecs

# -------------------------------------------------------------------------------------------------------------------------
# LID
# -------------------------------------------------------------------------------------------------------------------------

# train the model

train       = map(l -> split(chomp(l), '\t')[2], filelines("data/text.tsv"))
train_truth = map(l -> split(chomp(l), '\t')[1], filelines("data/text.tsv"))

bkgmodel, fextractor, model = tc_train(train, train_truth, lid_iterating_tokenizer, mincount = 2, cutoff = 1e10, 
                                       trainer = (fvs, truth, init_model) -> train_mira(fvs, truth, init_model, iterations = 20, k = 2, C = 0.01, average = true),
                                       iteration_method = :eager)

# -------------------------------------------------------------------------------------------------------------------------

# function to identify language from text using the model

function detectLang(text)
  fv      = fextractor(lid_iterating_tokenizer(text))
  scores  = score(model, fv)
  bidx, b = best(scores)
  return model.index_class[bidx]
end

# -------------------------------------------------------------------------------------------------------------------------

# HTTP Server to identify language from Request URI which is Base64 encoded and URI encoded

http = HttpHandler() do req::Request, res::Response
    text = unescape(req.resource)[2:end]
    text = bytestring(decode(Base64, text))
    println(text)
    println(detectLang(text))
    return Response(detectLang(text))
end
http.events["error"]  = (client, err) -> println(err)
http.events["listen"] = (saddr) -> println("Running on http://$saddr (Press CTRL+C to quit)")

server = Server(http)
run(server, host=IPv4(127,0,0,1), port=8000)


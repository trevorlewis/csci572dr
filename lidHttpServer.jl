using Text
using Base.Test, Stage, Ollam, DataStructures
using HttpServer

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

# HTTP Server to identify language from PUT Request data

http = HttpHandler() do req::Request, res::Response
  if req.method != "PUT"
    return Response("{\"lang\": \"error - use PUT method\"}")
  end
  text = bytestring(req.data)
  println(text)
  println(detectLang(text))
  return Response(string("{\"lang\": \"", detectLang(text), "\"}"))
end
http.events["error"]  = (client, err) -> println(err)
http.events["listen"] = (saddr) -> println("Running on http://$saddr (Press CTRL+C to quit)")

server = Server(http)
run(server, host=IPv4(127,0,0,1), port=8000)


using Text
using Base.Test, Stage, Ollam, DataStructures

# -------------------------------------------------------------------------------------------------------------------------
# LID
# -------------------------------------------------------------------------------------------------------------------------

train       = map(l -> split(chomp(l), '\t')[2], filelines("data/text.tsv"))
train_truth = map(l -> split(chomp(l), '\t')[1], filelines("data/text.tsv"))

bkgmodel, fextractor, model = tc_train(train, train_truth, lid_iterating_tokenizer, mincount = 2, cutoff = 1e10, 
                                       trainer = (fvs, truth, init_model) -> train_mira(fvs, truth, init_model, iterations = 20, k = 2, C = 0.01, average = true),
                                       iteration_method = :eager)

# -------------------------------------------------------------------------------------------------------------------------

while true
  println("Enter text:")
  text    = readline(STDIN)
  fv      = fextractor(lid_iterating_tokenizer(text))
  scores  = score(model, fv)
  bidx, b = best(scores)
  println(model.index_class[bidx])
end

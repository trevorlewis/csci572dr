#!/usr/bin/env python

import argparse

def read_file_data(filename):
    if filename is None:
        return None
    with open(filename, mode='r') as file:
        data = list()
        for line in file:
            data.append(line.strip().split('\t'))
        return data

def main():
    parser = argparse.ArgumentParser(conflict_handler='resolve')
    parser.add_argument('INPUTFILE', type=str, help='INPUTFILE: input file containing benchmark data')
    args = parser.parse_args()

    data = read_file_data(args.INPUTFILE)
    
    confusion_matrix_tika = dict()
    confusion_matrix_text = dict()
    for line in data:
        if line[1] not in confusion_matrix_tika:
            confusion_matrix_tika[line[1]] = dict()
        if line[1] not in confusion_matrix_text:
            confusion_matrix_text[line[1]] = dict()
        if line[2] not in confusion_matrix_tika[line[1]]:
            confusion_matrix_tika[line[1]][line[2]] = 0
        if line[4] not in confusion_matrix_text[line[1]]:
            confusion_matrix_text[line[1]][line[4]] = 0
        confusion_matrix_tika[line[1]][line[2]] += 1
        confusion_matrix_text[line[1]][line[4]] += 1

    lang_list = sorted(confusion_matrix_tika)
    for lang in lang_list:
        for lang2 in lang_list:
            if lang2 not in confusion_matrix_tika[lang]:
                confusion_matrix_tika[lang][lang2] = 0
            if lang2 not in confusion_matrix_text[lang]:
                confusion_matrix_text[lang][lang2] = 0

    accuracy_tika = 0.0
    accuracy_text = 0.0
    precision_tika = dict()
    precision_text = dict()
    recall_tika = dict()
    recall_text = dict()
    fscore_tika = dict()
    fscore_text = dict()

    for lang in lang_list:
        accuracy_tika += confusion_matrix_tika[lang][lang]
        accuracy_text += confusion_matrix_text[lang][lang]
    accuracy_tika /= len(data)
    accuracy_text /= len(data)

    for lang in lang_list:
        precision_tika[lang] = 0.0
        precision_text[lang] = 0.0
        recall_tika[lang] = 0.0
        recall_text[lang] = 0.0
        fscore_tika[lang] = 0.0
        fscore_text[lang] = 0.0

        for lang2 in lang_list:
                precision_tika[lang] += confusion_matrix_tika[lang][lang2]
                precision_text[lang] += confusion_matrix_text[lang][lang2]
                recall_tika[lang] += confusion_matrix_tika[lang2][lang]
                recall_text[lang] += confusion_matrix_text[lang2][lang]

        precision_tika[lang] = confusion_matrix_tika[lang][lang] / precision_tika[lang]
        precision_text[lang] = confusion_matrix_text[lang][lang] / precision_text[lang]
        recall_tika[lang] = confusion_matrix_tika[lang][lang] / recall_tika[lang]
        recall_text[lang] = confusion_matrix_text[lang][lang] / recall_text[lang]

        fscore_tika[lang] = 2 * precision_tika[lang] * recall_tika[lang] / (precision_tika[lang] + recall_tika[lang])
        fscore_text[lang] = 2 * precision_text[lang] * recall_text[lang] / (precision_text[lang] + recall_text[lang])
        
    print "TIKA RESULTS"
    print "Accuracy: " + str(accuracy_tika)
    print "Lang\tPrecision\tRecall\tF-Score"
    for lang in lang_list:
        print lang + "\t" + str(precision_tika[lang]) + "\t" + str(recall_tika[lang]) + "\t" + str(fscore_tika[lang])

    print

    print "TEXT RESULTS"
    print "Accuracy: " + str(accuracy_text)
    print "Lang\tPrecision\tRecall\tF-Score"
    for lang in lang_list:
        print lang + "\t" + str(precision_text[lang]) + "\t" + str(recall_text[lang]) + "\t" + str(fscore_text[lang])
    

if __name__ == '__main__':
    main()


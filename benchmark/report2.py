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
    
    confusion_matrix_text = dict()
    for line in data:
        if line[1] not in confusion_matrix_text:
            confusion_matrix_text[line[1]] = dict()
        if line[2] not in confusion_matrix_text[line[1]]:
            confusion_matrix_text[line[1]][line[2]] = 0
        confusion_matrix_text[line[1]][line[2]] += 1

    lang_list = sorted(confusion_matrix_text)
    for lang in lang_list:
        for lang2 in lang_list:
            if lang2 not in confusion_matrix_text[lang]:
                confusion_matrix_text[lang][lang2] = 0

    accuracy_text = 0.0
    precision_text = dict()
    recall_text = dict()
    fscore_text = dict()

    for lang in lang_list:
        accuracy_text += confusion_matrix_text[lang][lang]
    accuracy_text /= len(data)

    for lang in lang_list:
        precision_text[lang] = 0.0
        recall_text[lang] = 0.0
        fscore_text[lang] = 0.0

        for lang2 in lang_list:
                precision_text[lang] += confusion_matrix_text[lang][lang2]
                recall_text[lang] += confusion_matrix_text[lang2][lang]

        precision_text[lang] = confusion_matrix_text[lang][lang] / precision_text[lang]
        recall_text[lang] = confusion_matrix_text[lang][lang] / recall_text[lang]

        fscore_text[lang] = 2 * precision_text[lang] * recall_text[lang] / (precision_text[lang] + recall_text[lang])
        
    print "TEXT COMMAND LINE RESULTS"
    print "Accuracy: " + str(accuracy_text)
    print "Lang\tPrecision\tRecall\tF-Score"
    for lang in lang_list:
        print lang + "\t" + str(precision_text[lang]) + "\t" + str(recall_text[lang]) + "\t" + str(fscore_text[lang])
    
    count = dict()
    total_time_text = dict()
    for lang in lang_list:
        count[lang] = 0.0
        total_time_text[lang] = 0.0
    for line in data:
        lang = line[1]
        count[lang] += 1
        total_time_text[lang] += float(line[3])
    print
    print "Lang\tAvg_Time_Text"
    for lang in lang_list:
        print lang + "\t" + str(total_time_text[lang]/count[lang])
    print "*time in nano seconds"

if __name__ == '__main__':
    main()


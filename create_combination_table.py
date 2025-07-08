#!/usr/bin/env python
# -*- coding: utf-8 -*-
import os
import sys
import argparse

import pandas as pd
import numpy as np
import re


def main(est1_folder, gt1_folder, est2_folder, gt2_folder, rel_targets, output_dir='./'):
    """
    フォルダー内のファイル名を取得してcombination_tableを作成する
    xDR_Challenge_2025用

    table columns : [est1, gt1, tag1, est2, gt2, tag2]
    """
    est1_files = os.listdir(est1_folder)
    gt1_files = os.listdir(gt1_folder)
    datanames = os.listdir(est2_folder + F"{rel_targets[0]}/")

    tag1 = "1"
    tag2 = "2"
    tmp_list = []
    for rel_target in rel_targets:
        for dataname in datanames:
            section_files = os.listdir(
                F'{est2_folder}{rel_target}/{dataname}/')
            est1 = find_file_matching_dataname(est1_files, dataname)
            gt1 = find_file_matching_dataname(gt1_files, dataname)

            if est1 is None or gt1 is None:
                continue

            for section_file in section_files:
                est2 = gt2 = section_file.split('.')[0]
                section = section_file.split('.')[0].split('section')[-1]
                section = F"section{section}"

                tmp_list.append([est1, gt1, tag1, est2, gt2,
                                tag2, section, dataname, rel_target])

    df = pd.DataFrame(tmp_list, columns=[
                      "est1", "gt1", "tag1", "est2", "gt2", "tag2", "section", "data_name", "rel_target"])
    df.sort_values(by='est2', inplace=True)
    df.to_csv(
        F'{output_dir}combination_table.csv', index=False)


def find_file_matching_dataname(files, dataname):
    result = [text for text in files if dataname in text.split('.')[
        0][-len(dataname)-1:]]

    if len(result) != 1:
        print(dataname)
        print(files)
        print(result)
        return None

    name = result[0].split('.')[0]
    return name


def main_cl(args):
    main(args.est1_folder, args.gt1_folder,
         args.est2_folder, args.gt2_folder, args.rel_target, args.output_dir)


if __name__ == '__main__':
    parser = argparse.ArgumentParser()

    parser.add_argument('-est1_folder', '-e1_f')
    parser.add_argument('-gt1_folder', '-g1_f')
    parser.add_argument('-est2_folder', '-e2_f')
    parser.add_argument('-gt2_folder', '-g2_f')

    parser.add_argument('-rel_target', '-rel_target', nargs="+")
    parser.add_argument('-output_dir', '-o')

    args = parser.parse_args()
    main_cl(args)

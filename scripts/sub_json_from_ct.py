"""
This script generates subjects json from central timetable csv
"""
import pandas as pd
import sys
import json

fname = sys.argv[1]
print("Reading {}".format(fname))

df = pd.read_csv(fname)
df = df[['Subject', 'Subject Name']]
df.drop_duplicates(inplace=True)
df.dropna(inplace=True)

subcode = df['Subject'].tolist()
subname = df['Subject Name'].tolist()
subjects = dict([(k, [v, False]) for k, v in zip(subcode, subname)])
subjects.pop('Subject')
subjects.pop('Subject\rNo')

jsonfname = fname.replace('.csv', '.json')

with open(jsonfname, 'w') as fp:
    json.dump(subjects, fp)

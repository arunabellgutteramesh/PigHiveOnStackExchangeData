import pandas as pd;
import glob;

folderPath = "/home/vagrant/tfidfResults";

allFiles = glob.glob(folderPath + "/*.txt");

for completeFilePath in allFiles:
    filename = completeFilePath.split('/tfidfResults/')[1];
    print(filename.split('.')[0]+' Owner User ID\n');
    df = pd.read_csv(completeFilePath, sep="\t",header=None,names=["word","tfidf_score"]);
    df["word"] = df["word"].str.split(" ",n=1,expand=True);
    result = df.sort_values(by = ["tfidf_score"], ascending=False).head(10);
    print(result);
    print('\n\n');

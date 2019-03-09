
# coding: utf-8

# In[49]:


import pandas as pd;
import re;
import glob;


# In[50]:


folderPath = 'data';
folderPathToStore = 'data/cleaned';


# In[51]:


allFiles = glob.glob(folderPath + "/*.csv");


# In[52]:


for completeFilePath in allFiles:
    filename = completeFilePath.split('/')[1];
    df = pd.read_csv(completeFilePath);
    df['Body'] = df['Body'].apply(lambda b: re.sub('<.*?>|\\t*\\r*\\n*\\s+',' ',b));
    df['Title'] = df['Title'].apply(lambda t: re.sub('<.*?>|\\t*\\r*\\n*\\s+',' ',t));
    df.to_csv(folderPathToStore+'/cleaned_'+filename,index=False);


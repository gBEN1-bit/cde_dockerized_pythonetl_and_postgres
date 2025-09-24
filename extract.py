import pandas as pd 

def data_extract(url) -> pd.DataFrame:
    df = pd.read_csv(url,sep=",")
    return df
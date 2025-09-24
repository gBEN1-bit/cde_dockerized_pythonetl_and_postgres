from sqlalchemy import create_engine
import pandas as pd
from extract import data_extract
from transform import transform_data
from load import load_data_to_dw
import os

postgres_user = os.getenv('POSTGRES_USER')
postgres_password = os.getenv('POSTGRES_PASSWORD')
postgres_host = os.getenv('POSTGRES_HOST')
postgres_port = os.getenv('POSTGRES_PORT')
postgres_dw = os.getenv('POSTGRES_DW')
url = os.getenv('URL')

dw_engine_connect = create_engine(f'postgresql://{postgres_user}:{postgres_password}@{postgres_host}:{postgres_port}/{postgres_dw}')

def etl(url:str, dw_engine_connect):
    print ("---Starting ETL process...---")
    print ("---Extracting Data...---")
    df_extract = data_extract(url)

    print ("---Transforming Data...---")
    df_transform = transform_data(df_extract)

    print ("---Loading Data into DataWarehouse...---")
    load_data_to_dw(df_transform, dw_engine_connect) 

    print ("---Data loaded into DataWarehouse, ETL process completed!...---")


etl(url=url, dw_engine_connect=dw_engine_connect)
     

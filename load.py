import pandas as pd

def load_data_to_dw(df: pd.DataFrame, dw_engine_connect) -> None:
    df.to_sql(name='countries', con=dw_engine_connect, if_exists='replace',schema='public', index=False)
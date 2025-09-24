import pandas as pd

def transform_data(df: pd.DataFrame) -> pd.DataFrame:
    # Renaming columns
    print("---Renaming Columns...---")
    df = df.rename(columns={
        "Date": "date",
        "Country/Region": "country_region",
        "Province/State": "province_state",
        "Confirmed": "confirmed",
        "Recovered": "recovered",
        "Deaths": "deaths"
    })
    return df

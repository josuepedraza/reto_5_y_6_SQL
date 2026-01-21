import pandas as pd

df = pd.read_csv("01_data/raw/raw_sales_dump.csv")

print("SHAPE:", df.shape)
print("\nCOLUMNAS:")
print(df.columns.tolist())

print("\nPRIMERAS FILAS:")
print(df.head(3))
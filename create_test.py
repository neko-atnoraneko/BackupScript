import os
from datetime import datetime, timedelta

# フォルダ作成の基本パス
base_path = "./TEST"

# 開始日と終了日を指定
start_date = datetime(2024, 3, 15, 0, 0, 0)  # 例: 2023年9月1日 00:00:00
end_date = datetime(2024, 6, 1, 23, 59, 59)  # 例: 2023年9月1日 23:59:59

# 日付の増加間隔を15分ごとに設定
delta = timedelta(minutes=15)

# 日付を範囲内でループしてフォルダを作成
current_date = start_date
while current_date <= end_date:
    # フォルダ名を作成 (例: 2023年09月01日_00時00分00秒)
    folder_name = current_date.strftime("%Y年%m月%d日_%H時%M分%S秒")
    
    # 完全なパスを作成
    folder_path = os.path.join(base_path, folder_name)
    
    # フォルダが存在しない場合に作成
    if not os.path.exists(folder_path):
        os.makedirs(folder_path)
        with open(f'{folder_path}/a.txt', 'a') as a:
            a.write('aaa')
        print(f"フォルダ作成: {folder_path}")
    
    # 次の15分後に進める
    current_date += delta

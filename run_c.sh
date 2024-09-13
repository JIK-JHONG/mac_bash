#!/bin/bash

# 如果沒有提供參數，則使用默認名稱 xdpp
output_name=${1:-xdpp}
func_parameter=${2:-}
current_time=$(date +"%Y-%m-%d %H:%M:%S")
clear
echo ""
echo "進行作業 $current_time ..."
echo "正在編譯 $output_name.c ..."
# 編譯程式，輸出名稱使用變數
gcc -o "$output_name" "$output_name.c"
if [ $? -eq 0 ]; then
    echo "編譯成功！執行 $output_name ..."
    # 執行編譯後的程式
    # ./"$name"
    echo ""
    # 執行編譯後的程式
    ./"$output_name" "$func_parameter"
    echo ""
    echo "執行完畢 ..."
    echo ""
else
    echo "編譯失敗，請檢查程式碼是否有錯誤。"
    echo ""
    echo "執行完畢 ..."
    echo ""    
fi

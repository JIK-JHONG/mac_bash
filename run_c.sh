#!/bin/bash

# 如果沒有提供參數，則使用默認名稱 xdpp
output_name=${1:-xdpp}
func_parameter=${2:-}
current_time=$(date +"%Y-%m-%d %H:%M:%S")
clear

if [[ "$output_name" == *.c ]]; then
    # 使用者已輸入 xxx.cpp，檢查是否存在
    if [ ! -f "$output_name" ]; then
        echo "錯誤：檔案 $output_name 不存在。"
        exit 1
    fi
else
    # 使用者輸入的是 xxx，檢查 xxx.cpp 是否存在
    if [ -f "$output_name.c" ]; then
        output_name="$output_name.c"
    elif [ ! -f "$output_name" ]; then
        echo "錯誤：找不到 $output_name 或 $output_name.c。"
        exit 1
    fi
fi

exec_name="${output_name%.c}"

echo ""
echo "進行作業 $current_time ..."
echo "正在編譯 $output_name.c ..."
# 編譯程式，輸出名稱使用變數
gcc -o "$exec_name" "$output_name"
if [ $? -eq 0 ]; then
    echo "編譯成功！執行 $exec_name ..."
    # 執行編譯後的程式
    # ./"$name"
    echo ""
    # 執行編譯後的程式
    ./"$exec_name" "$func_parameter"
    echo ""
    echo "執行完畢 ..."
    echo ""
else
    echo "編譯失敗，請檢查程式碼是否有錯誤。"
    echo ""
    echo "執行完畢 ..."
    echo ""    
fi

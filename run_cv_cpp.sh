#!/bin/bash

# 如果沒有提供參數，則使用默認名稱 xdpp
# g++ -o <output_name> <output_name>.cpp `pkg-config --cflags --libs opencv4` -std=c++<cpp_version>
# g++ -o ovp ovp.cpp `pkg-config --cflags --libs opencv4` -std=c++11
output_name=${1:-xdpp}
cpp_version=${2:-11}
func_parameter=${3:-}
current_time=$(date +"%Y-%m-%d %H:%M:%S")
clear

if [[ "$output_name" == *.cpp ]]; then
    # 使用者已輸入 xxx.cpp，檢查是否存在
    if [ ! -f "$output_name" ]; then
        echo "錯誤：檔案 $output_name 不存在。"
        exit 1
    fi
else
    # 使用者輸入的是 xxx，檢查 xxx.cpp 是否存在
    if [ -f "$output_name.cpp" ]; then
        output_name="$output_name.cpp"
    elif [ ! -f "$output_name" ]; then
        echo "錯誤：找不到 $output_name 或 $output_name.cpp。"
        exit 1
    fi
fi

exec_name="${output_name%.cpp}"

# echo "openCV 版本："
# pkg-config --modversion opencv4
# echo -n "openCV 版本：" && pkg-config --modversion opencv4
# echo "gcc 版本： 11"
echo "-- 編譯版本資訊 --"
printf "%-15s %s\n" "openCV 版本：" "$(pkg-config --modversion opencv4)"
printf "%-15s %s\n" "gcc 版本：" "$(gcc -dumpversion)"
printf "%-15s %s\n" "使用的 C++ 標準：" "C++$cpp_version"
echo "--"

echo "進行作業 $current_time ..."
echo "正在編譯 $exec_name.cpp ..."
g++ -o "$exec_name" "$output_name" `pkg-config --cflags --libs opencv4` -std=c++"$cpp_version"
echo "--"
# printf "%-15s %s\n" "gcc 版本：" "$(gcc -dumpversion)"
echo "進行作業 $current_time ..."
echo "正在編譯 $exec_name.cpp ..."
# 編譯程式，輸出名稱使用變數
# g++ -o "$output_name" "$output_name.cpp" `pkg-config --cflags --libs opencv4` -std=c++11
g++ -o "$exec_name" "$output_name" `pkg-config --cflags --libs opencv4` -std=c++"$cpp_version"
if [ $? -eq 0 ]; then
    # echo "編譯成功！執行 $output_name ..."
    # 執行編譯後的程式
    # ./"$name"
    # echo ""
    # 執行編譯後的程式
    # ./"$output_name" "$func_parameter"
    echo "編譯成功！執行 $exec_name ..."
    echo ""
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

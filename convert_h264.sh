#!/bin/bash

# 取得輸入文件名
input_name=${1:-}
extension="${input_name##*.}"

# 如果沒有副檔名，則預設為 mp4
if [[ -z "$extension" ]]; then
    extension="mp4"
fi

# 設定輸出文件名，如果第二個參數存在則使用它，否則使用預設格式
if [[ -z "$2" ]]; then
    output_name="${input_name%.*}_H265.$extension"
else
    output_name="$2"
fi

# 記錄當前時間，用於計算耗時
start_time=$(date +%s)

# 檢查輸入文件是否存在
if [[ -f "$input_name" ]]; then
    video="$input_name"

    # 判斷是否使用 Intel Quick Sync
    if ffmpeg -hide_banner -hwaccels | grep -q 'qsv'; then
        echo "系統支持 Intel Quick Sync，使用 Quick Sync 進行轉換"
        ffmpeg -hide_banner -i "$video" -c:v hevc_qsv -b:v 2M -c:a aac "$output_name"
    # 判斷是否使用 Apple VideoToolbox
    elif ffmpeg -hide_banner -encoders | grep -q 'hevc_videotoolbox'; then
        echo "系統支持 Apple VideoToolbox，使用 VideoToolbox 進行轉換"
        ffmpeg -hide_banner -i "$video" -c:v hevc_videotoolbox -b:v 2M -c:a aac "$output_name"
    else
        echo "系統不支持 Intel Quick Sync 或 Apple VideoToolbox，使用軟體編碼進行轉換"
        ffmpeg -hide_banner -i "$video" -c:v libx265 -crf 28 -c:a aac "$output_name"
    fi

    # 檢查轉換後檔案是否生成
    if [[ -f "$output_name" ]]; then
        echo "已將 $video 轉換為 H.265 格式，輸出為 $output_name"
    else
        echo "轉換過程中發生錯誤，請檢查 FFmpeg 輸出日志"
    fi

    # 計算耗時
    end_time=$(date +%s)
    duration=$((end_time - start_time))
    echo "共耗時： $duration 秒"
else
    echo "找不到符合條件的文件 $input_name"
fi
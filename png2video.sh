#!/bin/bash
#   參考指令
# ./png2video.sh openFOAM/mixerVessel2D/ PP 1280 h264
# 預設參數
FRAME_RATE=24
VIDEO_CODEC="libx264"  # 預設使用 H.264 (改為 libx265 可用 H.265)
OUTPUT_SIZE=""  # 預設保持原始尺寸

# 使用說明
usage() {
    echo "Usage: $0 <directory> <filename_prefix> [resize] [codec]"
    echo "  <directory>: 圖片所在目錄"
    echo "  <filename_prefix>: 圖片名稱前綴 (如 PP 表示 PP.0000.png, PP.0001.png ...)"
    echo "  [resize]: 1280 表示強制縮放為 1280x1280，省略則保持原尺寸"
    echo "  [codec]: h265 使用 H.265，省略則使用 H.264"
    exit 1
}

# 檢查參數
if [ "$#" -lt 2 ]; then
    usage
fi

DIR="$1"
PREFIX="$2"
if [ "$3" == "1280" ]; then
    OUTPUT_SIZE="-vf scale=1280:1280"
fi
if [ "$4" == "h265" ]; then
    VIDEO_CODEC="libx265"
fi

# 確保 ffmpeg 安裝
if ! command -v ffmpeg &> /dev/null; then
    echo "錯誤: ffmpeg 未安裝，請使用 'brew install ffmpeg' 來安裝。"
    exit 1
fi

# 進入目錄
cd "$DIR" || { echo "錯誤: 目錄不存在"; exit 1; }

# 檢查是否有符合條件的圖片
if ! ls "${PREFIX}".*.png &> /dev/null; then
    echo "錯誤: 找不到符合條件的 PNG 檔案"
    exit 1
fi

# 產生影片
OUTPUT_FILE="${PREFIX}_Video.mp4"
ffmpeg -framerate $FRAME_RATE -pattern_type glob -i "${PREFIX}.*.png" \
       -c:v $VIDEO_CODEC -preset slow $OUTPUT_SIZE -pix_fmt yuv420p "$OUTPUT_FILE"

echo "轉換完成: $OUTPUT_FILE"
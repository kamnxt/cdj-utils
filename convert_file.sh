#!/bin/bash
set -ue
INPUT_FILE="$1"
if ! [ -e "$INPUT_FILE" ]; then
    echo "File $INPUT_FILE doesn't exist"
    exit 1
fi
SUB_PATH="${INPUT_FILE#*/}"
OUTPUT_FILE="conv/${SUB_PATH%.*}.mp3"
echo "Converting from $INPUT_FILE to $OUTPUT_FILE"
if [ -e "$OUTPUT_FILE" ]; then
    echo "Output $OUTPUT_FILE already exists, skipping"
    exit 0
fi
mkdir -p tmp
mkdir -p "$(dirname "$OUTPUT_FILE")"

ffmpeg -i "$INPUT_FILE" \
    -af "aformat=sample_fmts=s16:sample_rates=48000" \
    -c:a libmp3lame \
    -b:a 320k \
    -vf 'scale=if(gte(iw\,ih)\,min(800\,iw)\,-2):if(lt(iw\,ih)\,min(800\,ih)\,-2)'\
    "tmp/$(basename "$OUTPUT_FILE")" -y

mv "tmp/$(basename "$OUTPUT_FILE")" "$OUTPUT_FILE"

#!/bin/bash

set -e

if [ $# -lt 2 ]; then
    echo "Usage: $0 $# <IPAddress> <binfile>" >&2
    exit 1
fi
IPAddress=$1; binfile=$2; otaList="$1/list"; otaDelete="$1/delete"; otaUpload="$1/upload"; otaErase="$1/erase"; otaProgramm="$1/programm"; otaRun="$1/run";
otaBin="file=@upload.bin"
srBin="upload.bin"


curl -o NUL ${IPAddress}   				# 初始化并进入上传状态     STM32 INIT
echo -e "\n STM32 init OK!"
sleep 0.1
curl -o NUL ${otaDelete}	 		     	# 清空缓存bin文件      Clear bin files cache
echo -e "\n Clear cached bin files OK!"
sleep 0.1
cp ${binfile} ${srBin} 
curl -o NUL -F ${otaBin} ${otaUpload}		# 上传Bin文件         Upload bin file to cache
echo -e "\n Upload $2 to $1 cachespace OK!"
sleep 0.1
rm ${srBin}
curl -o NUL ${otaErase}		            # 清除STM32芯片flash    Erase STM32 flash
echo -e "\n Erase STM32 flash OK!"
sleep 0.1
curl -o NUL ${otaProgramm}		        # 烧录STM32            Upload bin file STM32 flash
echo -e "\n Write STM32 flash OK!"
sleep 0.1
curl -o NUL ${otaRun}               		# 运行STM32           Run STM32
echo -e "\n STM32 Running!"


echo Done
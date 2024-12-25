#!/bin/bash

# 获取输入参数
REMOTE_USER=$1
REMOTE_HOST=$2
REMOTE_PATH=$3
SSH_KEY=$4
WORK_SPACE=$5
# 配置 SSH
mkdir -p ~/.ssh
echo "$SSH_KEY" > ~/.ssh/id_rsa
chmod 600 ~/.ssh/id_rsa

# 查找项目根目录下唯一的 .scps 文件
SCPS_FILE=$(find $WORK_SPACE -maxdepth 1 -type f -name "*.scps")
if [[ -z "$SCPS_FILE" ]]; then
  echo "Error: No .scps file found in the project root."
  echo "::set-output name=transfer-status::Error: No .scps file found."
  exit 1
fi

if [[ $(echo "$SCPS_FILE" | wc -l) -ne 1 ]]; then
  echo "Error: Multiple .scps files found in the project root."
  echo "::set-output name=transfer-status::Error: Multiple .scps files found."
  exit 1
fi

# 初始化拼接的文件路径变量
FILES=""

# 逐行读取 .scps 文件
while IFS= read -r FILE; do
  if [[ -f "$WORK_SPACE/$FILE" ]]; then
    FILES="$FILES $WORK_SPACE/$FILE"
  else
    echo "Warning: '$FILE' listed in $SCPS_FILE does not exist or is not a regular file."
  fi
done < "$SCPS_FILE"

# 检查是否有有效文件
if [[ -z "$FILES" ]]; then
  echo "No valid files found to transfer."
  echo "::set-output name=transfer-status::Error: No valid files."
  exit 1
fi

# 执行 SCP 传输
echo "Transferring files to $REMOTE_USER@$REMOTE_HOST:$REMOTE_PATH"
scp -o StrictHostKeyChecking=no -i $SSH_KEY $FILES "$REMOTE_USER@$REMOTE_HOST:$REMOTE_PATH"

# 检查 SCP 是否成功
if [[ $? -eq 0 ]]; then
  echo "Files transferred successfully."
  echo "::set-output name=transfer-status::Success"
else
  echo "SCP transfer failed."
  echo "::set-output name=transfer-status::Error: SCP failed."
  exit 1
fi

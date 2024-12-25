#!/bin/bash

# Get input parameters
REMOTE_USER=$1
REMOTE_HOST=$2
REMOTE_PATH=$3
SSH_KEY_PATH=$4
WORK_SPACE=$5
# Configure SSH
mkdir -p ~/.ssh
echo "$SSH_KEY" > ~/.ssh/id_rsa
chmod 600 ~/.ssh/id_rsa

#Find the only .scps file in the project root directory
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

# Initialize the concatenated file path variable
FILES=""

# Reading .scps files line by line
while IFS= read -r FILE; do
  if [[ -f "$WORK_SPACE/$FILE" ]]; then
    FILES="$FILES $WORK_SPACE/$FILE"
    echo "Info: '$FILE' appended in ''$FILES "
  else
    echo "Warning: '$FILE' listed in $SCPS_FILE does not exist or is not a regular file."
  fi
done < "$SCPS_FILE"

# Check if there is a valid file
if [[ -z "$FILES" ]]; then
  echo "No valid files found to transfer."
  echo "::set-output name=transfer-status::Error: No valid files."
  exit 1
fi

#Performing an SCP transfer
echo "Transferring files to $REMOTE_USER@$REMOTE_HOST:$REMOTE_PATH"
scp -o StrictHostKeyChecking=no -i $SSH_KEY_PATH $FILES "$REMOTE_USER@$REMOTE_HOST:$REMOTE_PATH"

# Check if SCP was successful
if [[ $? -eq 0 ]]; then
  echo "Files transferred successfully."
  echo "::set-output name=transfer-status::Success"
else
  echo "SCP transfer failed."
  echo "::set-output name=transfer-status::Error: SCP failed."
  exit 1
fi

# SCP Transfer Files GitHub Action

This GitHub Action automatically transfers files listed in a `.scps` file in your project to a remote server using SCP.
test
Create .scps file in the root of the project, list all relative paths of the files that will be transfered to the server.
## Inputs

| Name           | Description                              | Required | 
|----------------|------------------------------------------|----------|
| `remote-user`  | Username for the remote server.          | Yes      | 
| `remote-host`  | Remote server address.                   | Yes      |   
| `remote-path`  | Destination path on the remote server.   | Yes      |     
| `ssh-key-path` | SSH private key path for authentication. | Yes      |  


## Outputs

| Name              | Description                       |
|-------------------|-----------------------------------|
| `transfer-status` | Status of the SCP transfer.       |

## Example Usage

```yaml
name: Deploy Files to Remote Server

on:
  push:
    branches:
      - main

jobs:
  deploy:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v3
        
      - name: Add SSH key
        run: |
          mkdir -p ~/.ssh
          echo "${{ secrets.YOUR_EC2_SSH_KEY }}" > ~/.example-ssh/your-ec2-pri-key.pem
          chmod 600 ~/.example-ssh/your-ec2-pri-key.pem
          
      - name: SCP Transfer Files
        uses: reene444/scp-transfer-action@v1.0.0
        with:
          remote-user: "ubuntu"
          remote-host: "ec2-example.com"
          remote-path: "~/deploy/"
          ssh-key-path: "~/.example-ssh/your-ec2-pri-key.pem"
```


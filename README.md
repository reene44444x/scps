# SCP Transfer Files GitHub Action

This GitHub Action automatically transfers files listed in a `.scps` file in your project to a remote server using SCP.

## Inputs

| Name          | Description                                   | Required | Default |
|---------------|-----------------------------------------------|----------|---------|
| `remote-user` | Username for the remote server.               | Yes      |         |
| `remote-host` | Remote server address.                       | Yes      |         |
| `remote-path` | Destination path on the remote server.        | Yes      |         |
| `ssh-key`     | SSH private key for authentication.           | Yes      |         |


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

      - name: SCP Transfer Files
        uses: reene444/scp-transfer-action@v1.0.0
        with:
          remote-user: "ubuntu"
          remote-host: "ec2example.com"
          remote-path: "~/deploy/"
          ssh-key: "${{ secrets.SSH_KEY }}"

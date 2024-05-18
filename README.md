# Postfix and Dovecot Email Server

This Docker image sets up a simple email server with Postfix and Dovecot. It allows you to easily deploy an email server for your domain.

## Configuration Parameters

### `SERVER_HOSTNAME`

- Set the hostname of your mail server. For example, if your domain is "example.com", set `SERVER_HOSTNAME` to "example.com". Email addresses will be in the format `user@example.com`.

### `AUTH`

- Use this parameter to create email users. The format is `<user>:<password>`. To add multiple users, separate each user/password pair with a semicolon `;`. For example, `<user1>:<password1>;<user2>:<password2>`.

## How to Use

### 1. Build the Docker Image

```bash
docker build -t email-server .
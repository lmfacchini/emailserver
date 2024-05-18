# Postfix and Dovecot Email Server

This Docker image sets up a simple email server with Postfix and Dovecot. It allows you to easily deploy an email server for your domain.

## Configuration Parameters

### `SERVER_HOSTNAME`

- Set the hostname of your mail server. For example, if your domain is "example.com", set `SERVER_HOSTNAME` to "example.com". Email addresses will be in the format `user@example.com`.

### `AUTH`

- Use this parameter to create email users. The format is `<user>:<password>`. To add multiple users, separate each user/password pair with a semicolon `;`. For example, `<user1>:<password1>;<user2>:<password2>`.

## How to Use

### 1. Run the Docker Container

```bash
docker run -d -p 25:25 -p 587:587 -p 993:993 -e SERVER_HOSTNAME=example.com -e AUTH="user1:password1;user2:password2" email-server
```

Replace `"example.com"` with your domain name and `"user1:password1;user2:password2"` with your desired email users and passwords.

### 3. Start Sending and Receiving Emails

Your email server is now running and ready to send and receive emails.

## Additional Notes

- Make sure to set up DNS records (MX, SPF, DKIM, etc.) for your domain to ensure proper email delivery.
- For security reasons, consider using SSL/TLS certificates for encrypted communication with your email server.

For more detailed information on configuring Postfix and Dovecot, refer to their respective documentation:

- [Postfix Documentation](http://www.postfix.org/documentation.html)
- [Dovecot Documentation](https://doc.dovecot.org/)
  
Feel free to customize the Dockerfile and configuration files according to your specific requirements.

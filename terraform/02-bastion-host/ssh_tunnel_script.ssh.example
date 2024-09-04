# ssh: Secure Shell command, used to connect and operate on a remote machine securely.

# -i "key.pem": Specifies the private key file used for authentication. In this case, the file is key.pem, located in your Downloads folder. SSH keys are a way to authenticate to your server without using passwords.

# -f: Requests ssh to go to the background just before command execution. This is used in conjunction with -N to run commands on the remote machine without opening a shell.

# -N: Tells SSH that no command will be sent once the tunnel is up. This is typically used with port forwarding or when you just need to keep a tunnel open without executing commands on the remote machine.

# -L 5432:rds_endpoint:5432: Specifies that the given port on the local (client) host is to be forwarded to the given host and port on the remote side. This flag is used to set up port forwarding. Here's a breakdown of this flag:

# 5432: Local port (on your machine).
# rds_endpoint:5432: The destination host and port you want to forward to. In this case, it's port 5432 on rds_endpoint, which is likely a database server.

# This means that accessing port 5432 on your local machine will forward the request to the database server specified, through the SSH tunnel.
# ec2_connection_url: The user and host you are connecting to. In this case, you're using the ubuntu user to connect to an EC2 instance hosted on AWS at ec2_url_connection.

# -v: Verbose mode. Causes ssh to print debugging messages about its progress. This is useful for diagnosing problems and understanding what the command is doing behind the scenes.

# Summary
# This command sets up an SSH connection using a specific private key to an EC2 instance on AWS, goes into the background before executing any command, doesn't execute a remote command (-N), forwards local port 5432 to port 5432 on a database server hosted on AWS RDS, and does so verbosely to show what's happening.

# In simpler terms, it creates a secure tunnel from your machine's port 5432 to the database server's port 5432 through the EC2 instance, allowing you to interact with the database as if it were locally available on your machine's port 5432.

ssh -i "~/path/to/your/key.pem" -f -N -L 5432:rds_cluster_write_endpoint:5432 ip-for-the-ec2-to-connect-to -v
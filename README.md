ec2-ssh-connect
===============

Self updating bash script for showing menu list of current EC2 servers, and then allow you to choose which server to SSH into using its private IP address. It will store a cache file with the info from AWS it needs to display the list of servers. If the cache file is older than a day it will force a refresh.

Unfortunately there are lots of variables that you will need to specificy in order to keep this script flexible between environments. I hope to make it simpler in the future.

## Setup

1. Install Amazon EC2 CLI Tools and Java JDK if not already installed. http://docs.aws.amazon.com/AWSEC2/latest/CommandLineReference/set-up-ec2-cli-linux.html#setting_up_ec2_command_linux
2. Grant IAM user the EC2 DescribeInstances role if not an IAM admin user. (I think this is the only one needed but I haven't verified myself yet.)
3. Download the scripts.
4. Update variables for your particular environment. EC2_HOME, JAVA_HOME, AWS_ACCESS_KEY, AWS_SECRET_KEY, LIST_FILE, userlogin, and region
5. Make the file executable.
6. Try it out! When the list of servers is displayed just type in the number of the server desired then hit Enter.

## Notes
The server names are pulled from the EC2 "Name" tag.

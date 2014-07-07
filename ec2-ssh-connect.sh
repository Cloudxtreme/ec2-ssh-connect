#!/bin/bash

# Must have the Amazon EC2 CLI Tools and Java JDK installed. Update EC2_HOME and JAVA_HOME as appropriate.
# http://docs.aws.amazon.com/AWSEC2/latest/CommandLineReference/set-up-ec2-cli-linux.html#setting_up_ec2_command_linux

export EC2_HOME='/usr/local/ec2/api'
export JAVA_HOME='/usr/libexec/java_home'
export PATH=$PATH:$EC2_HOME/bin
export AWS_ACCESS_KEY='<Input IAM AWS Access Key>'
export AWS_SECRET_KEY='<Input IAM AWS Secret Key>'

# The userlogin variable is used for the path of the
userlogin="<your username>"
region="<desired region>"

# Update path as appropriate or wherever you desire.
LIST_FILE="$HOME/.servers_cache.txt"

# If the server list cache doesn't exist, create it. If older than a day, update it. Otherwise continue.

function updateList(){
  ec2-describe-instances --region $region > $LIST_FILE
}

if [[ ! -f "$LIST_FILE" ]]; then
  echo "No server list cache file at $LIST_FILE, updating..."
  updateList
  echo "...done!"
elif [[ "$(find "$LIST_FILE" -mtime +1)" == "$LIST_FILE" ]]; then
  echo "Server list cache file is older than 1 day, updating..."
  updateList
  echo "...done!"
else
  echo "Server list cache file is recent."
fi

# Get the list of private IPs to use to match up with other data.
IP_LIST=$(grep "PRIVATEIPADDRESS" $LIST_FILE | awk '{print $2}')

n=0
instance_array=()
for ip in $(echo $IP_LIST); do
  instance=$(grep -w $ip $LIST_FILE | grep "INSTANCE" | awk '{print $2}')
  tagname=$(grep $instance $LIST_FILE | grep "TAG" | grep "Name" | awk '{print $5 $6 $7 $8 $9}')
  instance_array[$n]="$tagname $ip"
  ((++n))
done

# http://stackoverflow.com/a/11789688
IFS=$'\n' sorted_array=($(sort <<<"${instance_array[*]}"))

echo ============================
echo "     EC2 Server List      "
echo ============================
echo ""

eval set ${sorted_array[@]}
select opt in "${sorted_array[@]}"
do
  choice=$(echo $opt | awk '{print $2}')
  ssh -p 22 $userlogin@$choice
exit
done

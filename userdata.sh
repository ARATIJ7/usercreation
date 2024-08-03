#!/bin/bash
# Update the package list
sudo yum update -y

# Install MongoDB
sudo tee /etc/yum.repos.d/mongodb-org-4.4.repo <<EOF
[mongodb-org-4.4]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/amazon/2/mongodb-org/4.4/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-4.4.asc
EOF

sudo yum install -y mongodb-org

# Start MongoDB
sudo systemctl start mongod
sudo systemctl enable mongod

# Wait for MongoDB to start
sleep 10

# Create MongoDB users and databases based on the instance index
case $(curl http://169.254.169.254/latest/meta-data/instance-id) in
  $(aws ec2 describe-instances --query 'Reservations[*].Instances[*].InstanceId' --filters "Name=tag:Name,Values=MongoDBInstance0" --output text))
    mongo <<EOD
    use admin
    db.createUser({
      user: "adminUser",
      pwd: "adminPass",
      roles: [{ role: "userAdminAnyDatabase", db: "admin" }]
    })
    EOD
    ;;
  $(aws ec2 describe-instances --query 'Reservations[*].Instances[*].InstanceId' --filters "Name=tag:Name,Values=MongoDBInstance1" --output text))
    mongo <<EOD
    use database2
    db.createUser({
      user: "readWriteUser",
      pwd: "readWritePass",
      roles: [{ role: "readWrite", db: "database2" }]
    })
    EOD
    ;;
  $(aws ec2 describe-instances --query 'Reservations[*].Instances[*].InstanceId' --filters "Name=tag:Name,Values=MongoDBInstance2" --output text))
    mongo <<EOD
    use database3
    db.createUser({
      user: "readOnlyUser",
      pwd: "readOnlyPass",
      roles: [{ role: "read", db: "database3" }]
    })
    EOD
    ;;
esac

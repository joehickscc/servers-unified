##
## Draft

coreo_aws_ec2_securityGroups "${SERVER_NAME}${SUFFIX}" do
  action :sustain
  description "Server security group"
  vpc "${VPC_NAME}${SUFFIX}"
  allows [ 
          { 
            :direction => :ingress,
            :protocol => :tcp,
            :ports => ${SERVER_INGRESS_PORTS},
            :cidrs => ${SERVER_INGRESS_CIDRS}
          },{ 
            :direction => :egress,
            :protocol => :tcp,
            :ports => ["0..65535"],
            :cidrs => ["0.0.0.0/0"]
          }
    ]
end

coreo_aws_ec2_instance "${SERVER_NAME}${SUFFIX}" do
  action :define
  image_id "${AWS_LINUX_AMI}"
  size "${SERVER_SIZE}"
  security_groups ["${SERVER_NAME}${SUFFIX}"]
#  role "${SERVER_NAME}"
  ssh_key "${SERVER_KEYPAIR}"
  associate_public_ip "${ASSOCIATE_PUBLIC_IP}"
  upgrade_trigger "${SERVER_UPGRADE_TRIGGER}"
  disks [
         {
           :device_name => "/dev/xvda",
           :volume_size => 16
         }
        ]

# Joe and Jacob to check these environment variables with Paul
  environment_variables [
         "ENV=my_env",
         "TEST=true",
         "CLOUD=coreo"
          ]
end

coreo_aws_ec2_autoscaling "${SERVER_NAME}${SUFFIX}" do
  action :sustain 
  minimum ${ASG_MIN}
  maximum ${ASG_MAX}
  server_definition "${SERVER_NAME}${SUFFIX}"
  subnet "${PUBLIC_SUBNET_NAME}"
end


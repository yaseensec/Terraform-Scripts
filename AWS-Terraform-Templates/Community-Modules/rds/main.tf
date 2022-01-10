resource "aws_rds_cluster_parameter_group" "parameter-group" {
    name   = "darkrose-${var.infra-env}-pg-aurora-cluster"
    family = "aurora-mysql5.7"
    
    parameter {
    name  = "character_set_server"
    value = "utf8mb4"
    }
    
    parameter {
    name  = "character_set_client"
    value = "utf8mb4"
    }
    
    parameter {
    name  = "max_allowed_packet"
    value = "1073741824"
    }
    
    tags = {
    Name        = "darkrose ${var.infra-env} RDS Parameter Group - Aurora Cluster"
    Environment = var.infra-env
    Project     = "darkrose.io"
    ManagedBy   = "terraform"
    Type        = "aurora"
    }
}

resource "aws_db_parameter_group" "db-parameter-group" {
    # Name is used in aws_rds_cluster::db_parameter_group_name parameter
    name   = "darkrose-${var.infra-env}-pg-aurora"
    family = "aurora-mysql5.7"

    tags = {
        Name        = "darkrose ${var.infra-env} RDS Parameter Group - Aurora"
        Environment = var.infra-env
        Project     = "darkrose.io"
        ManagedBy   = "terraform"
        Type        = "aurora"
        }


}

module "rds-aurora" {
    source  = "terraform-aws-modules/rds-aurora/aws"
    version = "6.1.3"

    name           = "darkrose ${var.infra-env}-aurora-mysql"
    engine         = "aurora-mysql"
    engine_version = "5.7.mysql_aurora.2.09.2"
    instance_class = var.instance-type

    vpc_id  = var.vpc-id
    subnets = var.subnets

    # replica_count           = 1

    db_parameter_group_name         = aws_db_parameter_group.db-parameter-group.name
    db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.parameter-group.name

    create_random_password = false
    master_username = var.master-username
    master_password = var.master-password

    cluster_identifier = var.name

    tags = {
        Environment = var.infra-env
        Project     = "darkrose.io"
        ManagedBy   = "terraform"
        Type        = "aurora"
    }
}

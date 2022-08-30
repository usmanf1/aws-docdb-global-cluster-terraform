## Tasks for Part Time Devops Job
## Author: Faisal Usman

provider "aws" {
    alias = "primary"
    region = "us-west-2"
}

provider "aws" {
    alias = "secondary"
    region = "us-east-2"
  
}

resource "aws_docdb_global_cluster" "task-docdb-cluster" {
    provider = aws.primary
    global_cluster_identifier = "global-task-cluster"
    engine = "docdb"
    engine_version = "4.0.0"
    database_name = "task-db"

}

resource "aws_docdb_cluster" "task-docdb-primary" {
    provider = aws.primary
    cluster_identifier = "task-docdb-primary-cluster"
    engine =  aws_docdb_global_cluster.task-docdb-cluster.engine
    # engine_version = aws_docdb_global_cluster.task-docdb-cluster.engine_version
    master_username = "usman"
    master_password = "devopstask%321"
    global_cluster_identifier = aws_docdb_global_cluster.task-docdb-cluster.id
}

resource "aws_docdb_cluster_instance" "task-primary-instance" {
    provider = aws.primary
    engine = aws_docdb_global_cluster.task-docdb-cluster.engine
    # engine_version = aws_docdb_global_cluster.task-docdb-cluster.engine_version
    identifier = "task-primary-cluster-instance"
    cluster_identifier = aws_docdb_cluster.task-docdb-primary.id
    instance_class = "db.r5.large"
}

resource "aws_docdb_cluster" "task-docdb-secondary" {
    provider = aws.secondary
    cluster_identifier = "task-docdb-secondary-cluster"
    engine =  aws_docdb_global_cluster.task-docdb-cluster.engine
    # engine_version = aws_docdb_global_cluster.task-docdb-cluster.engine_version
    global_cluster_identifier = aws_docdb_global_cluster.task-docdb-cluster.id
  
}

resource "aws_docdb_cluster_instance" "task-secondary-instance" {
    provider = aws.secondary
    engine = aws_docdb_global_cluster.task-docdb-cluster.engine
    # engine_version = aws_docdb_global_cluster.task-docdb-cluster.engine_version
    identifier = "task-secondary-cluster-instance"
    cluster_identifier = aws_docdb_cluster.task-docdb-secondary.id
    instance_class = "db.r5.large"

    depends_on = [
      aws_docdb_cluster_instance.task-primary-instance
    ]
}


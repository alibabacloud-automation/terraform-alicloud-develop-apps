#!/bin/bash
# Environment variable configuration
export PATH=/usr/local/bin:$PATH

echo "export APPLETS_RDS_ENDPOINT=${database_endpoint}" >> ~/.bashrc
echo "export APPLETS_RDS_USER=${database_user}" >> ~/.bashrc
echo "export APPLETS_RDS_PASSWORD=${database_password}" >> ~/.bashrc
echo "export APPLETS_RDS_DB_NAME=${database_name}" >> ~/.bashrc
source ~/.bashrc

# Network check address
NETWORK_CHECk_ADDR="help-static-aliyun-doc.aliyuncs.com"

function unsupported_system() {
    log_fatal 1 "Unsupported System: $1"
}

function log_info() {
    printf "%s [INFO] %s\n" "$(date '+%Y-%m-%d %H:%M:%S')" "$1"
}

function log_error() {
    printf "%s [ERROR] %s\n" "$(date '+%Y-%m-%d %H:%M:%S')" "$1"
}

function log_fatal() {
    printf "\n========================================================================\n"
    printf "%s [FATAL] %s\n" "$(date '+%Y-%m-%d %H:%M:%S')" "$2"
    printf "\n========================================================================\n"
    exit $1
}

function debug_exec(){
    local cmd="$@"
    log_info "$cmd"
    eval "$cmd"
    ret=$?
    echo ""
    log_info "$cmd, exit code: $ret"
    return $ret
}

function check_network_available() {
    log_info "ping $NETWORK_CHECk_ADDR ..."
    if ! debug_exec ping -c 4 $NETWORK_CHECk_ADDR; then
        log_fatal 2 "Could not connect to https://$NETWORK_CHECk_ADDR"
    fi
}

function install_java() {
    log_info "install java"
    yum upgrade & yum install java-1.8.0-openjdk-devel -y
}

function init_database() {
    log_info "install mysql 1.20.1"
    yum install -y mysql
    mysql -h $APPLETS_RDS_ENDPOINT -u $APPLETS_RDS_USER -p$APPLETS_RDS_PASSWORD < /data/script.sql
}

log_info "System Information:"
if ! lsb_release -a; then
    unsupported_system
fi;
echo ""

check_network_available

mkdir -p /data
cat <<"EOF" >> /data/script.sql
-- script.sql
USE ${database_name};
CREATE TABLE `todo_list` (
  `id` bigint NOT NULL COMMENT 'id',
  `title` varchar(128) NOT NULL COMMENT 'title',
  `desc` text NOT NULL COMMENT 'description',
  `status` varchar(128) NOT NULL COMMENT 'status 未开始、进行中、已完成、已取消',
  `priority` varchar(128) NOT NULL COMMENT 'priority 高、中、低',
  `expect_time` datetime COMMENT 'expect time',
  `actual_completion_time` datetime COMMENT 'actual completion time',
  `gmt_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'create time',
  `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'modified time',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
;
INSERT INTO todo_list
(id, title, `desc`, `status`, priority, expect_time)
value(1,  "创建一个小程序", "使用阿里云解决方案快速搭建一个App应用", "进行中", "高", "2024-04-01 00:00:00")

EOF

if ! debug_exec install_java; then
    log_fatal 3 "install java failed"
fi

if ! debug_exec init_database; then
    log_fatal 4 "init database failed"
fi
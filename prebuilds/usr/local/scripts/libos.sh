#!/bin/bash
# Ver: 1.2 by Endial Fang (endial@126.com)
#
# 操作系统控制函数库

# 加载依赖项
. /usr/local/scripts/liblog.sh          # 日志输出函数库

# 函数列表

# 检测指定用户账户是否存在
# 参数:
#   $1 - 用户账户
user_exists() {
    local user="${1:?user is missing}"
    id "$user" >/dev/null 2>&1
}

# 检测指定用户分组是否存在
# 参数:
#   $1 - 用户组
group_exists() {
    local group="${1:?group is missing}"
    getent group "$group" >/dev/null 2>&1
}

# 获取系统可用内存大小(MB)信息
get_total_memory() {
    echo $(($(grep MemTotal /proc/meminfo | awk '{print $2}') / 1024))
}

# 获取以定量方式描述的内存大小
# 参数:
#   $1 - 内存大小 (MB，可选)
get_machine_size() {
    local memory="${1:-}"
    if [[ -z "$memory" ]]; then
        debug "Memory was not specified, detecting available memory automatically"
        memory="$(get_total_memory)"
    fi
    sanitized_memory=$(convert_to_mb "$memory")
    if [[ "$sanitized_memory" -gt 26000 ]]; then
        echo 2xlarge
    elif [[ "$sanitized_memory" -gt 13000 ]]; then
        echo xlarge
    elif [[ "$sanitized_memory" -gt 6000 ]]; then
        echo large
    elif [[ "$sanitized_memory" -gt 3000 ]]; then
        echo medium
    elif [[ "$sanitized_memory" -gt 1500 ]]; then
        echo small
    else
        echo micro
    fi
}

# 获取已定义的所有内存大小描述
get_supported_machine_sizes() {
    echo micro small medium large xlarge 2xlarge
}

# 将以字符串表示的内存大小转换为以MB为单位的内存大小值 (i.e. 2G -> 2048)
# 参数:
#   $1 - 内存大小
convert_to_mb() {
    local amount="${1:-}"
    if [[ $amount =~ ^([0-9]+)(M|G) ]]; then
        size="${BASH_REMATCH[1]}"
        unit="${BASH_REMATCH[2]}"
        if [[ "$unit" = "G" ]]; then
            amount="$((size * 1024))"
        else
            amount="$size"
        fi
    fi
    echo "$amount"
}

# 如果禁用调试模式，将输出信息重定向至 /dev/null
# 参数:
#   $@ - 待执行的命令
debug_execute() {
    local -r bool="${ENV_DEBUG:-false}"
    shopt -s nocasematch
    if [[ "$bool" = 1 || "$bool" =~ ^(yes|true)$ ]]; then
        "$@"
    else
        "$@" >/dev/null 2>&1
    fi   
}

# 重试执行命令
# 参数:
#   $1 - cmd (as a string)
#   $2 - 最大尝试次数. Default: 12
#   $3 - 重试前等待时间(秒). Default: 5
retry_while() {
    local -r cmd="${1:?cmd is missing}"
    local -r retries="${2:-12}"
    local -r sleep_time="${3:-5}"
    local return_value=1

    read -r -a command <<< "$cmd"
    for ((i = 1 ; i <= retries ; i+=1 )); do
        "${command[@]}" && return_value=0 && break
        sleep "$sleep_time"
    done
    return $return_value
}

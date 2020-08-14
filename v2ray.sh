#!/bin/bash
SH_PATH=$(cd "$(dirname "$0")";pwd)
cd ${SH_PATH}

clone_repo(){
    echo "Step 1: 初始化应用"
    git clone https://github.com/nkxingxh/IBMCF
    cd IBMCF
    git submodule update --init --recursive
    cd v2ray-cf/v2ray
    chmod +x *
    cd ${SH_PATH}/IBMCF/v2ray-cf
    echo "初始化完成"
}

create_mainfest_file(){
    echo "Step 2: 配置应用"
    read -p "请输入你的应用名称：" IBM_APP_NAME
    echo "应用名称：${IBM_APP_NAME}"
    read -p "请输入你的应用内存大小(默认256)：" IBM_MEM_SIZE
    if [ -z "${IBM_MEM_SIZE}" ];then
	IBM_MEM_SIZE=256
    fi
    echo "内存大小：${IBM_MEM_SIZE}"

    read -p "请输入UUID(默认随机生成): " UUID
    if [ -z "${UUID}" ];then
	UUID=$(cat /proc/sys/kernel/random/uuid)
    fi
    echo "V2Ray UUID：${UUID}"

    read -p "请输入path(不带'/'，默认v2ray): " V2RAYPATH
    if [ -z "${V2RAYPATH}" ];then
	V2RAYPATH="v2ray"
    fi
    echo "V2Ray path：$V2RAYPATH"

    cat >  ${SH_PATH}/IBMCF/v2ray-cf/manifest.yml  << EOF
    applications:
    - path: .
      name: ${IBM_APP_NAME}
      random-route: true
      memory: ${IBM_MEM_SIZE}M
EOF

     echo "配置完成"
}

install(){
    echo "Step 3: 安装应用"
    cd ${SH_PATH}/IBMCF/v2ray-cf
    sed -i "s/id\": .*\"/id\": \"$UUID\"/g" ./v2ray/config.json
    sed -i "s/v2raypathvalue/$V2RAYPATH/g" ./v2ray/config.json
    ibmcloud target --cf
    #ibmcloud cf install
    ibmcloud cf push
    echo "安装完成"
}

clone_repo
create_mainfest_file
install
exit 0
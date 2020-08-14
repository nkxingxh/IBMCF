\# v2ray-cloudfoundry

建议使用 install.sh 一键安装脚本

打开ibm官方shell，注意不是容器的ssh

`git clone https://github.com/badafans/v2ray-cloudfoundry.git`

`cd v2ray-cloudfoundry/v2ray`

`chmod +x *` 

你可以自定义修改v2ray的配置文件 config.json

`cd ..`

这里要自己去修改 manifest.yml文件

applications:

\- path: .

  name: GetStartedGo//这里改成你的容器的名称

  random-route: true

  memory: 128M//这里改成你的容器的内存

`ibmcloud target --cf`

`ibmcloud cf push`

等待cloud foundry重启成功!
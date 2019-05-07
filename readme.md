# Bad Mirror

[![WTFPL](http://www.wtfpl.net/wp-content/uploads/2012/12/wtfpl-badge-4.png)](http://www.wtfpl.net)

这是个方便搭建crates.io反向代理镜像的小工具，考虑到有这方面需求的基本都是中国人，所以本项目主要使用中文描述。

# 运行环境

+ docker
+ docker-compose(1.10以上版本，支持docker-compose 2.0语法即可)
+ 能够绑定80和443端口

# 环境变量

自建镜像一些主要的配置项由根目录下名为bad-mirror.env的文件通过dotenv语法完成配置，可配置的环境变量有

+ BAD_MIRROR_ORIGIN(必填): 用于指定自建index Git repository URL
+ BAD_MIRROR_HOST(必填): 用于指定crates镜像域名，使用了Caddy的自动HTTPS服务，会自动申请和更新网站证书、80端口自动跳转至443端口、HTTP/2支持，可在[Caddyfile](./Caddyfile)中进一步配置相关反向代理参数。暂时不考虑HTTP镜像的部署（因为Cargo的并行下载使用的是HTTP/2多路复用机制）
+ BAD_MIRROR_UPSTREAM(可选): 用于指定上游index Git repository URL，默认为`https://github.com/rust-lang/crates.io-index.git`。
+ BAD_MIRROR_INDEX(不建议修改): 用于指定本地中转所用的Git repository文件夹路径，默认为`./crates.io-index`，但在docker-compose.yml中被指定为`/index`以便于使用Docker的volume机制持久化。除非你在尝试脱离Docker环境手动部署，否则不建议修改该环境变量。

# 推送权限

通过`BAD_MIRROR_ORIGIN`环境变量可以配置自建index Git repository的URL，关于该项配置，有以下需要注意的地方

+ 如果使用HTTP协议，且git push需要登录使用，可以在URL中配置用户名和密码，如`https://username:password@github.com/dcjanus/bad-mirror`
+ 如果使用SSH协议，且git push需要相关权限，可在服务端配置公钥，并将私钥文件命名为`id_rsa`置于当前文件夹下，使用docker-compose启动时将挂载进容器内。

# 使用方法

拷贝本项目所有内容至`BAD_MIRROR_HOST`对应服务器，完成相关配置，在当前文件夹下执行`sudo docker-compose up -d `即可。

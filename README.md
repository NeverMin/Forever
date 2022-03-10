## 关于本仓库
由于疫情影响，居家上网课期间，需要收集学生的健康码，日常图片等，并排上号码，使用这个脚本可以快速处理，大约十几分钟可以处理完。

## 用法
1. 脚本运行在 Linux 下或 Windows 10 [WSL](https://docs.microsoft.com/zh-cn/windows/wsl/) 下；
1. 通过腾讯文档使用预先定义的学生名单收集，需要注意，表单设为可修改但不提交多份；
1. 导出 Excel 及附件，Excel 另存为 csv 文件，移去第一项及后面的空行，将图片解压到所在目录的 `attachment` 下；
1. `student_name` 是一个数组，需要放经过排序的学名姓名，以空格隔开；
1. 在 `F$((x+1))$file_name` 中的 F 为 Forever 团队名开着字母，一切准备好就运行脚本，结果会在 `target` 下面。

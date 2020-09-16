datafile = input("输入数据文件名：", "s");

destination = input("指定分割文件保存的文件夹：", "s");
% 创建数据文件指针
fpn = fopen (datafile, 'rt');
% 分割指定的列数
position = 0;
% 数据表第一行的标题
title = "";
% 上一个记录的值
record = "";
% 创建新文件的文件指针
newfile = 0;

while feof(fpn) ~= 1
  % 逐行读取文件
  line = fgetl(fpn);
  % 去掉多余空格
  line = regexprep(line, '\s+', ' ');
  % 去掉首行空格
  line = regexprep(line, '^\s', '');
  % 去掉行尾空格
  line = regexprep(line, "\s$", '');
  % 根据空格分割字符串
  list = regexp(line, '\s', 'split');
  % 将元胞数组转换为字符串数组
  list = string(list);
  % 尝试将第二个元素转换为数字
  [x, tf] = str2num(char(list(2)));
  % 用逗号连接成一行字符
  newLine = join(list, ',');
  % 如果不是数字则保存为标题
  if(~tf)
    title = newLine;
    % 打印读取的标题列表
    disp('目前表格题头列表有如下标题：');
    disp(list);
    aim = input('请输入一项分割列进行分割：', 's');
    len = length(list);
    for i = 1: len
      if aim == list(i)
        position = i;
      end
    end
    % 获取到标题之后跳出循环
    continue;
  end
  
  % 如果是数字
  % 获取到当前的记录值
  if (record == "")
    % 保存第一行记录
    record = list(position);
  end
  % 生成文件名
  if(destination == "")
    % 不指定保存文件夹
    fileName = join([aim, "=", list(position), ".csv"], "");
  else
    % 指定保存文件夹
    if(exist(destination, 'dir') == 0)
      status = mkdir(destination);
      if(status ~= 0)
        disp(join(["创建文件夹：", destination], " "));
      end
    end
    fileName = join([destination, "/", aim, "=", list(position), ".csv"], "");
  end
  % 判断文件是否存在，不存在则创建文件
  if(exist(fileName, 'file') == 0)
    % 如果文件指针是打开的
    if(newfile)
      fclose(newfile);
    end
    % 创建文件指针
    newfile = fopen(fileName, 'a');
    % 写入标题
    fprintf(newfile, join([title, "\n"]));
    disp(["已创建文件：", fileName]);
  end
  
  % newfile = fopen(fileName, 'a');
  % 写入行
  fprintf(newfile, join([newLine, "\n"]));
  % 如果指定处的数值和记录值相同
  if(list(position) ~= record)
    record = list(position);
  end
end
fclose(newfile);
fclose(fpn);

disp("文件整理完毕");
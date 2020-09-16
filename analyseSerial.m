% 读取附件一的所有表,统计每个季度进项额度和销项额度的报表

% fileName = input("附件一文件名: ", 's');

fileName = "附件1：123家有信贷记录企业的相关数据.xlsx";

f = waitbar(0, "正在读取文件...");

% companylist = readtable(fileName, "sheet", 1);

% waitbar(1/3, f);

% expenditurelist = table2cell(readtable(fileName, "sheet", 2));

% waitbar(2/3, f);

% incomeTable = table2cell(readtable(fileName, "sheet", 3));

% waitbar(3/3, f);

companyList = readCompany(companylist);

% expendList
clear expendList;
expendListPosition = 1;
expendLen = length(expenditurelist);

position = 1;
clear temp;
record = "";

waitbar(0, f, "正在分析进项发票信息...");

for i = 1: expendLen
    waitbar(i / expendLen, f);

    ID = string(expenditurelist{i, 1});
    line = [string(expenditurelist{i, 1}),
        string(expenditurelist{i, 2}),
        datestr(expenditurelist{i, 3}, "yyyy-mm-dd"),
        string(expenditurelist{i, 4}),
        string(expenditurelist{i, 5}),
        string(expenditurelist{i, 6}),
        string(expenditurelist{i, 7}),
        string(expenditurelist{i, 8})]';
    if(record == "")
        record = ID;
    end
    if(ID ~= record || i == expendLen)
        expendList(expendListPosition) = apartReport(temp);
        expendListPosition = expendListPosition + 1;
        position =  1;
        clear temp;
        record = ID;
        temp(position, :) = line;
        position = position + 1;
        continue;
    end
    temp(position, :) = line;
    position = position + 1;
end

% incomelist
clear incomeList;
incomeListPosition = 1;
incomeLen = length(incomeTable);

position = 1;
clear temp;
record = "";

waitbar(0, f, "正在分析销项发票信息...");

for i = 1: incomeLen
    waitbar(i / incomeLen, f);

    ID = string(incomeTable{i, 1});
    line = [string(incomeTable{i, 1}),
        string(incomeTable{i, 2}),
        datestr(incomeTable{i, 3}, "yyyy-mm-dd"),
        string(incomeTable{i, 4}),
        string(incomeTable{i, 5}),
        string(incomeTable{i, 6}),
        string(incomeTable{i, 7}),
        string(incomeTable{i, 8})]';
    if(record == "")
        record = ID;
    end
    if(ID ~= record || i == incomeLen)
        incomeList(incomeListPosition) = apartReport(temp);
        incomeListPosition = incomeListPosition + 1;
        position = 1;
        clear temp;
        record = ID;
        temp(position, :) = line;
        continue;
    end
    temp(position, :) = line;
    position = position + 1;
end

% 创建进销项文件夹
if(exist("expend", "dir") == 0)
    status = mkdir("expend");
    if(status ~= 0)
        disp('创建文件夹：expend');
    end
end
if(exist("income", "dir") == 0)
    status = mkdir("income");
    if(status ~= 0)
        disp('创建文件夹：income');
    end
end

extendLen = length(expendList);
incomeLen = length(incomeList);

waitbar(0, f, "正在写入进项报表...");

for i = 1: extendLen
    % waitbar(i / extendLen, f);

    filename = join(["expend/" ,expendList(i).ID, ".txt"], '');
    fpn =  fopen(filename, "w");
    fprintf(fpn, expendList(i).toString());
    fclose(fpn);
end

for i = 1: incomeLen
    % waitbar(i / incomeLen, f);

    filename = join(["income/" ,incomeList(i).ID, ".txt"], '');
    fpn =  fopen(filename, "w");
    fprintf(fpn, join(incomeList(i).toString()));
    fclose(fpn);
end

% 按统计要求格式化数据




% 关闭进度条
close(f);
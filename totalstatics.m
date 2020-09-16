% 一些统计量的计算程序
% 进项有效发票数
% 进项作废发票数
% 销项有效发票数
% 销项作废发票数
% 负数发票次数
% 负数发票次数占比
% 企业交易金额

fileName = "附件1：123家有信贷记录企业的相关数据.xlsx";
 
f = waitbar(0, "正在读取文件...");

% expenditurelist = table2cell(readtable(fileName, "sheet", 2));

% waitbar(1/2, f);

% incomeTable = table2cell(readtable(fileName, "sheet", 3));

% waitbar(1, f);

% expenditurelist
clear expendListDetails;
expendListPosition = 1;
expendLen = length(expenditurelist);

position = 1;
clear temp
record = "";

f = waitbar(0, "正在处理进项数据...");

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
        expendListDetails(expendListPosition) = apartDetails(temp);
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


% income

clear incomeListDetails;
incomeListPosition = 1;
incomeLen = length(incomeTable);

position = 1;
clear temp;
record = "";

f = waitbar(0, "正在处理销项数据...");

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
        incomeListDetails(incomeListPosition) = apartDetails(temp);
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
if(exist("expendDetails", "dir") == 0)
    status = mkdir("expendDetails");
    if(status ~= 0)
        disp('创建文件夹：expendDetails');
    end
end

if(exist("incomeDetails", "dir") == 0)
    status = mkdir("incomeDetails");
    if(status ~= 0)
        disp('创建文件夹：incomeDetails');
    end
end

extendLen = length(expendListDetails);
incomeLen = length(incomeListDetails);

waitbar(0, f, "正在写入进项报表...");

for i = 1: extendLen
    waitbar(i / extendLen, f);

    filename = join(["expendDetails/" ,expendListDetails(i).ID, ".txt"], '');
    fpn =  fopen(filename, "w");
    fprintf(fpn, expendListDetails(i).toString());
    fclose(fpn);
end

waitbar(0, f, "正在写入销项报表...");

for i = 1: incomeLen
    waitbar(i / incomeLen, f);

    filename = join(["incomeDetails/" ,incomeListDetails(i).ID, ".txt"], '');
    fpn =  fopen(filename, "w");
    fprintf(fpn, join(incomeListDetails(i).toString()));
    fclose(fpn);
end
% 关闭进度条

% 按统计要求格式化数据

filename = "expendDetails/expandTotalDetails.csv";
fptemp = fopen(filename, "w");

for i = 1: extendLen
    s = sprintf("%s,%d,%d,%d,%f\n", expendListDetails(i).ID,expendListDetails(i).UsageCount,expendListDetails(i).UnUsageCount,expendListDetails(i).MinusInvoicesCount,sum(expendListDetails(i).MonthTransactionListCount) / expendListDetails(i).CountMonth);
    fprintf(fptemp, s);
end
fclose(fptemp);

filename = "incomeDetails/incomeTotalDetails.csv";
fptemp = fopen(filename, "w");

for i = 1: incomeLen
    s = sprintf("%s,%d,%d,%d,%d", incomeListDetails(i).ID,incomeListDetails(i).UsageCount,incomeListDetails(i).UnUsageCount,incomeListDetails(i).MinusInvoicesCount,sum(incomeListDetails(i).MonthTransactionListCount) / incomeListDetails(i).CountMonth);
    fprintf(fptemp, s);
end
fclose(fptemp);

close(f);
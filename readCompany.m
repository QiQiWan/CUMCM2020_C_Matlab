function companyList = readCompany(data)
%READCOMPANY 从指定表格中读取已知公司列表
%   输入读取readtable之后读取的表格
    [rows, cols] = size(data);
    for i = 1: rows
        line = data{i, :};
        line = string(line);
        companyList(i) = companyModel(line(1), line(2), line(3), line(4));
    end
end
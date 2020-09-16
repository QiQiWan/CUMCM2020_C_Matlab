function amountList = apartReport(data)
    %READCOMPANY 从指定表格中读取单一公司参数,税金,日期
    %   该表格经过公司ID的单一处理

    [row, col] = size(data);

    ID = data(1, 1);

    amountList = amountListModel(ID);

    for i = 1: row
        usage = data(i, 8);
        if(usage == "作废发票")
            continue;
        end
        time = datetime(data(i, 3));
        amount = str2double(data(i, 7));
        amountList = amountList.add(time.Year, time.Month, amount);
    end
end
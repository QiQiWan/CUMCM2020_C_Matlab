function totalModelList = apartDetails(data)
%APARTDETAILS 根据导入表生成细节模型列表


    [row, col] = size(data);

    ID = data(1, 1);

    totalModelList = totalModel(ID, row);
    clear line;
    for i = 1: row
        line = data(i, :);
        totalModelList = totalModelList.add(line);
        clear line;
    end
end


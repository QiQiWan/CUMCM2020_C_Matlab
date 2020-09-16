function [company,status] = companyContains(companyList, ID)
%COMPANYCONTAINS 已知的公司列表中是否存在当前公司ID
%   存在则返回该公司对象和true,不存在返回空的公司对象和false
    len = size(companyList);
    for i = 1: len;
        if(companyList(i).ID = ID)
            company = companyList(i);
            status = true
            return;
        end
    end
    companyList = 0;
    status = false;
end
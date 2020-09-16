classdef amountListModel
    %AMOUNTLISTMODEL 此处显示有关此类的摘要
    %   此处显示详细说明
    
    properties
        % 对应的公司ID
        ID
        % 对应的季度
        Seasons = []
        % 对应的数量
        Amount = []
        % 列表中所有的数量
        Count
        % 月平均流水
        % Avarage
    end
    
    methods
        function obj = amountListModel(id)
            %AMOUNTLISTMODEL 构造列表类函数
            obj.ID = id;
            obj.Count = 1;
        end
        
        function new = add(obj, year, month, amount)
            % add 添加季度格式和加总金额
            seasonName = obj.getseason(year, month);
            [index, contains] = obj.seasonContains(seasonName);
            if(contains)
                obj.Amount(index) = obj.Amount(index) + amount;
            else
                obj.Amount(obj.Count) = amount;
                obj.Seasons(obj.Count) = seasonName;
                obj.Count = obj.Count + 1;
            end
            new = obj;
        end

        function seasonName = getseason(obj, year, month)
            % 根据日期生成季度格式字符串
            if(month == 1 || month == 2 || month == 3)
                times = 1;
            end
            if(month == 4 || month == 5 || month == 6)
                times = 2;
            end
            if(month == 7 || month == 8 || month == 9)
                times = 3;
            end
            if(month ==10 || month == 11 || month == 12)
                times = 4;
            end
            seasonName = year * 100 + month;
        end
        function [index, contains] = seasonContains(obj, currentSeason)
            len = length(obj.Seasons);
            for i = 1: len
                if(currentSeason == obj.Seasons(i))
                    index = i;
                    contains = true;
                    return;
                end
            end
            index = 0;
            contains = false;
        end
        function disp(obj)
            disp(obj.toString());
        end

        function string = toString(obj)
            s = sprintf('公司ID: %s\n', obj.ID);
            len = length(obj.Seasons);
            temp = "";            
            for i = 1: len
                temp = join([temp, sprintf('季度: %s  ,  金额: %f\n', obj.Seasons(i), obj.Amount(i))], "\n");
            end
            total = sprintf("总流水交易额为: %f, 总流水月平均交易额为: %f", sum(obj.Amount), sum(obj.Amount) / len);

            %[company,status] = companyContains(companyList, obj.ID);

            % if(status)
            %     credit = sprintf("企业 %s 的信用等级为: %s", company.ID, company.Credit);
            % else
            %     credit = sprintf("未找到该公司的记录!");
            % end
            string = join([s, temp, total], "\n");
        end
    end
end
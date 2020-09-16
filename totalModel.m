classdef totalModel
    %TOTALMODEL 综合统计量的储存类型,以单个公司为单位

    properties
        % 公司ID
        ID
        % 有效发票数
        UsageCount
        % 作废发票数
        UnUsageCount
        % 负数发票次数
        MinusInvoicesCount
        % 当前企业的交易月列表
        MonthList
        % 当月企业交易次数
        MonthTransactionListCount
        % 年列表
        YearList
        % 每年的交易量
        YearTransactionListAmount
        % 总共交易次数
        TotalCount
        % 移动MonthList的指针
        CountMonth
        CountYear
    end
    
    methods
        function obj = totalModel(id, count)
            %TOTALMPDEL 构造此类的实例
            obj.ID = id;
            obj.UsageCount = 0;
            obj.UnUsageCount = 0;
            obj.MinusInvoicesCount = 0;
            obj.MonthTransactionListCount = zeros(50);
            obj.YearTransactionListAmount = zeros(5);
            obj.TotalCount = 0;
            obj.CountMonth = 0;
            obj.CountYear = 0;
            obj.YearList = [];
            obj.MonthList = [];
        end
        function new  = add(obj, line)
            time = datetime(line(3));
            Year = time.Year;
            Amount = str2num(line(7));
            time = time.Year * 100 + time.Month;

            % 月交易数
            [index, contains] = obj.ListContains(obj.MonthList, time);
            if(contains)
                obj.MonthTransactionListCount(index) = obj.MonthTransactionListCount(index) + 1;
            else
                obj.CountMonth = obj.CountMonth + 1;
                obj.MonthTransactionListCount(obj.CountMonth) = 1;
                obj.MonthList(obj.CountMonth) = time;
            end
            % 年交易额
            [index, contains] = obj.ListContains(obj.YearList, Year);
            if(contains)
                obj.YearTransactionListAmount(index) = obj.YearTransactionListAmount(index) + 1;
            else
                obj.CountYear = obj.CountYear + 1;
                obj.YearTransactionListAmount(obj.CountYear) = obj.YearTransactionListAmount(obj.CountYear) + Amount;
                obj.YearList(obj.CountYear) = Year;
            end
            
            if(Amount < 0)
                obj.MinusInvoicesCount = obj.MinusInvoicesCount + 1;
            end
            if(line(8) == "有效发票")
                obj.UsageCount = obj.UsageCount + 1;
            end
            if(line(8) == "作废发票")
                obj.UnUsageCount = obj.UnUsageCount + 1;
            end
            new = obj;
        end

        function [index, contains] = ListContains(obj, list, element)
            len = length(list);
            for i = 1: len
                if(list(i) == element)
                    contains = true;
                    index = i;
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
            s = sprintf("企业编号: %s", obj.ID);
            s = join([s, sprintf("有效发票数: %d", obj.UsageCount)], "\n");
            s = join([s, sprintf("作废发票数: %d", obj.UnUsageCount)], "\n");
            s = join([s, sprintf("负数额度发票数: %d", obj.MinusInvoicesCount)], "\n");
            s = join([s, sprintf("有记录的交易月数: %d", obj.CountMonth)], "\n");
            s = join([s, sprintf("月平均交易次数: %f", sum(obj.MonthTransactionListCount) / obj.CountMonth)]);
            len = length(obj.MonthList);
            for i = 1: len
                s = join([s, sprintf("指定月: %d 的交易次数: %d", obj.MonthList(i), obj.MonthTransactionListCount(i))], "\n");
            end

            s = join([s, sprintf("全部交易次数: %d", obj.TotalCount)], "\n");

            len = length(obj.YearList);

            for i = 1: len
                S = join([s, sprintf("指定年: %d 的交易额: %f", obj.YearList(i), obj.YearTransactionListAmount(i))], "\n");
            end
            string = s;
        end
    end
end
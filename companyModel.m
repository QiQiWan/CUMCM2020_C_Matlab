classdef companyModel
    %COMPANYMODEL 公司类,定义一个公司对象
    %   包括公司ID,公司名称,公司信用评级,是否违约
    
    properties
        Name
        Credit
        ID
        Breach
    end
    
    methods
        function obj = companyModel(id, name, credit, breach)
            %COMPANYMODEL 构造此类的实例
            obj.ID = id;
            obj.Name = name;
            obj.Credit = credit;
            obj.Breach = breach;        
        end

        function  disp(obj)
            s=sprintf('公司ID：%s \n公司名：%s \n公司信用：%s \n是否违约：%s', obj.ID, obj.Name, obj.Credit, obj.Breach);
            disp(s);
        end
    end
end


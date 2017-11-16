function speechproc()

    % 定义常数
    FL = 80;                % 帧长
    WL = 240;               % 窗长
    P = 10;                 % 预测系数个数
    s = readspeech('voice.pcm',100000);             % 载入语音s
    L = length(s);          % 读入语音长度
    FN = floor(L/FL)-2;     % 计算帧数
    
    % 预测和重建滤波器
    exc = zeros(L,1);       % 激励信号（预测误差）
    zi_pre = zeros(P,1);    % 预测滤波器的状态
    s_rec = zeros(L,1);     % 重建语音
    zi_rec = zeros(P,1);    % 重建语音的滤波器状态
    zi_syn = zeros(P,1);    % 合成语音的滤波器状态
    zi_syn_v = zeros(P,1);  % 变速不变调的合成语音的滤波器状态
    zi_syn_t = zeros(P,1);  % 变调不变速的合成语音的滤波器状态
    
    % 合成滤波器
    exc_syn = zeros(L,1);   % 合成的激励信号（脉冲串）
    s_syn = zeros(L,1);     % 合成语音
    % 变调不变速滤波器
    exc_syn_t = zeros(L,1);   % 合成的激励信号（脉冲串）
    s_syn_t = zeros(L,1);     % 合成语音
    % 变速不变调滤波器（假设速度减慢一倍）
    exc_syn_v = zeros(2*L,1);   % 合成的激励信号（脉冲串）
    s_syn_v = zeros(2*L,1);     % 合成语音

    hw = hamming(WL);       % 汉明窗
    
    % 依次处理每帧语音
    for n = 3:FN

        % 计算预测系数（不需要掌握）
        s_w = s(n*FL-WL+1:n*FL).*hw;    %汉明窗加权后的语音
        [A E] = lpc(s_w, P);            %用线性预测法计算P个预测系数
                                        % A是预测系数，E会被用来计算合成激励的能量

        if n == 27
        % (3) 在此位置写程序，观察预测系统的零极点图
           a_pre=A;                     %定义输入信号系数（预测系数）
           b_pre=[1];                   %定义输出信号系数（1）
           zplane(b_pre,a_pre);         %zplane作出零极点分布图
           title('预测系统的零极点分布图');    %作图
        end
        
        s_f = s((n-1)*FL+1:n*FL);       % 本帧语音，下面就要对它做处理

        % (4) 在此位置写程序，用filter函数s_f计算激励，注意保持滤波器状态
        [exc((n-1)*FL+1:n*FL),zf_pre]=filter(A,1,s_f,zi_pre);
        zi_pre=zf_pre;                  % 保持滤波器状态


        % (5) 在此位置写程序，用filter函数和exc重建语音，注意保持滤波器状态
        [s_rec((n-1)*FL+1:n*FL),zf_rec]=filter(1,A,exc((n-1)*FL+1:n*FL),zi_rec);
        zi_rec=zf_rec;                  % 保持滤波器状态
  

        % 注意下面只有在得到exc后才会计算正确
        s_Pitch = exc(n*FL-222:n*FL);
        PT = findpitch(s_Pitch);    % 计算基音周期PT（不要求掌握）
        G = sqrt(E*PT);           % 计算合成激励的能量G（不要求掌握）

        
        % (10) 在此位置写程序，生成合成激励，并用激励和filter函数产生合成语音
        
        pos_syn=2*FL+1;                 %由于从第3帧开始处理，n=3时，语音信号从2*FL+1到n*FL
        while(pos_syn<=n*FL)            %利用9.2.2（2）中的基音周期处理方法
            exc_syn(pos_syn)=G;         %G为计算得到的增益
            pos_syn=pos_syn+PT;        	%控制每段内每个脉冲和前一个脉冲的间隔为本段的PT值
        end
        Gxn=exc_syn((n-1)*FL+1:n*FL);	%Gxn即exc_syn为合成的激励信号
        [sn_syn,zf_syn]=filter(1,A,Gxn,zi_syn);     %A为预测系数
        zi_syn=zf_syn;                  %保持滤波器状态不发生改变
        s_syn((n-1)*FL+1:n*FL)=sn_syn;	%合成语音~s(n)


        % (11) 不改变基音周期和预测系数，将合成激励的长度增加一倍，再作为filter
        % 的输入得到新的合成语音，听一听是不是速度变慢了，但音调没有变。
        
        pos_syn_v=2*FL+1;          %由于从第3帧开始处理，n=3时，语音信号从2*FL+1到n*FL
        while(pos_syn_v<=2*n*FL)   %利用9.2.2（2）中的基音周期处理；语音总长度为原来的2倍
            exc_syn_v(pos_syn_v)=G;%G为计算得到的增益
            pos_syn_v=pos_syn_v+PT;%同样控制每段内每个脉冲和前一个脉冲的间隔为本段的PT值
        end
        Gxn_t=exc_syn_v(2*(n-1)*FL+1:2*n*FL);	%Gxn_v即exc_syn_v为合成的激励信号
        [sn_syn_v,zf_syn_v]=filter(1,A,Gxn_t,zi_syn_v);     %A为预测系数
        zi_syn_v=zf_syn_v;         %保持滤波器状态不发生改变
        s_syn_v(2*(n-1)*FL+1:2*n*FL)=sn_syn_v;	%合成语音s_syn_v   
     

        
        %(13)将基音周期减小一半，将共振峰频率增加150Hz，重新合成语音，听听是啥感受～
        
            [z,p,k]=tf2zp(1,A);         %求解（1)极点
            fs=8000;                    %采样频率取8000Hz
            delta_omg=2*pi*150*sign(angle(p))/fs;  %推导的公式中的±△Ω
            pn=p.*exp(1i*delta_omg);               %得到两个共轭的新极点
            [Bc,Ac]=zp2tf(z,pn,k);                 %用zp2tf函数得到系数矩阵A,B
            pos_syn_t=2*FL+1;          %从第3帧开始处理，语音信号从2*FL+1到n*FL
            while(pos_syn_t<=n*FL)     %基音周期处理；语音总长度为原来的2倍
                exc_syn_t(pos_syn_t)=G;%G为计算得到的增益
                pos_syn_t=pos_syn_t+round(PT/2);%每段内每个脉冲和前一脉冲间隔为本段PT
            end
            Gxn_t=exc_syn_t((n-1)*FL+1:n*FL);	%Gxn_t即exc_syn_t为合成的激励信号
            [sn_syn_t,zf_syn_t]=filter(Bc,Ac,Gxn_t,zi_syn_t);   %A为预测系数
            zi_syn_t=zf_syn_t;     %保持滤波器状态不发生改变
            s_syn_t((n-1)*FL+1:n*FL)=sn_syn_t;	%合成语音s_syn_t
        
    end

    % (6) 在此位置写程序，听一听 s ，exc 和 s_rec 有何区别，解释这种区别
    % 后面听语音的题目也都可以在这里写，不再做特别注明
    figure;
    subplot(3,1,1); plot(s);        %完整的s(n)信号
    subplot(3,1,2); plot(exc);      %完整的e(n)信号
    subplot(3,1,3); plot(s_rec);    %完整的s^(n)信号
    
    figure;
    sound(s);                       %试听播放直接从voice.pcm载入的语音信号s(n)
    subplot(3,1,1);                 %子图1
    plot(s(0.3*L:0.5*L));           %选取完整语音的0.3~0.5部分
    title('s(n)信号');              %设置标题
    pause(2);                       %停顿2s,便于区分声音
    sound(exc);                     %试听之前得到的激励信号e(n)
    subplot(3,1,2);                 %子图2
    plot(exc(0.3*L:0.5*L));         %选取完整语音的0.3~0.5部分
    title('e(n)信号');              %设置标题
    pause(2);                       %停顿2s,便于区分声音
    sound(s_rec);                   %试听由激励信号e(n)恢复的语音信号s^(n)
    subplot(3,1,3);                 %子图3
    plot(s_rec(0.3*L:0.5*L));       %选取完整语音的0.3~0.5部分
    title('s''(n)信号');            %设置标题
    
    pause(2);
    sound(s_syn);                   %试听(10)的合成语音
   %figure;subplot(2,1,1);plot(s);subplot(2,1,2);plot(s_syn);
    pause(2);
    sound(s_syn_v);                 %试听(11)变速不变调的合成语音
   %figure;subplot(2,1,1);plot(s);subplot(2,1,2);plot(s_syn_v);
    pause(4);
    sound(s_syn_t);                 %试听(13)变调不变速的合成语音
   %figure;subplot(2,1,1);plot(s);subplot(2,1,2);plot(s_syn_t);
    
    
    % 保存所有文件
    writespeech('exc.pcm',exc);
    writespeech('rec.pcm',s_rec);
    writespeech('exc_syn.pcm',exc_syn);
    writespeech('syn.pcm',s_syn);
    writespeech('exc_syn_t.pcm',exc_syn_t);
    writespeech('syn_t.pcm',s_syn_t);
    writespeech('exc_syn_v.pcm',exc_syn_v);
    writespeech('syn_v.pcm',s_syn_v);
return

% 从PCM文件中读入语音
function s = readspeech(filename, L)
    fid = fopen(filename, 'r');
    s = fread(fid, L, 'int16');
    fclose(fid);
return

% 写语音到PCM文件中
function writespeech(filename,s)
    fid = fopen(filename,'w');
    fwrite(fid, s, 'int16');
    fclose(fid);
return

% 计算一段语音的基音周期，不要求掌握
function PT = findpitch(s)
    [B, A] = butter(5, 700/4000);
    s = filter(B,A,s);
    R = zeros(143,1);
    for k=1:143
        R(k) = s(144:223)'*s(144-k:223-k);
    end
    [R1,T1] = max(R(80:143));
    T1 = T1 + 79;
    R1 = R1/(norm(s(144-T1:223-T1))+1);
    [R2,T2] = max(R(40:79));
    T2 = T2 + 39;
    R2 = R2/(norm(s(144-T2:223-T2))+1);
    [R3,T3] = max(R(20:39));
    T3 = T3 + 19;
    R3 = R3/(norm(s(144-T3:223-T3))+1);
    Top = T1;
    Rop = R1;
    if R2 >= 0.85*Rop
        Rop = R2;
        Top = T2;
    end
    if R3 > 0.85*Rop
        Rop = R3;
        Top = T3;
    end
    PT = Top;
return
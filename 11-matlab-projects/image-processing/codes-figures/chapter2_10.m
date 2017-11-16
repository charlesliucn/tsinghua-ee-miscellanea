clear all,close all,clc;

load jpegcodes.mat;
DCL=length(DCCode);         %DC系数编码的码流长度
ACL=length(ACCode);     	%AC系数编码的码流长度
InputL=Height*Width*8;  	%输入文件长度，转换为二进制，每个像素需要8位
OutputL=DCL+ACL;        	%输出码流长度，包含DC系数编码码流和AC系数编码码流
COMR=InputL/OutputL;        %压缩比=输入文件长度/输出码流长度
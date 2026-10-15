%% 绘制示波器导出的心电图
% 数据文件：新建文件1.csv
% CSV 前两行是表头/采样参数，之后依次为序号、CH1 电压。

clear; clc; close all;

dataFile = fullfile(fileparts(mfilename('fullpath')), '新建文件3.csv');

% 读取数值区（跳过 CSV 的前两行说明）
data = readmatrix(dataFile, 'NumHeaderLines', 2);
sampleIndex = data(:, 1);
voltage = data(:, 2);
valid = isfinite(sampleIndex) & isfinite(voltage);
sampleIndex = sampleIndex(valid);
voltage = voltage(valid);

% 文件第二行给出的采样时间起点和采样间隔
startTime = -3.0;       % 秒
sampleInterval = 0.005; % 秒
time = startTime + sampleIndex .* sampleInterval;

figure('Color', 'w');
plot(time, voltage, 'b-', 'LineWidth', 1);
grid on;
xlabel('时间 (秒)');
ylabel('电压 (伏)');
title('心电图（CH1）');
xlim([min(time), max(time)]);

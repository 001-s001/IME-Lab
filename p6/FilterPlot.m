%% 绘制带通滤波器频率响应
% CSV 中 Vpp 单位统一为 mV。由于没有输入幅值，dB 曲线按最大 Vpp 归一化：
% dB = 20*log10(Vpp / max(Vpp))，峰值为 0 dB。

clear; clc; close all;

dataFile = fullfile(fileparts(mfilename('fullpath')), '带通滤波器频率响应.csv');
data = readmatrix(dataFile, 'NumHeaderLines', 1);
frequency = data(:, 1);
vpp = data(:, 2);
valid = isfinite(frequency) & isfinite(vpp) & frequency > 0 & vpp > 0;
frequency = frequency(valid);
vpp = vpp(valid);

% 图 1：峰峰值响应
figure('Color', 'w');
semilogx(frequency, vpp, 'o-', 'LineWidth', 1.5, 'MarkerSize', 6, ...
    'MarkerFaceColor', [0.2 0.45 0.85]);
grid on;
xlabel('频率 (Hz)');
ylabel('峰峰值 V_{pp} (mV)');
title('带通滤波器频率响应（V_{pp}）');
xlim([min(frequency), max(frequency)]);

% 图 2：相对峰值的 dB 响应
responseDB = 20 .* log10(vpp ./ max(vpp));
cutoffLevelDB = -3;
crossingIdx = find((responseDB(1:end-1) - cutoffLevelDB) .* ...
    (responseDB(2:end) - cutoffLevelDB) <= 0);
cutoffFrequency = zeros(size(crossingIdx));
for k = 1:numel(crossingIdx)
    idx = crossingIdx(k);
    % 在对数频率轴上对 -3 dB 交点做线性插值
    logFreq = interp1(responseDB(idx:idx+1), log10(frequency(idx:idx+1)), cutoffLevelDB);
    cutoffFrequency(k) = 10 .^ logFreq;
end

figure('Color', 'black');
semilogx(frequency, responseDB, 's-', 'LineWidth', 1.5, 'MarkerSize', 6, ...
    'MarkerFaceColor', [0.85 0.35 0.2]);
grid on;
hold on;
yline(cutoffLevelDB, '--k', '-3 dB', 'LabelHorizontalAlignment', 'left');
if numel(cutoffFrequency) >= 2
    xline(cutoffFrequency(1), ':w', sprintf('f_L = %.2f Hz', cutoffFrequency(1)), ...
        'LabelVerticalAlignment', 'bottom');
    xline(cutoffFrequency(end), ':w', sprintf('f_H = %.1f Hz', cutoffFrequency(end)), ...
        'LabelVerticalAlignment', 'bottom');
    plot(cutoffFrequency, repmat(cutoffLevelDB, size(cutoffFrequency)), ...
        'ko', 'MarkerFaceColor', 'y', 'HandleVisibility', 'off');
end
hold off;
xlabel('频率 (Hz)');
ylabel('相对幅值 (dB)');
title('带通滤波器相对频率响应（归一化 dB）');
xlim([min(frequency), max(frequency)]);

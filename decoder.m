margin = floor(charRange/2);
range = [];

for i = 1:95
    range = [range (low + i*charRange - margin)];
end

fs = 44100;
bits = 16;
channels = 1;

recorder = audiorecorder(fs, bits, channels);
disp("3");
pause(1);
disp("2");
pause(1);
disp("1");
pause(1);
disp("PLAY");
recordblocking(recorder, 33)
y = getaudiodata(recorder);

sampleSize = pow2(floor(log2(chunkSize / 3))); % size of sample taken for each char
msg = [];
start = 1;
freqRes = fs / sampleSize;

for i = 1:floor(length(y)/chunkSize)
    chunk = y(start:start + sampleSize - 1);
    [~, index] = max(abs(fft(chunk)));
    freq = index * freqRes;

    % checks if freq found in message freq range
    for j = 2:length(range)
        if freq >= range(j - 1) && freq < range(j)
            msg = [msg char(j + 29)];
            break
        end
    end

    start = start + chunkSize;
end

disp(msg)

fname = 'decodedMessage.txt';
fid = fopen(fname,'w');
fprintf(fid,'%s', msg);
fclose(fid);


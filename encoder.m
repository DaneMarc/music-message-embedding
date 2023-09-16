fname = 'message_to_be_encoded.txt';
aname = 'source_music.wav';

high = 14000;
low = 10000;
minChunkSize = 2048;
charRange = floor((high - low)/95); % spacing between each char
alpha = 0.3;

fid = fopen(fname,'r');
msg = fgetl(fid);
ascii = double(msg);
fclose(fid);

[sig, fs] = audioread(aname);
filtered = lowpass(sig, 9000, fs);
chunkSize = floor(length(filtered) / length(ascii)); % length of each char signal
chunkSize = max(minChunkSize, chunkSize);

t = 0 : 1/fs : chunkSize/fs - 1/fs;
long = [];

for i = 1:length(ascii)
    index = ascii(i) - 31; % space (ascii 32) taken as index 1
    long = [long sin(2*pi*(low + index * charRange)*t)];
end

encoded = filtered(1:length(long)) + alpha * long;
encoded = [encoded filtered(length(long) + 1 : length(filtered))];

audiowrite("musicWithMessage.wav", encoded, fs)

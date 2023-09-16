A signal processing school project. Embeds a given message into the provided source audio which can then be decoded.

## Encoding
The program assigns a frequency to each character based on their ascii decimal representation. In this case, I decided not to use the whole table and only consider space (32) to '~' (126) which is 95 characters in total. To find the frequency we take the specified upper and lower bound frequencies that are assigned for the message and divide the available bandwidth accordingly to find out how much spacing is needed for each character. For this program, we’ll be using frequencies from 10 kHz to 14 kHz to carry signals containing the message.
The message is then read and each character is converted into its decimal ascii representation.
The frequency of each character is determined by multiplying the calculated margin with its ascii number and adding it to the lower bound frequency. All the generated sine waves are then combined sequentially into one new signal containing the message. This new signal is then added on to the base sound which is passed through a low pass filter to limit the higher range frequencies that might interfere with the message signal. After fiddling around, I found that using 9000 Hz as the passband frequency for the filter provided a good compromise between sound quality and decoding accuracy.
The length of each character sine wave is determined by dividing the length of the base sound by the number of characters in the message. This is the chunk size variable that will be passed on to the decoder script.

## Decoding
To decode the message, the program calculates the estimated frequency range of each character by padding the character’s frequency with the previously calculated margin. This ranges are then stored in an array in order of each character’s ascii number.
The program then calculates the sample size which is how big of a sample the program listens to for each chunk. Too big and it might overlap with the next chunk but too small and it might affect the accuracy of the frequencies collected. Again, after playing around, I set the sample size to a third of a chunk (character signal). I then rounded it down to its closest power of 2 to optimize fft performance.
The program then listens in on each chunk of the sampled music and checks to see if each sample it takes contains a frequency in one of the message frequency ranges. If it does, it takes the index of the range, normalizes it (adds 31 since space is at index 1) and converts it to a character which is then added to the message string. This normalization variable can be used to calibrate the decoder based on microphone characteristics. In my case, after some testing, I realised that my microphone was picking up frequencies approximately 100 Hz lower than expected. Thus, when adding to the index, I add 29 instead of 31 to make up for this behaviour.

### Example of decoded message
![image](https://github.com/DaneMarc/music-message-embedding/assets/22977105/3dcdfba9-c10b-4627-8746-12d7b15279f9)


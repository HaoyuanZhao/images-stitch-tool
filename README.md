# images-stitch-tool
This is a tiny tool to stitch images together using the combination of FAST and Harris detector  
Sample:  
Original images and the Stitched images:  
<img src="https://github.com/HaoyuanZhao/images-stitch-tool/blob/main/sample_images/original-sample.png" width="500">
<img src="https://github.com/HaoyuanZhao/images-stitch-tool/blob/main/sample_images/output_image.png" width="400">

# Development
Way to run: run the main.m in Matlab  
Please put your images in the input_images folder  
To change the threshold of FAST and Harris, please see the line 13 and line 19 in the main file

# About the code
This project used the combination of FAST and Harris dectector. In detail, it first apply the fast feature detection, then using the Harris cornerness metric to eliminate some weak FAST points. The performance of this combined dectector is not guaranteed, if the output images has an unacceptable result, please switch to the build-in detector in Matlab.

# License
MIT License

Copyright (c) 2021 Haoyuan

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

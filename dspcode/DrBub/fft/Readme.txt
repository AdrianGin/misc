***********************************
* Contents of the FFT directory:
***********************************
 readme.txt: to indicate the contents of the fft directory

 fftr2a.asm:  DIT fft macro
 fftr2aa.asm: DIT fft macro
 fftr2b.asm:  DIT fft macro (faster than fftr2a)
 fftr2bf.asm: DIT fft macro (block floating point)
 fftr2c.asm:  DIT fft macro (fast)
 fftr2cc.asm: DIT fft macro (fast)
 fftr2cn.asm: DIT fft macro (fast)
 fftr2d.asm:  DIT fft macro
 fftr2e.asm:  Non-In-Place fft
 fftr2en.asm: DIT fft macro fftr2d.asm:  DIT fft macro
 fftr2a_t.asm: test program for fftr2a, fftr2aa, fftr2b, fftr2bf, fftr2c, fftr2cc,
	      and fftr2e.asm
 fftr2cn_t.asm: test program for fftr2cn.asm and fftr2en.asm
 fftr2d_t.asm: test of fftr2d.asm

 dct1.asm:   discrete cosine transform
 dhit.asm:   discrete hilbert transform
 dhit_t.asm: test program for dhit.asm

 fftas.asm:   DIT fft macro (smallest code size)
 fftas_t.asm: test program for fftas.asm
 fftbf.asm:   DIT fft macro (smallest code size)
 fftbf_t.asm: test program fot fftbf.asm

 bitrev.asm:   convert bit reverse order to normal order in-place
 sincos.asm:   sine-cosine table generator
 sinewave.asm: full-cycle sinewave table generator
 siggen.asm:   input signal generator (for test programs use)
 outdata.asm:  output results from memory to file (for test programs use)
 outdata_bf.asm: output results from memory to file (for fftbf_t.asm use)

 rfft563b.asm: real input fft Glen Bergland algorithm

 C-T.FFT:
 cfft563.asm:  512-points non-in-place fft
 rfft563t.asm: test program 1024-points real input non-in-place fft 
 sincosr.asm:  sine-cosine table generator for rfft563t.asm
 split563.asm: split N/2 complex fft (Hn) for N real fft (Fn)

 fftr2a-hlp.txt: help file for fftr2a.asm
 fftr2b-hlp.txt: help file for fftr2b.asm
 fftr2bf-hlp.txt: help file for fftr2bf.asm
 fftr2c-hlp.txt: help file for fftr2c.asm
 fftr2cc-hlp.txt: help file for fftr2cc.asm
 fftr2cn-hlp.txt: help file for fftr2cn.asm
 fftr2d-hlp.txt: help file for fftr2d.asm
 fftr2e-hlp.txt: help file for fftr2e.asm
 fftr2en-hlp.txt: help file for fftr2en.asm
 fftr2at-hlp.txt: help file for fftr2at.asm, fftr2cnt.asm, fftr2dt.asm
 
 dhit-hlp.txt: help file for dhit.asm
 dct1-hlp.txt: help file for dct1.asm
 sincos-hlp.txt: help file for sincos.asm
 sinewave-hlp.txt: help file for sinewave.asm

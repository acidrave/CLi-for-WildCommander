        DEVICE ZXSPECTRUM128

			org #6000
;startCode

;			include "plug01.asm"
			include "cli.asm"

;endCode nop

	;DISPLAY "startCode is:",/A,startCode
	;DISPLAY "endCode is:",/A,endCode
	;DISPLAY "len is:",/A,endCode-startCode
	;DISPLAY "code size (bytes):",/A,(pluginEnd - pluginStart)
	;DISPLAY "code size (blocks):",/A,(pluginEnd - pluginStart) / 512 + 1
	;DISPLAY "iBuffer addr:",/A,iBuffer
	;DISPLAY "sleepSeconds addr:",/A,sleepSeconds
	;DISPLAY "echoString addr:",/A,echoString
	;DISPLAY "enterKey addr:",/A,enterKey
	;DISPLAY "cliHistory addr:",/A,cliHistory
	;DISPLAY "upKey addr:",/A,upKey
	;DISPLAY "leftKey addr:",/A,leftKey
	DISPLAY "callFromExt addr:",/A,callFromExt

	SAVEBIN "../bin/CLI.WMF", startCode, endCode-startCode
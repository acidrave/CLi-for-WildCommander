;---------------------------------------; Code by Budder^MGN;---------------------------------------BSZ     EQU #7F-24CLN     EQU 30MIN_PAG EQU 1+128;MAX_PAG EQU 9+128; 128KB buffer;-------PR_POZ  ;i:  A - action type;          #00 - clear poz (like cls);          #01 - move up;          #02 - move down;          #03 - go to buffer start;          #04 - go to buffer end        OR A:JR Z,POZ_CLS        DEC A:JR Z,POZ_UP        DEC A:JR Z,POZ_DN        DEC A:JR Z,POZ_ST        DEC A:JR Z,POZ_ED        RETPOZ_CLS LD A,(CLN_PG),(WW_PG),A        LD HL,(CLN_OF),(WW_OFF),HL        LD A,CLN,(WW_DA),A        RETPOZ_UP  LD A,(WW_PG)        LD HL,(WW_OFF)        CALL PRV_LNR        CALL SUP:RET NZ        LD E,A        CALL WW_DT:RET NZ        LD A,E        LD (WW_PG),A        LD (WW_OFF),HL        RETPOZ_DN  LD A,(WW_PG)        LD HL,(WW_OFF)        CALL SDN:RET NZ        CALL NXT_LNR        LD (WW_PG),A        LD (WW_OFF),HL        RETPOZ_ST  CALL SHM:RET C        LD A,1,(WW_DA),A        LD HL,(BR_OFF)        LD A,(BR_PG)        CALL NXT_LNR        LD (WW_PG),A        LD (WW_OFF),HL        RETPOZ_ED  LD A,(WW_DA):DEC A:RET NZ        LD HL,(CLN_OF),(WW_OFF),HL        LD A,(CLN_PG),(WW_PG),A        RETSUP     LD DE,(CLN_CT)        INC D:DEC D:JR NZ,ZUP        LD D,A        LD A,E:CP CLN:JR C,SNN        LD A,DZUP     LD DE,(BR_PG)        CP E:JR NZ,SPP        LD DE,(BR_OFF)        OR A:SBC HL,DE:JR Z,SNN        ADD HL,DESPP     CP A        RETSNN     LD A,1:OR A        RETSDN     LD E,A        LD A,(WW_DA):DEC A:RET NZ        LD A,E        LD DE,(CLN_PG)        CP E:JR NZ,SPP        LD DE,(CLN_OF)        OR A:SBC HL,DE:JR Z,SNN        ADD HL,DE        JR SPPSHM     LD HL,(CLN_CT)        LD DE,CLN        OR A:SBC HL,DE        RET;-------PRINTWW ;i:no inputs        LD A,#FF:CALL DMAPL;Waiting DMA        LD A,#05,B,#00:CALL DMAPL        LD A,#06,B,BSZ:CALL DMAPLWWDATA  LD BC,(WW_DA),A,30:SUB C        LD B,A,C,B        LD HL,(WW_OFF)        LD A,(WW_PG):JR Z,A440WWD     CALL PRV_LNR        DJNZ WWD  A440    LD B,C:INC B        LD DE,0WWDTA   PUSH BC        PUSH DE        PUSH HL,AF        LD B,A        CALL PR_STR        POP AF,HL        CALL NXT_LNR        POP DE        EX DE,HL        LD BC,256:ADD HL,BC        EX DE,HL        POP BC:DJNZ WWDTA        LD A,(WW_DA)BKK     DEC A:RET Z        PUSH AF        LD HL,30*256        LD B,0;Screen page        PUSH DE:CALL PR_STR        POP HL        LD BC,256:ADD HL,BC:EX DE,HL        POP AF        JR BKKWW_UPD  LD HL,(CLN_OF),(WW_OFF),HL        LD A,(CLN_PG),(WW_PG),A        LD HL,(CLN_CT):INC HL        LD B,H,A,L        DUP 6        SRL B:RRA        EDUP        CP MAX_PAG-MIN_PAG        JR C,WW_TT        LD A,(BR_PG)        LD HL,(BR_OFF)        CALL NXT_LNR        LD (BR_PG),A        LD (BR_OFF),HL        JR WW_DTWW_TT   LD (CLN_CT),HLWW_DT   LD A,(WW_DA)        DEC A:RET Z        LD (WW_DA),A        RETPR_STR  ;i:HL - TXT Offset;           B - TXT Page;          DE - Address in Screen;               (#0000-#3F00)        PUSH DE:LD A,#01:CALL DMAPL        POP DE        LD C,#00        LD A,#02:CALL DMAPL        LD A,#FE:CALL DMAPL        RET;-------UPD     LD A,C:OR A:JP Z,DMACOPY        LD B,C        EX DE,HL        LD A,(CLN_PG)        LD HL,(CLN_OF)        PUSH HL,AF        PUSH DE        CALL PRV_LNR:DJNZ $-3        LD (CLN_OF),HL        LD (CLN_PG),A        POP HL:CALL DMACOPY        POP AF,HL        LD (CLN_OF),HL        LD (CLN_PG),A        RET       BUF_UPD ;i:HL - Buffer with STRING(256);           A: #00 - add sting;                    (no inputs);              #01 - upd string;                    (BC - delta)        OR A:JR NZ,UPD		        CALL DMACOPY        CALL NXT_LN        JP WW_UPD		DMACOPY LD A,H,BC,#0040        SUB C:JR C,WW:INC B        SUB C:JR C,WW:INC B        SUB C:JR C,WW:INC BWW      ADD A,C:LD H,A        LD A,#03:CALL DMAPL        ;LD A,#05,B,#00:CALL DMAPL        ;LD A,#06,B,#7F:CALL DMAPL        LD A,#05,B,#00:CALL DMAPL        LD A,#06,B,BSZ:CALL DMAPL        LD BC,(CLN_PG),DE,(CLN_OF)        LD A,#02:CALL DMAPL        LD A,#FF:CALL DMAPL;Waiting DMA        LD A,#FE:JP DMAPLNXT_LN  LD HL,(CLN_OF)        LD DE,256:ADD HL,DE        LD A,H:SUB #40:JR NC,NXTPG        LD (CLN_OF),HL        RETNXTPG   LD H,A,(CLN_OF),HL        LD A,(CLN_PG):INC A        CP MAX_PAG:JR C,$+4:LD A,MIN_PAG        LD (CLN_PG),A        RETPRV_LNR LD DE,256        OR A:SBC HL,DE:RET NC        LD E,A        LD A,H:AND %00111111:LD H,A        LD A,E        DEC A        CP MIN_PAG:RET NC        LD A,MAX_PAG-1        RETNXT_LNR LD DE,256:ADD HL,DE        LD E,A        LD A,H:SUB #40:JR C,NLNR        LD H,A        LD A,E:INC A        CP MAX_PAG:JR C,$+4:LD A,MIN_PAG        RETNLNR    LD A,E        RET;---------------------------------------CLN_PG  DB MIN_PAG;      PageCLN_OF  DW #0000;0-#3FFF;OffsetCLN_CT  DW 0;            CountBR_PG   DB MIN_PAGBR_OFF  DW #0000+28*256WW_PG   DB MIN_PAGWW_OFF  DW #0000WW_DA   DB CLN;delta;---------------------------------------
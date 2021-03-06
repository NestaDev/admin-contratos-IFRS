SELECT
'NESTA - RESUMO CONT?BIL - '+Convert(Char(10), @DATA_SALDO_ANTERIOR,103)+' a '+Convert(varchar(10),@DATA_SALDO_ATUAL ,103)
+' horas@ '+CAST(CONVERT(VARCHAR(50),sysdatetime()) AS CHAR(16))  "Emiss?o",
 TV.TVDSESTR "Empresa", CAST(OP.OPIDCONT AS VARCHAR(50)) "ID Interno",
CAST(PRD.CHIDCODI AS VARCHAR(50)) "Component",
CT.CADSAB20 "Carteira",
FO.FONMFORN "Banco", 
OP.OPNMCONT "Descri??o",
OP.OPCDAUXI "N? do Contrato",
PRD.PRPRODES "Produto",
dbo.FUNC_CJTPCTTX(OP.OPIDCONT,'Data Libera??o',GETDATE())  "Data Libera??o",
dbo.FUNC_CJTPCTTX(OP.OPIDCONT,'Data Encerramento',GETDATE()) "Data Encerramento",
IND.IESGINEC "Moeda",
OT.OPTPTPDS "Tipo",
ROUND(OP.OPVLCONT,2) "Valor Contrato (Moeda)" ,
 
(select (SUM(ROUND(RZ.RZVLPRIN,2)))
        FROM rzrazctb rz
        where rz.opidcont = OP.OPIDCONT
          and rz.rzdtdata = convert(datetime,@DATA_SALDO_ATUAL,103)
          AND RZ.RZNRREGI = (SELECT MAX(R1.RZNRREGI)
                             FROM RZRAZCTB R1 WHERE RZ.OPIDCONT = R1.OPIDCONT
                                                AND R1.OPIDCONT = OP.OPIDCONT
                                                AND R1.rzdtdata = convert(datetime,@DATA_SALDO_ATUAL,103)))  "Saldo Ativo", 
       (select (SUM(ROUND(RZ.RZVLSALD,2)))
        FROM rzrazctb rz
        where rz.opidcont = OP.OPIDCONT
          and rz.rzdtdata = convert(datetime,@DATA_SALDO_ATUAL,103)
          AND RZ.RZNRREGI = (SELECT MAX(R1.RZNRREGI)
                             FROM RZRAZCTB R1 WHERE RZ.OPIDCONT = R1.OPIDCONT
                                                AND R1.OPIDCONT = OP.OPIDCONT
                                                AND R1.rzdtdata = convert(datetime,@DATA_SALDO_ATUAL,103)))  "Saldo Passivo",
 
 ((select (SUM(ROUND(RZ.RZVLSALD,2)))
        FROM rzrazctb rz
        where rz.opidcont = OP.OPIDCONT
          and rz.rzdtdata = convert(datetime,@DATA_SALDO_ATUAL,103)
          AND RZ.RZNRREGI = (SELECT MAX(R1.RZNRREGI)
                             FROM RZRAZCTB R1 WHERE RZ.OPIDCONT = R1.OPIDCONT
                                                AND R1.OPIDCONT = OP.OPIDCONT
                                                AND R1.rzdtdata = convert(datetime,@DATA_SALDO_ATUAL,103))) -
												
		(select (SUM(ROUND(RZ.RZVLPRIN,2)))
        FROM rzrazctb rz
        where rz.opidcont = OP.OPIDCONT
          and rz.rzdtdata = convert(datetime,@DATA_SALDO_ATUAL,103)
          AND RZ.RZNRREGI = (SELECT MAX(R1.RZNRREGI)
                             FROM RZRAZCTB R1 WHERE RZ.OPIDCONT = R1.OPIDCONT
                                                AND R1.OPIDCONT = OP.OPIDCONT
                                                AND R1.rzdtdata = convert(datetime,@DATA_SALDO_ATUAL,103))))
        "Encargos",

        (select (SUM(ROUND(RZ.RZVLDEBI,2))-SUM(ROUND(RZ.RZVLCRED,2)))
         FROM rzrazctb rz
         where rz.opidcont = OP.OPIDCONT
           AND RZ.MOIDMODA = 18
           AND (RZ.RZDTDATA BETWEEN convert(datetime,@DATA_SALDO_ANTERIOR,103)+1 AND
convert(datetime,@DATA_SALDO_ATUAL,103)))
        "Transf Prin LC",
 
((select (SUM(ROUND(RZ.RZVLPRIN,2)))
        FROM rzrazctb rz
        where rz.opidcont = OP.OPIDCONT
          and rz.rzdtdata = convert(datetime,@DATA_SALDO_ATUAL,103)
          AND RZ.RZNRREGI = (SELECT MAX(R1.RZNRREGI)
                             FROM RZRAZCTB R1 WHERE RZ.OPIDCONT = R1.OPIDCONT
                                                AND R1.OPIDCONT = OP.OPIDCONT
                                                AND R1.rzdtdata = convert(datetime,@DATA_SALDO_ATUAL,103))) -
(ROUND(OP.OPVLCONT,2) *
(select TOP 1 RZ.RZVLCOTA 
         FROM rzrazctb rz
         where rz.opidcont = OP.OPIDCONT
           AND RZ.MOIDMODA = 1
          ))) *                                            
((SELECT  (Sum(ROUND(T1.APVLAPIO,2)  * CASE WHEN T1.IEIDINEC IN(6) THEN 1 ELSE
dbo.FUNC_BUSCA_COTA(T1.IEIDINEC, convert(datetime,@DATA_SALDO_ATUAL,103)) END ))
FROM APRAPRGT T1
WHERE T1.OPIDCONT = OP.OPIDCONT
      AND T1.MOIDMODA in( 6)
      AND T1.APDTPGTO > convert(datetime,@DATA_SALDO_ATUAL,103)
      AND (T1.APDTPGTO - convert(datetime,convert(datetime,@DATA_SALDO_ATUAL,103),103)) <= 365) /      
(select (SUM(ROUND(RZ.RZVLPRIN,2)))
        FROM rzrazctb rz
        where rz.opidcont = OP.OPIDCONT
          and rz.rzdtdata = convert(datetime,@DATA_SALDO_ATUAL,103)
          AND RZ.RZNRREGI = (SELECT MAX(R1.RZNRREGI)
                             FROM RZRAZCTB R1 WHERE RZ.OPIDCONT = R1.OPIDCONT
                                                AND R1.OPIDCONT = OP.OPIDCONT
                                                AND R1.rzdtdata = convert(datetime,@DATA_SALDO_ATUAL,103)))) 
"Transf Prin LC Var",

   (select (SUM(ROUND(RZ.RZVLDEBI,2))-SUM(ROUND(RZ.RZVLCRED,2)))
         FROM rzrazctb rz
         where rz.opidcont = OP.OPIDCONT
           AND RZ.MOIDMODA in(593)
           AND (RZ.RZDTDATA BETWEEN convert(datetime,@DATA_SALDO_ANTERIOR,103)+1 AND
convert(datetime,@DATA_SALDO_ATUAL,103)))
        "Bens Intang?veis",

   (select (SUM(ROUND(RZ.RZVLDEBI,2))-SUM(ROUND(RZ.RZVLCRED,2)))
         FROM rzrazctb rz
         where rz.opidcont = OP.OPIDCONT
           AND RZ.MOIDMODA in(588)
           AND (RZ.RZDTDATA BETWEEN convert(datetime,@DATA_SALDO_ANTERIOR,103)+1 AND
convert(datetime,@DATA_SALDO_ATUAL,103)))
        "Estorno Bens Intang?veis", 

   (select (SUM(ROUND(RZ.RZVLDEBI,2))-SUM(ROUND(RZ.RZVLCRED,2)))
         FROM rzrazctb rz
         where rz.opidcont = OP.OPIDCONT
           AND RZ.MOIDMODA in(680)
           AND (RZ.RZDTDATA BETWEEN convert(datetime,@DATA_SALDO_ANTERIOR,103)+1 AND
convert(datetime,@DATA_SALDO_ATUAL,103)))
        "Remensura??o",
 
   ((select (SUM(ROUND(RZ.RZVLDEBI,2))-SUM(ROUND(RZ.RZVLCRED,2)))
         FROM rzrazctb rz
         where rz.opidcont = OP.OPIDCONT
           AND RZ.MOIDMODA in(593)
           AND (RZ.RZDTDATA BETWEEN convert(datetime,@DATA_SALDO_ANTERIOR,103)+1 AND
convert(datetime,@DATA_SALDO_ATUAL,103)))*7.60)/100
        "Ativo Potencial PC COFINS",

   ((select (SUM(ROUND(RZ.RZVLDEBI,2))-SUM(ROUND(RZ.RZVLCRED,2)))
         FROM rzrazctb rz
         where rz.opidcont = OP.OPIDCONT
           AND RZ.MOIDMODA in(593)
           AND (RZ.RZDTDATA BETWEEN convert(datetime,@DATA_SALDO_ANTERIOR,103)+1 AND
convert(datetime,@DATA_SALDO_ATUAL,103)))*1.65)/100
        "Ativo Potencial PC PIS",

   ((select (SUM(ROUND(RZ.RZVLDEBI,2))-SUM(ROUND(RZ.RZVLCRED,2)))
         FROM rzrazctb rz
         where rz.opidcont = OP.OPIDCONT
           AND RZ.MOIDMODA in(680)
           AND (RZ.RZDTDATA BETWEEN convert(datetime,@DATA_SALDO_ANTERIOR,103)+1 AND
convert(datetime,@DATA_SALDO_ATUAL,103)))*7.60)/100
        "AP Remensura??o COFINS",

   ((select (SUM(ROUND(RZ.RZVLDEBI,2))-SUM(ROUND(RZ.RZVLCRED,2)))
         FROM rzrazctb rz
         where rz.opidcont = OP.OPIDCONT
           AND RZ.MOIDMODA in(680)
           AND (RZ.RZDTDATA BETWEEN convert(datetime,@DATA_SALDO_ANTERIOR,103)+1 AND
convert(datetime,@DATA_SALDO_ATUAL,103)))*1.65)/100
        "AP Remensura??o PIS",

        ((select (SUM(ROUND(RZ.RZVLDEBI,2))-SUM(ROUND(RZ.RZVLCRED,2)))
         FROM rzrazctb rz
         where rz.opidcont = OP.OPIDCONT
           AND RZ.MOIDMODA in (597)
           AND (RZ.RZDTDATA BETWEEN convert(datetime,@DATA_SALDO_ANTERIOR,103)+1 AND
convert(datetime,@DATA_SALDO_ATUAL,103)))*7.60)/100
        "Ajuste Deprecia??o COFINS",

        ((select (SUM(ROUND(RZ.RZVLDEBI,2))-SUM(ROUND(RZ.RZVLCRED,2)))
         FROM rzrazctb rz
         where rz.opidcont = OP.OPIDCONT
           AND RZ.MOIDMODA in (597)
           AND (RZ.RZDTDATA BETWEEN convert(datetime,@DATA_SALDO_ANTERIOR,103)+1 AND
convert(datetime,@DATA_SALDO_ATUAL,103)))*1.65)/100
        "Ajuste Deprecia??o PIS",

        (select (SUM(ROUND(RZ.RZVLDEBI,2))-SUM(ROUND(RZ.RZVLCRED,2)))
         FROM rzrazctb rz
         where rz.opidcont = OP.OPIDCONT
           AND RZ.MOIDMODA IN (39,71,41)
           AND (RZ.RZDTDATA BETWEEN convert(datetime,@DATA_SALDO_ANTERIOR,103)+1 AND
convert(datetime,@DATA_SALDO_ATUAL,103)))
        "Corr Monet Prin CP",
 
        (select (SUM(ROUND(RZ.RZVLDEBI,2))-SUM(ROUND(RZ.RZVLCRED,2)))
         FROM rzrazctb rz
         where rz.opidcont = OP.OPIDCONT
           AND RZ.MOIDMODA in(40,42)
           AND (RZ.RZDTDATA BETWEEN convert(datetime,@DATA_SALDO_ANTERIOR,103)+1 AND
convert(datetime,@DATA_SALDO_ATUAL,103)))
        "Corr Monet Prin LP",
 
        (select (SUM(ROUND(RZ.RZVLDEBI,2))-SUM(ROUND(RZ.RZVLCRED,2)))
         FROM rzrazctb rz
         where rz.opidcont = OP.OPIDCONT
           AND RZ.MOIDMODA in (596, 603, 45, 598, 261)
           AND (RZ.RZDTDATA BETWEEN convert(datetime,@DATA_SALDO_ANTERIOR,103)+1 AND
convert(datetime,@DATA_SALDO_ATUAL,103)))
        "Prov Juros CP",
 
        (select (SUM(ROUND(RZ.RZVLDEBI,2))-SUM(ROUND(RZ.RZVLCRED,2)))
         FROM rzrazctb rz
         where rz.opidcont = OP.OPIDCONT
           AND RZ.MOIDMODA IN(4,5,706,48)
           AND (RZ.RZDTDATA BETWEEN convert(datetime,@DATA_SALDO_ANTERIOR,103)+1 AND
convert(datetime,@DATA_SALDO_ATUAL,103)))
         "Prov Comis/Taxas CP",

        (select (SUM(ROUND(RZ.RZVLDEBI,2))-SUM(ROUND(RZ.RZVLCRED,2)))
         FROM rzrazctb rz
         where rz.opidcont = OP.OPIDCONT
           AND RZ.MOIDMODA in(594,595)
           AND (RZ.RZDTDATA BETWEEN convert(datetime,@DATA_SALDO_ANTERIOR,103)+1 AND
convert(datetime,@DATA_SALDO_ATUAL,103)))
         "Pagto Parcela",
        (select (SUM(ROUND(RZ.RZVLDEBI,2))-SUM(ROUND(RZ.RZVLCRED,2)))
         FROM rzrazctb rz
         where rz.opidcont = OP.OPIDCONT
           AND RZ.MOIDMODA in (599)
           AND (RZ.RZDTDATA BETWEEN convert(datetime,@DATA_SALDO_ANTERIOR,103)+1 AND
convert(datetime,@DATA_SALDO_ATUAL,103)))
        "Recupera??o PIS",

        (select (SUM(ROUND(RZ.RZVLDEBI,2))-SUM(ROUND(RZ.RZVLCRED,2)))
         FROM rzrazctb rz
         where rz.opidcont = OP.OPIDCONT
           AND RZ.MOIDMODA in (600)
           AND (RZ.RZDTDATA BETWEEN convert(datetime,@DATA_SALDO_ANTERIOR,103)+1 AND
convert(datetime,@DATA_SALDO_ATUAL,103)))
        "Recupera??o COFINS", 

        (select (SUM(ROUND(RZ.RZVLDEBI,2))-SUM(ROUND(RZ.RZVLCRED,2)))
         FROM rzrazctb rz
         where rz.opidcont = OP.OPIDCONT
           AND RZ.MOIDMODA in (597)
           AND (RZ.RZDTDATA BETWEEN convert(datetime,@DATA_SALDO_ANTERIOR,103)+1 AND
convert(datetime,@DATA_SALDO_ATUAL,103)))
        "Deprecia??o Bens",

        -- Var Cambial Prin CP
        (
          -- Var Cambial Ativa Principal
         ISNULL( (select (SUM(ROUND(RZ.RZVLDEBI,2))-SUM(ROUND(RZ.RZVLCRED,2)))
           FROM rzrazctb rz
           where rz.opidcont = OP.OPIDCONT
             AND RZ.MOIDMODA in (639)
             AND (RZ.RZDTDATA BETWEEN convert(datetime,@DATA_SALDO_ANTERIOR,103)+1 AND
convert(datetime,@DATA_SALDO_ATUAL,103))),0)+
          -- Var Cambial Passiva CP
          ISNULL((select (SUM(ROUND(RZ.RZVLDEBI,2))-SUM(ROUND(RZ.RZVLCRED,2)))
           FROM rzrazctb rz
           where rz.opidcont = OP.OPIDCONT
             AND RZ.MOIDMODA in (641)
             AND (RZ.RZDTDATA BETWEEN convert(datetime,@DATA_SALDO_ANTERIOR,103)+1 AND
convert(datetime,@DATA_SALDO_ATUAL,103))),0) ) "Var Camb Prin CP",
        -- Var Cambial Prin LP
          -- Var Cambial Ativa Principal
         ( 
ISNULL((select (SUM(ROUND(RZ.RZVLDEBI,2))-SUM(ROUND(RZ.RZVLCRED,2)))
           FROM rzrazctb rz
           where rz.opidcont = OP.OPIDCONT
             AND RZ.MOIDMODA in (640)
             AND (RZ.RZDTDATA BETWEEN convert(datetime,@DATA_SALDO_ANTERIOR,103)+1 AND
convert(datetime,@DATA_SALDO_ATUAL,103))),0) +
          -- Var Cambial Passiva LP
          ISNULL((select (SUM(ROUND(RZ.RZVLDEBI,2))-SUM(ROUND(RZ.RZVLCRED,2)))
           FROM rzrazctb rz
           where rz.opidcont = OP.OPIDCONT
             AND RZ.MOIDMODA in (642)
             AND (RZ.RZDTDATA BETWEEN convert(datetime,@DATA_SALDO_ANTERIOR,103)+1 AND
convert(datetime,@DATA_SALDO_ATUAL,103))),0)
        ) "Var Camb Prin LP",
        -- Var Cambial Juros/Com
        (
          -- Varia??o Cambiam Ativa
         ISNULL( (select (SUM(ROUND(RZ.RZVLDEBI,2))-SUM(ROUND(RZ.RZVLCRED,2)))
           FROM rzrazctb rz
           where rz.opidcont = OP.OPIDCONT
             AND RZ.MOIDMODA in (24,25, 26, 96, 97, 98)
             AND (RZ.RZDTDATA BETWEEN convert(datetime,@DATA_SALDO_ANTERIOR,103)+1 AND
convert(datetime,@DATA_SALDO_ATUAL,103))),0) +
          -- Varia??o Cambial Passiva
          ISNULL((select (SUM(ROUND(RZ.RZVLDEBI,2))-SUM(ROUND(RZ.RZVLCRED,2)))
           FROM rzrazctb rz
           where rz.opidcont = OP.OPIDCONT
             AND RZ.MOIDMODA in (106, 107, 108, 290, 291, 292)
             AND (RZ.RZDTDATA BETWEEN convert(datetime,@DATA_SALDO_ANTERIOR,103)+1 AND
convert(datetime,@DATA_SALDO_ATUAL,103))),0) 
         ) "Var Camb Juros/Com/Taxas",
        (select (SUM(ROUND(RZ.RZVLDEBI,2))-SUM(ROUND(RZ.RZVLCRED,2)))
         FROM rzrazctb rz
         where rz.opidcont = OP.OPIDCONT
           AND RZ.MOIDMODA in (801,802,803,804)
           AND (RZ.RZDTDATA BETWEEN  dateadd(day,1,convert(datetime,@DATA_SALDO_ANTERIOR,103)) AND
convert(datetime,@DATA_SALDO_ATUAL,103)))
        "Ajustes" ,
(SELECT  (Sum(ROUND(T1.PHVLIPRE,2))) 
FROM PHPLANIF T1
WHERE T1.OPIDCONT = OP.OPIDCONT
      AND T1.PHDTEVEN >= convert(datetime,@DATA_SALDO_ATUAL,103)
      AND (T1.PHDTEVEN - convert(datetime,convert(datetime,@DATA_SALDO_ATUAL,103),103)) <= 365) "Encargos CP",
 
(SELECT  (Sum(ROUND(T1.PHVLIPRE,2)))
FROM PHPLANIF T1
WHERE T1.OPIDCONT = OP.OPIDCONT
      AND T1.PHDTEVEN >= convert(datetime,@DATA_SALDO_ATUAL,103)
      AND (T1.PHDTEVEN - convert(datetime,convert(datetime,@DATA_SALDO_ATUAL,103),103)) >= 366) "Encargos LP",

(SELECT  (Sum(ROUND(T1.PHVLTOTA,2))) 
FROM PHPLANIF T1
WHERE T1.OPIDCONT = OP.OPIDCONT
      AND T1.PHDTEVEN >= convert(datetime,@DATA_SALDO_ATUAL,103)
      AND (T1.PHDTEVEN - convert(datetime,convert(datetime,@DATA_SALDO_ATUAL,103),103)) <= 365) "Passivo CP",
 
(SELECT  (Sum(ROUND(T1.PHVLTOTA,2)))
FROM PHPLANIF T1
WHERE T1.OPIDCONT = OP.OPIDCONT
      AND T1.PHDTEVEN >= convert(datetime,@DATA_SALDO_ATUAL,103)
      AND (T1.PHDTEVEN - convert(datetime,convert(datetime,@DATA_SALDO_ATUAL,103),103)) >= 366) "Passivo LP",

(SELECT  (Sum(ROUND(T1.PHVLTOTA,2)))
FROM PHPLANIF T1
WHERE T1.OPIDCONT = OP.OPIDCONT
      AND T1.PHDTEVEN < convert(datetime,@DATA_SALDO_ATUAL,103)) "Contrapresta??o"
         
FROM OPCONTRA OP, FOFORNEC FO, CACTEIRA CT, PRPRODUT PRD, IEINDECO IND, 
TVESTRUT TV, OPTPTIPO OT
WHERE OP.TVIDESTR = @Empresa
  AND OP.TVIDESTR = TV.TVIDESTR
  AND OP.FOIDFORN  = FO.FOIDFORN
  AND OP.CAIDCTRA = CT.CAIDCTRA
  AND OP.PRPRODID = PRD.PRPRODID
  AND IND.IEIDINEC = PRD.IEIDINEC
  AND PRD.CMTPIDCM = 8
  AND PRD.CMTPIDCM = OT.CMTPIDCM
  AND OP.OPTPTPID = OT.OPTPTPID
  AND OT.PAIDPAIS = 1
  AND OP.OPTPTPID <> 4  
  AND PRD.PRTPIDOP IN(1,17)

create or replace PROCEDURE POS_INS
(v_poziciq POZICIQ.poziciq%TYPE,
v_zaplata POZICIQ.zaplata%TYPE)
AS
 BEGIN
 INSERT INTO POZICIQ(poziciq, zaplata)
 Values (v_poziciq, v_zaplata);
END;
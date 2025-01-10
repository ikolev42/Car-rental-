--1
SELECT
    v.vid,
    z.data_na_zaemane,
    a.godina,
    a.izminati_km,
    a.cena_na_den,
    c.cvqt,
    m.marka,
    mo.model,
    s.ime AS slujitel_ime,
    k.ime AS klient_ime
FROM
    zaemane_pod_naem z
JOIN
    avtomobil a ON z.id_avtomobil = a.id_avtomobil
JOIN
    vid v ON a.id_vid = v.id_vid
JOIN
    slujitel s ON z.id_slujitel = s.id_slujitel
JOIN
    klient k ON z.id_klient = k.id_klient
JOIN
    cvqt c ON a.id_cvqt = c.id_cvqt
JOIN
    modell mo ON a.id_model = mo.id_model
JOIN
    marka m ON mo.id_marka = m.id_marka
ORDER BY
    v.vid,
    z.data_na_zaemane;
    
--2    
SELECT
    vid,
    data_na_zaemane,
    godina,
    izminati_km,
    cena_na_den,
    cvqt,
    marka,
    model,
    slujitel_ime,
    klient_ime
FROM (
    SELECT
        v.vid,
        z.data_na_zaemane,
        a.godina,
        a.izminati_km,
        a.cena_na_den,
        c.cvqt,
        m.marka,
        mo.model,
        s.ime AS slujitel_ime,
        k.ime AS klient_ime,
        ROW_NUMBER() OVER (ORDER BY z.data_na_zaemane DESC) AS rnum
    FROM
        zaemane_pod_naem z
    JOIN
        avtomobil a ON z.id_avtomobil = a.id_avtomobil
    JOIN
        vid v ON a.id_vid = v.id_vid
    JOIN
        slujitel s ON z.id_slujitel = s.id_slujitel
    JOIN
        klient k ON z.id_klient = k.id_klient
    JOIN
        cvqt c ON a.id_cvqt = c.id_cvqt
    JOIN
        modell mo ON a.id_model = mo.id_model
    JOIN
        marka m ON mo.id_marka = m.id_marka
    ORDER BY
        z.data_na_zaemane DESC
)
WHERE rnum <= 10;

--3

ACCEPT klient_ime CHAR PROMPT 'Въведете част от името на клиента: ';

SELECT
    z.data_na_zaemane,
    k.ime AS klient_ime,
    mo.model,
    m.marka,
    a.godina,
    a.izminati_km,
    a.cena_na_den,
    c.cvqt,
    s.ime AS slujitel_ime
FROM
    zaemane_pod_naem z
JOIN
    avtomobil a ON z.id_avtomobil = a.id_avtomobil
JOIN
    klient k ON z.id_klient = k.id_klient
JOIN
    slujitel s ON z.id_slujitel = s.id_slujitel
JOIN
    cvqt c ON a.id_cvqt = c.id_cvqt
JOIN
    modell mo ON a.id_model = mo.id_model
JOIN
    marka m ON mo.id_marka = m.id_marka
WHERE
    k.ime LIKE '%' || '&klient_ime' || '%'
ORDER BY
    z.data_na_zaemane;
    
    
--4
SELECT
    k.ime AS klient_ime,
    z.data_na_zaemane,
    z.broi_dni,
    mo.model,
    m.marka,
    a.godina,
    a.izminati_km,
    a.cena_na_den,
    c.cvqt,
    s.ime AS slujitel_ime
FROM
    zaemane_pod_naem z
JOIN
    avtomobil a ON z.id_avtomobil = a.id_avtomobil
JOIN
    klient k ON z.id_klient = k.id_klient
JOIN
    slujitel s ON z.id_slujitel = s.id_slujitel
JOIN
    cvqt c ON a.id_cvqt = c.id_cvqt
JOIN
    modell mo ON a.id_model = mo.id_model
JOIN
    marka m ON mo.id_marka = m.id_marka
WHERE
    z.data_na_zaemane BETWEEN TO_DATE('&начална_дата', 'DD-MM-RR') AND TO_DATE('&крайна_дата', 'DD-MM-RR')
ORDER BY
    k.ime,
    z.data_na_zaemane; 
--spravka 1--
CREATE OR REPLACE PROCEDURE spr_Empl_pos(V_POS_NAME slujitel.poziciq%TYPE) IS
BEGIN
    DBMS_OUTPUT.PUT_LINE('Employees with ' || V_POS_NAME || ' position');
    
    FOR EMP_RECORD IN (
        SELECT s.ime AS slujitel_ime
        FROM slujitel s
        JOIN poziciq p ON s.id_poziciq = p.id_poziciq
        WHERE p.poziciq = V_POS_NAME
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE(EMP_RECORD.slujitel_ime);
    END LOOP;
END spr_Empl_pos;

BEGIN
    FIND_EMPLOYEE('John');
END;
--spravka 2--
CREATE OR REPLACE PROCEDURE FIND_EMPLOYEE(KEYWORDS VARCHAR2) IS
    KEYWORDS_new VARCHAR2(500);
BEGIN
    KEYWORDS_new := '%' || KEYWORDS || '%';
    DBMS_OUTPUT.PUT_LINE('Employees whose name contains ' || KEYWORDS);

    FOR EMP_RECORD IN (
        SELECT s.ime AS slujitel_ime, p.poziciq
        FROM slujitel s
        JOIN poziciq p ON s.id_poziciq = p.id_poziciq
        WHERE s.ime LIKE KEYWORDS_new
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE(EMP_RECORD.slujitel_ime || ' ' || EMP_RECORD.poziciq);
    END LOOP;
END FIND_EMPLOYEE;

BEGIN
    FIND_EMPLOYEE('John');
END;

--KUROSR 1
CREATE OR REPLACE PROCEDURE DisplayZaemaneRecords IS
    CURSOR zaemane_cursor IS
        SELECT
            v.vid,
            z.data_na_zaemane,
            a.godina,
            a.izminati_km,
            a.cena_na_den,
            c.cvqt,
            m.marka,
            mo.model,
            s.ime AS slujitel_ime,
            k.ime AS klient_ime
        FROM
            zaemane_pod_naem z
        JOIN
            avtomobil a ON z.id_avtomobil = a.id_avtomobil
        JOIN
            vid v ON a.id_vid = v.id_vid
        JOIN
            slujitel s ON z.id_slujitel = s.id_slujitel
        JOIN
            klient k ON z.id_klient = k.id_klient
        JOIN
            cvqt c ON a.id_cvqt = c.id_cvqt
        JOIN
            modell mo ON a.id_model = mo.id_model
        JOIN
            marka m ON mo.id_marka = m.id_marka
        ORDER BY
            v.vid,
            z.data_na_zaemane;

BEGIN
    FOR zaemane_rec IN zaemane_cursor LOOP
        DBMS_OUTPUT.PUT_LINE(
            zaemane_rec.vid || ', ' ||
            zaemane_rec.data_na_zaemane || ', ' ||
            zaemane_rec.godina || ', ' ||
            zaemane_rec.izminati_km || ', ' ||
            zaemane_rec.cena_na_den || ', ' ||
            zaemane_rec.cvqt || ', ' ||
            zaemane_rec.marka || ', ' ||
            zaemane_rec.model || ', ' ||
            zaemane_rec.slujitel_ime || ', ' ||
            zaemane_rec.klient_ime
        );
    END LOOP;
END DisplayZaemaneRecords;

EXEC DisplayZaemaneRecords;

--2 cursor
CREATE OR REPLACE PROCEDURE DisplayTopZaemaneRecords IS
    CURSOR zaemane_cursor IS
        SELECT
            vid,
            data_na_zaemane,
            godina,
            izminati_km,
            cena_na_den,
            cvqt,
            marka,
            model,
            slujitel_ime,
            klient_ime
        FROM (
            SELECT
                v.vid,
                z.data_na_zaemane,
                a.godina,
                a.izminati_km,
                a.cena_na_den,
                c.cvqt,
                m.marka,
                mo.model,
                s.ime AS slujitel_ime,
                k.ime AS klient_ime,
                ROW_NUMBER() OVER (ORDER BY z.data_na_zaemane DESC) AS rnum
            FROM
                zaemane_pod_naem z
            JOIN
                avtomobil a ON z.id_avtomobil = a.id_avtomobil
            JOIN
                vid v ON a.id_vid = v.id_vid
            JOIN
                slujitel s ON z.id_slujitel = s.id_slujitel
            JOIN
                klient k ON z.id_klient = k.id_klient
            JOIN
                cvqt c ON a.id_cvqt = c.id_cvqt
            JOIN
                modell mo ON a.id_model = mo.id_model
            JOIN
                marka m ON mo.id_marka = m.id_marka
            ORDER BY
                z.data_na_zaemane DESC
        )
        WHERE rnum <= 10;

BEGIN
    FOR zaemane_rec IN zaemane_cursor LOOP
        DBMS_OUTPUT.PUT_LINE(
            zaemane_rec.vid || ', ' ||
            zaemane_rec.data_na_zaemane || ', ' ||
            zaemane_rec.godina || ', ' ||
            zaemane_rec.izminati_km || ', ' ||
            zaemane_rec.cena_na_den || ', ' ||
            zaemane_rec.cvqt || ', ' ||
            zaemane_rec.marka || ', ' ||
            zaemane_rec.model || ', ' ||
            zaemane_rec.slujitel_ime || ', ' ||
            zaemane_rec.klient_ime
        );
    END LOOP;
END DisplayTopZaemaneRecords;

EXEC DisplayTopZaemaneRecords;

--CURSOR3--

CREATE OR REPLACE PROCEDURE DisplayZaemaneByClient(
    p_klient_ime IN VARCHAR2
) IS
    CURSOR zaemane_cursor IS
        SELECT
            z.data_na_zaemane,
            k.ime AS klient_ime,
            mo.model,
            m.marka,
            a.godina,
            a.izminati_km,
            a.cena_na_den,
            c.cvqt,
            s.ime AS slujitel_ime
        FROM
            zaemane_pod_naem z
        JOIN
            avtomobil a ON z.id_avtomobil = a.id_avtomobil
        JOIN
            klient k ON z.id_klient = k.id_klient
        JOIN
            slujitel s ON z.id_slujitel = s.id_slujitel
        JOIN
            cvqt c ON a.id_cvqt = c.id_cvqt
        JOIN
            modell mo ON a.id_model = mo.id_model
        JOIN
            marka m ON mo.id_marka = m.id_marka
        WHERE
            k.ime LIKE '%' || p_klient_ime || '%'
        ORDER BY
            z.data_na_zaemane;

BEGIN
    FOR zaemane_rec IN zaemane_cursor LOOP
        DBMS_OUTPUT.PUT_LINE(
            zaemane_rec.data_na_zaemane || ', ' ||
            zaemane_rec.klient_ime || ', ' ||
            zaemane_rec.model || ', ' ||
            zaemane_rec.marka || ', ' ||
            zaemane_rec.godina || ', ' ||
            zaemane_rec.izminati_km || ', ' ||
            zaemane_rec.cena_na_den || ', ' ||
            zaemane_rec.cvqt || ', ' ||
            zaemane_rec.slujitel_ime
        );
    END LOOP;
END DisplayZaemaneByClient;

EXEC DisplayZaemaneByClient;

--CURSOR4--

CREATE OR REPLACE PROCEDURE DisplayZaemaneByDateRange(
    p_start_date IN VARCHAR2,
    p_end_date IN VARCHAR2
) IS
    CURSOR zaemane_cursor IS
        SELECT
            k.ime AS klient_ime,
            z.data_na_zaemane,
            z.broi_dni,
            mo.model,
            m.marka,
            a.godina,
            a.izminati_km,
            a.cena_na_den,
            c.cvqt,
            s.ime AS slujitel_ime
        FROM
            zaemane_pod_naem z
        JOIN
            avtomobil a ON z.id_avtomobil = a.id_avtomobil
        JOIN
            klient k ON z.id_klient = k.id_klient
        JOIN
            slujitel s ON z.id_slujitel = s.id_slujitel
        JOIN
            cvqt c ON a.id_cvqt = c.id_cvqt
        JOIN
            modell mo ON a.id_model = mo.id_model
        JOIN
            marka m ON mo.id_marka = m.id_marka
        WHERE
            z.data_na_zaemane BETWEEN TO_DATE(p_start_date, 'DD-MM-RR') AND TO_DATE(p_end_date, 'DD-MM-RR')
        ORDER BY
            k.ime,
            z.data_na_zaemane;

BEGIN
    FOR zaemane_rec IN zaemane_cursor LOOP
        DBMS_OUTPUT.PUT_LINE(
            zaemane_rec.klient_ime || ', ' ||
            zaemane_rec.data_na_zaemane || ', ' ||
            zaemane_rec.broi_dni || ', ' ||
            zaemane_rec.model || ', ' ||
            zaemane_rec.marka || ', ' ||
            zaemane_rec.godina || ', ' ||
            zaemane_rec.izminati_km || ', ' ||
            zaemane_rec.cena_na_den || ', ' ||
            zaemane_rec.cvqt || ', ' ||
            zaemane_rec.slujitel_ime
        );
    END LOOP;
END DisplayZaemaneByDateRange;

EXEC DisplayZaemaneByDateRange;

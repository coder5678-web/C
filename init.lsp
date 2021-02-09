(vl-load-com)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
(defun init()
  (setvar "osmode" 1)
  (setvar "cmdecho" 1)
  (setvar "ltscale" 1)
  (setvar "lunits" 2)
  (setvar "luprec" 4)
  (setvar "aunits" 1)
  (setvar "auprec" 4)
  (setvar "msltscale" 0)
  (setvar "psltscale" 0)
  (setvar "angbase" 0)
  (setvar "lwdefault" 18)
  (setvar "angdir" 0)
  (command "purge" "A" "*" "N");��ȫ������һ��
  (setq index 0)
  (repeat 9;����ͼ�㼰����ɫ
	  (setq sindex (strcat "k" (itoa(setq index(+ 1 index)))))
	  (if(/= "k7" sindex)
	    (command "layer" "m" sindex "c"  (itoa index) "" "" )
	    (command "layer" "m" sindex "c" 255  "" "" )
	    )
	  )
  ;1-����
  ;2-����ǽ����
  ;3-�ֽ�
  ;4-��
  ;5-����
  ;6-���ǽ��Ȧ��
  ;7----
  ;8-������������ǽ����ע
  ;k8-h��ˮƽ��ע
  ;k8-v����ֱ��ע
  ;9-�ߴ��ע,���
  ;0-˵��
  ;repeat end;
  (load "searchfile.lsp")
  (if (not (searchline "*dot1000-200-20-200,axis" "acadiso.lin"))
    (progn
      (setq filestr (findfile  "acadiso.lin"))
      (setq file1 (open filestr "a"))
      (write-line "*dot1000-200-20-200,axis" file1)  
      (write-line "A,1500,-250,200,-250" file1)  
      (write-line "*dashed400-100,dashed" file1)  
      (write-line "A,400,-200" file1)  
      (close file1)
      ;(command "linetype" "c" "dot1000-200-20-200" "acadiso.lin" "axis"  "1000,-200,20,-200" "l" "dot1000-200-20-200" "" "" )
      ;(command "linetype" "c" "dashed400x100" "acadiso.lin" "����" "400,-100" "l" "dashed400x100" "" "" )
      (command "linetype" "L"  "dashed400-100" "acadiso.lin" "")
      (command "layer" "s" "k4" "l" "dashed400-100" "" "") 
      (command "linetype" "L" "dot1000-200-20-200" "acadiso.lin" "")
      (command "layer" "s" "k1" "l" "dot1000-200-20-200" "" "" ) 
      )
    )
 (command "layer" "m" "k8-v" "c" 200  "" "" )
 (command "layer" "m" "k8-h" "c" 55 "" "" )
 (if (not (tblobjname "ltype" "dashed400-100"))
    (progn
      (command "linetype" "L"  "dashed400-100" "acadiso.lin" "")
      (command "layer" "s" "k4" "l" "dashed400-100" "" "") 
      )
    )
  (if (not (tblobjname "ltype" "dot1000-200-20-200" ))
    (progn
      (command "linetype" "L" "dot1000-200-20-200" "acadiso.lin" "")
      (command "layer" "s" "k1" "l" "dot1000-200-20-200" "" "" ) 
      )
    )
  (command "layer" "s" "k3" "lw" 0.5 "" "") 
  (command "style" "tssd-k7" "tssdeng2.shx,cwcec.shx" 0 0.8 0 "n" "n" "n")
  (command "style" "tssd-8-9" "tssdeng.shx,cwcec.shx" 0 0.8 0 "n" "n" "n")
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun os1 ()
  (setvar "osmode" 8871)
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun os0 ()
  (setvar "osmode" 0)
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun cq()
  (setvar "clayer" (getstring "the layer name"))
  (setvar "celtype" "bylayer")
  (setvar "cecolor" "bylayer")
  (setvar "celweight" -1)
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun ki(kli)
  (setq b1 (ssget));ssget���ã�qs������
  (command "chprop" b1 "" "la" kli "");??
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;������ͼ��
(defun nl()
  (setq lname (getstring "������ͼ����"))
  (setq lcolor (getstring "������ͼ����ɫ������ɫϵͳdic��ɫ��"))
  (command "layer" "m" lname "c" "co" "dic color guide" (strcat "dic" lcolor) "" "")
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;ѡ��activex���󣬲���ʾ������
(defun getob()
  (vl-load-com)
  (setq myacad (vlax-get-acad-object))
  ;(vlax-dump-object myacad T)
  (setq caddoc (vla-get-ActiveDocument myacad))
  ;(vlax-dump-object caddoc T)
  (setq myms (vla-get-modelspace caddoc))
  ;(vlax-dump-object myms T)
  (setq mycount(vla-get-count myms))
  (setq smycount (itoa mycount))
  (setq i(getint  (strcat "nth activeX obj to ob?" smycount)))
  (setq ob (vla-item myms (- i 1) ))
  (vlax-dump-object ob T)
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
(defun ld()
  (setq  text (ssget  '((0 . "TEXT"))))
  (setq n 0)
  (setq b (cons 72 0))
  (setq c (cons 73 0))
  (repeat (sslength text)
	  (setq name (ssname text n))
	  (setq elist(entget (ssname text n)))
	  (setq elist (subst b (assoc 72 elist) elist))
	  (setq elist (subst c (assoc 73 elist) elist))
	  (entmod elist)
	  (setq n (+ 1 n))
	  )
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun md()
  ;(setvar "celweight" 50)
  ;(setvar "clayer" "k9")
  ;(if (not(tblsearch "block" "dim"))
  ;  (progn
  ;    (setq p0 (getvar "vsmin"))
  ;     (command "line" p0 (polar p0 (/ pi 4) 200) "")
  ;    (command "zoom" "e")
  ;   (setq p1 (list (+ (car p0) 70.7) (+ (cadr p0) 70.7)))
  ;  (setq p2 (osnap p1 "mid"))
  ; (command "block" "dim" p2 p2 "")
  ;)
  ;)

  (setvar "dimblk" "_archtick")
  (setvar "dimgap" 1)
  (setvar "dimasz" 1)
  (setvar "dimexe" 1)
  (setvar "dimexo" 2)
  (setvar "dimtad" 1)
  (setvar "dimtih" 0)
  (setvar "dimtoh" 0)
  (setvar "dimtofl" 1)
  (setvar "dimtxsty" "tssd-8-9")
  (setvar "dimdec" 0)
  (setvar "dimtxt" 3.50)
  (setvar "dimtix" 1)
  (setvar "dimfxlon" 1)
  (setvar "dimfxl"  10)
  (command "dim1" "save" "k1dim")
  )


;  (setvar "dimlfac" 1)
;  (setvar "dimscale" 1)
;  (command "dim1" "save" "100-100")
;
;  (setvar "dimlfac" 1)
;  (setvar "dimscale" 0.5)
;  (command "dim1" "save" "50-50")
;
;  (setvar "dimlfac" 1)
;  (setvar "dimscale" 0.2)
;  (command "dim1" "save" "20-20")
;
;  (setvar "dimlfac" 1)
;  (setvar "dimscale" 0.3)
;  (command "dim1" "save" "30-30")
;
;  (setvar "dimlfac" 1)
;  (setvar "dimscale" 0.25)
;  (command "dim1" "save" "25-25")
;
;  (setvar "dimlfac" 1)
;  (setvar "dimscale" 1.5)
;  (command "dim1" "save" "150-150")
;
;  (setvar "dimlfac" 1)
;  (setvar "dimscale" 0.15)
;  (command "dim1" "save" "15-15")
;
;  (setvar "dimlfac" 1)
;  (setvar "dimscale" 0.1)
;  (command "dim1" "save" "10-10")
;
;  (setvar "dimlfac" 1)
;  (setvar "dimscale" 0.4)
;  (command "dim1" "save" "40-40")
;
;
;  (setvar "dimlfac" 1)
;  (setvar "dimscale" 2)
;  (command "dim1" "save" "200-200")
;
;  (setvar "dimlfac" 1)
;  (setvar "dimscale" 2.5)
;  (command "dim1" "save" "250-250")
;
;  (setvar "dimlfac" 1)
;  (setvar "dimscale" 3)
;  (command "dim1" "save" "300-300")
;
;  (setvar "dimlfac" 1)
;  (setvar "dimscale" 5)
;  (command "dim1" "save" "500-500")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;(setq i 0 )
;(setq	ii 0)
;(setq ps-ss_13 (vlax-make-safearray vlax-vbSingle '(0 . 12)))
;(vlax-safearray-fill ps-ss_13 '(10 15 20 25 30 40 50 100 150 200 250 300 500))
;(repeat 13
;	  (setq si (vlax-safearray-get-element ps-ss_13 i)) ;siΪ��ӡ����
;	  (setq str_si (rtos (vlax-safearray-get-element ps-ss_13 i) 2 0)) 
;	  (repeat 13
;		  (setq sii (vlax-safearray-get-element ps-ss_13 ii));siiΪ����ͼ����
;		  (setq str_sii (rtos (vlax-safearray-get-element ps-ss_13 ii) 2 0)) 
;		  (setvar "dimscale" (/ si 100))
;		  (setvar "dimlfac" (/ sii si))
;		  (command "dim1" "save" (strcat "��ӡ����:" str_si "-" "����ͼ������" str_sii))
;		  (setq ii (1+ ii))
;		  )
;	  (setq i (1+ i))
;	  (setq ii 0)
;	  )
;(setvar "celweight" -1)
;  (princ)
;  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;��ȡ�ļ�������
(defun getda()
  (setq f1(open (getstring "����·�����ļ���:") "r"))
  (setq str1 (read-line f1))
  (setq list1 (read str1))
  (setq data1 (cadr (assoc (getstring "�����������ͣ�") list1)))
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;ѡ�������ѡ������ʵ���ͼ�������ʵ��
(defun qs(); s1  s_len array_50 i ii ei_layer  iii)
  (setq s1 (ssget)) 
  (setq s_len (sslength s1))
  (setq array_50 (vlax-make-safearray vlax-vbString '(0 . 50)))
  (setq i 1)
  (setq ii 0)
  (vlax-safearray-put-element array_50 0 (cdr (assoc 8 (entget(ssname s1 0)))))
  (repeat (1- s_len)
	  (setq ei_layer (cdr (assoc 8 (entget(ssname s1 i)))));��i��s1��ͼ������
	  (setq iii 0)
	  (while (and (<= iii ii) (/= ei_layer (vlax-safearray-get-element  array_50 iii)))
		 (setq iii (+ 1 iii))
		 )
	  (if (> iii ii)
	    (progn 
	      (setq ii iii) 
	      (vlax-safearray-put-element array_50 ii ei_layer)
	      )
	    )
	  (setq i (1+ i))
	  )
  (setq i 1)
  ;(setq a1 '(-4 . "<or"))
  (setq b1 (list  (cons 8 (vlax-safearray-get-element array_50 0))))
  (repeat  ii
	   (setq b1 (cons (cons 8 (vlax-safearray-get-element array_50 i)) b1 ))
	   (setq i (1+ i))
	   )
  (setq b1 (cons (cons -4 "<OR") b1))
  (setq b1 (append b1 (list (cons -4 "OR>"))))
  ;(setq a1 (list b1))
  (setq g1 (ssget "X" b1))
  )
;(defun c:qs()
;  (if (setq e1 (entsel "ѡ��һ������"))
;    (setq s1 (ssget "X" (list 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun setlayer();set layer and color (bylayer)��Pl�߻�Ϊ��ֱ��
  (setq s (ssget))
  (setq n 0)
  (setvar "cmdecho" 0)
  (repeat (sslength s) 
	  (setq elist (entget (ssname s n)))
	  (setq layername (cdr (assoc 8 elist)))  
	  (cond
	    ((or (= layername "1525")(= layername "ǽ���ݽ�")(= layername "ǽ������")(= layername "��׸ֽ�")(= layername "�ֽ�")(= layername "���ӹ���")(= layername "��������")(= layername "��������")(= layername "�ֽ���")(= layername "��__����")(= layername "��ƽ���ݽ�")(= layername "��ƽ������")(= layername "�ֽ�-0.25")(= layername "ǽ����ʾ��")(= layername "��__�ݽ�")(= layername "1407")(= layername "1413")(= layername "521")(= layername "518")  (= layername "֧���ֽ�")) (setq a (cons 8 "k3")))
	    ((or (= layername "926")(= layername "�ֽ��ע")(= layername "ǽ������")(= layername "��__�ֽ��ע")(= layername "��ע�ֽ�")(= layername "1526")(= layername "1418")(= layername "��׸ֽ��ע")  (= layername "�����������")(= layername "֧���ֽ��ע")) (setq a (cons 8 "k8")))
	    ((or (= layername "���ӹ����")(= layername "ˮƽ�����ע")(= layername "��__�ߴ���")(= layername "biaozhu")(= layername "��ע")(= layername "ˮƽ��ע")  (= layername "���������ע")(= layername "���������ע")(= layername "ˮƽ�ֽ�")(= layername "��ԭλ��ע")(= layername "�����б�ע")(= layername "�����б�ע")(= layername "��ԭλ��ע")(= layername "�ֲ�������")(= layername "��������")(= layername "�������ע")(= layername "�������ע")(= layername "��ֱ�ֽ�")(= layername "������ע")(= layername "��ֱ��ע")) (setq a (cons 8 "k8")))
	    ((or (= layername "������")(= layername "��")(= layername "��ʵ��")(= layername "��__ʵ��")(= layername "ǽ��__��̨��")(= layername "��__����")(= layername "3")(= layername "31")) (setq a (cons 8 "k4")))
	    ((or (= layername "����")(= layername "DOTE")(= layername "����__�㻮��")(= layername "����Ȧ")(= layername "����__���ߺź���Ȧ"))   (setq a (cons 8 "k1")))
	    ((or(= layername "AXIS")(= layername "PUB_DIM")(= layername "���")(= layername "DIM_ELEV")(= layername "1213")(= layername "1530")(= layername "ǽ����λ")(= layername "PUB_TEXT")(= layername "��ע�ߴ�")(= layername "�ߴ��߼�����")(= layername "1408")(= layername "biaozhu")(= layername "508")(= layername "����__�ߴ�����"))   (setq a (cons 8 "k9")))
	    ((or(= layername "����")(= layername "ͼ���»���")(= layername "108")(= layername "725")(= layername "�»���")(= layername "1534")(= layername "������")(= layername "916")(= layername "ͼ��")(= layername "TAB")(= layername "����")(= layername "1421")(= layername "1417")(= layername "˵��"))   (setq a (cons 8 "k7")))
	    ((or (= layername "��ƽ������")(= layername "��")  (= layername "505")(= layername "210")(= layername "2")(= layername "ǽ")(= layername "ǽ��__����")(= layername "��ǽ")(= layername "ǽ������")(= layername "104")(= layername "�߹�Ϳʵ(ƽ)")(= layername "1402")(= layername "710")(= layername "708")(= layername "��__�ߴ���")(= layername "GJ")(= layername "ǽ__ʵ��")(= layername "1")(= layername "11"))(setq a (cons 8 "k2")))
	    ((or (= layername "1505")(= layername "���λ���")  (= layername "��������")(= layername "���������")(= layername "104")(= layername "1")(= layername "11")) (setq a (cons 8 "k5")))
	    ((or (= layername "���ǽ")  (= layername "Ȧ��")) (setq a (cons 8 "k6")))
	    ((or (= layername "1412")(= layername "����")  (= layername "�ֲ���ʾ��")(= layername "ͼ������")(= layername "ǽ����������")(= layername "����")(= layername "���ڱ���")(= layername "����")) (setq a (cons 8 "k7")))
	    (T (setq a(cons 8 layername)))
	    );end cond
	  (setq a0(cons 62 256))
	  (setq a1(cons 6 "bylayer"))
	  (setq elist (subst a (assoc 8 elist) elist));layer
	  (setq elist (subst a0 (assoc 62 elist) elist));color by layer
	  (setq elist (subst a1 (assoc 6 elist) elist));line type by layer
	  (entmod elist)
	  (setq n (+ 1 n))
	  );end repeat
  ;(command "purge" "a" "" "n")
  (setq ss (ssget  '((-4 . "<or")(0 . "POLYLINE")(0 . "LWPOLYLINE")(-4 . "or>"))))
  (setq n 0)
  (repeat (sslength ss)
	  (if(= "LWPOLYLINE" (cdr (assoc 0 (entget (ssname ss n)))))
	    (command "convertpoly" "H" (ssname ss n) "")
	    )
	  (setq elist (entget (ssname ss n)))
	  (setq elist (cons (cons 370 50) elist))
	  (entmod elist)
	  (command "explode" (ssname ss n))
	  (setq n(+ 1 n))
	  )
  )

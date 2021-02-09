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
  (command "purge" "A" "*" "N");先全部清理一次
  (setq index 0)
  (repeat 9;设置图层及其颜色
	  (setq sindex (strcat "k" (itoa(setq index(+ 1 index)))))
	  (if(/= "k7" sindex)
	    (command "layer" "m" sindex "c"  (itoa index) "" "" )
	    (command "layer" "m" sindex "c" 255  "" "" )
	    )
	  )
  ;1-轴线
  ;2-承重墙，柱
  ;3-钢筋
  ;4-梁
  ;5-基础
  ;6-填充墙，圈梁
  ;7----
  ;8-基础，梁柱，墙板筋标注
  ;k8-h梁水平标注
  ;k8-v梁垂直标注
  ;9-尺寸标注,标高
  ;0-说明
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
      ;(command "linetype" "c" "dashed400x100" "acadiso.lin" "虚线" "400,-100" "l" "dashed400x100" "" "" )
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
  (setq b1 (ssget));ssget调用（qs）函数
  (command "chprop" b1 "" "la" kli "");??
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;创建新图层
(defun nl()
  (setq lname (getstring "输入新图层名"))
  (setq lcolor (getstring "输入新图层颜色名（配色系统dic颜色号"))
  (command "layer" "m" lname "c" "co" "dic color guide" (strcat "dic" lcolor) "" "")
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;选择activex对象，并显示其属性
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
;	  (setq si (vlax-safearray-get-element ps-ss_13 i)) ;si为打印比例
;	  (setq str_si (rtos (vlax-safearray-get-element ps-ss_13 i) 2 0)) 
;	  (repeat 13
;		  (setq sii (vlax-safearray-get-element ps-ss_13 ii));sii为大样图比例
;		  (setq str_sii (rtos (vlax-safearray-get-element ps-ss_13 ii) 2 0)) 
;		  (setvar "dimscale" (/ si 100))
;		  (setvar "dimlfac" (/ sii si))
;		  (command "dim1" "save" (strcat "打印比例:" str_si "-" "大样图比例：" str_sii))
;		  (setq ii (1+ ii))
;		  )
;	  (setq i (1+ i))
;	  (setq ii 0)
;	  )
;(setvar "celweight" -1)
;  (princ)
;  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;获取文件表数据
(defun getda()
  (setq f1(open (getstring "输入路径和文件名:") "r"))
  (setq str1 (read-line f1))
  (setq list1 (read str1))
  (setq data1 (cadr (assoc (getstring "输入数据类型：") list1)))
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;选择具有所选的所有实体的图层的所有实体
(defun qs(); s1  s_len array_50 i ii ei_layer  iii)
  (setq s1 (ssget)) 
  (setq s_len (sslength s1))
  (setq array_50 (vlax-make-safearray vlax-vbString '(0 . 50)))
  (setq i 1)
  (setq ii 0)
  (vlax-safearray-put-element array_50 0 (cdr (assoc 8 (entget(ssname s1 0)))))
  (repeat (1- s_len)
	  (setq ei_layer (cdr (assoc 8 (entget(ssname s1 i)))));第i个s1的图层名称
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
;  (if (setq e1 (entsel "选择一个物体"))
;    (setq s1 (ssget "X" (list 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun setlayer();set layer and color (bylayer)将Pl线化为粗直线
  (setq s (ssget))
  (setq n 0)
  (setvar "cmdecho" 0)
  (repeat (sslength s) 
	  (setq elist (entget (ssname s n)))
	  (setq layername (cdr (assoc 8 elist)))  
	  (cond
	    ((or (= layername "1525")(= layername "墙柱纵筋")(= layername "墙柱箍筋")(= layername "板底钢筋")(= layername "钢筋")(= layername "附加箍筋")(= layername "次梁吊筋")(= layername "次梁箍筋")(= layername "钢筋线")(= layername "柱__箍筋")(= layername "柱平法纵筋")(= layername "柱平法箍筋")(= layername "钢筋-0.25")(= layername "墙柱箍示意")(= layername "柱__纵筋")(= layername "1407")(= layername "1413")(= layername "521")(= layername "518")  (= layername "支座钢筋")) (setq a (cons 8 "k3")))
	    ((or (= layername "926")(= layername "钢筋标注")(= layername "墙柱文字")(= layername "柱__钢筋标注")(= layername "标注钢筋")(= layername "1526")(= layername "1418")(= layername "板底钢筋标注")  (= layername "拉结区拉筋规")(= layername "支座钢筋标注")) (setq a (cons 8 "k8")))
	    ((or (= layername "附加箍筋标")(= layername "水平箍筋标注")(= layername "柱__尺寸线")(= layername "biaozhu")(= layername "标注")(= layername "水平标注")  (= layername "次梁吊筋标注")(= layername "次梁箍筋标注")(= layername "水平钢筋")(= layername "梁原位标注")(= layername "柱集中标注")(= layername "梁集中标注")(= layername "柱原位标注")(= layername "分布筋文字")(= layername "连梁文字")(= layername "梁截面标注")(= layername "柱截面标注")(= layername "垂直钢筋")(= layername "构件标注")(= layername "垂直标注")) (setq a (cons 8 "k8")))
	    ((or (= layername "梁虚线")(= layername "梁")(= layername "梁实线")(= layername "梁__实线")(= layername "墙线__窗台线")(= layername "梁__虚线")(= layername "3")(= layername "31")) (setq a (cons 8 "k4")))
	    ((or (= layername "轴线")(= layername "DOTE")(= layername "轴线__点划线")(= layername "轴线圈")(= layername "轴线__轴线号和轴圈"))   (setq a (cons 8 "k1")))
	    ((or(= layername "AXIS")(= layername "PUB_DIM")(= layername "标高")(= layername "DIM_ELEV")(= layername "1213")(= layername "1530")(= layername "墙柱定位")(= layername "PUB_TEXT")(= layername "标注尺寸")(= layername "尺寸线及数字")(= layername "1408")(= layername "biaozhu")(= layername "508")(= layername "轴线__尺寸数字"))   (setq a (cons 8 "k9")))
	    ((or(= layername "中文")(= layername "图名下划线")(= layername "108")(= layername "725")(= layername "下划线")(= layername "1534")(= layername "比例尺")(= layername "916")(= layername "图名")(= layername "TAB")(= layername "文字")(= layername "1421")(= layername "1417")(= layername "说明"))   (setq a (cons 8 "k7")))
	    ((or (= layername "柱平法截面")(= layername "柱")  (= layername "505")(= layername "210")(= layername "2")(= layername "墙")(= layername "墙线__粗线")(= layername "砼墙")(= layername "墙柱轮廓")(= layername "104")(= layername "边构涂实(平)")(= layername "1402")(= layername "710")(= layername "708")(= layername "柱__尺寸线")(= layername "GJ")(= layername "墙__实线")(= layername "1")(= layername "11"))(setq a (cons 8 "k2")))
	    ((or (= layername "1505")(= layername "条形基础")  (= layername "独立基础")(= layername "条基剖面号")(= layername "104")(= layername "1")(= layername "11")) (setq a (cons 8 "k5")))
	    ((or (= layername "填充墙")  (= layername "圈梁")) (setq a (cons 8 "k6")))
	    ((or (= layername "1412")(= layername "其它")  (= layername "分布筋示意")(= layername "图名底线")(= layername "墙柱高亮部分")(= layername "零厚板")(= layername "洞口边线")(= layername "其他")) (setq a (cons 8 "k7")))
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

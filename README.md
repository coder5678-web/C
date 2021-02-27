# initcad--用来初始化autocad的
lisp对表的处理是其最擅长的，lisp language=list process language，lisp提供了许多表处理函数，例如assoc ,car cdr cons,等。

(car list) --返回第一元素
(cdr list) --排除第一元素后的list ,若果变量list是点对，则返回点对后面的atom
car和cdr可叠加四层：例如caddr=car cdr cdr
(nth n list)-- 返回第n+1个元素
生成列表的函数：cons
(cons "abc" '())=("abc")
(cons "abc" (cons "abc" '()))=("abc" "abc")
可用这个方法生产字符串表
'函数不求值，list函数求值造表
'((+ 2 3) b)=((+ 2 3) b)
(list (+ 2 3) b)=(5 nil )
list 是括号内用空格分隔的数据
(subst a b list):--用a替换List中的b
(append list1 atom)--追加atom to list1
(reverse list ) --倒排List
点对是种特殊的表（improper list），其存储空间小于普通的表，但是大多数的表处理函数不能处理点对，在编程时要注意。
cons 函数处理参数时，如果所给的第二个元素不是表（或者不是空表‘（）），则返回一个点对:
（cons 1 3）=（1 . 3 ）
assoc 函数检索一个association list（联合表,以点对为元素的表)，返回以参数key为第一个元素的点对的第二个元素：
(setq sublist (cons 'lyr "WALLS"))
return :(LYR . "WALLS")
(setq wallinfo (list sublist(cons 'len 240.0) (cons 'hgt 96.0)))
( (LYR . "WALLS") (LEN . 240.0) (HGT . 96.0) )
(assoc 'len wallinfo)
(LEN . 240.0)
cdr (assoc 'lyr wallinfo))
"WALLS"
(nth 1 wallinfo)
(LEN . 240.0)
(car (nth 1 wallinfo))
LEN
其它的点表处理函数
(vl-consp list-variable)
Determines whether or not a list is nil
(subst newitem olditem lst)
Searches a list for an old item and returns a copy of the list with a new item substituted in place of every occurrence of the old item

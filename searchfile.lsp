(defun searchline ( ltline1 tofile / ltline note filestr ) ;从文本文件中查找到某行文字;全局变量note
  (setq filestr (findfile tofile)) ;找到线形文件acadiso.lin的含有路径名的文件名
  (setq file2 (open filestr "r"));将此线形文件作为file2只读打开
  (setq ltline (read-line file2))
  (while  ltline ;读入每行且赋值给ltline(str类型)
	  (setq ltline (read-line file2))
	  (if  (= ltline ltline1)  ;如果读到"dot-1000-200-20-200,轴线”行，说明已经建立了线形
	    (progn
	      (setq ltline nil );ltline 设置为nil退出循环此时将note 设置为1 说明找到了这行
	      (setq note 1)
	      )
	    )
	  );循环直到EOF
  (close file2)
  (setq note note) ;返回函数
  )
  

(defun searchline ( ltline1 tofile / ltline note filestr ) ;���ı��ļ��в��ҵ�ĳ������;ȫ�ֱ���note
  (setq filestr (findfile tofile)) ;�ҵ������ļ�acadiso.lin�ĺ���·�������ļ���
  (setq file2 (open filestr "r"));���������ļ���Ϊfile2ֻ����
  (setq ltline (read-line file2))
  (while  ltline ;����ÿ���Ҹ�ֵ��ltline(str����)
	  (setq ltline (read-line file2))
	  (if  (= ltline ltline1)  ;�������"dot-1000-200-20-200,���ߡ��У�˵���Ѿ�����������
	    (progn
	      (setq ltline nil );ltline ����Ϊnil�˳�ѭ����ʱ��note ����Ϊ1 ˵���ҵ�������
	      (setq note 1)
	      )
	    )
	  );ѭ��ֱ��EOF
  (close file2)
  (setq note note) ;���غ���
  )
  

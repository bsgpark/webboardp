<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.util.Enumeration"%>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@ page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page import ="org.json.simple.*" %>
<%@ include file ="JDBCConnector.jsp" %>
<%try{
	Long intUnixTime = System.currentTimeMillis() / 1000;
	if(conn != null){
		Date today = new Date();
		java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyyMMdd"); 
		String today_path = sdf.format(today);
		String root_path = "C:/work/java/webboard/WebContent/";
		String upload_path = "assets/upload/" + today_path;
		String total_path = root_path + upload_path;
		
		File dir = new File(total_path);
		if(!dir.exists()){
			dir.mkdir();
		}
		
		int maxSize = 1024*1024*10;
		
		String fileName ="";// 유일한 이름 작성
		String originalName ="";// 실제 원본 이름
		long fileSize = 0;// 파일 사이즈
		String fileType ="";// 파일 타입
		     
		MultipartRequest multi =null;
		String title = "";
		String keyword = "";
		String contents = "";
		
		try{
	        // request,파일저장경로,용량,인코딩타입,중복파일명에 대한 기본 정책
	        multi =new MultipartRequest(request, total_path, maxSize,"utf-8", new DefaultFileRenamePolicy());

	        title = multi.getParameter("title");
	    	keyword = multi.getParameter("keyword");
	    	contents = multi.getParameter("contents");
	    	
	        // 전송한 전체 파일이름들을 가져옴
	        Enumeration files = multi.getFileNames();
	         
	        while(files.hasMoreElements()){
	            // form 태그에서 <input type="file" name="여기에 지정한 이름" />을 가져온다.
	            String file = (String)files.nextElement();// 파일 input에 지정한 이름을 가져옴
	            // 그에 해당하는 실재 파일 이름을 가져옴
	            originalName = multi.getOriginalFileName(file);
	            // 파일명이 중복될 경우 중복 정책에 의해 뒤에 1,2,3 처럼 붙어 unique하게 파일명을 생성하는데
	            // 이때 생성된 이름을 filesystemName이라 하여 그 이름 정보를 가져온다.(중복에 대한 처리)
	            fileName = multi.getFilesystemName(file);
	            // 파일 타입 정보를 가져옴
	            fileType = multi.getContentType(file);
	            // input file name에 해당하는 실재 파일을 가져옴
	            File filec = multi.getFile(file);
	            // 그 파일 객체의 크기를 알아냄
	            fileSize = filec.length();
	        }
	    }catch(Exception e){
	    	fileName ="";// 유일한 이름 작성
		    originalName ="";// 실제 원본 이름
		    fileSize = 0;// 파일 사이즈
		    fileType ="";// 파일 타입
	    }
		
		int midx = (int)session.getAttribute("mid");
		String title2 = request.getParameter("title");
		String keyword2 = request.getParameter("keyword");
		String contents2 = request.getParameter("contents");
		
		
		pstmt = conn.prepareStatement("insert into community(midx, title, keyword, contents, filename_real, fileName,readcount,regdate)"
							+"values (?,?,?,?,?,?,?,?)");
		pstmt.setInt(1, midx);
		pstmt.setString(2, title2);
		pstmt.setString(3, keyword2);
		pstmt.setString(4, contents2);
		pstmt.setString(5, originalName);
		pstmt.setString(6, fileName);
		pstmt.setInt(7, 0);
		pstmt.setLong(8, intUnixTime);
		
		int prs = pstmt.executeUpdate();
		//기본글의 id를 계층형을 만들때 쓰는 masterid와 일치 시켜 주어야 그 글에 생긴 답글이 id 밑으로 정렬될 수 있다. 
		rs = pstmt.executeQuery("SELECT last_insert_id()");
			if(rs.next()) {
				int masterid = rs.getInt(1);
				pstmt = conn.prepareStatement("UPDATE community set masterid = ? where idx = ?");
				pstmt.setInt(1, masterid);
				pstmt.setInt(2, masterid);
				pstmt.executeUpdate();	
			}
		pstmt.close();
		conn.close();
		
		JSONObject obj = new JSONObject();
		obj.put("result", "1");
		obj.put("msg", "글이 올라갔습니다.");
		obj.put("url", "List.jsp");
		
		String jsonSt = obj.toJSONString();
		out.print(jsonSt);
	}else {
		JSONObject obj = new JSONObject();
		obj.put("result", "0");
		obj.put("msg", "글이 올라가지 않았습니다. 다시 시도해 주십시요.");
		obj.put("url", "Create.jsp");
		
		String jsonSt = obj.toJSONString();
		out.print(jsonSt);
	}
	
	
}catch (Exception e) {
	// 에러 메시지 출력
	e.printStackTrace(new java.io.PrintWriter(out));
}
	
%>
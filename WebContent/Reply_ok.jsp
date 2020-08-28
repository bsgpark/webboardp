<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.util.Enumeration"%>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@ page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page import="org.json.simple.*"%>
<%@ include file="JDBCConnector.jsp" %> 

<%
request.setCharacterEncoding("UTF-8");
// 로그인 세션이 종료되어서 댓글을 써지 못함 그 부분을 추가해주고 try catch 하면 에러가  안보여서 주석처리를 해두고 찾아야한다!!! 수정하기 !!!!

try {
	Long intUnixTime = System.currentTimeMillis() / 1000;
	
	//Long intUnixTime = Calendar.getInstance().getTime().getTime() / 1000;

	if (conn != null) {
		
		Date today = new Date();
		java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyyMMdd"); 
		String today_path = sdf.format(today);
		
	    // request.getRealPath("상대경로") 를 통해 파일을 저장할 절대 경로를 구해온다.
	    // 운영체제 및 프로젝트가 위치할 환경에 따라 경로가 다르기 때문에 아래처럼 구해오는게 좋음
		// 이클립스에서 서버를 생성했을 경우 temp 디렉토리에서 서블릿이 실행되므로 아래와 같이 자신의 코드가 있는 절대 경로를 하드코딩한다.
		String root_path = "C:/work/java/webboard/WebContent/";
		String upload_path = "assets/upload/" + today_path;
		String total_path = root_path + upload_path;

	    //out.println("절대경로 : " + total_path +"<br/>");
	    
	    File dir = new File(total_path);

	    if (!dir.exists()) {
	    	// 현재 디렉토리가 없다면 디렉토리를 생성한다.
	    	dir.mkdirs();
	    }
	     
	    int maxSize =1024 *1024 *10;// 한번에 올릴 수 있는 파일 용량 : 10M로 제한
	     
	    String fileName ="";// 유일한 이름 작성
	    String originalName ="";// 실제 원본 이름
	    long fileSize = 0;// 파일 사이즈
	    String fileType ="";// 파일 타입
	     
	    MultipartRequest multi =null;
	    String title = "";
	    String keyword = "";
	    String contents = "";
	    String tempidx = "";
	    
	   try{
	        // request,파일저장경로,용량,인코딩타입,중복파일명에 대한 기본 정책
	        multi =new MultipartRequest(request, total_path, maxSize,"utf-8", new DefaultFileRenamePolicy());

	        tempidx = multi.getParameter("idx");
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
	     
	    int masterid = 0;
	    int orderno = 0;
	    int step = 0;
	    pstmt = conn.prepareStatement("Select * from community where idx = ?");
	    pstmt.setString(1,tempidx);
	    rs = pstmt.executeQuery();
	    if(rs.next()){
	    	masterid = rs.getInt("masterid");
	    	step = rs.getInt("step") + 1;
	    	if(rs.getInt("orderno") != 0){
	    		orderno = rs.getInt("orerno");
	    	}
	    	else{
	    		pstmt = conn.prepareStatement("select max(orderno) from community where masterid = ?");
	    		pstmt.setInt(1, masterid);
	    		ResultSet rs2 = pstmt.executeQuery();
	    		if(rs2.next()){
	    			orderno = rs2.getInt(1) + 1;
	    		}
	    	}
	    	step = rs.getInt("step") + 1;
	    } 
	    
	    int midx = 0;
	    if(session.getAttribute("mid") != null){
	    	 midx = (int)session.getAttribute("mid");
	    }
		
		
		pstmt = conn.prepareStatement("INSERT into community (midx, title, keyword, contents, filename_real, filename, readcount, regdate, masterid, orderno, step)" + 
				"values (?,?,?,?,?,?,?,?,?,?,?)");
		pstmt.setInt(1, midx);
		pstmt.setString(2, title);
		pstmt.setString(3, keyword);
		pstmt.setString(4, contents);
		pstmt.setString(5, today_path + "/" + originalName);
		pstmt.setString(6, today_path + "/" + fileName);
		pstmt.setInt(7, 0);
		pstmt.setLong(8, intUnixTime);
		pstmt.setInt(9, masterid);
		pstmt.setInt(10, orderno);
		pstmt.setInt(11, step);
		
		int prs = pstmt.executeUpdate(); 		
		
		pstmt.close();
		conn.close();
		
		JSONObject obj = new JSONObject();
		obj.put("result", 1);
		obj.put("msg", "글이 올라갔습니다.");
		obj.put("url", "List.jsp");
		
		String jsonSt = obj.toJSONString();
		out.print(jsonSt);
	} else {
		JSONObject obj = new JSONObject();
		obj.put("result", 0);
		obj.put("msg", "글이 올라가지 않았습니다. 다시 시도해 주십시요.");
		obj.put("url", "Reply.jsp");
		
		String jsonSt = obj.toJSONString();
		out.print(jsonSt);
	}
	

} catch (Exception e) {
	// 에러 메시지 출력
	e.printStackTrace(new java.io.PrintWriter(out));
	    
	    } 
	    %>
	    
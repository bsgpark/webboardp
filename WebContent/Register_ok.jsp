<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import ="org.json.simple.*" %>

     <%@ include file ="JDBCConnector.jsp" %>
<%
	try{
		String name = request.getParameter("name");
		String email = request.getParameter("email");
		String password = request.getParameter("password1");
		String[] favorite = request.getParameterValues("favorite");
		String gender = request.getParameter("gender");
		
		if(gender == null){gender ="M";};
		String favorites ="";
		if(favorites != null){
			for (String val:favorite){
				favorites = favorite + val +",";
			}
		}
		Long intUnixTime = System.currentTimeMillis()/1000;
		
		
		System.out.print(name);
		System.out.print(favorite);
		if(conn != null){//연결이 되면 이메일 중복 체크
				pstmt = conn.prepareStatement("INSERT into member (name, email, password, favorite, gender, regdate) values (?,?,?,?,?,?)");
				pstmt.setString(1,name);
				pstmt.setString(2,email);
				pstmt.setString(3,password);
				pstmt.setString(4,favorites);
				pstmt.setString(5,gender);
				pstmt.setLong(6,intUnixTime);
				
				int prs = pstmt.executeUpdate();
				
				pstmt.close();
				conn.close();
				
				JSONObject obj = new JSONObject();
				obj.put("result",1);
				obj.put("msg","회원가입이 되었습니다.");
				obj.put("url","Login.jsp");
				
				String jsonSt = obj.toJSONString();
				out.print(jsonSt);
		}
		else{
			JSONObject obj = new JSONObject();
			obj.put("result","0");
			obj.put("msg","회원가입을 할 수 없습니다. 다시 시도해 주세요.");
			obj.put("url", "Login.jsp");
			
			String jsonSt = obj.toJSONString();
			out.print(jsonSt);
		}} catch (Exception e){
			//에러 메시지 출력
			e.printStackTrace(new java.io.PrintWriter(out));
		}
		
		%>
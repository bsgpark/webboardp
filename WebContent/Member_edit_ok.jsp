<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import ="org.json.simple.*" %>
<%@ include file ="JDBCConnector.jsp" %>
<%
	try{
		String name = request.getParameter("name");
		//String email = request.getParameter("email");
		String password = request.getParameter("password1");
		String[] favorite = request.getParameterValues("favorite");
		String gender = request.getParameter("gender");
		
		if(gender == null){gender ="M";};
		String favorites ="";
		if(favorite != null){
			for (String val:favorite){
				favorites = favorites + val +',';
				}
			}
		Long intUnixTime = System.currentTimeMillis()/1000;
		
		int mid = (int)session.getAttribute("mid");
		
		if(conn != null){
			if(password.equals("")){
				pstmt = conn.prepareStatement("update member set name = ?, favorite = ?, gender = ? where idx = ?");
				pstmt.setString(1,name);
				pstmt.setString(2,favorites);
				pstmt.setString(3,gender);
				pstmt.setInt(4,mid);
				
				
			}
			else{
				pstmt = conn.prepareStatement("update member set name =? , password = ?, favorite = ?, gender =? where idx =?");
				pstmt.setString(1, name);
				pstmt.setString(2, password);
				pstmt.setString(3, favorites);
				pstmt.setInt(4, mid);
				
			}
			int prs = pstmt.executeUpdate();
			
			pstmt.close();
			conn.close();
			
			JSONObject obj = new JSONObject();
			obj.put("result","1");
			obj.put("msg","회원 수정이 완료되었습니다.다시 로그인 해주세요");
			session.invalidate();
			obj.put("url", "Login.jsp");
			// 다시 로그인 해주세요.하려면 세션값을 초기화하고 로그인 페이지로 이동 시켜야함
			
			String jsonSt = obj.toJSONString();
			out.print(jsonSt);
			
			
		}
		else{
			JSONObject obj = new JSONObject();
			obj.put("result", "0");
			obj.put("msg", "회원수정을 할 수 없습니다. 다시 시도해 주십시요.");
			obj.put("url", "Member_edit.jsp");
			
			String jsonSt = obj.toJSONString();
			out.print(jsonSt);
		}
			
	}catch (Exception e) {
		// 에러 메시지 출력
		e.printStackTrace(new java.io.PrintWriter(out));
	}
	%>
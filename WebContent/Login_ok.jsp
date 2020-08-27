<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import ="org.json.simple.*" %>
<%@ include file ="JDBCConnector.jsp" %>

<%
	String email = request.getParameter("email");
	String password = request.getParameter("password");
	
	if (conn != null){
		pstmt = conn.prepareStatement("select * from member where email = ?");
		pstmt.setString(1, email);
		
		rs = pstmt.executeQuery();
		if(rs.next()){
			ResultSet rs2 = null;
			pstmt = conn.prepareStatement("select * from member where email = ? and password = ?");
			pstmt.setString(1,email);
			pstmt.setString(2,password);
			
			rs2 = pstmt.executeQuery();
			if(rs2.next()){
				JSONObject obj= new JSONObject();
				obj.put("result",1);
				obj.put("msg","로그인 되었습니다.");
				obj.put("url", "Index.jsp");
				
				String jsonSt = obj.toJSONString();
				out.print(jsonSt);
				
				int mid = rs2.getInt("idx");
				email = rs2.getString("email");
				String name = rs2.getString("name");
				
				session.setAttribute("id", session.getId());
				session.setAttribute("mid", mid);
				session.setAttribute("email",email);
				session.setAttribute("name", name);
				
			}else{
				JSONObject obj= new JSONObject();
				obj.put("result",2);
				obj.put("msg","비밀번호가 일치하지 않습니다");
				obj.put("url","Login.jsp");
				
				String jsonSt= obj.toJSONString();
				out.print(jsonSt);
			}
		
		}else{
			JSONObject obj= new JSONObject();
			obj.put("result",2);
			obj.put("msg","이메일이 일치하지 않습니다.");
			obj.put("url","Login.jsp");
			
			String jsonSt = obj.toJSONString();
			out.print(jsonSt);
		}
	}
%>
	
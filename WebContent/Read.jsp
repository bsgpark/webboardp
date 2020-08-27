<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file ="JDBCConnector.jsp" %>
<%
	//조회수 증가
	String id = request.getParameter("idx");
	pstmt = conn.prepareStatement("update community set readcount = readcount +1 where idx = ?");
	pstmt.setString(1,id);
	pstmt.executeUpdate();
	
	//데이터 출력
	pstmt = conn.prepareStatement("select a.*, b.name from community a join member b on a.idx = b.idx where a.idx = ? ");
	pstmt.setString(1,id);
	rs = pstmt.executeQuery();
	
	String ctitle = "";
	String ckeyword = "";
	String contents = "";
	String name = "";
	
	if(rs.next()){
		ctitle = rs.getString("title");
		ckeyword = rs.getString("keyword");
		contents = rs.getString("contents");
		name = rs.getString("name");
	}
	%>
	<%
    String title = "글읽는";
    String keyword ="jsp,java";
    String description ="jsp 프로그래밍";
    String subject =ctitle;
    String author ="Bokmoon";
    %>
<%@ include file = "Header.jsp" %>
	<div class = "container">
		<div>제목<%=ctitle %></div>
		<div>글쓴이<%=name %></div>
		<div>키워드<%=ckeyword %></div>
		<div>내용<%=contents %></div>
		
		<div><a href="List.jsp">목록으로 가기</a></div>
		
	</div>
<%@ include file = "Footer.jsp" %>
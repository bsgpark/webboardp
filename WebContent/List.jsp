<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file ="JDBCConnector.jsp" %>
<%
    String title = "글목록화면";
    String keyword ="jsp,java";
    String description ="jsp 프로그래밍";
    String subject ="jsp로 커뮤니티 만들기";
    String author ="Bokmoon";
    %>
<%@ include file = "Header.jsp" %>
	<div class ="container">
		<div>
		<span class = "idx">번호</span>
		<span class = "title">제목</span>
		<span class = "keyword">키워드</span>
		<span class = "regdate">조회수</span>
		<span class = "regdate">글쓴이</span>
		</div>
	
	</div>
<%
	pstmt = conn.prepareStatement("select * from community order by idx desc");
	rs = pstmt.executeQuery();
	while(rs.next()){
		Long regdate = rs.getLong("regdate") * 1000;
		Date today = new Date(regdate);
		java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd"); 
		String rdate = sdf.format(today);
	%>
		<div>
		<span class = "idx"><%=rs.getInt("idx") %></span>
		<span class = "title"><a href="Read.jsp?idx=<%=rs.getInt("idx") %>"><%=rs.getString("title") %></a></span>
		<span class = "keyword"><%=rs.getString("keyword") %></span>
		<span class = "regdate"><%=rs.getInt("regdate") %></span>
		<span class = "regdate"><%=rdate %></span>
		</div>
	
<% } %>
<%@ include file = "Footer.jsp" %>

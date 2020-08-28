<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import ="org.json.simple.*" %>
<%@ include file ="JDBCConnector.jsp" %>
<%
    String title = "글목록화면";
    String keyword ="jsp,java";
    String description ="jsp 프로그래밍";
    String subject ="jsp로 커뮤니티 만들기";
    String author ="Bokmoon";
    %>
<%@ include file = "Header.jsp" %>
<%
	String search = request.getParameter("search");
	if(search ==null){
		search = "";
	}
	String tempPage = request.getParameter("page");
	int cPage = 0;
	if(tempPage == null || tempPage.length() == 0){
		cPage = 1;
	}
	try{
		cPage = Integer.parseInt(tempPage);
	}catch(NumberFormatException e){
		cPage = 1;
		
	}
	// 리스트 사이즈 조절 부분
	int pageSize = 5;
	int pageBlock = 3;
	int Limitstart = (int)((cPage - 1)*pageSize);
	
	
	int totalCount = 0;
	pstmt = conn.prepareStatement("select count(*) from community where title like ? or keyword like ?");
	pstmt.setString(1,"%" + search +"%");
	pstmt.setString(2,"%" + search +"%");
	rs = pstmt.executeQuery();
	if(rs.next()){
		totalCount = rs.getInt(1);
	}
	int pageCount = (int)((totalCount -1) / pageSize) + 1;
	int startPage = (int)((cPage -1)/pageBlock) * pageBlock + 1;
	int endPage = startPage + pageBlock - 1;
	if(endPage >pageCount){
		endPage = pageCount;
	}
	
	
	pstmt = conn.prepareStatement("select * from community where title like ? or keyword like ? order by idx desc limit ?,?");
	pstmt.setString(1,"%" + search +"%");
	pstmt.setString(2,"%" + search +"%");
	pstmt.setInt(3,Limitstart);
	pstmt.setInt(4,pageSize);
	rs = pstmt.executeQuery();
	

%>
	<div class ="container">
		<form name = "form" action ="List.jsp" method = "get" >
			<div class = "form-search">
			<label class = "field" for ="search">검색:</label>
			<input type = "text" id = "search" name = "search" class ="form-control">
			<button class="button" >확인▶</button>
			</div>
		</form>
		<div>
				<span class = "idx">번호</span>
				<span class = "title">제목</span>
				<span class = "keyword">키워드</span>
				<span class = "regdate">조회수</span>
				<span class = "regdate">글쓴이</span>
					
		</div>
	
	</div>
<%
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
<%
	String pageURL = "./List.jsp?search=" + search +"&";
	%>
	<div class = "containers">
	<ul class = "pagination">
	<%
		String pageStr = "";
		if(cPage > pageBlock){
			pageStr = pageStr + "<a class = 'pagelink' href  = '"+pageURL+"page=1"+"'><li class = 'pageitem'>◀</li></a>";
			pageStr = pageStr + "<a class = 'pagelink' href  = '"+pageURL+"page="+(endPage - pageBlock)+"'><li class = 'pageitem'>&lt;</li></a>";
			
		}
		for(int count = startPage; count <= endPage; count++){
			if(cPage == count){
				pageStr = pageStr+ "<a class = 'pagelink' href  = '"+pageURL+"page="+count+"'><li class = 'pageitemactive'>"+count+"</li></a>";
				
			}
			else{
				pageStr = pageStr+ "<a class = 'pagelink' href  = '"+pageURL+"page="+count+"'><li class = 'pageitem'>"+count+"</li></a>";
			}
		}
		if(pageCount > endPage){
			pageStr = pageStr + "<a class = 'pagelink' href  = '"+pageURL+"page="+(startPage + pageBlock)+"'><li class = 'pageitem'>&gt;</li></a>";
			pageStr = pageStr+ "<a class = 'pagelink' href  = '"+pageURL+"page="+pageCount+"'><li class = 'pageitem'>▶</li></a>";
		}
		out.print(pageStr);
	%>
	</ul>
	</div>

<%@ include file = "Footer.jsp" %>

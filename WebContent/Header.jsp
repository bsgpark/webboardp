<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.util.*" %>
<% Random r = new Random(); int i = r.nextInt(1000000); %>
<%-- <%
    String title = "메인화면";
    String keyword ="jsp,java";
    String description ="jsp 프로그래밍";
    String subject ="jsp로 커뮤니티 만들기";
    String author ="Bokmoon";
    %> --%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">	
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="robots" content="all" />
<meta name="keywords" content="<%=keyword%>" />
<meta name="description" content="<%=description%>" />
<meta name="subject" content="<%=subject%>" />
<meta name="google-site-verification" content="<%=title%>" />
<meta name="msvalidate.01" content="<%=title%>" />
<meta name="alexaVerifyID" content="<%=title%>" />
<meta name="author" content="<%=author%>" />
<meta name="writer" content="<%=author%>">
<meta name="copyright" content="<%=author%>">
<meta http-equiv="Pragma" content="No-Cache">
<meta property="og:type" content="website">
<meta property="og:title" content="<%=title%>">
<meta property="og:description" content="<%=description%>">
<meta property="og:image" content="">
<meta property="og:url" content="">
<title><%=title%></title>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="./assets/css/style.css?ver=<%=i%>" rel="stylesheet" type="text/css">
</head>
<body>
	<div class = "container">
		<div class = "menu">
		<div><a href="">메인메뉴</a></div>
		<div><a href="Register.jsp">회원가입</a>
			 <a href="Login.jsp">로그인</a></div>
		</div>
	</div>



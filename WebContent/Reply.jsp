<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    String title = "댓글화면";
    String keyword ="jsp,java";
    String description ="jsp 프로그래밍";
    String subject ="jsp로 커뮤니티 만들기";
    String author ="Sojung";
 %>
<%@ include file="Header.jsp" %>
 <%
 	String tempidx = request.getParameter("idx");
 	%>

<div class ="container">
	<form name = "form" action ="Reply_ok.jsp" method = "get" onsubmit="return check_ok();">
	<input type = 'hidden' name = 'idx' value = "<%=tempidx%>">
		<div class = "form-input">
		<label class = "field" for ="title">title</label>
		<input type = "text" id = "title" name = "title" class ="form-control">
		</div>
		<div class = "form-input">
		<label class = "field" for ="contents">contents</label>
		<textarea id="contents" name="contents" rows="5" cols="50" maxlength="200"> </textarea>
		</div>
		<div class = "buttons">
		<button class= "button">확인</button>
		</div>
	</form>
		


</div>

<%@ include file="Footer.jsp" %> 

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script>
	function check_ok(){
		
		var formdata = $('form').serializeArray();
		
		$.post("Reply_ok.jsp", formdata)
		.done(function(response){
			console.log(response);
			var data = JSON.parse(response.trim());
			if (data.result == 1){//저장 성공
				alert(data.msg);
				document.location.replace(data.url);//글 목록
			}else{
				alert(data.msg);//저장 실패
			}
		});
		//return false;
	}
</script>
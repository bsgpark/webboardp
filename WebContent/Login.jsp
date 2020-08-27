<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%
    String title = "로그인가입화면";
    String keyword ="jsp,java";
    String description ="jsp 프로그래밍";
    String subject ="jsp로 커뮤니티 만들기";
    String author ="Sojung";
    %>
<%@ include file ="Header.jsp" %>
  
<div class ="container">
	<form name = "form" action ="Login_ok.jsp" method = "post" onsubmit="return check_ok();">
	<%-- <input type ="hidden" name = "idx" value=<%=idx%>> --%>
	<div class = "form-input">
		<label class = "field" for ="email">이메일</label>
		<input type = "text" id = "email" name = "email" class ="form-control">
	</div>
	<div class = "form-input">
		<label class = "field" for="password">비밀번호</label>
		<input type ="password" id="password" name = "password" class = "form-control">
	</div>
	<div class="buttons">
		<button class="button" >확인</button>
	</div>
	</form>
</div>
<%@ include file ="Footer.jsp" %>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script>
	function check_ok(){
		var confirmcheck = 0;
		var focusble = true;
		
		var email = $.trim($("#email").val());
		var password = $.trim($("#password").val());
		
		if(email==""){
			if(focusble){
				$("#email").focus();
				focusble = false;
			}
			confirmcheck = confirmcheck + 1;
			alery("이메일을 입력해 주세요.");
			return false;
		}else{
			re=/^[0-9a-zA-Z]([\-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([\-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,4}$/;
			if(!re.test(email)){
				if(focusble){
					$("#email").focus();
					focusble = false;
				}
				confirmcheck += confirmcheck +1;
				alert("정상적인 이메일을 입력해 주세요.");
				return false;
			}
			
		}
		if(confirmcheck == 0){
			var formdata = $('form').serializeArray();
			
			$.post("Login_ok.jsp", formdata)
			.done(function(response){
				console.log(response);
				var data = JSON.parse(response.trim());
				if (data.result == 1){
					alert(data.msg);
					document.location.replace(data.url);
				}else{
					alert(data.msg);
				}
			});
			
		}/* else{
			return false;
		}
		return false; */
	}
	$("#email").focus();
</script>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%
    String title = "회원가입화면";
    String keyword ="jsp,java";
    String description ="jsp 프로그래밍";
    String subject ="jsp로 커뮤니티 만들기";
    String author ="Sojung";
    %>
<%@ include file ="Header.jsp" %>
<div class ="container">
	<form name = "form" action ="Register_ok.jsp" method = "post" onsubmit="return check_ok();">
	<div class = "form-input">
		<label class = "field" for ="name">이름</label>
		<input type = "text" id = "name" name = "name" class ="form-control">
	</div>
	<div class = "form-input">
		<label class = "field" for="email">이메일</label>
		<input type ="email" id="email" name = "email" class = "form-control">
	</div>
	<div class = "form-input">
		<label class = "field" for="password1">비밀번호</label>
		<input type ="password" id="password1" name = "password1" class = "form-control">
	</div>
	<div class="form-input">
		<label class="field" for="password2">비밀번호 확인</label>
		<input type="password" id="password2" name="password2" class="form-control">
	</div>
	<div class ="form-input">
		<label class="field">선호 언어</label>
		<input type="checkbox" name = "favorite" class ="form-control" value ='1'>java
		<input type="checkbox" name = "favorite" class ="form-control" value ='2'>c++
		<input type="checkbox" name = "favorite" class ="form-control" value ='3'>Python
		<input type="checkbox" name = "favorite" class ="form-control" value ='4'>Php
	</div>
	<div  class ="form-input">
		<label class="field">성별</label>
		<input type="radio" name = "gender" class ="form-control" value ="M">남
		<input type="radio" name = "gender" class ="form-control" value ="W">여
		
	</div>
	<div class = "buttons">
		<button class= "button">확인</button>
	</div>
</form>
</div>
<%@ include file ="Footer.jsp" %>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script>
function check_ok() {
	var confirmcheck = 0;
	var focusble = true;
	
	var name = $.trim($("#name").val());			
	var email = $.trim($("#email").val());
	var password1 = $.trim($("#password1").val());	
	var password2 = $.trim($("#password2").val());	
		
	if(name=="") {		
		if(focusble) {
			$("#name").focus();
			focusble = false;
		}
		confirmcheck = confirmcheck + 1;
		alert("이름을 입력해 주세요.");
		return false;
	} 

	
	if (email=="") {		
		if(focusble) {
			$("#email").focus();
			focusble = false;
		}
		confirmcheck = confirmcheck + 1;
		alert("이메일을 입력해 주세요.");
		return false;
	} else {		
		re=/^[0-9a-zA-Z]([\-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([\-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,4}$/; 
		if(!re.test(email)) {
			if(focusble) {
				$("#email").focus();
				focusble = false;
			}
			confirmcheck = confirmcheck + 1;
			alert("정상적인 이메일을 입력해 주세요.");
			return false;
		} 
	}

	if(password1=="") {
		if(focusble) {
			$("#password1").focus();
			focusble = false;
		}
		confirmcheck = confirmcheck + 1;
		alert("비밀번호를 입력해 주세요.");
		return false;
	} 

	if(password2=="") {
		if(focusble) {
			$("#password2").focus();
			focusble = false;
		}
		confirmcheck = confirmcheck + 1;
		alert("비밀번호 확인을 입력해 주세요.");
		return false;
	} else {
		if(password1 != password2) {
			if(focusble) {
				$("#password2").focus();
				focusble = false;
			}
			confirmcheck = confirmcheck + 1;
			alert("비밀번호가 일치하지 않습니다.");
			return false;
		} 
	}


	if(confirmcheck==0) {
		var formdata = $('form').serializeArray();
		$.post("Register_ok.jsp", formdata)
		  .done(function( response ) {
			  console.log(response);
			var data = JSON.parse(response.trim());
			 if (data.result==1) {
				 alert(data.msg);
	                if(focusble) {
	                     $("#email").focus();
	                     focusble = false;
	                  }
	                return false;

				 //document.location.replace(data.url);
			 } else {
				 alert(data.msg);
				 document.location.replace(data.url);
				 
			 }
		  });		
	/*  else {
		return false;
	}

	return false;
} */
</script>

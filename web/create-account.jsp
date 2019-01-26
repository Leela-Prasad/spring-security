<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<html>
   <head>
   	<title>New User Registration</title>
   	<link href="<c:url value="/styles.css"/>" rel="Stylesheet" type="text/css"/>   
   </head>

   <body>
	  <jsp:include page="/header.jsp"/>

	  <div id="addBook">
		  <form:form commandName="userFormObject">
		  
	         <label>Enter Username</label><form:input path="username"/>	  
	                                      <form:errors path="username" cssClass="error"/>  
	                    
	         <label>Enter Password</label> <form:password path="password"/>
	         		                    <form:errors path="password" cssClass="error"/>  
	
	         <input type="submit" value="Create New Account"/>
	      </form:form>		   	  
      </div>
            
      <jsp:include page="/footer.jsp"/>
   </body>
</html>

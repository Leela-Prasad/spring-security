package com.virtualpairprogrammers.security;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

public class UsernameAndPasswordFailureHandler implements AuthenticationFailureHandler {

	private UsernamePasswordAuthenticationFilter filter;
	
	public void setFilter(UsernamePasswordAuthenticationFilter filter) {
		this.filter = filter;
	}

	@Override
	public void onAuthenticationFailure(HttpServletRequest request, HttpServletResponse response, 
			AuthenticationException exception) throws IOException, ServletException {
		
		//String username = request.getParameter("vppUsername");
		response.getWriter().println("Username :" + filter.getUsernameParameter());
		String username = request.getParameter(filter.getUsernameParameter());
		
		
		response.sendRedirect(request.getContextPath() + "/login.jsp?error&username="+username);
	}

}

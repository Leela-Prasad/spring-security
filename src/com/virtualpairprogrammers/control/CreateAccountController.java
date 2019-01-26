package com.virtualpairprogrammers.control;

import java.util.ArrayList;
import java.util.List;

import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.provisioning.JdbcUserDetailsManager;
import org.springframework.stereotype.Controller;
import org.springframework.validation.Errors;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.virtualpairprogrammers.domain.UserFormObject;

@Controller
@RequestMapping("/createAccount")
public class CreateAccountController {

	@Autowired
	private JdbcUserDetailsManager userManager;
	
	@Autowired
	@Qualifier("vppAuthenticator")
	private AuthenticationManager authManager;
	
	@RequestMapping(method=RequestMethod.GET)
	public ModelAndView showForm() {
		return new ModelAndView("create-account","userFormObject", new UserFormObject());
	}
	
	@RequestMapping(method=RequestMethod.POST)
	public ModelAndView processForm(@Valid UserFormObject newUser, Errors results) {
		if(results.hasErrors())
			return new ModelAndView("create-account","userFormObject", newUser);
		
		List<GrantedAuthority> roles = new ArrayList<>();
		roles.add(new SimpleGrantedAuthority("ROLE_USER"));
		User user = new User(newUser.getUsername(),newUser.getPassword(),roles);
		try {
			userManager.createUser(user);
		}catch(DuplicateKeyException e) {
			results.rejectValue("username", "username.unique");
			return new ModelAndView("create-account","userFormObject", newUser);
		}
		
		Authentication authenticationToken = new UsernamePasswordAuthenticationToken(user.getUsername(),user.getPassword());
		Authentication credentials = authManager.authenticate(authenticationToken);
		if(credentials.isAuthenticated()) {
			//authManager.authenticate will generate new credentials which needs to 
			//be set in securitycontextholder so that it will login new user automatically
			SecurityContextHolder.getContext().setAuthentication(credentials);
			return new ModelAndView("redirect:/viewAllBooks.do");
		}else {
			throw new RuntimeException("Unable to login New User Automatically :(");
		}
	}
	
}

package com.cms.services;

import org.springframework.web.servlet.ModelAndView;

public interface LoginService {

	public String login(String userId, String password, int department);
	
	public void postLogin(String userId, ModelAndView view);

}

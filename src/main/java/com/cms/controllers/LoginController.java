package com.cms.controllers;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.cms.models.Employee;
import com.cms.services.LoginService;
import com.cms.util.RandomStringUtil;
import com.cms.util.ResponseMessages;

@Controller
public class LoginController {

	@Autowired
	private LoginService service;

	@RequestMapping(value = "/login", method = RequestMethod.POST)
	public ModelAndView loginUser(@RequestParam String userId,
			@RequestParam String password, @RequestParam int department,
			HttpServletResponse response) {
		ModelAndView modelAndView = new ModelAndView();
		String result = service.login(userId, password, department);
		modelAndView.addObject("response", result);
		if (result.equals(ResponseMessages.LOGIN_SUCCESSFUL)) {
			response.addCookie(new Cookie("System-Cookie", RandomStringUtil
					.getRandomCookieValue()));
			Cookie userIdCookie = new Cookie("userid", userId);
			userIdCookie.setMaxAge(24 * 60 * 60);

			response.addCookie(userIdCookie);
			service.postLogin(userId, modelAndView);
			Employee employee = (Employee) modelAndView.getModelMap().get(
					"employee_details");
			Cookie userNameCookie = new Cookie("user_name",
					employee.getEmployeeName());
			Cookie managerCookie = new Cookie("manager_id",
					employee.getManagerId());
			managerCookie.setMaxAge(24 * 60 * 60);
			userIdCookie.setMaxAge(24 * 60 * 60);
			response.addCookie(userNameCookie);
			response.addCookie(managerCookie);
		}

		return modelAndView;
	}

	@RequestMapping(value = "/logout", method = RequestMethod.GET)
	public ModelAndView logoutUser(@RequestParam String userId,

	HttpServletRequest request, HttpServletResponse response) {
		ModelAndView modelAndView = new ModelAndView();
		
		
			
			Cookie[] cookies = request.getCookies();
			for(Cookie cookie : cookies){
				cookie.setMaxAge(0);
				cookie.setValue("/");
				cookie.setPath("/");
				response.addCookie(cookie);
			}
		modelAndView.setViewName("index");

		return modelAndView;
	}

}

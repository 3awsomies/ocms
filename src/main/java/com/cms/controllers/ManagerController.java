package com.cms.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.cms.dao.EmployeeDao;
import com.cms.models.Position;

@Controller
public class ManagerController {
	
	@Autowired
	private EmployeeDao employeeDao;
	
	@RequestMapping(value = "/manager/create/position", method = RequestMethod.POST)
	public void createPosition(@RequestBody Position position){
		employeeDao.createPosition(position);
	}
	
	@RequestMapping(value = "/manager/save/recommendation/{text}/{positionId}", method = RequestMethod.POST)
	public void createPosition(@PathVariable String text, @PathVariable String positionId){
		employeeDao.insertHRRecommendations(text, positionId);
	}

}

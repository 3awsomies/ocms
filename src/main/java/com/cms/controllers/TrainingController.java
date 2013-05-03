package com.cms.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.cms.dao.EmployeeDao;
import com.cms.models.Training;

@Controller
public class TrainingController {
	@Autowired
	EmployeeDao employeeDao;
	
	@RequestMapping(value = "/create/training", method = RequestMethod.POST)
	public void createTraining(@ModelAttribute("training") Training training){
		employeeDao.createTraining(training);
	}

}

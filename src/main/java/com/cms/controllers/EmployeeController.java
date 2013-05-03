package com.cms.controllers;

import java.io.IOException;
import java.util.List;

import org.codehaus.jackson.JsonGenerationException;
import org.codehaus.jackson.map.JsonMappingException;
import org.codehaus.jackson.map.ObjectMapper;
import org.codehaus.jackson.node.ObjectNode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.cms.dao.EmployeeDao;
import com.cms.models.Employee;
import com.cms.models.Skill;
import com.cms.models.SkillRating;
import com.cms.models.UserSkillSet;

@Controller
public class EmployeeController {

	@Autowired
	private EmployeeDao employeeDao;

	@RequestMapping(value = "/create/employee", method = RequestMethod.POST)
	public ModelAndView createUser(@ModelAttribute("employee") Employee employee) {
		ModelAndView modelAndView = new ModelAndView();
		boolean flag = employeeDao.createUser(employee);
		if (flag) {
			modelAndView.setViewName("hrdepartment");
			modelAndView.addObject("message", "success");
		} else {
			modelAndView.addObject("message", "failed");
			modelAndView.setViewName("hrdepartment");
		}
		return modelAndView;
	}

	@RequestMapping(value = "/employee/skills/{employeeId}", method = RequestMethod.GET)
	@ResponseBody
	public String getEmployeeSkills(@PathVariable String employeeId)
			throws JsonGenerationException, JsonMappingException, IOException {
		ObjectMapper objectMapper = new ObjectMapper();
		ObjectNode objectNode = objectMapper.createObjectNode();
		List<SkillRating> skills = employeeDao.employeeSkills(employeeId);
		String data = objectMapper.writeValueAsString(skills);
		objectNode.put("skills", data);
		return objectNode.toString();
	}

	@RequestMapping(value = "/store/employee/skills", method = RequestMethod.POST)
	public String insertEmployeeSkillRatings(@RequestBody UserSkillSet userSkillSet ) {
		ObjectMapper objectMapper = new ObjectMapper();
		ObjectNode objectNode = objectMapper.createObjectNode();
		employeeDao.insertSkillSet(userSkillSet);
		objectNode.put("skills", "yoyo");
		return objectNode.toString();
	}
	
	@RequestMapping(value = "/edit/employee/skills", method = RequestMethod.POST)
	public String editEmployeeSkillRatings(@RequestBody UserSkillSet userSkillSet ) {
		ObjectMapper objectMapper = new ObjectMapper();
		ObjectNode objectNode = objectMapper.createObjectNode();
		employeeDao.editEmployeeSkills(userSkillSet);
		objectNode.put("skills", "yoyo");
		return objectNode.toString();
	}
	
	@RequestMapping(value = "/employee/skillset/{employeeId}", method = RequestMethod.GET)
	@ResponseBody
	public String getEmployeeSkillSet(@PathVariable String employeeId)
			throws JsonGenerationException, JsonMappingException, IOException {
		ObjectMapper objectMapper = new ObjectMapper();
		ObjectNode objectNode = objectMapper.createObjectNode();
		UserSkillSet userSkillSet = employeeDao.employeeSkillSet(employeeId);
		String data = objectMapper.writeValueAsString(userSkillSet.getSkills());
		objectNode.put("skillset", data);
		return objectNode.toString();
	}

}

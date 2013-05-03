package com.cms.dao;

import java.util.List;

import com.cms.models.Employee;
import com.cms.models.Position;
import com.cms.models.Skill;
import com.cms.models.SkillRating;
import com.cms.models.Training;
import com.cms.models.UserSkillSet;

public interface EmployeeDao {

	boolean createUser(Employee employee);
		
	public Employee getEmployeeDetails(String employeeId);
	
	public List<Employee> getTeamMembers(String managerId);
	
	public UserSkillSet employeeSkillSet(String employeeId);
	
	public List<SkillRating> employeeSkills(String employeeId);
	
	//public 
	
	public boolean insertSkillSet(UserSkillSet userSkillSet);
	
	public boolean createPosition(Position position);
	
	public List<Position> getListOfPositions();
	
	public boolean createTraining(Training training);
	
	public boolean insertHRRecommendations(String text, String positionId);
	
	public String getListOfRecommendations();
	
	public boolean editEmployeeSkills(UserSkillSet userSkillSet);

}

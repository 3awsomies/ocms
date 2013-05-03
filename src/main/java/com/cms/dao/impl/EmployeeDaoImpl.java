package com.cms.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.cms.dao.EmployeeDao;
import com.cms.models.Employee;
import com.cms.models.Position;
import com.cms.models.SkillRating;
import com.cms.models.Training;
import com.cms.models.UserSkillSet;
import com.cms.util.CommonUtil;
import com.cms.util.DbConnection;
import com.cms.util.RandomStringUtil;

public class EmployeeDaoImpl implements EmployeeDao {

	private static final String IS_USER_ALREADY_EXISTS = "select * from user_management where userId=";
	private static final String INSERT_NEW_USER = "insert into user_management (userId, password,departmentId) values(?,?,?)";
	private static final String INSERT_NEW_EMPLOYEE = "insert into employee_master (employee_id, email_id, designation, manager_id, employee_name, department) values(?,?,?,?,?,?)";
	private static final String SELECT_EMPLOYEE_DETAIL = "select * from employee_master where employee_id='";
	private static final String SELECT_MANAGER_TEAM_DETAIL = "select * from employee_master where manager_id='";
	private static final String SELECT_EMPLOYEE_SKILLS_RATINGS = "select * from employee_skills_rating where employeeId='";
	private static final String SELECT_EMPLOYEE_SKILLS = "select * from employee_skills_rating where employeeId='";
	private static final String INSERT_EMPLOYEE_SKILLS = "insert into employee_skills_rating (employeeId,skillId,ratingId,givenBy) values(?,?,?,?)";
	private static final String INSERT_POSITION = "insert into position_master (position_id,position_name,createdBy,status) values(?,?,?,?)";
	private static final String INSERT_POSITION_SKILL_RATING = "insert into position_skill_ratings (position_id,skill_id,rating_id) values(?,?,?)";
	private static final String SELECT_ALL_PROJECTS = "select * from position_master";
	private static final String INSERT_TRAINING = "insert into training_master (training_name, skill_id, rating_id) values(?,?,?)";
	private static final String INSERT_HR_RECOMMENDATIONS = "update position_master set hr_recommendations='";
	private static final String SELECT_PROJECTS_FOR_TRAINING = "select * from position_master where status='OPEN' and hr_recommendations is not null";
	private static final String INSERT_SKILL_SCORE = "insert into employee_skill_rating_score (employee_id, skill_id, score) values(?,?,?)";
	private static final String UPDATE_SKILL_SCORE = "update employee_skills_rating_score set score=";
	private static final String SELECT_SKILL_SCORE = "select score from employee_skills_rating_score where employee_id='";
	private static final String UPDATE_EMPLOYEE_SKILL_RATING = "update employee_skills_rating set ratingId=";
	private static final Log m_logger = LogFactory
			.getLog(EmployeeDaoImpl.class);

	public boolean isUserAlreadyExists(String userId) {
		Connection connection = new DbConnection().getConnection();
		ResultSet resultSet = null;
		boolean flag = false;
		Statement statement = null;
		try {
			statement = connection.createStatement();
			resultSet = statement.executeQuery(IS_USER_ALREADY_EXISTS + userId);
			if (resultSet.next())
				flag = true;
		} catch (SQLException e) {
			m_logger.error(e.getMessage(), e);
		} finally {
			try {
				if (connection != null)
					connection.close();
				if (resultSet != null)
					resultSet.close();
				if (statement != null)
					statement.close();
			} catch (SQLException e) {
				m_logger.error(e.getMessage(), e);
			}
		}
		return flag;
	}

	public boolean createUser(Employee employee) {
		Connection connection = new DbConnection().getConnection();
		PreparedStatement preparedStatement = null;
		boolean flag = false;
		boolean isUserAlreadyExists = isUserAlreadyExists(employee
				.getEmployeeId());
		if (!isUserAlreadyExists) {
			String password = RandomStringUtil.getDefaultPasswordString();
			try {
				preparedStatement = connection
						.prepareStatement(INSERT_NEW_USER);
				preparedStatement.setString(1, employee.getEmployeeId());
				preparedStatement.setString(2, password);
				preparedStatement.setInt(3, employee.getDepartment());
				preparedStatement.executeUpdate();
				flag = true;
				addEmployeeDetails(employee);
			} catch (SQLException e) {
				m_logger.error(e.getMessage(), e);
			} finally {
				try {
					if (connection != null)
						connection.close();
					if (preparedStatement != null)
						preparedStatement.close();
				} catch (SQLException e) {
					m_logger.error(e.getMessage(), e);
				}
			}
		}
		return flag;
	}

	public void addEmployeeDetails(Employee employee) {
		Connection connection = new DbConnection().getConnection();
		PreparedStatement preparedStatement = null;

		try {
			preparedStatement = connection
					.prepareStatement(INSERT_NEW_EMPLOYEE);
			preparedStatement.setString(1, employee.getEmployeeId());
			preparedStatement.setString(2, employee.getEmailId());
			preparedStatement.setString(3, employee.getDesignation());
			preparedStatement.setString(4, employee.getManagerId());
			preparedStatement.setString(5, employee.getEmployeeName());
			preparedStatement.setInt(6, employee.getDepartment());
			preparedStatement.executeUpdate();
		} catch (SQLException e) {
			m_logger.error(e.getMessage(), e);
		} finally {
			try {
				if (connection != null)
					connection.close();
				if (preparedStatement != null)
					preparedStatement.close();
			} catch (SQLException e) {
				m_logger.error(e.getMessage(), e);
			}
		}
	}

	public Employee getEmployeeDetails(String employeeId) {
		String uniqueUserSql = SELECT_EMPLOYEE_DETAIL + employeeId + "'";
		Connection connection = new DbConnection().getConnection();
		Employee employee = new Employee();
		ResultSet resultSet = null;
		Statement statement = null;
		try {
			statement = connection.createStatement();
			resultSet = statement.executeQuery(uniqueUserSql);
			while (resultSet.next()) {
				String employeeName = resultSet.getString("employee_name");
				String email_id = resultSet.getString("email_id");
				String designation = resultSet.getString("designation");
				String manager_id = resultSet.getString("manager_id");
				int deptt = resultSet.getInt("department");
				employee.setDesignation(designation);
				employee.setEmailId(email_id);
				employee.setEmployeeId((employeeId));
				employee.setManagerId((manager_id));
				employee.setEmployeeName(employeeName);
				employee.setEmployeeId(employeeId);
				employee.setDepartment(deptt);
			}

		} catch (SQLException e) {
			m_logger.error(e.getMessage(), e);
		} finally {
			try {
				if (connection != null)
					connection.close();
				if (resultSet != null)
					resultSet.close();
				if (statement != null)
					statement.close();
			} catch (SQLException e) {
				m_logger.error(e.getMessage(), e);
			}
		}
		return employee;
	}

	public List<Employee> getTeamMembers(String managerId) {
		String uniqueUserSql = SELECT_MANAGER_TEAM_DETAIL + managerId + "'";
		Connection connection = new DbConnection().getConnection();
		List<Employee> teamMembers = new ArrayList<Employee>();
		ResultSet resultSet = null;
		Statement statement = null;
		try {
			statement = connection.createStatement();
			resultSet = statement.executeQuery(uniqueUserSql);

			while (resultSet.next()) {
				Employee employee = new Employee();
				String employeeName = resultSet.getString("employee_name");
				String employeeId = resultSet.getString("employee_id");
				String email_id = resultSet.getString("email_id");
				String designation = resultSet.getString("designation");
				String manager_id = resultSet.getString("manager_id");
				int deptt = resultSet.getInt("department");
				employee.setDesignation(designation);
				employee.setEmailId(email_id);
				employee.setManagerId((manager_id));
				employee.setEmployeeName(employeeName);
				employee.setEmployeeId(employeeId);
				employee.setDepartment(deptt);
				if (!employee.getEmployeeId().equals(manager_id))
					teamMembers.add(employee);
			}

		} catch (SQLException e) {
			m_logger.error(e.getMessage(), e);
		} finally {
			try {
				if (connection != null)
					connection.close();
				if (resultSet != null)
					resultSet.close();
				if (statement != null)
					statement.close();
			} catch (SQLException e) {
				m_logger.error(e.getMessage(), e);
			}
		}
		return teamMembers;

	}

	@Override
	public UserSkillSet employeeSkillSet(String employeeId) {
		UserSkillSet userSkillSet = new UserSkillSet();
		String sql = SELECT_EMPLOYEE_SKILLS_RATINGS + employeeId
				+ "' order by givenBy, skillId";
		Connection connection = new DbConnection().getConnection();
		// Map<String, Map<String, Integer>> completeDataDet = new
		// HashMap<String, Map<String, Integer>>();
		List<SkillRating> skillRatings = new ArrayList<SkillRating>();
		ResultSet resultSet = null;
		Statement statement = null;
		try {
			statement = connection.createStatement();
			resultSet = statement.executeQuery(sql);

			while (resultSet.next()) {
				SkillRating skillRating = new SkillRating();
				int skillId = resultSet.getInt(2);
				String skillName = CommonUtil.getSkillName(skillId);
				String givenBy = resultSet.getString(4);
				int ratingId = resultSet.getInt(3);
				skillRating.setGivenBy(givenBy);
				skillRating.setRatingId(ratingId);
				skillRating.setSkillId(skillId);
				skillRating.setSkillName(CommonUtil.getSkillName(skillId));
				skillRatings.add(skillRating);
				/*
				 * Map<String, Integer> skillRatingMap = null; if
				 * (!completeDataDet.containsKey(givenBy)){ skillRatingMap = new
				 * HashMap<String, Integer>(); completeDataDet.put(givenBy,
				 * skillRatingMap); } skillRatingMap =
				 * completeDataDet.get(givenBy); if
				 * (!skillRatingMap.containsKey(skillName)) {
				 * skillRatingMap.put(skillName, ratingId); }
				 */

			}
		} catch (SQLException e) {
			m_logger.error(e.getMessage(), e);
		} finally {
			try {
				if (connection != null)
					connection.close();
				if (resultSet != null)
					resultSet.close();
				if (statement != null)
					statement.close();
			} catch (SQLException e) {
				m_logger.error(e.getMessage(), e);
			}
		}
		userSkillSet.setSkills(skillRatings);
		userSkillSet.setUserId(employeeId);
		return userSkillSet;
	}

	@Override
	public List<SkillRating> employeeSkills(String employeeId) {
		String sql = SELECT_EMPLOYEE_SKILLS + employeeId + "' AND givenBy ='"
				+ employeeId + "'";
		List<SkillRating> skills = new ArrayList<SkillRating>();
		Connection connection = new DbConnection().getConnection();
		ResultSet resultSet = null;
		Statement statement = null;
		try {
			statement = connection.createStatement();
			resultSet = statement.executeQuery(sql);

			while (resultSet.next()) {
				SkillRating skill = new SkillRating();
				int skillId = resultSet.getInt("skillId");
				int ratingId = resultSet.getInt("ratingId");
				String skillName = CommonUtil.getSkillName(skillId);
				skill.setSkillId(skillId);
				skill.setSkillName(skillName);
				skill.setRatingId(ratingId);
				skill.setGivenBy(employeeId);
				skills.add(skill);
			}

		} catch (SQLException e) {
			m_logger.error(e.getMessage(), e);
		} finally {
			try {
				if (connection != null)
					connection.close();
				if (resultSet != null)
					resultSet.close();
				if (statement != null)
					statement.close();
			} catch (SQLException e) {
				m_logger.error(e.getMessage(), e);
			}
		}

		return skills;
	}

	public boolean insertSkillSet(UserSkillSet userSkillSet) {
		Connection connection = new DbConnection().getConnection();
		PreparedStatement preparedStatement = null;
		boolean flag = false;
		List<SkillRating> skillRatings = userSkillSet.getSkills();
		Iterator<SkillRating> iterator = skillRatings.iterator();
		try {
			while (iterator.hasNext()) {
				SkillRating skillRating = iterator.next();
				preparedStatement = connection
						.prepareStatement(INSERT_EMPLOYEE_SKILLS);
				preparedStatement.setString(1, userSkillSet.getUserId());
				preparedStatement.setInt(2,
						CommonUtil.getSkillId(skillRating.getSkillName()));
				preparedStatement.setInt(3, skillRating.getRatingId());
				preparedStatement.setString(4, skillRating.getGivenBy());
				preparedStatement.executeUpdate();
				String employeeId = userSkillSet.getUserId();
				String givenBy = skillRating.getGivenBy();
				if (employeeId.equals(givenBy))
					insertSkillScore(employeeId, skillRating.getSkillName(),
							skillRating.getRatingId());
				else
					updateSkillScore(employeeId, skillRating.getSkillName(),
							skillRating.getRatingId());
			}

			flag = true;
		} catch (SQLException e) {
			m_logger.error(e.getMessage(), e);
		} finally {
			try {
				if (connection != null)
					connection.close();
				if (preparedStatement != null)
					preparedStatement.close();
			} catch (SQLException e) {
				m_logger.error(e.getMessage(), e);
			}
		}
		return flag;
	}

	@Override
	public boolean createPosition(Position position) {
		String sql = INSERT_POSITION;
		Connection connection = new DbConnection().getConnection();
		PreparedStatement preparedStatement = null;
		boolean flag = false;
		String positionId = position.getPositionId();
		String positionName = position.getPositionName();
		String createdBy = position.getCreatedBy();
		String status = "OPEN";
		try {
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, positionId);
			preparedStatement.setString(2, positionName);
			preparedStatement.setString(3, createdBy);
			preparedStatement.setString(4, status);
			preparedStatement.executeUpdate();
			flag = true;
			addPositionDetails(position);
		} catch (SQLException e) {
			m_logger.error(e.getMessage(), e);
		} finally {
			try {
				if (connection != null)
					connection.close();
				if (preparedStatement != null)
					preparedStatement.close();
			} catch (SQLException e) {
				m_logger.error(e.getMessage(), e);
			}
		}

		return flag;
	}

	private boolean addPositionDetails(Position position) {
		String sql = INSERT_POSITION_SKILL_RATING;
		Connection connection = new DbConnection().getConnection();
		PreparedStatement preparedStatement = null;
		boolean flag = false;
		String positionid = position.getPositionId();
		List<SkillRating> skillRatings = position.getRequiredSkillRatings();
		Iterator<SkillRating> iterator = skillRatings.iterator();
		try {
			while (iterator.hasNext()) {
				SkillRating skillRating = iterator.next();
				preparedStatement = connection.prepareStatement(sql);
				preparedStatement.setString(1, positionid);
				preparedStatement.setInt(2,
						CommonUtil.getSkillId(skillRating.getSkillName()));
				preparedStatement.setInt(3, skillRating.getRatingId());
				preparedStatement.executeUpdate();
			}

			flag = true;
		} catch (SQLException e) {
			m_logger.error(e.getMessage(), e);
		} finally {
			try {
				if (connection != null)
					connection.close();
				if (preparedStatement != null)
					preparedStatement.close();
			} catch (SQLException e) {
				m_logger.error(e.getMessage(), e);
			}
		}
		return flag;
	}

	public List<Position> getListOfPositions() {
		List<Position> positions = new ArrayList<Position>();
		ResultSet resultSet = null;
		Statement statement = null;
		Connection connection = new DbConnection().getConnection();
		try {
			statement = connection.createStatement();
			resultSet = statement.executeQuery(SELECT_ALL_PROJECTS);

			while (resultSet.next()) {
				Position position = new Position();
				String positionId = resultSet.getString("position_id");
				String projectName = resultSet.getString("position_name");
				String projectStatus = resultSet.getString("status");
				String createdBy = resultSet.getString("createdBy");
				String recommendations = resultSet
						.getString("hr_recommendations");
				if (recommendations == null)
					recommendations = "";
				position.setCreatedBy(createdBy);
				position.setPositionId(positionId);
				position.setPositionName(projectName);
				position.setStatus(projectStatus);
				position.setRecommendation(recommendations);
				positions.add(position);
			}

		} catch (SQLException e) {
			m_logger.error(e.getMessage(), e);
		} finally {
			try {
				if (connection != null)
					connection.close();
				if (resultSet != null)
					resultSet.close();
				if (statement != null)
					statement.close();
			} catch (SQLException e) {
				m_logger.error(e.getMessage(), e);
			}
		}

		return positions;
	}

	@Override
	public boolean createTraining(Training training) {
		Connection connection = new DbConnection().getConnection();
		PreparedStatement preparedStatement = null;
		boolean flag = false;

		try {
			preparedStatement = connection.prepareStatement(INSERT_TRAINING);
			preparedStatement.setString(1, training.getTrainingName());
			preparedStatement.setInt(2,
					CommonUtil.getSkillId(training.getSkillName()));
			preparedStatement.setInt(3, training.getRatingId());
			preparedStatement.executeUpdate();
			flag = true;
		} catch (SQLException e) {
			m_logger.error(e.getMessage(), e);
		} finally {
			try {
				if (connection != null)
					connection.close();
				if (preparedStatement != null)
					preparedStatement.close();
			} catch (SQLException e) {
				m_logger.error(e.getMessage(), e);
			}
		}

		return flag;
	}

	@Override
	public boolean insertHRRecommendations(String text, String positionId) {
		String sql = INSERT_HR_RECOMMENDATIONS + text + "' where position_id='"
				+ positionId + "'";
		Connection connection = new DbConnection().getConnection();
		PreparedStatement preparedStatement = null;
		boolean flag = false;

		try {
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.executeUpdate();
			flag = true;
		} catch (SQLException e) {
			m_logger.error(e.getMessage(), e);
		} finally {
			try {
				if (connection != null)
					connection.close();
				if (preparedStatement != null)
					preparedStatement.close();
			} catch (SQLException e) {
				m_logger.error(e.getMessage(), e);
			}
		}

		return flag;
	}

	@Override
	public String getListOfRecommendations() {
		String sql = SELECT_PROJECTS_FOR_TRAINING;
		List<Position> positions = new ArrayList<Position>();
		ResultSet resultSet = null;
		Statement statement = null;
		Connection connection = new DbConnection().getConnection();
		try {
			statement = connection.createStatement();
			resultSet = statement.executeQuery(sql);

			while (resultSet.next()) {
				Position position = new Position();
				String positionId = resultSet.getString("position_id");
				String projectName = resultSet.getString("position_name");
				String projectStatus = resultSet.getString("status");
				String createdBy = resultSet.getString("createdBy");
				String recommendations = resultSet
						.getString("hr_recommendations");
				if (recommendations == null)
					recommendations = "";
				position.setCreatedBy(createdBy);
				position.setPositionId(positionId);
				position.setPositionName(projectName);
				position.setStatus(projectStatus);
				position.setRecommendation(recommendations);
				positions.add(position);
			}

		} catch (SQLException e) {
			m_logger.error(e.getMessage(), e);
		} finally {
			try {
				if (connection != null)
					connection.close();
				if (resultSet != null)
					resultSet.close();
				if (statement != null)
					statement.close();
			} catch (SQLException e) {
				m_logger.error(e.getMessage(), e);
			}
		}
		processProjectsForTraining(positions);
		return null;
	}

	private void processProjectsForTraining(List<Position> positions) {
		Iterator<Position> iterator = positions.iterator();
		while (iterator.hasNext()) {
			Position position = iterator.next();
			String managerId = position.getCreatedBy();
			List<SkillRating> projectSkillRatings = position
					.getRequiredSkillRatings();
			List<Employee> team = getTeamMembers(managerId);
			for (SkillRating skillRating : projectSkillRatings) {
				String skillName = skillRating.getSkillName();
				int skillId = skillRating.getSkillId();
				int ratingId = skillRating.getRatingId();
				for (Employee employee : team) {
					String employeeId = employee.getEmployeeId();
					List<SkillRating> employeeSkillRatings = employeeSkills(employeeId);
				}
			}
		}
	}

	public boolean insertSkillScore(String employeeId, String skillName,
			int ratingId) {
		String sql = INSERT_SKILL_SCORE;
		Connection connection = new DbConnection().getConnection();
		PreparedStatement preparedStatement = null;
		boolean flag = false;

		try {
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, employeeId);
			preparedStatement.setInt(2, CommonUtil.getSkillId(skillName));
			preparedStatement.setInt(3, ratingId);
			preparedStatement.executeUpdate();
			flag = true;
		} catch (SQLException e) {
			m_logger.error(e.getMessage(), e);
		} finally {
			try {
				if (connection != null)
					connection.close();
				if (preparedStatement != null)
					preparedStatement.close();
			} catch (SQLException e) {
				m_logger.error(e.getMessage(), e);
			}
		}

		return flag;
	}

	public boolean updateSkillScore(String employeeId, String skillName,
			int ratingId) {
		String sql = SELECT_SKILL_SCORE + employeeId + "' and skill_id="
				+ CommonUtil.getSkillId(skillName);
		Connection connection = new DbConnection().getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		Statement statement = null;
		int rating_Id = 0;
		boolean flag = false;

		try {

			statement = connection.createStatement();
			resultSet = statement.executeQuery(sql);

			while (resultSet.next()) {
				rating_Id = resultSet.getInt("rating_id");
			}
			rating_Id = Math.round((rating_Id + ratingId) / 2);
			sql = UPDATE_SKILL_SCORE + rating_Id + " where employee_id='"
					+ employeeId + "' and skill_id="
					+ CommonUtil.getSkillId(skillName);
			preparedStatement = connection.prepareStatement(sql);

			preparedStatement.executeQuery();
			flag = true;
		} catch (SQLException e) {
			m_logger.error(e.getMessage(), e);
		} finally {
			try {
				if (connection != null)
					connection.close();
				if (preparedStatement != null)
					preparedStatement.close();
			} catch (SQLException e) {
				m_logger.error(e.getMessage(), e);
			}
		}

		return flag;
	}

	@Override
	public boolean editEmployeeSkills(UserSkillSet userSkillSet) {
		String userid = userSkillSet.getUserId();
		List<SkillRating> updateList = userSkillSet.getSkills();
		Connection connection = new DbConnection().getConnection();
		PreparedStatement preparedStatement = null;
		boolean flag = false;
		try {
			Iterator<SkillRating> iterator = updateList.iterator();
			while (iterator.hasNext()) {
				SkillRating skillRating = iterator.next();
				int skillId = CommonUtil.getSkillId(skillRating.getSkillName());
				int ratingId = skillRating.getRatingId();
				String givenBy = userid;
				String sql = UPDATE_EMPLOYEE_SKILL_RATING + ratingId
						+ " where employeeId='" + userid + "' and skillId="
						+ skillId + " and givenBy='" + givenBy +"'";
				preparedStatement = connection.prepareStatement(sql);
				preparedStatement.executeUpdate();
			}
			flag = true;
		} catch (SQLException e) {
			m_logger.error(e.getMessage(), e);
		} finally {
			try {
				if (connection != null)
					connection.close();
				if (preparedStatement != null)
					preparedStatement.close();
			} catch (SQLException e) {
				m_logger.error(e.getMessage(), e);
			}
		}
		return flag;
	}

}

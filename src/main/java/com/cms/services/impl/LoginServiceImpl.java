package com.cms.services.impl;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.ModelAndView;

import com.cms.dao.EmployeeDao;
import com.cms.models.User;
import com.cms.services.LoginService;
import com.cms.util.CommonUtil;
import com.cms.util.DbConnection;
import com.cms.util.ResponseMessages;

public class LoginServiceImpl implements LoginService {

	private static final String IS_USER_EXISTS = "select * from user_management where userId ='";
	private User m_user;
	
	@Autowired
	private EmployeeDao employeeDao;

	private static Log m_logger = LogFactory.getLog(LoginServiceImpl.class);

	public String login(String userId, String password, int department) {
		User user = validateUser(userId);
		if (user == null) {
			m_logger.debug("userId " + userId + " is not valid");
			return ResponseMessages.USER_DOES_NOT_EXIST;
		}
		if (!password.equals(user.getPassword())) {
			m_logger.debug("password for " + userId + " not matched");
			return ResponseMessages.PASSWORD_NOT_MATCHED;
		}
		if (department != user.getDepartment()) {
			m_logger.debug("department for " + userId + " not successful");
			return ResponseMessages.DEPARTMENT_NOT_MATCHED;
		}
		setUser(user);
		return ResponseMessages.LOGIN_SUCCESSFUL;
	}

	public User validateUser(String userId) {
		User user = null;
		Connection connection = (new DbConnection()).getConnection();
		try {
			Statement statement = connection.createStatement();
			String sql = IS_USER_EXISTS + userId + "'";
			ResultSet resultSet = statement.executeQuery(sql);
			if (resultSet.next()) {
				user = new User();
				String password = resultSet.getString("password");
				int department = resultSet.getInt("departmentId");
				user.setUserId(userId);
				user.setPassword(password);
				user.setDepartment(department);
			}
		} catch (SQLException e) {
			m_logger.error(e.getMessage(), e);
		}
		return user;
	}

	public void postLogin(String userId, ModelAndView view) {
		int deptId = m_user.getDepartment();
		String viewName = null;
		if (deptId == 10)
			viewName = "employee";
		else if (deptId == 20)
			viewName = "manager";
		else if (deptId == 30)
			viewName = "hrdepartment";
		else if(deptId == 40)
			viewName = "training";
		view.setViewName(viewName);
		view.addObject("user_details", m_user);
		view.addObject("employee_details", employeeDao.getEmployeeDetails(userId));
		new CommonUtil();
	}

	/**
	 * @return the m_user
	 */
	public User getUser() {
		return m_user;
	}

	/**
	 * @param m_user
	 *            the m_user to set
	 */
	public void setUser(User user) {
		this.m_user = user;
	}

}

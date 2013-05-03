package com.cms.util;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

public class CommonUtil {

	private static Map<Integer, String> ratingsMap;
	private static Map<Integer, String> skillsMap;
	private static final String SELECT_ALL_RATINGS = "SELECT * FROM skill_ratings";
	private static final String SELECT_ALL_SKILLS = "SELECT * FROM skill_master";
	private static List<String> skills;
	private static List<String> ratings;
	private static Log m_logger = LogFactory.getLog(CommonUtil.class);

	public CommonUtil() {
		if (ratingsMap == null) {
			ratingsMap = new HashMap<Integer, String>();
			populateRatingMap();
		}
		if (skillsMap == null) {
			skillsMap = new HashMap<Integer, String>();
			populateSkillMap();
		}
	}

	public void populateSkillMap() {
		Connection connection = new DbConnection().getConnection();
		ResultSet resultSet = null;
		Statement statement = null;
		try {
			statement = connection.createStatement();
			resultSet = statement.executeQuery(SELECT_ALL_SKILLS);
			while (resultSet.next()) {

				int skillId = resultSet.getInt("skill_Id");
				String skillName = resultSet.getString("skill_name");
				skillsMap.put(skillId, skillName);
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
	}

	public void populateRatingMap() {
		Connection connection = new DbConnection().getConnection();
		ResultSet resultSet = null;
		Statement statement = null;
		try {
			statement = connection.createStatement();
			resultSet = statement.executeQuery(SELECT_ALL_RATINGS);
			while (resultSet.next()) {

				int ratingId = resultSet.getInt("ratingId");
				String description = resultSet.getString("description");
				ratingsMap.put(ratingId, description);
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

	}

	public static String getSkillName(int skillId) {
		return skillsMap.get(skillId);
	}
	
	public static int getSkillId(String skillName) {
		Iterator<Integer> iterator = skillsMap.keySet().iterator();
		int skillId = 0;
		while(iterator.hasNext()){
			int key = iterator.next();
			String value = skillsMap.get(key);
			if(value.equals(skillName))
				skillId = key;
		}
		return skillId;
	}

	public static String getRatingDescription(int ratingId) {
		return ratingsMap.get(ratingId);
	}

	public static Set<Integer> getAllRatings() {
		return ratingsMap.keySet();
	}

	public static List<String> getAllSkills() {
		Collection<String> skis = skillsMap.values();
		if (skills == null)
			skills = new ArrayList<String>(skis);
		return skills;
	}

	public static List<String> getAllRatingDescriptions() {
		Collection<String> skis = ratingsMap.values();
		if (ratings == null)
			ratings = new ArrayList<String>(skis);
		return ratings;
	}

}

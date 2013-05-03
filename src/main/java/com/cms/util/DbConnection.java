package com.cms.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

public class DbConnection {

	private static final String DRIVER = "db.driverName";
	private static final String CLASS_NAME = "db.className";
	private static final String DATA_SOURCE = "db.datasource";

	private static Log m_logger = LogFactory.getLog(DbConnection.class);

	public Connection getConnection() {
		Connection connection = null;
		DbConfiguration dbConfiguration = new DbConfiguration();
		String driver = dbConfiguration.getDbProperty(DRIVER);
		String className = dbConfiguration.getDbProperty(CLASS_NAME);
		String datasurce = dbConfiguration.getDbProperty(DATA_SOURCE);
		m_logger.debug(driver + " ::: " + className + " ::: " + datasurce);
		try {
			Class.forName("com.mysql.jdbc.Driver");
			String url = driver + datasurce;
			m_logger.debug("url for db connection :: " + url);
			connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/ocms", "root", "root");
		} catch (ClassNotFoundException e) {
			m_logger.error(e.getMessage(), e);
		} catch (SQLException e) {
			m_logger.error(e.getMessage(), e);
		}
		return connection;
	}

}

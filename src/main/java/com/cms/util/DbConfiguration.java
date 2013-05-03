package com.cms.util;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.Properties;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

public class DbConfiguration {

	private static final String DB_CONFIGURATION_FILE = "db.properties";
	private static Log m_logger = LogFactory.getLog(DbConfiguration.class);

	public String getDbProperty(String key) {
		Properties properties = new Properties();
		try {
			FileInputStream fileInputStream = new FileInputStream(
					getClass().getClassLoader().getResource(".").getPath() + File.separator
							+ "resources" + File.separator
							+ DB_CONFIGURATION_FILE);

			properties.load(fileInputStream);
		} catch (IOException e) {
			m_logger.error(e.getMessage(), e);
		}
		String value = properties.getProperty(key);
		return value;
	}

}

package com.cms.util;

import org.apache.commons.lang3.RandomStringUtils;

public class RandomStringUtil {

	public static String getRandomCookieValue() {
		String random = RandomStringUtils.randomAlphanumeric(60);
		return random;
	}

	public static String getValidationString() {
		String random = RandomStringUtils.randomAlphanumeric(20);
		return random;
	}
	
	public static String getDefaultPasswordString() {
		String random = RandomStringUtils.randomAlphanumeric(8);
		return random;
	}
}

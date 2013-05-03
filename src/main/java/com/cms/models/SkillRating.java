package com.cms.models;

import java.io.Serializable;

import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement
public class SkillRating implements Serializable{
	
	private int skillId;
	private int ratingId;
	private String givenBy;
	private String skillName;
	
	/**
	 * @return the givenBy
	 */
	public String getGivenBy() {
		return givenBy;
	}
	/**
	 * @param givenBy the givenBy to set
	 */
	public void setGivenBy(String givenBy) {
		this.givenBy = givenBy;
	}
	
	
	/**
	 * @return the skillId
	 */
	public int getSkillId() {
		return skillId;
	}
	/**
	 * @param skillId the skillId to set
	 */
	public void setSkillId(int skillId) {
		this.skillId = skillId;
	}
	/**
	 * @return the ratingId
	 */
	public int getRatingId() {
		return ratingId;
	}
	/**
	 * @param ratingId the ratingId to set
	 */
	public void setRatingId(int ratingId) {
		this.ratingId = ratingId;
	}
	/* (non-Javadoc)
	 * @see java.lang.Object#toString()
	 */
	@Override
	public String toString() {
		return "SkillRating [ skillId=" + skillId
				+ ", ratingId=" + ratingId + ", givenBy=" + givenBy + "]";
	}
	/**
	 * @return the skillName
	 */
	public String getSkillName() {
		return skillName;
	}
	/**
	 * @param skillName the skillName to set
	 */
	public void setSkillName(String skillName) {
		this.skillName = skillName;
	}

}

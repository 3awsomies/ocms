package com.cms.models;

import java.io.Serializable;
import java.util.List;

import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement
public class Position implements Serializable{
	
	private String positionId;
	private String positionName;
	private String createdBy;
	private String status;
	private List<SkillRating> requiredSkillRatings;
	private String recommendation;
	/**
	 * @return the positionId
	 */
	public String getPositionId() {
		return positionId;
	}
	/**
	 * @param positionId the positionId to set
	 */
	public void setPositionId(String positionId) {
		this.positionId = positionId;
	}
	/**
	 * @return the positionName
	 */
	public String getPositionName() {
		return positionName;
	}
	/**
	 * @param positionName the positionName to set
	 */
	public void setPositionName(String positionName) {
		this.positionName = positionName;
	}
	/**
	 * @return the createdBy
	 */
	public String getCreatedBy() {
		return createdBy;
	}
	/**
	 * @param createdBy the createdBy to set
	 */
	public void setCreatedBy(String createdBy) {
		this.createdBy = createdBy;
	}
	/**
	 * @return the status
	 */
	public String getStatus() {
		return status;
	}
	/**
	 * @param status the status to set
	 */
	public void setStatus(String status) {
		this.status = status;
	}
	/**
	 * @return the requiredSkillRatings
	 */
	public List<SkillRating> getRequiredSkillRatings() {
		return requiredSkillRatings;
	}
	/**
	 * @param requiredSkillRatings the requiredSkillRatings to set
	 */
	public void setRequiredSkillRatings(List<SkillRating> requiredSkillRatings) {
		this.requiredSkillRatings = requiredSkillRatings;
	}
	/**
	 * @return the recommendation
	 */
	public String getRecommendation() {
		return recommendation;
	}
	/**
	 * @param recommendation the recommendation to set
	 */
	public void setRecommendation(String recommendation) {
		this.recommendation = recommendation;
	}
	
}

/*
Script Name: Covid 19 Data Exploration 
Author: Kiesha Lasquite
Date Created: 09 September 2024
Last Modified: 09 September 2024
Description: Data Exploration using SQL guided by Alex the Analyst.
				This script explores a dataset, performing data analysis 
				operations such as filtering, grouping, and ordering to identify insights. 
Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, 
				Creating Views, Converting Data Types
Parameters:
	Start Date: 01 January 2020
	End Date: 30 April 2021
Relevant links:
	a. Reference: 
		Data Analyst Portfolio Project | SQL Data Exploration | Project 1/4: https://www.youtube.com/watch?v=qfyynHBFOsM&list=PLUaB-1hjhk8H48Pj32z4GZgGWyylqv85f
	b. Data: 
		CovidDeaths: https://github.com/AlexTheAnalyst/PortfolioProjects/blob/main/CovidDeaths.xlsx
		CovidVaccinations: https://github.com/AlexTheAnalyst/PortfolioProjects/blob/main/CovidVaccinations.xlsx

*/
Select *
From PortfolioProject..CovidDeaths
order by 3,4  /*refers to ordering the results based on the third and fourth columns in the SELECT clause*/

Select *
From PortfolioProject..CovidVaccinations
order by 3,4
COVID-19 Data Analysis Project

This project involves analyzing COVID-19 data using SQLite. The database contains tables related to COVID-19 deaths and vaccinations. The provided SQL queries perform various analyses on the data, including death rates, vaccination rates, and population statistics. The results can be used to gain insights into the impact of COVID-19 across different countries, continents, and income levels.
Table of Contents

    Description
    Queries
    Views
    Usage

Description

The project aims to provide insights into the COVID-19 pandemic by analyzing data related to deaths and vaccinations. It utilizes an SQLite database containing tables for COVID-19 deaths (covid_deaths) and vaccinations (covid_vaccinations). The provided SQL queries offer various analyses, including:

    Calculating death rates by case and population.
    Analyzing vaccination rates.
    Comparing contraction and death rates across different countries, continents, and income levels.
    Creating views to store data for visualization purposes.

Queries

The SQL queries in this project cover a range of analyses, including:

    Total cases vs total deaths
    Contraction rate vs population
    Death rate vs population
    Percentage of vaccinated population

Views

Views are created to store the results of specific queries for easier access and visualization. The views include:

    Death rate by case
    Death rate by case in Germany
    Contraction rate in Germany
    Highest contraction and death rates by country
    Highest contraction and death rates by continent
    Highest contraction and death rates by income rate
    Contraction and death rates compared to worldwide population
    Total population and vaccinations in every country
    Increasing number of vaccinations in every country
    Increasing number of vaccinations in Germany
    Percentage of vaccinated population in every country


Note: Raw dataset can be found here: https://github.com/owid/covid-19-data/tree/master/public/data

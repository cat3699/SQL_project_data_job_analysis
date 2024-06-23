/* 
Question: What are the most optimal skills to learn, that is, it's high in demand 
            and high paying skill?
- Identify skills in high demand and associate with high average salaries for Data Analyst roles
- Concentrates on remote positions with specific salaries
- Why? Targets skills that offers job security and finantial benefits, offering strategic insights
        for careers developments in data analyst
*/

WITH skills_demand AS(
    SELECT 
        skills_dim.skill_id,
        skills_dim.skills,
        COUNT(skills_job_dim.job_id) AS demand_count
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
    WHERE 
        job_postings_fact.job_title_short = 'Data Analyst'
        AND salary_year_avg IS NOT NULL
        AND job_work_from_home = True
    GROUP BY 
        skills_dim.skill_id
), top_paying_skills AS(
    SELECT 
        skills_dim.skill_id,
        ROUND(AVG(salary_year_avg)) AS avg_salary
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
    WHERE 
        job_postings_fact.job_title_short = 'Data Analyst'
        AND salary_year_avg IS NOT NULL
        AND job_work_from_home = True
    GROUP BY 
        skills_dim.skill_id
)


SELECT 
    skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    avg_salary
FROM
    skills_demand
INNER JOIN top_paying_skills on skills_demand.skill_id = top_paying_skills.skill_id
WHERE demand_count > 10
ORDER BY demand_count DESC, avg_salary DESC
LIMIT 25
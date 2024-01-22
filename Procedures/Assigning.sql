CREATE OR REPLACE PROCEDURE assign_validated(IN task_id INT, IN volunteer_ids INT[], IN hours_limit INT DEFAULT 8)
AS 
$body$
DECLARE 
	report TEXT;
    task_state TEXT;
	examined_volunteer INT;
	cu_volunteer_competency REFCURSOR; 
	volunteer_competency_pair RECORD;
BEGIN
    SELECT s.name FROM task t JOIN status s ON t.status_id = s.id 
    WHERE t.id = $1 INTO task_state;

    IF task_state NOT IN ('Planned', 'Cancelled') THEN
        RAISE EXCEPTION 'Task already %', task_state;
    ELSE
	IF need_special_skills($1) = true THEN
		report := report || 'Assigment report\n';
		
		FOREACH examined_volunteer IN ARRAY $2
		LOOP
			OPEN cu_volunteer_competency FOR
			SELECT u.volunteer_id, tc.competency_id
			FROM task_competency tc
			CROSS JOIN unnest(volunteer_ids) AS u(volunteer_id)
			WHERE tc.task_id = $1 AND u.volunteer_id = examined_volunteer;
			LOOP
				FETCH cu_volunteer_competency INTO volunteer_competency_pair;
				EXIT WHEN NOT FOUND;
				RAISE NOTICE 'pair id % comp %', volunteer_competency_pair.volunteer_id, volunteer_competency_pair.competency_id ; --debug
				IF EXISTS (
					SELECT 1
					FROM volunteer_competency vc 
					WHERE vc.volunteer_id = volunteer_competency_pair.volunteer_id
					AND vc.competency_id = volunteer_competency_pair.competency_id 
					) AND get_hours(volunteer_competency_pair.volunteer_id) < $3
				THEN
					CALL assign_for_task($1, volunteer_competency_pair.volunteer_id);
				ELSE
				report := report || 'Volunteer '||volunteer_competency_pair.volunteer_id
				||'does not have competency:'||volunteer_competency_pair.competency_id||'\n';
				END IF;
			END LOOP;
			CLOSE cu_volunteer_competency;
		END LOOP;
		ELSE
			FOREACH examined_volunteer IN ARRAY $2
			LOOP
			CALL assign_for_task($1, examined_volunteer);
			END LOOP;
			report := report || 'Assigment does not need special skills';
		END IF;
    END IF;
	IF (SELECT COUNT(*) FROM volunteer_task vt
	   WHERE vt.task_id = $1) = 0
	   OR
	   (SELECT COUNT(*) FROM volunteer_task vt
	   WHERE vt.task_id = $1) <> array_length($2, 1)
	THEN
		RAISE EXCEPTION 'Assigment failed';
	ELSE UPDATE task SET status_id = 2 WHERE task.id = $1;
	report := 'Task succesfully assigned';
	RAISE NOTICE '%', report;
	END IF;
END
$body$
LANGUAGE plpgsql;


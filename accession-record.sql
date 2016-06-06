--- Basic Information + User Defined
select 
       acc.title Title, 
       acc.identifier, 
       acc.content_description "Content Description", 
       acc.accession_date "Accession Date",
       ( SELECT value FROM enumeration_value where id = acc.acquisition_type_id) "Acquisition Type", 
       ( SELECT value FROM enumeration_value where id = acc.resource_type_id) "Resource Type", 
       acc.restrictions_apply "Restrictions Apply", 
       acc.publish "Publish", 
       acc.access_restrictions "Access Restrictions", 
       acc.use_restrictions "Use Restrictions",
       ud.string_1 "Mss Number", 
       ud.string_2 "Location", 
       ud.string_3 "SIRSI Number",
       ud.date_1 "Date Received" 
from accession acc 
inner join 
      user_defined ud on ud.accession_id = acc.id 
where acc.id = 95\G

--- sample output
/*
*************************** 1. row ***************************
              Title: E. S. Morgan Confederate Captain Commission
         identifier: ["Acc2013","48",null,null]
Content Description: Conferederate captain commission for E.S. Morgan.  Catalog record only.
Part of a purchase made from James Prescott Stuart in June 2008.  Total cost of the purchase was 9000.00, the cost of individual items is not known.
     Accession Date: 2013-10-08
   Acquisition Type: Purchase
      Resource Type: Captain Commission
 Restrictions Apply: 0
            Publish: 0
Access Restrictions: 0
   Use Restrictions: 0
         Mss Number: 5133
           Location: MISC:M
      Date Received: 2008-06-23

*/


select 
       e.number Number, 
       (select value from enumeration_value where id = e.extent_type_id) Type,
       (select value from enumeration_value where id = e.portion_id)  Portion
from extent e
where e.accession_id = 95;


/*
+--------+-------+---------+
| Number | Type  | Portion |
+--------+-------+---------+
| 1      | items | whole   |
+--------+-------+---------+
*/

--- Dates
select 
  np.sort_name agent, 
  ac.address_1, 
  ac.city, 
  ac.region, 
  ac.post_code,
  (select value from enumeration_value where id = lar.role_id) role
from linked_agents_rlshp lar 
  join name_person np on lar.agent_person_id = np.id 
  join agent_contact ac on lar.agent_person_id = ac.agent_person_id  
where accession_id = 829\G

/*
+------------+--------+----------+
| Expression | Type   | Label    |
+------------+--------+----------+
| 10/8/1861  | single | creation |
+------------+--------+----------+
*/


--- Agent Links
select 
       (select value from enumeration_value where id = lar.role_id) role, 
       np.sort_name agent 
from linked_agents_rlshp lar 
     join name_person np on lar.agent_person_id = np.id 
where accession_id = 95;

/*
+--------+-----------------------+
| role   | agent                 |
+--------+-----------------------+
| source | James Prescott Stuart |
+--------+-----------------------+
*/

--- events

select  
	(select ev.value from enumeration_value ev where ev.id = e.event_type_id ) event_type, 
	e.created_by "Created By", 
	e.create_time "Date Created", 
	e.last_modified_by "Last Modified By", 
	e.user_mtime "Date modified"
from event_link_rlshp elr 
     join event e on e.id = elr.event_id 
where elr.accession_id = 95;

/*
+------------+------------+---------------------+------------------+---------------------+
| event_type | Created By | Date Created        | Last Modified By | Date modified       |
+------------+------------+---------------------+------------------+---------------------+
| processed  | jmitc84    | 2015-11-18 20:27:18 | jmitc84          | 2015-11-18 20:27:18 |
| cataloged  | jmitc84    | 2015-11-18 20:27:18 | jmitc84          | 2015-11-18 20:27:18 |
+------------+------------+---------------------+------------------+---------------------+
*/


--- ALL TOGETHER NOW...

select 
      acc.title Title, 
      acc.identifier, 
      acc.content_description "Content Description", 
      acc.accession_date "Accession Date",
      ( SELECT value FROM enumeration_value where id = acc.acquisition_type_id) "Acquisition Type", 
      ( SELECT value FROM enumeration_value where id = acc.resource_type_id) "Resource Type", 
      acc.restrictions_apply "Restrictions Apply", 
      acc.publish "Publish", 
      acc.access_restrictions "Access Restrictions", 
      acc.use_restrictions "Use Restrictions",
      ud.string_1 "Mss Number", 
      ud.string_2 "Location", 
      ud.string_3 "SIRSI Number",
      ud.date_1 "Date Received",
      e.number Number, 
      (select value from enumeration_value where id = e.extent_type_id) Type,
      (select value from enumeration_value where id = e.portion_id)  Portion,
      np.sort_name agent, 
      ac.address_1, 
      ac.city, 
      ac.region, 
      ac.post_code,
      (select value from enumeration_value where id = lar.role_id) role,
      (select ev.value from enumeration_value ev where ev.id = evt.event_type_id ) event_type, 
      evt.created_by "Created By", 
      evt.create_time "Date Created", 
      evt.last_modified_by "Last Modified By", 
      evt.user_mtime "Date modified"

from accession acc 
inner join 
      user_defined ud on ud.accession_id = acc.id
      join extent e on e.accession_id = acc.id
      join linked_agents_rlshp lar on lar.accession_id = acc.id
      join name_person np on lar.agent_person_id = np.id 
      join agent_contact ac on lar.agent_person_id = ac.agent_person_id 
      join event_link_rlshp elr on elr.accession_id = acc.id
      join event evt on evt.id = elr.event_id 
where acc.id = 95\G

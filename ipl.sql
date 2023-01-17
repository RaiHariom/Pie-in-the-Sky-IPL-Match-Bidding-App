USE IPL;

-- 1. Show the percentage of wins of each bidder in the order of highest to lowest percentage.

select bdr_dt.bidder_id 'Bidder ID', bdr_dt.bidder_name 'Bidder Name', 
(select count(*) from ipl_bidding_details bid_dt 
where bid_dt.bid_status = 'won' and bid_dt.bidder_id = bdr_dt.bidder_id) / 
(select no_of_bids from ipl_bidder_points bdr_pt 
where bdr_pt.bidder_id = bdr_dt.bidder_id)*100 as win_percentage
from ipl_bidder_details bdr_dt
order by win_percentage desc;

-- 2.	Display the number of matches conducted at each stadium with stadium name, city from the database.

select ipl_stadium.stadium_name, ipl_stadium.city, count(ipl_match_schedule.match_id) as total_matches from ipl_stadium 
join ipl_match_schedule
on ipl_match_schedule.stadium_id =ipl_stadium.stadium_id
group by ipl_stadium.stadium_id
order by total_matches desc;

-- 3.	In a given stadium, what is the percentage of wins by a team which has won the toss?

select ipl_stadium.stadium_name,
round(sum(case
when ipl_match.toss_winner = ipl_match.match_winner then 1
else 0
end)*100/count(ipl_match.match_id),2) as tosswin_matchwin_percentage
from ipl_stadium
join ipl_match_schedule
on ipl_match_schedule.stadium_id =ipl_stadium.stadium_id
join ipl_match 
on ipl_match_schedule.match_id = ipl_match.match_id
group by ipl_stadium.stadium_name;

-- 4.	Show the total bids along with bid team and team name

select ipl_bidding_details.bid_team, ipl_team.team_name, sum(ipl_bidder_points.no_of_bids) as total_bids from ipl_team
join ipl_bidding_details
on ipl_team.team_id = ipl_bidding_details.bid_team
join ipl_bidder_points
on ipl_bidding_details.bidder_id = ipl_bidder_points.bidder_id
group by ipl_bidding_details.bid_team
order by ipl_bidding_details.bid_team;

-- 5.	Show the team id who won the match as per the win details.

select match_id, 
case
when match_winner = 1 then team_id1
else team_id2
end as team_id, win_details
from ipl_match;

-- 6.	Display total matches played, total matches won and total matches lost by team along with its team name.
select * from ipl_team_standings;
select ipl_team.team_id, ipl_team.team_name, sum(ipl_team_standings.matches_played) as total_played, sum(ipl_team_standings.matches_won) as total_won, sum(ipl_team_standings.matches_lost) as total_lost from ipl_team
join ipl_team_standings
on ipl_team.team_id = ipl_team_standings.team_id
group by ipl_team.team_name;

-- 7.	Display the bowlers for Mumbai Indians team.

select ipl_team.team_name, ipl_team_players.player_role, ipl_player.player_name from ipl_team
join ipl_team_players
on ipl_team.team_id = ipl_team_players.team_id
join ipl_player
on ipl_team_players.player_id = ipl_player.player_id
where ipl_team.team_name = "mumbai indians" and ipl_team_players.player_role = "bowler";

-- 8.	How many all-rounders are there in each team, Display the teams with more than 4 all-rounder in descending order.

select ipl_team.team_name, count(ipl_team_players.player_role) as total_all_rounder from ipl_team
join ipl_team_players
on ipl_team.team_id = ipl_team_players.team_id
join ipl_player
on ipl_team_players.player_id = ipl_player.player_id
where ipl_team_players.player_role = "all-rounder"
group by team_name
having total_all_rounder > 4
order by total_all_rounder desc;
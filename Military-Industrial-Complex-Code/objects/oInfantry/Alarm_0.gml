if (m_sm.state_name == "m_engage" || m_sm.state_name == "m_follow") && instance_exists(target_inst)
{
	goal_x = target_inst.x;
	goal_y = target_inst.y;
}

var coords = find_nearest_empty_space(goal_x, goal_y);
goal_x = coords[0];
goal_y = coords[1];

if path_goal_find(x, y, goal_x, goal_y, path)
	path_goal_multiplayer_update(x, y, goal_x, goal_y);
else
	m_sm.swap(m_idle);
	
if m_sm.state_name == "m_engage" || m_sm.state_name == "m_follow"
	alarm[0] = 30
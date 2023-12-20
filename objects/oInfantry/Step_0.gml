// Run the State Machine
m_sm.run();
a_sm.run();
b_sm.run();

if health <= 0
{
	b_sm.swap(b_idle);
	instance_destroy();
}
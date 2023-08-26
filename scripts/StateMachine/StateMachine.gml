// StateMachine constructor
function StateMachine() constructor {
    static nullState = new State();

    state = nullState;
	stateName = "null";
    time = 0;

    // Swap to a new state
    swap = function(_state = nullState) {
        state.destroy();

        state = _state;
		stateName = _state.stateName;
        time = 0;

        state.create();
    }

    // Run current state
    run = function() {
        state.update();
        time++;
    }
}

// State constructor
function State() constructor {
    static NOOP = function() { };

    create = NOOP;
    update = NOOP;
    destroy = NOOP;
}

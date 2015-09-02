// explicit declare
//typedef unsigned char uint8_t;


RobotMind *robot_mind_new(int hist_len);

void robot_mind_gc(RobotMind *robot_mind);

void robot_mind_get_images(RobotMind *robot_mind, uint8_t* dst);

void robot_mind_act(RobotMind *robot_mind, int action);

int robot_mind_get_reward(RobotMind *robot_mind);

/*
// Applies the action and returns the obtained reward.
double robot_mind_act(RobotMind *robot_mind, int action);

// Returns the screen width.
int robot_mind_getScreenWidth(const RobotMind *robot_mind);

// Returns the screen height.
int robot_mind_getScreenHeight(const RobotMind *robot_mind);

// Indicates whether the game ended.
// Call resetGame to restart the game.
//
// Returning of bool instead of int is important.
// The bool is converted to lua bool by FFI.
bool robot_mind_isGameOver(const RobotMind *robot_mind);

// Resets the game.
void robot_mind_resetGame(RobotMind *robot_mind);

// robot_mind save state
void robot_mind_saveState(RobotMind *robot_mind);

// robot_mind load state
bool robot_mind_loadState(RobotMind *robot_mind);

// Fills the obs with raw probot_mindtte values.
//
// Currently, the probot_mindtte values are even numbers from 0 to 255.
// So there are only 128 distinct values.
void robot_mind_fillObs(const RobotMind *robot_mind, uint8_t *obs, size_t obs_size);

// Fills the given array with the content of the RAM.
// The obs_size should be 128.
void robot_mind_fillRamObs(const RobotMind *robot_mind, uint8_t *obs, size_t obs_size);

// Returns the number of legal actions
int robot_mind_numLegalActions(RobotMind *robot_mind);

// Returns the valid actions for a game
void robot_mind_legalActions(RobotMind *robot_mind, int *actions, size_t size);

// Returns the number of remaining lives for a game
int robot_mind_livesRemained(const RobotMind *robot_mind);

// Used by api to create a string of correct size.
int robot_mind_getSnapshotLength(const RobotMind *robot_mind);

// Save the current state into a snapshot
void robot_mind_saveSnapshot(const RobotMind *robot_mind, uint8_t *data, size_t length);

// Load a particular snapshot into the emulator
void robot_mind_restoreSnapshot(RobotMind *robot_mind, const uint8_t *snapshot,
                         size_t size);
*/


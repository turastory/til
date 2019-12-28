## Why RL is different from other approaches

### Reinforcement Learning vs Supervised Learning

Reinforcement Learning is different from supervised learning, because the agent, who sense the environment and learn from it, to approach the goal does not rely on external knowledge. In supervised learning, there's an "answer" against to given input value. Whereas in reinforcement learning, on the other hand, the "answer" or an optimal solution to the given problem is not provided to the agent.

### Reinforcement Learning vs Unsupervised Learning

Reinforcement Learning is different from unsupervised learning, altough both approach does not give the learner the optimal solution to the given problem. In unsupervised learning, the main goal is to find some pattern - or hidden structure of inputs. In case of reinfocement learning, the main goal is to maximize a reward signal.

### Reinforcement Learning vs Genetic Algorithms

Genetic algorithms starts with some individual units, and uses the idae of natural selection to discover solutions. It is useful when the agent is completely unaware of the environment.


## Key concepts of RL

### Exploration / Exploitation

To get rewards as much as possible, the agent should learn from the previous experiences - which way gave it more rewards, and which way didn't.
On the other hand, there might be another better choices than currently best path. So the agent should explore new ways to see if there's a better way to maximize rewards.
This concept - "Exploring new path to find more better path" - is called "Exploration" where the other - "Keep the best path" - is called "Exploitation".
The balance of those two approaches is one of the challenges in reinforcement learning.

### Policy

Mapping from perceived states to actions to be taken.
Defines "how the agent will behave" in given state.

### Reward

Defines the goal of RL problem.
Each time step - it is important that the reward should be calculated right at specific time step.

### Value function

Value of the state means the expectation about the state. It is not an actual reward. But this expectation make the agent not just choosing the best action in specific time step greedily, but rather think about the future rewards.

-> How efficiently and correctly estimate these values are the most important part.

#### Temporal Difference

For the following statement:

    V(s) <- V(s) + alpha * [V(s') - V(s)]
    
    s: State before move
    s': State after move
    alpha: step-size parameter - it affects the rate of learning
    V(s): the update to the estimated value of s

It is called "temporal-difference" learning method, because it chages based on the difference between estimates at two different times.

### Model of environemnt

Model is an optional, fourth element of reinforcement learning, and it means agent's assumptions about the environments. Models are not necessary, but they might helpful to make decisions.

If the model is present, it is called "model-based learning", and otherwise it is called "model-free learning".

### Timestep

In RL, the agent are interacting with the environment to learn how to optimize itself. Therefore, concepts about "time" is significantly important.

At each time step, the agent sense some data, or "states" of the environment, and decide which action to perform next based on the policy, to get rewards as much as possible.


## Exercises

### 1.1 Self Play

If the agent plays against itself, definitely it is more efficient than random opponent because as the agent play well, the opponent - the agent itself - will also play well.

### GAN

- https://pathmind.com/wiki/generative-adversarial-network-gan
- https://openai.com/blog/generative-models/

GAN - Generative Adversarial Networks.

Discriminative algorithms - Predicts the label y given the input feature x -> p(x|y)
-> Discriminative algorithms map features to labels.

Generative algorithms - Predicts the input x, given the label y.
-> Given the label y, how to get the input x?

-> Discriminitive algorithms and generative algorithms are adversarial - so GAN.

Another way to think about it is to distinguish discriminative from generative like this:
- Discriminative models learn the boundary between classes
- Generative models model the distribution of individual classes

#### Types of generative algorithms?

- Given a "label", they predict the associated features (Naive Bayes)
- Given a "hidden representation", they predict the associated features (VAE, GAN)
- Given some of the features, they predict the rest (inpainting, imputation)

### Image Completion (Inpainting)

Image completion - Filling missing pixels in the image.
How to do image completion? There are 2 ways:

- Contextual Information: Infer missing pixels based on information provided by "surrounding pixels"
- Perceptual Information: Common sense which is considered "normal" - e.g. Usually the sky is blue and the beach is yellow.

### What is actor-critic model? 

- https://arxiv.org/abs/1610.01945

### What is RBMs?

- https://pathmind.com/wiki/restricted-boltzmann-machine














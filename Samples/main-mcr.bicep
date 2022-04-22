module helloWorld 'br/public:samples/hello-world:1.0.1' = {
  name: 'helloWorld'
  params: {
    name: 'Freek'
  }
}

output greeting string = helloWorld.outputs.greeting

module avset 'br/public:compute/availability-set:1.0.1' = {
  name: 'my-avset-demo'
  params: {
    name: 'avset-01'
    availabilitySetSku: 'aligned'
    availabilitySetUpdateDomain: 2
    availabilitySetFaultDomain: 2
    tags: {
      tag1: 'MCR demo'
    }
  }
}

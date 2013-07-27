require! {
  Q
  chai
  "sinon-chai"
  "chai-as-promised"
  "mocha-as-promised"
}

chai.should!
chai.use chai-as-promised
chai.use sinon-chai

mocha-as-promised!

gloabl import chai{
  expect
  AssertionError
  Assertion
  assert
}

gloabl import Q{
  fulfilled-promise: resolve
  rejected-promise: reject
}

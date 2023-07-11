use starknet_forge_template::fib;

#[test]
fn test_fib() {
    assert(fib(0, 1, 10) == 55, fib(0, 1, 10));
}

#[test]
fn test_simple() {
    assert(1 == 1, 'simple check');
}

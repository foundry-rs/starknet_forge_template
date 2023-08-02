use array::ArrayTrait;
use result::ResultTrait;
use option::OptionTrait;
use traits::TryInto;
use starknet::ContractAddress;
use starknet::Felt252TryIntoContractAddress;
use cheatcodes::PreparedContract;

use starknet_forge_template::IHelloStarknetSafeDispatcher;
use starknet_forge_template::IHelloStarknetSafeDispatcherTrait;

fn deploy_contract(name: felt252) -> ContractAddress {
    let class_hash = declare(name);
    let prepared = PreparedContract {
        class_hash, constructor_calldata: @ArrayTrait::new()
    };
    deploy(prepared).unwrap()
}

#[test]
fn test_increase_balance() {
    let contract_address = deploy_contract('HelloStarknet');

    let safe_dispatcher = IHelloStarknetSafeDispatcher { contract_address };

    let balance_before = safe_dispatcher.get_balance().unwrap();
    assert(balance_before == 0, 'Invalid balance');

    safe_dispatcher.increase_balance(42).unwrap();

    let balance_after = safe_dispatcher.get_balance().unwrap();
    assert(balance_after == 42, 'Invalid balance');
}

#[test]
fn test_cannot_increase_balance_with_zero_value() {
    let contract_address = deploy_contract('HelloStarknet');

    let safe_dispatcher = IHelloStarknetSafeDispatcher { contract_address };

    let balance_before = safe_dispatcher.get_balance().unwrap();
    assert(balance_before == 0, 'Invalid balance');

    match safe_dispatcher.increase_balance(0) {
        Result::Ok(_) => panic_with_felt252('Should have panicked'),
        Result::Err(panic_data) => {
            assert(*panic_data.at(0) == 'Amount cannot be 0', *panic_data.at(0));
        }
    };
}

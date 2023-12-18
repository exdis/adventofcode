(module
    (import "env" "length" (func $length (result i32)))
    (import "env" "log" (func $log (param i32)))
    (memory (export "memory") 1)
    (func $run (result i32)
        (local $strPtr i32)
        (local $currNum i32)
        (local $firstNum i32)
        (local $lastNum i32)
        (local $firstNumSet i32)
        (local $result i32)
        (local $i i32)
        (local $char i32)
        call $length
        local.set $strPtr

        (loop $loop
            local.get $i
            i32.const 1
            i32.add
            local.set $i

            local.get $i
            i32.load8_u
            local.set $currNum

            local.get $currNum
            i32.const 48
            i32.gt_u

            (if
                (then
                    local.get $currNum
                    i32.const 57
                    i32.le_u

                    (if
                        (then

                            local.get $firstNumSet
                            (if
                                (then
                                    local.get $currNum
                                    local.set $lastNum
                                    br $loop
                                )
                                (else
                                    local.get $currNum
                                    local.set $firstNum
                                    i32.const 1
                                    local.set $firstNumSet
                                    br $loop
                                )
                            )
                        )
                    )
                )
            )

            local.get $currNum
            i32.const 10
            i32.eq

            (if
                (then
                    i32.const 0
                    local.set $firstNumSet

                    i32.const 0
                    local.get $lastNum
                    i32.eq
                    (if
                        (then
                            local.get $firstNum
                            local.set $lastNum
                        )
                    )

                    local.get $firstNum
                    i32.const 48
                    i32.sub
                    i32.const 10
                    i32.mul
                    local.set $firstNum

                    local.get $lastNum
                    i32.const 48
                    i32.sub
                    local.set $lastNum

                    local.get $firstNum
                    local.get $lastNum
                    i32.add

                    local.get $result
                    i32.add

                    local.set $result

                    i32.const 0
                    local.set $firstNum
                    i32.const 0
                    local.set $lastNum
                )
            )

            local.get $i
            local.get $strPtr
            i32.lt_u
            br_if $loop
        )

        local.get $result
    )
    (func $run2 (result i32)
        (local $strPtr i32)
        (local $currNum i32)
        (local $firstNum i32)
        (local $lastNum i32)
        (local $firstNumSet i32)
        (local $result i32)
        (local $i i32)
        (local $char i32)
        call $length
        local.set $strPtr

        (loop $loop
            local.get $i
            i32.const 1
            i32.add
            local.set $i

            local.get $i
            i32.load8_u
            local.set $currNum

            local.get $currNum
            i32.const 48
            i32.gt_u

            local.get $i
            call $isOne

            (if
                (then
                    i32.const 49
                    local.set $currNum

                    local.get $i
                    i32.const 1
                    i32.add
                    local.set $i
                )
            )

            local.get $i
            call $isTwo

            (if
                (then
                    i32.const 50
                    local.set $currNum

                    local.get $i
                    i32.const 1
                    i32.add
                    local.set $i
                )
            )

            local.get $i
            call $isThree

            (if
                (then
                    i32.const 51
                    local.set $currNum

                    local.get $i
                    i32.const 1
                    i32.add
                    local.set $i
                )
            )

            local.get $i
            call $isFour

            (if
                (then
                    i32.const 52
                    local.set $currNum

                    local.get $i
                    i32.const 1
                    i32.add
                    local.set $i
                )
            )

            local.get $i
            call $isFive

            (if
                (then
                    i32.const 53
                    local.set $currNum

                    local.get $i
                    i32.const 1
                    i32.add
                    local.set $i
                )
            )

            local.get $i
            call $isSix

            (if
                (then
                    i32.const 54
                    local.set $currNum

                    local.get $i
                    i32.const 1
                    i32.add
                    local.set $i
                )
            )

            local.get $i
            call $isSeven

            (if
                (then
                    i32.const 55
                    local.set $currNum

                    local.get $i
                    i32.const 1
                    i32.add
                    local.set $i
                )
            )

            local.get $i
            call $isEight

            (if
                (then
                    i32.const 56
                    local.set $currNum

                    local.get $i
                    i32.const 1
                    i32.add
                    local.set $i
                )
            )

            local.get $i
            call $isNine

            (if
                (then
                    i32.const 57
                    local.set $currNum

                    local.get $i
                    i32.const 1
                    i32.add
                    local.set $i
                )
            )

            local.get $i
            call $isZero

            (if
                (then
                    i32.const 48
                    local.set $currNum

                    local.get $i
                    i32.const 1
                    i32.add
                    local.set $i
                )
            )

            (if
                (then
                    local.get $currNum
                    i32.const 57
                    i32.le_u

                    (if
                        (then
                            local.get $firstNumSet
                            (if
                                (then
                                    local.get $currNum
                                    local.set $lastNum
                                    br $loop
                                )
                                (else
                                    local.get $currNum
                                    local.set $firstNum
                                    i32.const 1
                                    local.set $firstNumSet
                                    br $loop
                                )
                            )
                        )
                    )
                )
            )

            local.get $currNum
            i32.const 10
            i32.eq

            (if
                (then
                    i32.const 0
                    local.set $firstNumSet

                    i32.const 0
                    local.get $lastNum
                    i32.eq
                    (if
                        (then
                            local.get $firstNum
                            local.set $lastNum
                        )
                    )

                    local.get $firstNum
                    i32.const 48
                    i32.sub
                    i32.const 10
                    i32.mul
                    local.set $firstNum

                    local.get $lastNum
                    i32.const 48
                    i32.sub
                    local.set $lastNum

                    local.get $firstNum
                    local.get $lastNum
                    i32.add

                    local.get $result
                    i32.add

                    local.set $result

                    i32.const 0
                    local.set $firstNum
                    i32.const 0
                    local.set $lastNum
                )
            )

            local.get $i
            local.get $strPtr
            i32.lt_u
            br_if $loop
        )

        local.get $result
    )
    (func $isOne (param $ptr i32) (result i32)
        local.get $ptr
        i32.load8_u

        i32.const 111
        i32.eq

        local.get $ptr
        i32.const 1
        i32.add

        i32.load8_u

        i32.const 110
        i32.eq

        local.get $ptr
        i32.const 2
        i32.add

        i32.load8_u

        i32.const 101
        i32.eq

        i32.and
        i32.and
    )
    (func $isTwo (param $ptr i32) (result i32)
        local.get $ptr
        i32.load8_u

        i32.const 116
        i32.eq

        local.get $ptr
        i32.const 1
        i32.add

        i32.load8_u

        i32.const 119
        i32.eq

        local.get $ptr
        i32.const 2
        i32.add

        i32.load8_u

        i32.const 111
        i32.eq

        i32.and
        i32.and
    )
    (func $isThree (param $ptr i32) (result i32)
        local.get $ptr
        i32.load8_u

        i32.const 116
        i32.eq

        local.get $ptr
        i32.const 1
        i32.add

        i32.load8_u

        i32.const 104
        i32.eq

        local.get $ptr
        i32.const 2
        i32.add

        i32.load8_u

        i32.const 114
        i32.eq

        local.get $ptr
        i32.const 3
        i32.add

        i32.load8_u

        i32.const 101
        i32.eq

        local.get $ptr
        i32.const 4
        i32.add

        i32.load8_u

        i32.const 101
        i32.eq

        i32.and
        i32.and
        i32.and
        i32.and
    )
    (func $isFour (param $ptr i32) (result i32)
        local.get $ptr
        i32.load8_u

        i32.const 102
        i32.eq

        local.get $ptr
        i32.const 1
        i32.add

        i32.load8_u

        i32.const 111
        i32.eq

        local.get $ptr
        i32.const 2
        i32.add

        i32.load8_u

        i32.const 117
        i32.eq

        local.get $ptr
        i32.const 3
        i32.add

        i32.load8_u

        i32.const 114
        i32.eq

        i32.and
        i32.and
        i32.and
    )
    (func $isFive (param $ptr i32) (result i32)
        local.get $ptr
        i32.load8_u

        i32.const 102
        i32.eq

        local.get $ptr
        i32.const 1
        i32.add

        i32.load8_u

        i32.const 105
        i32.eq

        local.get $ptr
        i32.const 2
        i32.add

        i32.load8_u

        i32.const 118
        i32.eq

        local.get $ptr
        i32.const 3
        i32.add

        i32.load8_u

        i32.const 101
        i32.eq

        i32.and
        i32.and
        i32.and
    )
    (func $isSix (param $ptr i32) (result i32)
        local.get $ptr
        i32.load8_u

        i32.const 115
        i32.eq

        local.get $ptr
        i32.const 1
        i32.add

        i32.load8_u

        i32.const 105
        i32.eq

        local.get $ptr
        i32.const 2
        i32.add

        i32.load8_u

        i32.const 120
        i32.eq

        i32.and
        i32.and
    )
    (func $isSeven (param $ptr i32) (result i32)
        local.get $ptr
        i32.load8_u

        i32.const 115
        i32.eq

        local.get $ptr
        i32.const 1
        i32.add

        i32.load8_u

        i32.const 101
        i32.eq

        local.get $ptr
        i32.const 2
        i32.add

        i32.load8_u

        i32.const 118
        i32.eq

        local.get $ptr
        i32.const 3
        i32.add

        i32.load8_u

        i32.const 101
        i32.eq

        local.get $ptr
        i32.const 4
        i32.add

        i32.load8_u

        i32.const 110
        i32.eq

        i32.and
        i32.and
        i32.and
        i32.and
    )
    (func $isEight (param $ptr i32) (result i32)
        local.get $ptr
        i32.load8_u

        i32.const 101
        i32.eq

        local.get $ptr
        i32.const 1
        i32.add

        i32.load8_u

        i32.const 105
        i32.eq

        local.get $ptr
        i32.const 2
        i32.add

        i32.load8_u

        i32.const 103
        i32.eq

        local.get $ptr
        i32.const 3
        i32.add

        i32.load8_u

        i32.const 104
        i32.eq

        local.get $ptr
        i32.const 4
        i32.add

        i32.load8_u

        i32.const 116
        i32.eq

        i32.and
        i32.and
        i32.and
        i32.and
    )
    (func $isNine (param $ptr i32) (result i32)
        local.get $ptr
        i32.load8_u

        i32.const 110
        i32.eq

        local.get $ptr
        i32.const 1
        i32.add

        i32.load8_u

        i32.const 105
        i32.eq

        local.get $ptr
        i32.const 2
        i32.add

        i32.load8_u

        i32.const 110
        i32.eq

        local.get $ptr
        i32.const 3
        i32.add

        i32.load8_u

        i32.const 101
        i32.eq

        i32.and
        i32.and
        i32.and
    )
    (func $isZero (param $ptr i32) (result i32)
        local.get $ptr
        i32.load8_u

        i32.const 122
        i32.eq

        local.get $ptr
        i32.const 1
        i32.add

        i32.load8_u

        i32.const 101
        i32.eq

        local.get $ptr
        i32.const 2
        i32.add

        i32.load8_u

        i32.const 114
        i32.eq

        local.get $ptr
        i32.const 3
        i32.add

        i32.load8_u

        i32.const 111
        i32.eq

        i32.and
        i32.and
        i32.and
    )
    (export "run" (func $run))
    (export "run2" (func $run2))
)

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
    (export "run" (func $run))
)

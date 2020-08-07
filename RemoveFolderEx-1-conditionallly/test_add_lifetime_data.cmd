mkdir "C:\Program Files (x86)\Acme\Foobar\bin"
mkdir "C:\Program Files (x86)\Acme\Foobar\var"
echo 123>>"C:\Program Files (x86)\Acme\Foobar\bin\lifetime_data_that_should_be_removed.txt"
echo 123>>"C:\Program Files (x86)\Acme\Foobar\var\lifetime_data_that_should_persist.txt"
test_show_lifetime_data.cmd

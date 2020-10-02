mkdir "C:\AcmeFoobar\bin"
mkdir "C:\AcmeFoobar\var"
echo 123>>"C:\AcmeFoobar\bin\lifetime_data_that_should_be_removed.txt"
echo 123>>"C:\AcmeFoobar\var\lifetime_data_that_should_persist.txt"
test_show_lifetime_data.cmd

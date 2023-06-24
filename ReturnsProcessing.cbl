       identification division.
       program-id. ReturnsProcessing.
       author. Neema, Diego, Yustina, Kinen.
       date-written. 2023-04-06.
      *Program Description: The RETURNS PROCESSING program is
      * responsible for producing a detail report of returns with some
      * summary statistics at the end.

       environment division.
       configuration section.
       file-control.

           select input-file
               assign to "../../../data/return-project8.dat"
               organization is line sequential.

           select output-file
               assign to "../../../data/ReturnsReport.out"
               organization is line sequential.
      *
       data division.
       file section.
       fd input-file
           data record is input-line
           record contains 36 characters.

       01 input-line.
         05 in-transaction-code pic x.
         05 in-transaction-amount pic 9(5)v99.
         05 in-payment-type pic xx.
         05 in-store-number pic xx.
         05 in-invoice-number pic x(9).
         05 in-sku-code pic x(15).

      *
       fd output-file
           data record is output-line
           record contains 125 characters.

       01 output-line pic x(125).

       working-storage section.

      *End of file flag
       01 ws-eof-flag pic x value "n".

      *Variables for calculations
       01 ws-details.
         05 ws-tax-owing pic 9(5)v99.
         05 ws-total-tax pic 9(5)v99.
         05 ws-total-records pic 999 value 0.
         05 ws-total-ca-pmt pic 999 value 0.
         05 ws-total-cr-pmt pic 999 value 0.
         05 ws-total-db-pmt pic 999 value 0.
         05 ws-pct-ca pic 99.
         05 ws-pct-cr pic 99.
         05 ws-pct-db pic 99.
         05 ws-line-count pic 99 value 0.
         05 ws-lines-per-page pic 99 value 20.
         05 ws-page-count pic 99 value 0.
         05 ws-01-r-total pic 9(8) value 0.
         05 ws-02-r-total pic 9(8) value 0.
         05 ws-03-r-total pic 9(8) value 0.
         05 ws-04-r-total pic 9(8) value 0.
         05 ws-05-r-total pic 9(8) value 0.
         05 ws-12-r-total pic 9(8) value 0.

      *Headers
       01 ws-header1.
         05 filler pic x(52) value spaces.
         05 filler pic x(25) value "RETURNS PROCESSING REPORT".
         05 filler pic x(41) value spaces.
         05 filler pic x(5) value "Page ".
         05 ws-page-number pic Z9.

       01 ws-header2.
         05 filler pic x(16) value "Transaction Code".
         05 filler pic x(8) value spaces.
         05 filler pic x(6) value "Amount".
         05 filler pic x(8) value spaces.
         05 filler pic x(12) value "Payment Type".
         05 filler pic x(8) value spaces.
         05 filler pic x(12) value "Store Number".
         05 filler pic x(8) value spaces.
         05 filler pic x(14) value "Invoice Number".
         05 filler pic x(8) value spaces.
         05 filler pic x(8) value "SKU Code".
         05 filler pic x(8) value spaces.
         05 filler pic x(9) value "Tax Owing".

      *Formatted output variables
       01 ws-output.
         05 filler pic x(7) value spaces.
         05 ws-ol-t-code pic x value spaces.
         05 filler pic x(12) value spaces.
         05 ws-ol-t-amount pic $$$,$$9.99 value zeroes.
         05 filler pic x(12) value spaces.
         05 ws-ol-p-type pic xx value spaces.
         05 filler pic x(18) value spaces.
         05 ws-ol-s-number pic xx value spaces.
         05 filler pic x(17) value spaces.
         05 ws-ol-i-number pic x(9) value spaces.
         05 filler pic x(6) value spaces.
         05 ws-ol-sku pic x(15) value spaces.
         05 filler pic x(4) value spaces.
         05 ws-ol-tax pic $$$,$$9.99 value zeroes.

      *Footers
       01 ws-footer1.
         05 filler pic x(23) value "Number of S&L Records: ".
         05 ws-ol-total-records pic Z9.
         05 filler pic x(100) value spaces.

       01 ws-footer4.
         05 filler pic x(25) value "Number of Cash Payments: ".
         05 ws-ol-total-ca pic z9 value zeroes.
         05 filler pic xxx value " (%".
         05 ws-ol-per-ca pic zz9 value zeroes.
         05 filler pic x value ")".
         05 filler pic x(91) value spaces.

       01 ws-footer5.
         05 filler pic x(27) value "Number of Credit Payments: ".
         05 ws-ol-total-cr pic z9 value zeroes.
         05 filler pic xxx value " (%".
         05 ws-ol-per-cr pic zz9 value zeroes.
         05 filler pic x value ")".
         05 filler pic x(89) value spaces.

       01 ws-footer6.
         05 filler pic x(26) value "Number of Debit Payments: ".
         05 ws-ol-total-db pic z9 value zeroes.
         05 filler pic xxx value " (%".
         05 ws-ol-per-db pic zz9 value zeroes.
         05 filler pic x value ")".
         05 filler pic x(90) value spaces.

       01 ws-footer7.
         05 filler pic x(17) value "Total Tax Owing: ".
         05 ws-ol-total-tax pic $$$,$$9.99 value zeroes.
         05 filler pic x(98) value spaces.

       01 ws-footer8.
         05 filler pic x(22) value "Store with highest R: ".
         05 ws-high-store-r pic xx.
         05 filler pic x(101) value spaces.

       01 ws-footer9.
         05 filler pic x(21) value "Store with lowest R: ".
         05 ws-low-store-r pic xx.
         05 filler pic x(102) value spaces.

      *Constant
       77 ws-tax-pct pic 9v99 value 0.13.

       procedure division.
       000-main.
      *
      *Open files
           open input input-file.
           open output output-file.
      *
      *Read first record from input
           read input-file
               at end
                   move "y" to ws-eof-flag.
      *
      *    Process Pages
           perform 100-process-pages
             until ws-eof-flag = "y".

      *    Write the footers to output file
           perform 400-write-footers.

           close input-file.
           close output-file.

           goback.

       100-process-pages.

           perform 200-headings.

      *    Performs calculations
           perform 300-process-data
             varying ws-line-count from 1 by 1
             until (ws-line-count > ws-lines-per-page
                    OR ws-eof-flag = "y").

           move spaces to output-line.
      *
       200-headings.

      *    Page number
           add 1 to ws-page-count.
           move ws-page-count to ws-page-number.

      *Print first header
           move spaces to output-line.
           write output-line from ws-header1
             after advancing 2 lines.

      *Print second header
           move spaces to output-line
           write output-line from ws-header2
             after advancing 2 lines.

       300-process-data.
      *Clear buffers
           move spaces to output-line.
           move spaces to ws-output.

      *Moving input details to output details
           move in-transaction-code to ws-ol-t-code.
           move in-transaction-amount to ws-ol-t-amount.
           move in-payment-type to ws-ol-p-type.
           move in-store-number to ws-ol-s-number.
           move in-invoice-number to ws-ol-i-number.
           move in-sku-code to ws-ol-sku.

      *Calculate tax owing, move to output variable
           multiply in-transaction-amount
             by ws-tax-pct
             giving ws-tax-owing.
           add ws-tax-owing to ws-total-tax.
           move ws-tax-owing to ws-ol-tax.

      *Total records
           add 1 to ws-total-records.

      *Logic to determine number of cash payments
           if (in-payment-type = "CA") then
               add 1 to ws-total-ca-pmt
           end-if.

      *Logic to determine number of credit payments
           if (in-payment-type = "CR") then
               add 1 to ws-total-cr-pmt
           end-if.

      *Logic to determine number of debit payments
           if (in-payment-type = "DB") then
               add 1 to ws-total-db-pmt
           end-if.

      *Determining the percentage of each payment type
      *and adding them to footer variables
           compute ws-pct-ca rounded = (ws-total-ca-pmt /
                                        ws-total-records) * 100.

           compute ws-pct-cr rounded = (ws-total-cr-pmt /
                                        ws-total-records) * 100.

           compute ws-pct-db rounded = (ws-total-db-pmt /
                                        ws-total-records) * 100.

      *Store with high and low S&L
           if in-store-number = "01" then
               add in-transaction-amount to ws-01-r-total
           end-if.

           if in-store-number = "02" then
               add in-transaction-amount to ws-02-r-total
           end-if.

           if in-store-number = "03" then
               add in-transaction-amount to ws-03-r-total
           end-if.

           if in-store-number = "04" then
               add in-transaction-amount to ws-04-r-total
           end-if.

           if in-store-number = "05" then
               add in-transaction-amount to ws-05-r-total
           end-if.

           if in-store-number = "12" then
               add in-transaction-amount to ws-12-r-total
           end-if.

           move "01" to ws-high-store-r.
           move "01" to ws-low-store-r.

           if ws-02-r-total > ws-01-r-total then
               move "02" to ws-high-store-r
           end-if.

           if ws-02-r-total < ws-01-r-total then
               move "02" to ws-low-store-r
           end-if.

           if ws-03-r-total > ws-02-r-total and
             ws-03-r-total > ws-01-r-total then
               move "03" to ws-high-store-r
           end-if.

           if ws-03-r-total < ws-02-r-total and
             ws-03-r-total < ws-01-r-total then
               move "03" to ws-low-store-r
           end-if.

           if ws-04-r-total > ws-03-r-total and
             ws-04-r-total > ws-02-r-total and
             ws-04-r-total > ws-01-r-total then
               move "04" to ws-high-store-r
           end-if.

           if ws-04-r-total < ws-03-r-total and
             ws-04-r-total < ws-02-r-total and
             ws-04-r-total < ws-01-r-total then
               move "04" to ws-low-store-r
           end-if.

           if ws-05-r-total > ws-04-r-total and
             ws-05-r-total > ws-03-r-total and
             ws-05-r-total > ws-02-r-total and
             ws-05-r-total > ws-01-r-total then
               move "05" to ws-high-store-r
           end-if.

           if ws-05-r-total < ws-04-r-total and
             ws-05-r-total < ws-03-r-total and
             ws-05-r-total < ws-02-r-total and
             ws-05-r-total < ws-01-r-total then
               move "05" to ws-low-store-r
           end-if.

           if ws-12-r-total > ws-05-r-total and
             ws-12-r-total > ws-04-r-total and
             ws-12-r-total > ws-03-r-total and
             ws-12-r-total > ws-02-r-total and
             ws-12-r-total > ws-01-r-total then
               move "12" to ws-high-store-r
           end-if.

           if ws-12-r-total < ws-05-r-total and
             ws-12-r-total < ws-04-r-total and
             ws-12-r-total < ws-03-r-total and
             ws-12-r-total < ws-02-r-total and
             ws-12-r-total < ws-01-r-total then
               move "12" to ws-low-store-r
           end-if.

      *Add totals to footers
           move ws-total-records to ws-ol-total-records.
           move ws-total-ca-pmt to ws-ol-total-ca.
           move ws-total-cr-pmt to ws-ol-total-cr.
           move ws-total-db-pmt to ws-ol-total-db.
           move ws-total-tax to ws-ol-total-tax.
           move ws-pct-ca to ws-ol-per-ca.
           move ws-pct-cr to ws-ol-per-cr.
           move ws-pct-db to ws-ol-per-db.

      *Write output
           write output-line from ws-output
             after advancing 2 lines.

      *Mark the file end point
           read input-file
               at end
                   move "y" to ws-eof-flag.

       400-write-footers.

           write output-line from ws-footer1
             after advancing 3 lines.

           write output-line from ws-footer4
             after advancing 1 line.

           write output-line from ws-footer5
             after advancing 1 line.

           write output-line from ws-footer6
             after advancing 1 line.

           write output-line from ws-footer7
             after advancing 1 line.

           write output-line from ws-footer8
             after advancing 1 line.

           write output-line from ws-footer9
             after advancing 1 line.

       end program ReturnsProcessing.

       identification division.
       program-id. Edit.
       author. Neema, Diego, Yustina, Kinen.
       date-written. 2023-04-04.
      *Program Description: This EDIT Program is for Editing Programs.
      * Records will Output 2 Files -> Valid and Invalid.
      *  Error File will be created.

       environment division.
       input-output section.
       file-control.

           select input-file
               assign to "../../../data/project8.dat"
               organization is line sequential.

           select error-report-file
               assign to "../../../data/Errors.out"
               organization is line sequential.

           select valid-data-file
               assign to "../../../data/valid-project8.dat"
               organization is line sequential.

           select invalid-data-file
               assign to "../../../data/invalid-project8.dat"
               organization is line sequential.

      *
       data division.
       file section.
       fd input-file
           data record is salary-rec
           record contains 36 characters.

      *Fields used to take in data from input file
       01 input-record.
         05 transaction-code pic X.
           88 transaction-code-valid-88
                   value "S", "R", "L".
         05 transaction-amount pic 9(5)V99.
         05 payment-type pic XX.
           88 payment-type-valid-88
                   value "CA", "CR", "DB".
         05 store-number pic XX.
           88 store-number-valid-88
                   value "01", "02", "03", "04", "05", "12".
         05 invoice-number pic X(9).
         05 invoice-number-r redefines invoice-number.
           10 in-invoice-letters1 pic X.
             88 in-invoice-letters1-valid-88
                       value "A", "B", "C", "D", "E".
           10 in-invoice-letters2 pic X.
             88 in-invoice-letters2-valid-88
                      value "A", "B", "C", "D", "E".
           10 in-invoice-dash pic X.
             88 invoice-dash-valid-88
                       value "-".
           10 invoice-numbers pic 9(6).
         05 in-sku-code pic X(15).
      *
       fd error-report-file
           data record is report-line
           record contains 36 characters.

       01 report-line pic x(36).

       fd valid-data-file
           data record is data-line
           record contains 36 characters.

       01 valid-data-line pic x(36).

       fd invalid-data-file
           data record is data-line
           record contains 36 characters.

       01 invalid-data-line pic x(36).

       working-storage section.

      *Indicates end of file flag
       01 ws-eof-flag pic x value 'n'.

      *Report title
       01 ws-report-title-line1.
         05 filler pic x(7) value spaces.
         05 ws-report-title pic x(15) value "ERRORS REPORT -".
         05 filler pic x(1) value spaces.
         05 ws-group pic x(7) value "GROUP 3".
         05 filler pic x(6) value spaces.

      *Declares the summary underline
       01 ws-report-title-line2.
         05 filler pic x(36) value
                   "------------------------------------".
      *              "----+----1----+----2----+----3----+----4"

      *Report Heading - line 1
       01 ws-heading-line1.
         05 filler pic x(2) value spaces.
         05 ws-record-desc pic x(6) value "Record".
         05 filler pic x(2) value spaces.
         05 ws-raw-data-desc pic x(26) value
                             "------ERROR MESSAGES------".

      *Report Heading - line 2
       01 ws-heading-line2.
         05 filler pic x(2) value spaces.
         05 ws-number-desc pic x(6) value "Number".
         05 filler pic x(2) value spaces.
         05 ws-messages-desc pic x(26) value
                             "--------RAW DATA---------".

      *Report detail line
       01 ws-report-detail-line.
         05 filler pic x(3) value spaces.
         05 ws-record-number-counter pic ZZ9.
         05 filler pic x(4) value spaces.
         05 ws-inv-desc pic x(7) value "INV. #:".
         05 filler pic x value spaces.
         05 ws-invoice-num pic x(9).
         05 filler pic x(9) value spaces.

      *Report error line1 - Transaction Code
       01 ws-report-error-line1.
         05 filler pic x(10) value spaces.
         05 ws-error1 pic x(24).
         05 filler pic x(2) value spaces.

      *Report error line2 - Transaction Amount
       01 ws-report-error-line2.
         05 filler pic x(10) value spaces.
         05 ws-error2 pic x(24).
         05 filler pic x(2) value spaces.

      *Report error line3 - Payment Type
       01 ws-report-error-line3.
         05 filler pic x(10) value spaces.
         05 ws-error3 pic x(24).
         05 filler pic x(2) value spaces.

      *Report error line4 - Store Number
       01 ws-report-error-line4.
         05 filler pic x(10) value spaces.
         05 ws-error4 pic x(24).
         05 filler pic x(2) value spaces.

      *Report error line5 - Invoice number format
       01 ws-report-error-line5.
         05 filler pic x(10) value spaces.
         05 ws-error5 pic x(24).
         05 filler pic x(2) value spaces.

      *Report error line6 - Invoice Letters
       01 ws-report-error-line6.
         05 filler pic x(10) value spaces.
         05 ws-error6 pic x(24).
         05 filler pic x(2) value spaces.

      *Report error line7 - Repetitive Invoice Letters
       01 ws-report-error-line7.
         05 filler pic x(10) value spaces.
         05 ws-error7 pic x(24).
         05 filler pic x(2) value spaces.

      *Report error line8 - Out of range invoice number
       01 ws-report-error-line8.
         05 filler pic x(10) value spaces.
         05 ws-error8 pic x(24).
         05 filler pic x(2) value spaces.

      *Report error line9 - Invoice dash
       01 ws-report-error-line9.
         05 filler pic x(10) value spaces.
         05 ws-error9 pic x(24).
         05 filler pic x(2) value spaces.

      *Report error line10 - Empty SKU Code
       01 ws-report-error-line10.
         05 filler pic x(10) value spaces.
         05 ws-error10 pic x(24).
         05 filler pic x(2) value spaces.

      *Report error line10 - Empty SKU Code
       01 ws-report-valid-line.
         05 filler pic x(10) value spaces.
         05 ws-valid pic x(24).
         05 filler pic x(2) value spaces.

      *Total Records
       01 ws-total-records.
         05 ws-total-records-desc pic x(18) value "NUMBER OF RECORDS:".
         05 filler pic x(9) value spaces.
         05 ws-total-records-num pic ZZ9.
         05 filler pic x(6) value spaces.

      *Total Valid Records
       01 ws-total-valid-records.
         05 ws-total-valid-records-desc pic x(24) value
                                        "NUMBER OF VALID RECORDS:".
         05 filler pic x(3) value spaces.
         05 ws-total-valid-records-num pic ZZ9.
         05 filler pic x(6) value spaces.

      *Total Invalid Records
       01 ws-total-invalid-records.
         05 ws-total-invalid-records-desc pic x(26) value
                                          "NUMBER OF INVALID RECORDS:".
         05 filler pic x value spaces.
         05 ws-total-invalid-records-num pic ZZ9.
         05 filler pic x(6) value spaces.

      *Temporary values
       01 ws-calcs.
         05 ws-record-number-counter-temp pic 9(3).
         05 ws-invalid-counter pic 9(3).
         05 ws-valid-counter pic 9(3).
         05 ws-error1-counter pic 9(3).
         05 ws-error2-counter pic 9(3).
         05 ws-error3-counter pic 9(3).
         05 ws-error4-counter pic 9(3).
         05 ws-error5-counter pic 9(3).
         05 ws-error6-counter pic 9(3).
         05 ws-error7-counter pic 9(3).
         05 ws-error8-counter pic 9(3).
         05 ws-error9-counter pic 9(3).
         05 ws-error10-counter pic 9(3).

      *Constants
       77 ws-error1-text pic x(18) value "INVALID TRAN. CODE".
       77 ws-error2-text pic x(24) value "TRAN. AMOUNT NOT NUMERIC".
       77 ws-error3-text pic x(20) value "INVALID PAYMENT TYPE".
       77 ws-error4-text pic x(20) value "INVALID STORE NUMBER".
       77 ws-error5-text pic x(21) value "INVALID INV. # FORMAT".
       77 ws-error6-text pic x(20) value "INVALID INV. LETTERS".
       77 ws-error7-text pic x(23) value "INV. WITH EQUAL LETTERS".
       77 ws-error8-text pic x(19) value "INV. # OUT OF RANGE".
       77 ws-nine-hd-thou pic 9(6) value 900000.
       77 ws-error9-text pic x(22) value "INV. DOES NOT HAVE '-'".
       77 ws-error10-text pic x(20) value "SKU CODE NOT FILLED".

       procedure division.
       000-main.
      *    Opens input and output files
           open input input-file.
           open output error-report-file.
           open output valid-data-file.
           open output invalid-data-file.

      *    Reads input-file
           read input-file
               at end
                   move "Y" to ws-eof-flag.

      *    Displays headings
           perform 100-print-headings.

      *    Displays list of products
           perform 200-process-data
             until ws-eof-flag = "Y".

           write report-line from ws-total-records.
           write report-line from ws-total-valid-records.
           write report-line from
             ws-total-invalid-records.

      *    Closes files
           close input-file.
           close error-report-file.
           close valid-data-file.
           close invalid-data-file.

           goback.

       100-print-headings.

      *    Writes Report title
           write report-line from ws-report-title-line2
             after advancing 2 lines.

      *    Writes Report title
           write report-line from ws-report-title-line1
             after advancing 1 line.

      *    Writes Report title
           write report-line from ws-report-title-line2
             after advancing 1 line.

      *    Advances 1 line
           write report-line from spaces
             after advancing 1 line.

      *    Writes Heading line 1
           write report-line from ws-heading-line1
             after advancing 1 line.

      *    Writes Heading line 2
           write report-line from ws-heading-line2.

      *    Advances 1 line
           write report-line from spaces
             after advancing 1 line.

       200-process-data.

      *    Sets counters to 0
           move 0 to ws-error1-counter
           move 0 to ws-error2-counter
           move 0 to ws-error3-counter
           move 0 to ws-error4-counter
           move 0 to ws-error5-counter
           move 0 to ws-error6-counter
           move 0 to ws-error7-counter
           move 0 to ws-error8-counter
           move 0 to ws-error9-counter
           move 0 to ws-error10-counter

      *    Record counter
           compute ws-record-number-counter-temp =
             ws-record-number-counter-temp + 1.

           move ws-record-number-counter-temp
             to ws-record-number-counter.

      *    Processes the errors so they appear above the invalid data
           perform 300-process-errors.

      *    Processes all lines including invalid and invalid data,
      *    and the report data
           perform 400-process-lines.

      *    Reads until end of file
           read input-file
               at end
                   move "Y" to ws-eof-flag.

       300-process-errors.

      *    Processes all errors
           perform 310-process-error1.
           perform 320-process-error2.
           perform 330-process-error3.
           perform 340-process-error4.
           perform 350-process-error5.
           perform 360-process-error6.
           perform 370-process-error7.
           perform 380-process-error8.
           perform 390-process-error9.
           perform 395-process-error10.

       310-process-error1.

      *    Error 1: Transaction Code
           if not transaction-code-valid-88 then

               move ws-error1-text to ws-error1
               write report-line from ws-report-error-line1
               compute ws-error1-counter = ws-error1-counter + 1

           end-if.

       320-process-error2.

      *    Error 2: Transaction Amount
           if transaction-amount not numeric then

               move ws-error2-text to ws-error2
               write report-line from ws-report-error-line2
               compute ws-error2-counter = ws-error2-counter + 1

           end-if.

       330-process-error3.

      *    Error 3: Payment Type
           if not payment-type-valid-88 then

               move ws-error3-text to ws-error3
               write report-line from ws-report-error-line3
               compute ws-error3-counter = ws-error3-counter + 1

           end-if.

       340-process-error4.

      *    Error 4: Store Number
           if not store-number-valid-88 then

               move ws-error4-text to ws-error4
               write report-line from ws-report-error-line4
               compute ws-error4-counter = ws-error4-counter + 1

           end-if.

       350-process-error5.

      *    Error 5: Invoice number format
           if in-invoice-letters1 not alphabetic or
             in-invoice-letters2 not alphabetic or
             invoice-numbers not numeric then

               move ws-error5-text to ws-error5
               write report-line from ws-report-error-line5
               compute ws-error5-counter = ws-error5-counter + 1

           end-if.

       360-process-error6.

      *    Error 6: Invoice Letters
           if not in-invoice-letters1-valid-88 or
             not in-invoice-letters2-valid-88 then

               move ws-error6-text to ws-error6
               write report-line from ws-report-error-line6
               compute ws-error6-counter = ws-error6-counter + 1

           end-if.

       370-process-error7.

      *    Error 7: Repetitive invoice letters
           if in-invoice-letters1 = in-invoice-letters2 then

               move ws-error7-text to ws-error7
               write report-line from ws-report-error-line7
               compute ws-error7-counter = ws-error7-counter + 1

           end-if.

       380-process-error8.

      *    Error 8: Out of range Invoice Number
           if invoice-numbers numeric then

               if invoice-numbers > ws-nine-hd-thou or
                 invoice-numbers < 0 then

                   move ws-error8-text to ws-error8
                   write report-line from ws-report-error-line8
                   compute ws-error8-counter = ws-error8-counter + 1

               end-if.

       390-process-error9.

      *    Error 9: Invoice dash
           if not invoice-dash-valid-88 then

               move ws-error9-text to ws-error9
               write report-line from ws-report-error-line9
               compute ws-error9-counter = ws-error9-counter + 1

           end-if.

       395-process-error10.

      *    Error 10: Empty SKU Code
           if in-sku-code is equal spaces then

               move ws-error10-text to ws-error10
               write report-line from ws-report-error-line10
               compute ws-error10-counter = ws-error10-counter + 1

           end-if.

       400-process-lines.

      *    If there are errors
           if ws-error1-counter is not equal 0 or
             ws-error2-counter is not equal 0 or
             ws-error3-counter is not equal 0 or
             ws-error4-counter is not equal 0 or
             ws-error5-counter is not equal 0 or
             ws-error6-counter is not equal 0 or
             ws-error7-counter is not equal 0 or
             ws-error8-counter is not equal 0 or
             ws-error9-counter is not equal 0 or
             ws-error10-counter is not equal 0 then

               compute ws-invalid-counter =
                 ws-invalid-counter + 1

      *        Moves data to invalid dat file
               write invalid-data-line from input-record

      *        Invoice description
               move invoice-number to ws-invoice-num

      *        Writes detail line
               write report-line from ws-report-detail-line

      *        Advances 1 line
               write report-line from spaces
                 after advancing 1 line

           else

               compute ws-valid-counter = ws-valid-counter + 1

      *        Moves data to valid dat file
               write valid-data-line from input-record

           end-if.

      *    Process totals
           move ws-record-number-counter to ws-total-records-num.
           move ws-valid-counter to
             ws-total-valid-records-num.
           move ws-invalid-counter to
             ws-total-invalid-records-num.

       end program Edit.
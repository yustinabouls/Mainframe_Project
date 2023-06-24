       program-id. DataSplitandCount.
       author. Neema, Diego, Yustina, Kinen.
       date-written. 2023-04-05.
      *Program Description: TThe DATA SPLIT AND COUNT program is
      * responsilble for dividing the input data records into 2 output
      * data files according to Transaction Code and generating a
      *  report of the totals of each type of record.

       environment division.
       input-output section.
       file-control.
      *
           select input-file
               assign to "../../../data/valid-project8.dat"
               organization is line sequential.

           select sc-report-file
               assign to "../../../data/CountsandControls.out"
               organization is line sequential.

           select return-data-file
               assign to "../../../data/return-project8.dat"
               organization is line sequential.

           select saleslayaway-data-file
               assign to "../../../data/saleslayaway-project8.dat"
               organization is line sequential.
      *
       data division.
       file section.
       fd input-file
           data record is input-rec
           record contains 36 characters.

      *Fields used to take in data from input file
       01 input-rec.
         05 in-transaction-code pic X.
           88 in-88-code-S
                   value "S".
           88 in-88-code-L
                   value "L".
           88 in-88-code-R
                   value "R".
         05 in-transaction-amount pic 9(5)V99.
         05 in-payment-type pic XX.
           88 in-88-type-CA
                   value "CA".
           88 in-88-type-DB
                   value "DB".
           88 in-88-type-CR
                   value "CR".
         05 in-store-number pic XX.
         05 in-invoice-number pic X(9).
         05 in-invoice-number-r pic 9(6).
         05 in-sku-code pic X(15).
      *
       fd sc-report-file
           data record is report-line
           record contains 40 characters.

       01 report-line pic x(40).
      *
       fd return-data-file
           data record is return-data-line
           record contains 36 characters.

       01 return-data-line pic x(36).
      *
       fd saleslayaway-data-file
           data record is saleslayaway-data-line
           record contains 36 characters.
      *
       01 saleslayaway-data-line pic x(36).

       working-storage section.
      *
      *Indicates end of file flag
       01 ws-eof-flag pic x value 'n'.

      *Report title
       01 ws-report-title-line.
         05 filler pic x(2) value spaces.
         05 ws-report-title pic x(28) value
                            "COUNTS AND CONTROLS REPORT -".
         05 filler pic x(1) value spaces.
         05 ws-group pic x(7) value "GROUP 3".
         05 filler pic x(2) value spaces.

      *
      *Declares the summary heading
       01 ws-summary1-line.
         05 filler pic x(40) value
                   "       SALES and LAYAWAY SUMMARY        ".
      *              "----+----1----+----2----+----3----+----4"
      *
      *Declares the summary underline
       01 ws-summary-underline.
         05 filler pic x(40) value
                   "----------------------------------------".
      *              "----+----1----+----2----+----3----+----4"
      *
      *Total line 1: Number of S&L records
       01 ws-total1-line1.
         05 filler pic x(27) value "Total number of S&L records".
      *               ----+----1----+----2----+----3----+
         05 filler pic x(6) value spaces.
         05 ws-total-num-sl pic zz9.
         05 filler pic x(4) value spaces.
      *
      *Total line 1: Total Amount for S&L records
       01 ws-total1-line2.
         05 filler pic x(27) value "Total amount of S&L records".
      *               ----+----1----+----2----+----3----+
         05 filler pic x(2) value spaces.
         05 ws-total-amount-sl pic $(4),$$9.99.
      *
      *Total line 2: Number of S records
       01 ws-total2-line1.
         05 filler pic x(27) value "Total number of S records  ".
      *               ----+----1----+----2----+----3----+
         05 filler pic x(6) value spaces.
         05 ws-total-num-s pic zz9.
         05 filler pic x(4) value spaces.
      *
      *Total line 2: Total Amount for S records
       01 ws-total2-line2.
         05 filler pic x(27) value "Total amount of S records  ".
      *               ----+----1----+----2----+----3----+
         05 filler pic x(2) value spaces.
         05 ws-total-amount-s pic $(4),$$9.99.
      *
      *Total line 3: Number of L records
       01 ws-total3-line1.
         05 filler pic x(27) value "Total number of L records  ".
      *               ----+----1----+----2----+----3----+
         05 filler pic x(6) value spaces.
         05 ws-total-num-l pic zz9.
         05 filler pic x(4) value spaces.
      *
      *Total line 3: Total Amount for L records
       01 ws-total3-line2.
         05 filler pic x(27) value "Total amount of L records  ".
      *               ----+----1----+----2----+----3----+
         05 filler pic x(2) value spaces.
         05 ws-total-amount-l pic $(4),$$9.99.
      *
      *Declares the summary heading 2
       01 ws-summary2-line.
         05 filler pic x(40) value "Store Transactions           ".
      *              "----+----1----+----2----+----3----+----4"

      *Total line 4: Total transaction amount for each store
       01 ws-total4-line occurs 6 times.
         05 filler pic x(5) value "Store".
      *               ----+----1----+----2----+----3----+
         05 filler pic x(2) value spaces.
         05 ws-store-sl pic XX.
         05 filler pic x(14) value spaces.
         05 filler pic x(5) value "Total".
         05 filler pic x(1) value spaces.
         05 filler pic x(1) value "-".
         05 filler pic x(1) value spaces.
         05 ws-total-store-sl pic $$,$$9.99.
      *
      *Declares the summary heading 2
       01 ws-summary3-line.
         05 filler pic x(40) value "Payment Percentages          ".
      *              "----+----1----+----2----+----3----+----4"
      *
      *Total line 5: Percentage of number of transactions
      *    in each payment type category
      *
       01 ws-total5-line occurs 3 times.
         05 filler pic x(12) value "Payment Type".
      *               ----+----1----+----2----+----3----+
         05 filler pic x(2) value spaces.
         05 ws-payment-type pic XX.
         05 filler pic x(20) value spaces.
         05 ws-percentage-type pic zz9.
         05 filler pic x(1) value "%".
      *
      *Declares the summary heading
       01 ws-summary4-line.
         05 filler pic x(40) value
                   "             RETURN SUMMARY             ".
      *              "----+----1----+----2----+----3----+----4"
      *
      *Declares the summary heading 2
       01 ws-summary5-line.
         05 filler pic x(40) value
                   "Store Transactions and # of returns".
      *              "----+----1----+----2----+----3----+----4"

      *Total line 4: Total transaction amount for each store
       01 ws-total6-line occurs 6 times.
         05 filler pic x(5) value "Store".
      *               ----+----1----+----2----+----3----+
         05 filler pic x(2) value spaces.
         05 ws-store-r pic XX.
         05 filler pic x(3) value spaces.
         05 filler pic x(6) value "# of R".
         05 filler pic x(1) value spaces.
         05 filler pic x(1) value "-".
         05 filler pic x(1) value spaces.
         05 ws-store-r-count pic 9.
         05 filler pic x(3) value spaces.
         05 filler pic x(5) value "Total".
         05 filler pic x(1) value spaces.
         05 filler pic x(1) value "-".
         05 filler pic x(1) value spaces.
         05 ws-total-store-r pic $$$9.99.
      *
      *Total line 7: Number of R records
       01 ws-total7-line1.
         05 filler pic x(27) value "Total number of R records  ".
      *               ----+----1----+----2----+----3----+
         05 filler pic x(6) value spaces.
         05 ws-total-num-r pic zz9.
         05 filler pic x(4) value spaces.
      *
      *Total line 2: Total Amount for R records
       01 ws-total7-line2.
         05 filler pic x(27) value "Total amount of R records  ".
      *               ----+----1----+----2----+----3----+
         05 filler pic x(2) value spaces.
         05 ws-total-amount-r pic $(4),$$9.99.
      *
      *Declares the summary heading
       01 ws-summary6-line.
         05 filler pic x(40) value
                   "            TOTAL SUMMARY               ".
      *              "----+----1----+----2----+----3----+----4"
      *Total line 2: Total Amount for R records
       01 ws-total8-line1.
         05 filler pic x(28) value "Grand total of S&L without R".
      *               ----+----1----+----2----+----3----+
         05 filler pic x(1) value spaces.
         05 ws-grand-total-amount-sl pic $(4),$$9.99.

      *
      *Temporary values
       01 ws-calcs.
         05 ws-total-num-sl-calc pic 9(3) value 0.
         05 ws-total-amount-sl-calc pic 9(8)v99 value 0.
         05 ws-total-num-s-calc pic 9(3) value 0.
         05 ws-total-amount-s-calc pic 9(8)v99 value 0.
         05 ws-total-num-l-calc pic 9(3) value 0.
         05 ws-total-amount-l-calc pic 9(8)v99 value 0.
         05 ws-total-num-r-calc pic 9(3) value 0.
         05 ws-total-amount-r-calc pic 9(8)v99 value 0.
         05 ws-grand-amount-sl-calc pic 9(8)v99 value 0.
         05 ws-total-store-sl-calc pic 9(8)v99 value 0 occurs 6 times.
         05 ws-total-store-r-calc pic 9(8)v99 value 0 occurs 6 times.
         05 ws-pct-num-calc pic 9(3) value 0 occurs 3 times.
         05 ws-pct-calc pic 9(3) value 0 occurs 3 times.
         05 ws-pct-overall-calc pic 9(3) value 0.
         05 ws-store-r-count-calc pic 999 value 0 occurs 6 times.

      *Array calculation values
       01 ws-payment-type-records.
         05 ws-type-data.
           10 filler pic xx value "CA".
           10 filler pic xx value "CR".
           10 filler pic xx value "DB".
         05 ws-payment-type-records redefines ws-type-data occurs 3
                                    times.
           10 ws-type-name pic xx.
       01 ws-store-records.
         05 ws-store-data.
           10 filler pic xx value "01".
           10 filler pic xx value "02".
           10 filler pic xx value "03".
           10 filler pic xx value "04".
           10 filler pic xx value "05".
           10 filler pic xx value "12".
         05 ws-store-records redefines ws-store-data occurs 6 times.
           10 ws-store-name pic xx.

      *
       01 ws-constants.
         05 ws-num-of-payment-types pic 99 value 3.
         05 ws-num-of-stores pic 99 value 6.
         05 ws-sub pic 99 value 1.

       procedure division.
       000-main.
      *
      *Opens the files
           open input input-file.
           open output sc-report-file
             return-data-file
             saleslayaway-data-file.
      *
      *Initial read of salary file
           read input-file
               at end
                   move "y" to ws-eof-flag.
      *
      *Displays headings
           perform 100-print-headings.
      *
      *Processes each input record and reads the next
           perform 200-process-data
             until ws-eof-flag equals "y".
      *
      *Print the totals
           perform 300-print-totals.

           close input-file
             sc-report-file
             return-data-file
             saleslayaway-data-file.
      *
           goback.

       100-print-headings.

      *    Advances 1 line
           write report-line from spaces
             after advancing 1 line.

      *    Writes Report title
           write report-line from ws-summary-underline.
           write report-line from ws-report-title-line.
           write report-line from ws-summary-underline.

       200-process-data.

      *    Process return file
           perform 210-process-return.

      *    Process sales and layaway file
           perform 220-process-saleslayaway.

           perform 230-process-totals.

      *    Reads until end of file
           read input-file
               at end
                   move "y" to ws-eof-flag.

      *    Proccesses the returns
       210-process-return.

           if in-88-code-R
               write return-data-line from input-rec
           end-if.
      *
      *    Proccesses the returns
       220-process-saleslayaway.
           if in-88-code-S or in-88-code-L
               write saleslayaway-data-line
                 from input-rec
           end-if.
      *
      *    Proccesses the returns
       230-process-totals.

      *    Total Calulations: S&L records
           if in-88-code-S or in-88-code-L
               add 1 to ws-total-num-sl-calc
               add in-transaction-amount to ws-total-amount-sl-calc
           end-if.

      *    Total Calulations: S records
           if in-88-code-S
               add 1 to ws-total-num-s-calc
               add in-transaction-amount to ws-total-amount-s-calc
           end-if.

      *    Total Calulations: L records
           if in-88-code-L
               add 1 to ws-total-num-l-calc
               add in-transaction-amount to ws-total-amount-l-calc
           end-if.

      *    S&L Store Transaction Calulations
           perform
             varying ws-sub from 1 by 1
             until ws-sub > ws-num-of-stores

               move ws-store-name(ws-sub) to ws-store-sl(ws-sub)

               if in-88-code-L or in-88-code-S
                   if in-store-number = ws-store-name(ws-sub)
                       add in-transaction-amount
                         to ws-total-store-sl-calc(ws-sub)
                       move ws-total-store-sl-calc(ws-sub)
                         to ws-total-store-sl(ws-sub)
                   end-if
               end-if

           end-perform

      *    Payment Percentage Calulations
           perform
             varying ws-sub from 1 by 1
             until ws-sub > ws-num-of-payment-types

               move ws-type-name(ws-sub) to ws-payment-type(ws-sub)

               if in-88-code-L or in-88-code-S
                   if in-payment-type = ws-type-name(ws-sub)
                       add 1 to ws-pct-overall-calc
                   end-if
               end-if

               if in-88-code-L or in-88-code-S
                   if ws-type-name(ws-sub) = ws-type-name(ws-sub)
                       if in-payment-type = ws-type-name(ws-sub)
                           add 1 to ws-pct-num-calc(ws-sub)

                           compute ws-pct-calc(ws-sub) =
                             ((ws-pct-num-calc(ws-sub)
                               / ws-pct-overall-calc)
                              * (100))

                           move ws-pct-calc(ws-sub)
                             to ws-percentage-type(ws-sub)
                       end-if
                   end-if
               end-if
           end-perform.

      *    R Store Transaction Calulations include total number
      *    of stores and total transactions
           perform
             varying ws-sub from 1 by 1
             until ws-sub > ws-num-of-stores

               move ws-store-name(ws-sub) to ws-store-r(ws-sub)

      *        Initializes all stores which ensures that
      *        the stores within loop are all accounted for
               if in-store-number = ws-store-name(ws-sub)
                   add 0
                     to ws-total-store-r-calc(ws-sub)
                   move ws-total-store-r-calc(ws-sub)
                     to ws-total-store-r(ws-sub)

                   add 0
                     to ws-store-r-count-calc(ws-sub)
                   move ws-store-r-count-calc(ws-sub)
                     to ws-store-r-count(ws-sub)
               end-if

               if in-88-code-R
                   if in-store-number = ws-store-name(ws-sub)
                       add in-transaction-amount to
                         ws-total-store-r-calc(ws-sub)
                       move ws-total-store-r-calc(ws-sub)
                         to ws-total-store-r(ws-sub)

                       add 1
                         to ws-store-r-count-calc(ws-sub)
                       move ws-store-r-count-calc(ws-sub)
                         to ws-store-r-count(ws-sub)
                   end-if
               end-if

           end-perform.

      *    Total Calulations: R records
           if in-88-code-R
               add 1 to ws-total-num-r-calc
               add in-transaction-amount to ws-total-amount-r-calc
           end-if.

      *    Grand Total Calculations
           compute ws-grand-amount-sl-calc rounded =
             (ws-total-amount-sl-calc - ws-total-amount-r-calc).

       300-print-totals.
      *
      *    Moves required data to total lines for output
           move ws-total-num-sl-calc to ws-total-num-sl.
           move ws-total-amount-sl-calc to ws-total-amount-sl.
           move ws-total-num-s-calc to ws-total-num-s.
           move ws-total-amount-s-calc to ws-total-amount-s.
           move ws-total-num-l-calc to ws-total-num-l.
           move ws-total-amount-l-calc to ws-total-amount-l.
           move ws-total-num-r-calc to ws-total-num-r.
           move ws-total-amount-r-calc to ws-total-amount-r.
           move ws-grand-amount-sl-calc to ws-grand-total-amount-sl.

      *    Summary 1: S&L transactions
           write report-line from ws-summary1-line
             after advancing 2 lines.
           write report-line from ws-summary-underline.
           write report-line from ws-total1-line1
             after advancing 1 line.
           write report-line from ws-total1-line2.
           write report-line from ws-total2-line1
             after advancing 1 line.
           write report-line from ws-total2-line2.
           write report-line from ws-total3-line1
             after advancing 1 line.
           write report-line from ws-total3-line2.

      *    Summary 2: S&L Store transactions
           write report-line from ws-summary2-line
             after advancing 1 line.
           perform
             varying ws-sub from 1 by 1
             until ws-sub > ws-num-of-stores
               write report-line from ws-total4-line(ws-sub)
                 after advancing 1 line
           end-perform

      *    Summary 3: S&L Payment Percentages
           write report-line from ws-summary3-line
             after advancing 2 lines.
           perform
             varying ws-sub from 1 by 1
             until ws-sub > ws-num-of-payment-types
               write report-line from ws-total5-line(ws-sub)
                 after advancing 1 line
           end-perform

      *    Summary 4: R Store Transactions
           write report-line from ws-summary4-line
             after advancing 2 lines.
           write report-line from ws-summary-underline.
           write report-line from ws-summary5-line
             after advancing 1 line.

           perform
             varying ws-sub from 1 by 1
             until ws-sub > ws-num-of-stores
               write report-line from ws-total6-line(ws-sub)
                 after advancing 1 line
           end-perform

      *    Total R payments
           write report-line from ws-total7-line1
             after advancing 2 lines.

           write report-line from ws-total7-line2.

      *    Summary 5: Grand Totals
           write report-line from ws-summary6-line
             after advancing 1 line.
           write report-line from ws-summary-underline.

      *    Grand Total S&L
           write report-line from ws-total8-line1
             after advancing 1 line.

       end program DataSplitandCount.

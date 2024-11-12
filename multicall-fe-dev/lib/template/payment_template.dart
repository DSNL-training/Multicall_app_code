String htmlTemplate = """
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>96b183ac-a46c-47fc-a442-9a01c28aa4e0</title>
    <style type="text/css">
      * {
        margin: 0;
        padding: 24;
        text-indent: 0;
      }
      h1 {
        color: black;
        font-family: Arial, sans-serif;
        font-style: normal;
        font-weight: bold;
        text-decoration: none;
        font-size: 15pt;
      }
      p {
        color: black;
        font-family: Arial, sans-serif;
        font-style: normal;
        font-weight: bold;
        text-decoration: none;
        font-size: 12pt;
        margin: 0pt;
      }
      .s1 {
        color: #fff;
        font-family: Arial, sans-serif;
        font-style: normal;
        font-weight: bold;
        text-decoration: none;
        font-size: 12pt;
      }
      .s2 {
        color: black;
        font-family: Arial, sans-serif;
        font-style: normal;
        font-weight: normal;
        text-decoration: none;
        font-size: 12pt;
      }
      .a,
      a {
        color: black;
        font-family: Arial, sans-serif;
        font-style: normal;
        font-weight: normal;
        text-decoration: none;
        font-size: 12pt;
      }
      li {
        display: block;
      }
      #l1 {
        padding-left: 0pt;
        counter-reset: c1 1;
      }
      #l1 > li > *:first-child:before {
        counter-increment: c1;
        content: counter(c1, decimal) ". ";
        color: black;
        font-family: Arial, sans-serif;
        font-style: normal;
        font-weight: bold;
        text-decoration: none;
        font-size: 12pt;
      }
      #l1 > li:first-child > *:first-child:before {
        counter-increment: c1 0;
      }
      table,
      tbody {
        vertical-align: top;
        overflow: visible;
      }
    </style>
  </head>
  <body>
    <p style="padding-left: 7pt; text-indent: 0pt; text-align: left">
      <span
        ><table border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td>
              <img
                width="137"
                height="40"
                src="data:image/png;base64,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Z2d1dHQMLyoq2nz33Xdfmpub271kyZIzXnjhhftDodDQnp6e5unTpz98+eWXP7x27dqJ995772vTp09f/cYbb5w4e/bs31522WUPPvbYY3/YunXrj4LBYOCZZ55Z9etf/3rO8OHDm9KCkamNHnrooQc7OzvHeL3exoaGhnHBYLDt7rvvvqC4uLj5448/PmHBggWP+P3+kd3d3V2TJk167qc//emdL7744q179+6tmj9//oVCCJ43b96Lw4cP33XTTTddS0R04403Lrnkkkt+9/3vf/91ANAE2alvtCW7CTmN3BwbM4EppBv8Xtti8CcKc4+ei5IC9zyPIXQ6f+RMPrZ8ApK2jYpgKaSQBAAegM+tOZrGFA3BnZ++jk/21oPgkFd62YEgBQnBgELqGx+SSH3KAYDg5nv69kncCKCwpZTlK1euPPuKK664vrKy8mvbtvHMM8/cd+GFF4449dRTaevWrUMeffTRu6ZNm/ZOXl5e+1VXXfXrqVOnLl23bt24uXPnLjnjjDOet23b+8wzz9wyb968Occee+yyTZs21VRWVrZs2bJFKKW65syZM3/8+PGr77vvvkdfeeWVG6dNm/a+x+NJB8BUV1dX4THHHLNwxowZ/3zggQceX7x48d1/+tOfJkQikdDPf/7z5V988cXE0tLS1vnz5788d+5c78knn0zLli0b8rvf/e7u2tra90OhUEcymayMRCKL7r///unV1dXbli9ffvqGDRt+OW/ePKOwsBBPPvnksU899dSDd9555yWGYTh9aBQC0HXDDTdc4ziOuOaaaza+/fbbp8+aNeuVRx555JlZs2ZVXHrppbRr166SG2+8ce6wYcNWzpo167m77rrr311dXTnt7e3BeDw+Zfv27SPb2tryGhoahtm2HZw8efL76YWpSbI1SSYEBDkkU5lYZiYmhxnETAVeHz7qeoe7P+2gm4+4jSvKKogIrFihzF8EUOrzvPSpGYBYKYzOH8wLZl1Fi3as4vlf/pcaw1EypLf3Qz7BghS7h40VZOozMAazA8BxjVAfQSYAiMfjmDZt2gvTpk37kIiwcuXKSYZhVO/atavl73//O5RyA5wNDQ2lkydP3sjMOxYvXnxmS0vL2JycHAkAX3/9dU1JSUlk/Pjxq4mIa2trtwKAbduGz+frqK2tXafruj1s2LDN27dvn5jpowghlBAiOWbM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"
              />
            </td>
          </tr></table
      ></span>
    </p>
    <p style="padding-top: 1pt; text-indent: 0pt; text-align: left"><br /></p>
    <h1 id="order_id" style="padding-left: 6pt; text-indent: 0pt; text-align: left">
      Order ID : {{orderId}}
    </h1>
    <p style="text-indent: 0pt; text-align: left"><br /></p>
    <p style="padding-top: 5pt; text-indent: 0pt; text-align: left"><br /></p>
    <p style="padding-left: 6pt; text-indent: 0pt; text-align: left">From</p>
    <p style="padding-left: 6pt; text-indent: 0pt; text-align: left">
      C3Ware MultiCall Technologies Pvt Ltd, T4, 7th Street, VSI Estate, Phase
      2, Thiruvanmiyur,
    </p>
    <p style="padding-left: 6pt; text-indent: 0pt; text-align: left">
      Chennai,
    </p>
    <p style="padding-left: 6pt; text-indent: 0pt; text-align: left">
      Tamil Nadu - 600 041.
    </p>
    <p style="padding-top: 2pt; text-indent: 0pt; text-align: left"><br /></p>
    <p style="padding-left: 6pt; text-indent: 0pt; text-align: left">
      Account No: {{accountId}}
    </p>
    <p style="padding-top: 2pt; text-indent: 0pt; text-align: left"><br /></p>
    <p style="padding-left: 6pt; text-indent: 0pt; text-align: left">
      Payment Date: 2022-10-06
    </p>
    <p
      style="
        padding-top: 4pt;
        padding-left: 6pt;
        text-indent: 0pt;
        text-align: left;
      "
    >
      For {{name}}, {{address}}, {{city}}.
    </p>
    <p style="padding-left: 6pt; text-indent: 0pt; text-align: left">
      {{state}} - {{pinCode}}. Phone:{{phoneNumber}} GST No:{{gstNo}}
    </p>
    <p style="padding-left: 6pt; text-indent: 0pt; text-align: left">
      State Code: {{pinCode}}
    </p>
    <p style="padding-top: 6pt; text-indent: 0pt; text-align: left"><br /></p>
    <table
      style="border-collapse: collapse; margin-left: 5.88pt"
      cellspacing="0"
    >
      <tr style="height: 15pt">
        <td
          style="
            width: 96pt;
            border-bottom-style: solid;
            border-bottom-width: 1pt;
          "
          bgcolor="#3F99FF"
        >
          <p
            class="s1"
            style="text-indent: 0pt; line-height: 12pt; text-align: center"
          >
            S.No
          </p>
        </td>
        <td
          style="
            width: 259pt;
            border-bottom-style: solid;
            border-bottom-width: 1pt;
          "
          bgcolor="#3F99FF"
        >
          <p
            class="s1"
            style="
              padding-left: 1pt;
              text-indent: 0pt;
              line-height: 12pt;
              text-align: left;
            "
          >
            Description
          </p>
        </td>
        <td
          style="
            width: 164pt;
            border-bottom-style: solid;
            border-bottom-width: 1pt;
          "
          bgcolor="#3F99FF"
        >
          <p
            class="s1"
            style="text-indent: 0pt; line-height: 12pt; text-align: right"
          >
            Details
          </p>
        </td>
      </tr>
      <tr style="height: 19pt">
        <td
          style="
            width: 96pt;
            border-top-style: solid;
            border-top-width: 1pt;
            border-left-style: solid;
            border-left-width: 1pt;
            border-bottom-style: solid;
            border-bottom-width: 1pt;
            border-right-style: solid;
            border-right-width: 1pt;
          "
        >
          <p
            class="s2"
            style="padding-top: 1pt; text-indent: 0pt; text-align: center"
          >
            1
          </p>
        </td>
        <td
          style="
            width: 259pt;
            border-top-style: solid;
            border-top-width: 1pt;
            border-left-style: solid;
            border-left-width: 1pt;
            border-bottom-style: solid;
            border-bottom-width: 1pt;
            border-right-style: solid;
            border-right-width: 1pt;
          "
        >
          <p
            class="s2"
            style="
              padding-top: 1pt;
              padding-left: 4pt;
              text-indent: 0pt;
              text-align: left;
            "
          >
            {{planName}}
          </p>
        </td>
        <td
          style="
            width: 164pt;
            border-top-style: solid;
            border-top-width: 1pt;
            border-left-style: solid;
            border-left-width: 1pt;
            border-bottom-style: solid;
            border-bottom-width: 1pt;
            border-right-style: solid;
            border-right-width: 1pt;
          "
        >
          <p
            class="s2"
            style="
              padding-top: 1pt;
              padding-right: 3pt;
              text-indent: 0pt;
              text-align: right;
            "
          >
            {{planAmount}}
          </p>
        </td>
      </tr>
      <tr style="height: 20pt">
        <td
          style="
            width: 96pt;
            border-top-style: solid;
            border-top-width: 1pt;
            border-left-style: solid;
            border-left-width: 1pt;
            border-bottom-style: solid;
            border-bottom-width: 1pt;
            border-right-style: solid;
            border-right-width: 1pt;
          "
        >
          <p
            class="s2"
            style="padding-top: 1pt; text-indent: 0pt; text-align: center"
          >
            2
          </p>
        </td>
        <td
          style="
            width: 259pt;
            border-top-style: solid;
            border-top-width: 1pt;
            border-left-style: solid;
            border-left-width: 1pt;
            border-bottom-style: solid;
            border-bottom-width: 1pt;
            border-right-style: solid;
            border-right-width: 1pt;
          "
        >
          <p
            class="s2"
            style="
              padding-top: 1pt;
              padding-left: 4pt;
              text-indent: 0pt;
              text-align: left;
            "
          >
            cgst({{cgst}}%)
          </p>
        </td>
        <td
          style="
            width: 164pt;
            border-top-style: solid;
            border-top-width: 1pt;
            border-left-style: solid;
            border-left-width: 1pt;
            border-bottom-style: solid;
            border-bottom-width: 1pt;
            border-right-style: solid;
            border-right-width: 1pt;
          "
        >
          <p
            class="s2"
            style="
              padding-top: 1pt;
              padding-right: 3pt;
              text-indent: 0pt;
              text-align: right;
            "
          >
            {{cgstAmount}}
          </p>
        </td>
      </tr>
      <tr style="height: 20pt">
        <td
          style="
            width: 96pt;
            border-top-style: solid;
            border-top-width: 1pt;
            border-left-style: solid;
            border-left-width: 1pt;
            border-bottom-style: solid;
            border-bottom-width: 1pt;
            border-right-style: solid;
            border-right-width: 1pt;
          "
        >
          <p
            class="s2"
            style="padding-top: 1pt; text-indent: 0pt; text-align: center"
          >
            3
          </p>
        </td>
        <td
          style="
            width: 259pt;
            border-top-style: solid;
            border-top-width: 1pt;
            border-left-style: solid;
            border-left-width: 1pt;
            border-bottom-style: solid;
            border-bottom-width: 1pt;
            border-right-style: solid;
            border-right-width: 1pt;
          "
        >
          <p
            class="s2"
            style="
              padding-top: 1pt;
              padding-left: 4pt;
              text-indent: 0pt;
              text-align: left;
            "
          >
            sgst({{sgst}}%)
          </p>
        </td>
        <td
          style="
            width: 164pt;
            border-top-style: solid;
            border-top-width: 1pt;
            border-left-style: solid;
            border-left-width: 1pt;
            border-bottom-style: solid;
            border-bottom-width: 1pt;
            border-right-style: solid;
            border-right-width: 1pt;
          "
        >
          <p
            class="s2"
            style="
              padding-top: 1pt;
              padding-right: 3pt;
              text-indent: 0pt;
              text-align: right;
            "
          >
            {{sgstAmount}}
          </p>
        </td>
      </tr>
      <tr style="height: 20pt">
        <td
          style="
            width: 96pt;
            border-top-style: solid;
            border-top-width: 1pt;
            border-left-style: solid;
            border-left-width: 1pt;
            border-bottom-style: solid;
            border-bottom-width: 1pt;
            border-right-style: solid;
            border-right-width: 1pt;
          "
        >
          <p
            class="s2"
            style="padding-top: 1pt; text-indent: 0pt; text-align: center"
          >
            4
          </p>
        </td>
        <td
          style="
            width: 259pt;
            border-top-style: solid;
            border-top-width: 1pt;
            border-left-style: solid;
            border-left-width: 1pt;
            border-bottom-style: solid;
            border-bottom-width: 1pt;
            border-right-style: solid;
            border-right-width: 1pt;
          "
        >
          <p
            class="s2"
            style="
              padding-top: 1pt;
              padding-left: 4pt;
              text-indent: 0pt;
              text-align: left;
            "
          >
            igst({{igst}}%)
          </p>
        </td>
        <td
          style="
            width: 164pt;
            border-top-style: solid;
            border-top-width: 1pt;
            border-left-style: solid;
            border-left-width: 1pt;
            border-bottom-style: solid;
            border-bottom-width: 1pt;
            border-right-style: solid;
            border-right-width: 1pt;
          "
        >
          <p
            class="s2"
            style="
              padding-top: 1pt;
              padding-right: 3pt;
              text-indent: 0pt;
              text-align: right;
            "
          >
            {{igstAmount}}
          </p>
        </td>
      </tr>
      <tr style="height: 19pt">
        <td
          style="
            width: 96pt;
            border-top-style: solid;
            border-top-width: 1pt;
            border-left-style: solid;
            border-left-width: 1pt;
            border-bottom-style: solid;
            border-bottom-width: 1pt;
            border-right-style: solid;
            border-right-width: 1pt;
          "
        >
          <p
            class="s2"
            style="padding-top: 1pt; text-indent: 0pt; text-align: center"
          >
            5
          </p>
        </td>
        <td
          style="
            width: 259pt;
            border-top-style: solid;
            border-top-width: 1pt;
            border-left-style: solid;
            border-left-width: 1pt;
            border-bottom-style: solid;
            border-bottom-width: 1pt;
            border-right-style: solid;
            border-right-width: 1pt;
          "
        >
          <p
            class="s2"
            style="
              padding-top: 1pt;
              padding-left: 4pt;
              text-indent: 0pt;
              text-align: left;
            "
          >
            Total amount
          </p>
        </td>
        <td
          style="
            width: 164pt;
            border-top-style: solid;
            border-top-width: 1pt;
            border-left-style: solid;
            border-left-width: 1pt;
            border-bottom-style: solid;
            border-bottom-width: 1pt;
            border-right-style: solid;
            border-right-width: 1pt;
          "
        >
          <p
            class="s2"
            style="
              padding-top: 1pt;
              padding-right: 3pt;
              text-indent: 0pt;
              text-align: right;
            "
          >
            {{totalAmount}}
          </p>
        </td>
      </tr>
    </table>
    <p style="padding-top: 2pt; text-indent: 0pt; text-align: left"><br /></p>
    <p style="padding-left: 6pt; text-indent: 0pt; text-align: left">
      For C3Ware MultiCall Technologies Pvt Ltd
    </p>
    <p style="padding-top: 2pt; text-indent: 0pt; text-align: left"><br /></p>
    <p style="padding-left: 6pt; text-indent: 0pt; text-align: left">
      <span
        ><table border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td>
              <img
                width="138"
                height="50"
                src="data:image/jpg;base64,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"
              />
            </td>
          </tr></table
      ></span>
    </p>
    <p
      style="
        padding-top: 3pt;
        padding-left: 6pt;
        text-indent: 0pt;
        line-height: 112%;
        text-align: left;
      "
    >
      Authorised Signatory Notes
    </p>
    <p
      style="
        padding-top: 13pt;
        padding-left: 6pt;
        text-indent: 0pt;
        text-align: left;
      "
    >
      Statutory Details:
    </p>
    <p style="padding-top: 1pt; text-indent: 0pt; text-align: left"><br /></p>
    <ol id="l1">
      <li data-list-text="1.">
        <p style="padding-left: 19pt; text-indent: -13pt; text-align: left">
          Our GST Registration number 33AAHCC8115C1Z4
        </p>
        <p style="padding-top: 1pt; text-indent: 0pt; text-align: left">
          <br />
        </p>
      </li>
      <li data-list-text="2.">
        <p style="padding-left: 19pt; text-indent: -13pt; text-align: left">
          Service Accounting Code: (SAC) 998599 - Other Support Services n.e.c
        </p>
        <p style="padding-top: 1pt; text-indent: 0pt; text-align: left">
          <br />
        </p>
      </li>
      <li data-list-text="3.">
        <p style="padding-left: 19pt; text-indent: -13pt; text-align: left">
          PAN Number: AAHCC8115C
        </p>
        <p style="padding-top: 1pt; text-indent: 0pt; text-align: left">
          <br />
        </p>
      </li>
      <li data-list-text="4.">
        <p style="padding-left: 19pt; text-indent: -13pt; text-align: left">
          CIN No. U74999TN2018PTC125295
        </p>
        <p style="padding-top: 1pt; text-indent: 0pt; text-align: left">
          <br />
        </p>
      </li>
      <li data-list-text="5.">
        <p style="padding-left: 19pt; text-indent: -13pt; text-align: left">
          Refer to website for plan details
        </p>
      </li>
    </ol>
    <p style="padding-top: 3pt; text-indent: 0pt; text-align: left"><br /></p>
    <p style="text-indent: 0pt; text-align: center">
      <a href="mailto:support@multicall.in" class="a" target="_blank"
        >For queries regarding this invoice, write to: </a
      ><a href="mailto:support@multicall.in" target="_blank"
        >support@multicall.in</a
      >
    </p>
  </body>
</html>
""";

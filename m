Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-qk0-x231.google.com (mail-qk0-x231.google.com
 [IPv6:2607:f8b0:400d:c09::231])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 95E6F2110AE0C
 for <linux-nvdimm@lists.01.org>; Thu, 14 Jun 2018 12:43:50 -0700 (PDT)
Received: by mail-qk0-x231.google.com with SMTP id j80-v6so4338789qke.9
 for <linux-nvdimm@lists.01.org>; Thu, 14 Jun 2018 12:43:50 -0700 (PDT)
From: Masayoshi Mizuma <msys.mizuma@gmail.com>
Subject: [PATCH 0/2] nfit,
 test: Add some global variables and functions to cleanup.
Date: Thu, 14 Jun 2018 15:43:34 -0400
Message-Id: <20180614194336.15341-1-msys.mizuma@gmail.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

This is additional cleanup patches for test scripts.
Add following global variable and functions to test/common file.
Then, cleanup test script to use them.

 - NFIT_TEST_BUS[01] (global variable)
   Buses are created when nfit_test module is loaded.

 - NDCTL (global variable)
   ndctl command path (renamed).

 - _cleanup
   Helper function cleans up nfit_test module.

 - json2var
   Helper function (filter) converts json to var.

Masayoshi Mizuma (2):
  nfit, test: Add NFIT_TEST_BUS[01] variable and some helper funtions to common
  nfit, test: cleanup test scripts

 test/blk-exhaust.sh       | 21 ++++++----------
 test/btt-check.sh         | 52 ++++++++++++++++++---------------------
 test/btt-errors.sh        |  7 +++---
 test/btt-pad-compat.sh    | 36 ++++++++++++---------------
 test/clear.sh             | 25 +++++++------------
 test/common               | 29 +++++++++++++++++++---
 test/create.sh            | 26 +++++++++-----------
 test/daxdev-errors.sh     | 29 ++++++++--------------
 test/firmware-update.sh   | 25 +++++--------------
 test/inject-error.sh      | 24 ++++++++----------
 test/label-compat.sh      | 17 +++++--------
 test/multi-dax.sh         | 23 ++++++-----------
 test/pmem-errors.sh       | 19 +++++---------
 test/rescan-partitions.sh | 22 ++++++++---------
 test/sector-mode.sh       | 22 ++++++-----------
 15 files changed, 161 insertions(+), 216 deletions(-)

-- 
2.18.0.rc1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

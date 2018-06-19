Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-qt0-x242.google.com (mail-qt0-x242.google.com
 [IPv6:2607:f8b0:400d:c0d::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 526D92116DFB8
 for <linux-nvdimm@lists.01.org>; Tue, 19 Jun 2018 12:30:47 -0700 (PDT)
Received: by mail-qt0-x242.google.com with SMTP id p23-v6so851255qtn.6
 for <linux-nvdimm@lists.01.org>; Tue, 19 Jun 2018 12:30:46 -0700 (PDT)
From: Masayoshi Mizuma <msys.mizuma@gmail.com>
Subject: [PATCH v2 0/2] nfit,
 test: Add some global variables and functions to cleanup.
Date: Tue, 19 Jun 2018 15:30:29 -0400
Message-Id: <20180619193031.17555-1-msys.mizuma@gmail.com>
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

Changelog:
 - Fix missing '-b' before $NFIT_TEST_BUS*.

Masayoshi Mizuma (2):
  nfit, test: Add NFIT_TEST_BUS[01] variable and some helper funtions to common
  nfit, test: cleanup test scripts

 test/blk-exhaust.sh       | 21 ++++++----------
 test/btt-check.sh         | 52 ++++++++++++++++++---------------------
 test/btt-errors.sh        | 30 +++++++++++-----------
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
 15 files changed, 172 insertions(+), 228 deletions(-)

-- 
2.18.0.rc1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

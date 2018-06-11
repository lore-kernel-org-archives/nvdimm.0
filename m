Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-qt0-x244.google.com (mail-qt0-x244.google.com
 [IPv6:2607:f8b0:400d:c0d::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7FC9F21163706
 for <linux-nvdimm@lists.01.org>; Mon, 11 Jun 2018 09:46:03 -0700 (PDT)
Received: by mail-qt0-x244.google.com with SMTP id s9-v6so20891060qtg.2
 for <linux-nvdimm@lists.01.org>; Mon, 11 Jun 2018 09:46:03 -0700 (PDT)
From: Masayoshi Mizuma <msys.mizuma@gmail.com>
Subject: [PATCH 0/2] test: add some helper function and cleanup test script
Date: Mon, 11 Jun 2018 12:45:29 -0400
Message-Id: <20180611164531.8242-1-msys.mizuma@gmail.com>
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

Some test scripts have same function. So, let's cleanup
to stop the duplication by intoducing 'test/common' file.
Test scripts includes the common file to use the functions.

Masayoshi Mizuma (2):
  test: add some helper function for test script
  test: cleanup test scripts

 test/blk-exhaust.sh       | 21 +++------------
 test/btt-check.sh         | 35 +++++++-----------------
 test/btt-errors.sh        | 20 ++++----------
 test/btt-pad-compat.sh    | 52 +++++++++++++----------------------
 test/clear.sh             | 21 +++------------
 test/common               | 57 +++++++++++++++++++++++++++++++++++++++
 test/create.sh            | 21 +++------------
 test/daxdev-errors.sh     | 19 +++----------
 test/firmware-update.sh   | 25 ++++-------------
 test/inject-error.sh      | 31 ++++++---------------
 test/label-compat.sh      | 21 +++------------
 test/multi-dax.sh         | 19 +++----------
 test/pmem-errors.sh       | 20 +++++---------
 test/rescan-partitions.sh | 44 ++++++++----------------------
 test/sector-mode.sh       |  5 +---
 15 files changed, 146 insertions(+), 265 deletions(-)
 create mode 100644 test/common

-- 
2.17.1
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-qk0-x244.google.com (mail-qk0-x244.google.com
 [IPv6:2607:f8b0:400d:c09::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EE3FF2130F352
 for <linux-nvdimm@lists.01.org>; Tue, 12 Jun 2018 18:56:41 -0700 (PDT)
Received: by mail-qk0-x244.google.com with SMTP id k86-v6so615775qkh.13
 for <linux-nvdimm@lists.01.org>; Tue, 12 Jun 2018 18:56:41 -0700 (PDT)
From: Masayoshi Mizuma <msys.mizuma@gmail.com>
Subject: [PATCH v2 0/2] ndctl,
 test: add some helper function and cleanup test script
Date: Tue, 12 Jun 2018 21:56:14 -0400
Message-Id: <20180613015616.26487-1-msys.mizuma@gmail.com>
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

Changelog:
  - Add SPDX style license header to the new test/common file.
  - Fix wrong test expression in detect() on test/firmware-update.sh

Masayoshi Mizuma (2):
  ndctl, test: add some helper function for test script
  ndctl, test: cleanup test scripts

 test/blk-exhaust.sh       | 21 +++-----------
 test/btt-check.sh         | 35 +++++++----------------
 test/btt-errors.sh        | 20 ++++---------
 test/btt-pad-compat.sh    | 52 +++++++++++++--------------------
 test/clear.sh             | 23 ++++-----------
 test/common               | 60 +++++++++++++++++++++++++++++++++++++++
 test/create.sh            | 21 +++-----------
 test/daxdev-errors.sh     | 19 +++----------
 test/firmware-update.sh   | 26 ++++-------------
 test/inject-error.sh      | 31 ++++++--------------
 test/label-compat.sh      | 21 +++-----------
 test/multi-dax.sh         | 19 +++----------
 test/pmem-errors.sh       | 20 ++++---------
 test/rescan-partitions.sh | 44 +++++++---------------------
 test/sector-mode.sh       |  5 +---
 15 files changed, 151 insertions(+), 266 deletions(-)
 create mode 100644 test/common

-- 
2.18.0.rc1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C27418032B
 for <linux-nvdimm@lists.01.org>; Mon,  6 Mar 2017 13:38:41 -0800 (PST)
Subject: [PATCH 0/4] ndctl: adding test and support for dev dax poison clear
From: Dave Jiang <dave.jiang@intel.com>
Date: Mon, 06 Mar 2017 14:38:40 -0700
Message-ID: <148883624600.72901.16358369702902205527.stgit@djiang5-desk3.ch.intel.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

The following series implements unit test and support funciton for device
dax poison clear.

---

Dave Jiang (4):
      ndctl: add function to acquire region resource
      ndctl: have do_cmd() in libndctl return errno instead of -1
      ndctl/test: remove the bus check functions
      ndctl: add device dax error clear test


 ndctl/lib/libndctl.c   |   30 ++++
 ndctl/lib/libndctl.sym |    1 
 ndctl/libndctl.h.in    |    1 
 test/Makefile.am       |   10 +
 test/daxdev-errors.c   |  361 ++++++++++++++++++++++++++++++++++++++++++++++++
 test/daxdev-errors.sh  |   71 +++++++++
 test/libndctl.c        |  217 -----------------------------
 7 files changed, 471 insertions(+), 220 deletions(-)
 create mode 100644 test/daxdev-errors.c
 create mode 100755 test/daxdev-errors.sh

--
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

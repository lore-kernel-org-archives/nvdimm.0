Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EE71221A1349B
 for <linux-nvdimm@lists.01.org>; Thu,  4 May 2017 14:48:56 -0700 (PDT)
Subject: [PATCH v6 0/3] ndctl: add error clearing support for dev dax
From: Dave Jiang <dave.jiang@intel.com>
Date: Thu, 04 May 2017 14:48:56 -0700
Message-ID: <149393422747.2642.5136375594842641153.stgit@djiang5-desk3.ch.intel.com>
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

The following series implements support for error clearing and error
listing for device dax through ndctl.

---

v2: Addressed comments from Vishal
- added bounds checking for the badblocks region.
- updated verbiage to use badblocks instead of poison.
- set default len to 1.
- fixed error out for stat
- fixed error out that was copy/paste error
- remove duplicate check_min_kver() in shell script
- fixed logic of checking empty badblocks

v3: Addressed comments from Toshi
- Fixed bad region path for badblocks

v4: Address comments from Toshi
- Added error output for length that exceeds badblock coverage.

v5: Address comments from Toshi
- Made -l 0 to error out and no length means 1 block cleared.

v6: Address comments from Dan
- Fixed clear-error to be based off of device instead of region.
- Added list-errors command to ndctl

Dave Jiang (3):
      ndctl: add clear-error to ndctl for device dax
      ndctl: add list-errors support
      ndctl: add test for clear-error


 Documentation/ndctl-clear-error.txt |   38 ++++
 Documentation/ndctl-list-errors.txt |   26 +++
 builtin.h                           |    2 
 ndctl/Makefile.am                   |    1 
 ndctl/clear-error.c                 |  352 +++++++++++++++++++++++++++++++++++
 ndctl/lib/libndctl.c                |   72 +++++++
 ndctl/lib/libndctl.sym              |    2 
 ndctl/libndctl.h.in                 |  10 +
 ndctl/ndctl.c                       |   2 +
 test/Makefile.am                    |   1 +
 test/ndctl-clear-error-dax.sh       |  66 +++++++
  11 files changed, 572 insertions(+)
 create mode 100644 Documentation/ndctl-clear-error.txt
 create mode 100644 Documentation/ndctl-list-errors.txt
 create mode 100644 ndctl/clear-error.c
 create mode 100755 test/ndctl-clear-error-dax.sh
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

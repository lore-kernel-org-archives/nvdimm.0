Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 972AA22119BCA
 for <linux-nvdimm@lists.01.org>; Fri, 15 Dec 2017 15:19:18 -0800 (PST)
Subject: [PATCH v3 0/4] ndctl: add DIMM firmware update support
From: Dave Jiang <dave.jiang@intel.com>
Date: Fri, 15 Dec 2017 16:23:59 -0700
Message-ID: <151338007905.4485.4189717376304274611.stgit@djiang5-desk3.ch.intel.com>
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

The following series implements support for DIMM firmware update in ndctl.

v3: Addressed Dan's comments
- Removed Intel specific bits from update get info. 
- Added inherited context for related commands
- Moved all input params into new_cmd function.
- Added translated status return

---

Dave Jiang (4):
      ndctl: add support to alloc_intel_cmd for variable payload
      ndctl: add firmware download support functions in libndctl
      ndctl: add firmware update command option for ndctl
      ndctl, test: firmware update unit test


 ndctl/Makefile.am      |    3 
 ndctl/lib/Makefile.am  |    1 
 ndctl/lib/firmware.c   |  119 +++++++++++
 ndctl/lib/intel.c      |  264 +++++++++++++++++++++++
 ndctl/lib/intel.h      |   77 +++++++
 ndctl/lib/libndctl.sym |   15 +
 ndctl/lib/private.h    |   16 +
 ndctl/libndctl.h       |   36 +++
 ndctl/ndctl.c          |    1 
 ndctl/update.c         |  544 ++++++++++++++++++++++++++++++++++++++++++++++++
 10 files changed, 1074 insertions(+), 2 deletions(-)
 create mode 100644 ndctl/lib/firmware.c
 create mode 100644 ndctl/update.c

--
Signature
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

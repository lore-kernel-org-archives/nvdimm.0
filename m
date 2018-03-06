Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B93C1223522BD
 for <linux-nvdimm@lists.01.org>; Tue,  6 Mar 2018 10:19:22 -0800 (PST)
Subject: [PATCH v2 0/2] ndctl: move firmware update to dimm action
From: Dave Jiang <dave.jiang@intel.com>
Date: Tue, 06 Mar 2018 11:25:36 -0700
Message-ID: <152036051666.9605.11333285528137008907.stgit@djiang5-desk3.ch.intel.com>
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
To: vishal.l.verma@intel.com, dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

The following series moves firmware update to dimm.c in order to take
advantage of the command line parsing that already exists and remove
duplications.

v2:
- Add distinct return errors for lack of support in ndctl, kernel, or
  platform.
- Moved the firmware update defines and structs to its own header.

---

Dave Jiang (2):
      ndctl: add check for update firmware supported
      ndctl: merge firmware-update to dimm.c as one of the dimm ops


 ndctl/Makefile.am       |    1 
 ndctl/dimm.c            |  466 ++++++++++++++++++++++++++++++++++++++++
 ndctl/firmware-update.h |   45 ++++
 ndctl/lib/firmware.c    |   11 +
 ndctl/lib/intel.c       |   24 ++
 ndctl/lib/libndctl.sym  |    1 
 ndctl/lib/private.h     |    1 
 ndctl/libndctl.h        |    1 
 ndctl/update.c          |  545 -----------------------------------------------
 9 files changed, 547 insertions(+), 548 deletions(-)
 create mode 100644 ndctl/firmware-update.h
 delete mode 100644 ndctl/update.c

--
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DE67F21B02822
 for <linux-nvdimm@lists.01.org>; Wed, 26 Sep 2018 18:06:18 -0700 (PDT)
Subject: [PATCH 0/5] Adding nvdimm overwrite support
From: Dave Jiang <dave.jiang@intel.com>
Date: Wed, 26 Sep 2018 17:58:24 -0700
Message-ID: <153800975246.57703.6532101433026481472.stgit@djiang5-desk3.ch.intel.com>
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

The following series implements the overwrite support for Intel nvdimm.
Overwrite DSM commands are part of Intel DSM v1.7 spec. It allows the
nvdimm to wipe all the information on the target nvdimm (including the
label area). The operation can take tens of mintues or more depending
on the size of the nvdimm.

---

Dave Jiang (5):
      libnvdimm: introduce NDD_SECURITY_BUSY flag
      libnvdimm: Add security DSM overwrite support
      nfit_test: Add overwrite support for nfit_test
      libnvdimm: add overwrite status notification
      libnvdimm: add documentation for ovewrite


 Documentation/nvdimm/security.txt |   11 ++
 drivers/acpi/nfit/core.c          |    5 +
 drivers/acpi/nfit/intel.c         |  118 +++++++++++++++++++++
 drivers/acpi/nfit/intel.h         |    4 +
 drivers/acpi/nfit/nfit.h          |    1 
 drivers/nvdimm/dimm.c             |    4 +
 drivers/nvdimm/dimm_devs.c        |  207 +++++++++++++++++++++++++++++++++++++
 drivers/nvdimm/nd-core.h          |    3 +
 drivers/nvdimm/nd.h               |    3 +
 drivers/nvdimm/region_devs.c      |    7 +
 include/linux/libnvdimm.h         |    9 ++
 tools/testing/nvdimm/test/nfit.c  |   55 ++++++++++
 12 files changed, 425 insertions(+), 2 deletions(-)

--
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

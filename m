Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8D5A82222C23A
 for <linux-nvdimm@lists.01.org>; Wed, 31 Jan 2018 11:39:57 -0800 (PST)
Subject: [PATCH v5 0/4] add support for platform persistence capabilities
From: Dave Jiang <dave.jiang@intel.com>
Date: Wed, 31 Jan 2018 12:45:32 -0700
Message-ID: <151742786907.53525.180738048776121385.stgit@djiang5-desk3.ch.intel.com>
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
To: dan.j.williams@intel.com, ross.zwisler@linux.intel.com
Cc: linux-acpi@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

ACPI 6.2a provides an NFIT sub-table that informs if the platform has
auto CPU flush and memory flush on unexpected power loss events. This series
propogates those attributes to nd_region and add sysfs attribute to show
those capabilities.

v5:
Fix value of mask in nfit_test.

v4:
Fixed typos and added Reviewed-by tags from Ross.

v3:
Addressed Ross's comments
- fixed mask calculation for platform cap
- fixed nfit_test nfit_buf size calcuation
- fixed offset for test data structure

v2:
Per Dan's comments
- Added ADR cap flags propogation
- Added sysfs attribute

---

Dave Jiang (4):
      acpi: nfit: Add support for detect platform CPU cache flush on power loss
      acpi: nfit: add persistent memory control flag for nd_region
      libnvdimm: expose platform persistence attribute for nd_region
      nfit-test: Add platform cap support from ACPI 6.2a to test


 drivers/acpi/nfit/core.c         |   23 +++++++++++++++++++++++
 drivers/acpi/nfit/nfit.h         |    1 +
 drivers/nvdimm/pmem.c            |    4 +++-
 drivers/nvdimm/region_devs.c     |   13 +++++++++++++
 include/linux/libnvdimm.h        |   11 +++++++++++
 tools/testing/nvdimm/test/nfit.c |   14 ++++++++++++--
 6 files changed, 63 insertions(+), 3 deletions(-)

--
Signature
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4D3B580328
 for <linux-nvdimm@lists.01.org>; Mon,  6 Mar 2017 12:32:27 -0800 (PST)
Subject: [PATCH 0/5] Adding clear poison path for device DAX
From: Dave Jiang <dave.jiang@intel.com>
Date: Mon, 06 Mar 2017 13:32:26 -0700
Message-ID: <148883211285.49239.17952572594430933942.stgit@djiang5-desk3.ch.intel.com>
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

The following series implements a way to clear poison for device DAX
through ndctl from user space. The application can acquire the region's
base address through the sysfs region resource attribute. From that an
ioctl can be used to send ND_CMD_CLEAR_ERROR for clearing the poison and
related badblocks.

---

Dave Jiang (5):
      libnvdimm: Add mechanism to publish badblocks at nd region level
      libnvdimm: Add resource sysfs attrib to nd region
      acpi: cleanup acpi_nfit_ctl calling xlat_status
      acpi_nfit, libnvdimm: Add support for clear poison list and bad blocks
      libnvdimm: providing dax support for nvdimm testing


 drivers/acpi/nfit/core.c         |   78 ++++++++++++++++++++++++++++++++++----
 drivers/acpi/nfit/nfit.h         |    2 +
 drivers/dax/dax-private.h        |   40 +++++++++++++++++++
 drivers/dax/dax.c                |   29 ++------------
 drivers/nvdimm/bus.c             |   55 +++++++++++++++++++++++----
 drivers/nvdimm/core.c            |   17 ++++++--
 drivers/nvdimm/nd.h              |    1 
 drivers/nvdimm/region.c          |   33 ++++++++++++++++
 drivers/nvdimm/region_devs.c     |   32 ++++++++++++++++
 include/linux/libnvdimm.h        |    6 ++-
 tools/testing/nvdimm/Kbuild      |    3 +
 tools/testing/nvdimm/dax-dev.c   |   44 +++++++++++++++++++++
 tools/testing/nvdimm/test/nfit.c |   23 +++++++----
 13 files changed, 309 insertions(+), 54 deletions(-)
 create mode 100644 drivers/dax/dax-private.h
 create mode 100644 tools/testing/nvdimm/dax-dev.c

--
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

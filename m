Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 by ml01.01.org (Postfix) with ESMTP id 533881A1EC9
 for <linux-nvdimm@lists.01.org>; Tue,  8 Mar 2016 14:47:53 -0800 (PST)
Subject: [PATCH 0/3] nfit, libnvdimm, pmem: clear poison support
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 08 Mar 2016 14:47:13 -0800
Message-ID: <20160308224713.16298.33547.stgit@dwillia2-desk3.jf.intel.com>
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
To: linux-nvdimm@lists.01.org
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, linux-acpi@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

ACPI 6.1 introduces the ability to send "clear error" commands to the
ACPI0012:00 device representing the root of an "nvdimm bus".

Similar to relocating a bad block on a disk, this support clears
media errors in response to a write.

---

Dan Williams (3):
      nfit, libnvdimm: clear poison command support
      libnvdimm, pmem: fix kmap_atomic() leak in error path
      libnvdimm, pmem: clear poison on write


 arch/x86/include/asm/pmem.h      |    5 +++
 drivers/acpi/nfit.c              |   12 ++++++-
 drivers/nvdimm/bus.c             |   65 ++++++++++++++++++++++++++++++++++++++
 drivers/nvdimm/nd.h              |    2 +
 drivers/nvdimm/pmem.c            |   40 ++++++++++++++++++++---
 include/linux/pmem.h             |   19 +++++++++++
 include/uapi/linux/ndctl.h       |   13 ++++++++
 tools/testing/nvdimm/test/nfit.c |   29 +++++++++++++++++
 8 files changed, 179 insertions(+), 6 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

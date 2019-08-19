Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com
 [148.163.158.5])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B18C920216B77
 for <linux-nvdimm@lists.01.org>; Mon, 19 Aug 2019 06:36:32 -0700 (PDT)
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: [PATCH v6 0/7] Mark the namespace disabled on pfn superblock mismatch
Date: Mon, 19 Aug 2019 19:04:44 +0530
Message-Id: <20190819133451.19737-1-aneesh.kumar@linux.ibm.com>
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
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

We add new members to pfn superblock (PAGE_SIZE and struct page size) in this series.
This is now checked while initializing the namespace. If we find a mismatch we mark
the namespace disabled.

This series also handle configs where hugepage support is not enabled by default.
This can result in different align restrictions for dax namespace. We mark the
dax namespace disabled if we find the alignment not supported.

Changes from v5:
* Split patch 3
* Update commit message
* Add MAX_STRUCT_PAGE_SIZE with value 64 and use that when allocating reserve block
* Add BUILD_BUG_ON if we find sizeof(struct page) > 64


Aneesh Kumar K.V (6):
  libnvdimm/pmem: Advance namespace seed for specific probe errors
  libnvdimm/pfn_dev: Add a build check to make sure we notice when
    struct page size change
  libnvdimm/pfn_dev: Add page size and struct page size to pfn
    superblock
  libnvdimm/label: Remove the dpa align check
  libnvdimm: Use PAGE_SIZE instead of SZ_4K for align check
  libnvdimm/dax: Pick the right alignment default when creating dax
    devices

Dan Williams (1):
  libnvdimm/region: Rewrite _probe_success() to _advance_seeds()

 arch/powerpc/include/asm/libnvdimm.h |  9 ++++
 arch/powerpc/mm/Makefile             |  1 +
 arch/powerpc/mm/nvdimm.c             | 34 +++++++++++++
 arch/x86/include/asm/libnvdimm.h     | 19 +++++++
 drivers/nvdimm/bus.c                 |  8 ++-
 drivers/nvdimm/label.c               |  5 --
 drivers/nvdimm/namespace_devs.c      | 40 +++++++++++----
 drivers/nvdimm/nd-core.h             |  3 +-
 drivers/nvdimm/nd.h                  | 10 ++--
 drivers/nvdimm/pfn.h                 |  5 +-
 drivers/nvdimm/pfn_devs.c            | 67 ++++++++++++++++++++++--
 drivers/nvdimm/pmem.c                | 29 +++++++++--
 drivers/nvdimm/region_devs.c         | 76 +++++-----------------------
 include/linux/huge_mm.h              |  7 ++-
 14 files changed, 215 insertions(+), 98 deletions(-)
 create mode 100644 arch/powerpc/include/asm/libnvdimm.h
 create mode 100644 arch/powerpc/mm/nvdimm.c
 create mode 100644 arch/x86/include/asm/libnvdimm.h

-- 
2.21.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

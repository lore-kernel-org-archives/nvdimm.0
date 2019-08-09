Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com
 [148.163.158.5])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 52D0C212DD37D
 for <linux-nvdimm@lists.01.org>; Fri,  9 Aug 2019 00:48:06 -0700 (PDT)
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: [PATCH v5 0/4] Mark the namespace disabled on pfn superblock mismatch
Date: Fri,  9 Aug 2019 13:15:16 +0530
Message-Id: <20190809074520.27115-1-aneesh.kumar@linux.ibm.com>
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
Cc: linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

We add new members to pfn superblock (PAGE_SIZE and struct page size) in this series.
This is now checked while initializing the namespace. If we find a mismatch we mark
the namespace disabled.

This series also handle configs where hugepage support is not enabled by default.
This can result in different align restrictions for dax namespace. We mark the
dax namespace disabled if we find the alignment not supported.

Aneesh Kumar K.V (4):
  nvdimm: Consider probe return -EOPNOTSUPP as success
  mm/nvdimm: Add page size and struct page size to pfn superblock
  mm/nvdimm: Use correct #defines instead of open coding
  mm/nvdimm: Pick the right alignment default when creating dax devices

 arch/powerpc/include/asm/libnvdimm.h |  9 ++++
 arch/powerpc/mm/Makefile             |  1 +
 arch/powerpc/mm/nvdimm.c             | 34 +++++++++++++++
 arch/x86/include/asm/libnvdimm.h     | 19 +++++++++
 drivers/nvdimm/bus.c                 |  2 +-
 drivers/nvdimm/label.c               |  2 +-
 drivers/nvdimm/namespace_devs.c      |  6 +--
 drivers/nvdimm/nd.h                  |  6 ---
 drivers/nvdimm/pfn.h                 |  5 ++-
 drivers/nvdimm/pfn_devs.c            | 62 ++++++++++++++++++++++++++--
 drivers/nvdimm/pmem.c                | 26 ++++++++++--
 drivers/nvdimm/region_devs.c         |  8 ++--
 include/linux/huge_mm.h              |  7 +++-
 13 files changed, 163 insertions(+), 24 deletions(-)
 create mode 100644 arch/powerpc/include/asm/libnvdimm.h
 create mode 100644 arch/powerpc/mm/nvdimm.c
 create mode 100644 arch/x86/include/asm/libnvdimm.h

-- 
2.21.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

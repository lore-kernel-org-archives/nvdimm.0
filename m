Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2352.austin.hpe.com (g2t2352.austin.hpe.com [15.233.44.25])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4CEFD1A1DF5
 for <linux-nvdimm@lists.01.org>; Fri,  9 Sep 2016 15:25:25 -0700 (PDT)
From: Toshi Kani <toshi.kani@hpe.com>
Subject: [PATCH 0/2] refactor shmem_get_unmapped_area()
Date: Fri,  9 Sep 2016 16:24:21 -0600
Message-Id: <1473459863-11287-1-git-send-email-toshi.kani@hpe.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: akpm@linux-foundation.org
Cc: linux-nvdimm@lists.01.org, mawilcox@microsoft.com, hughd@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, kirill.shutemov@linux.intel.com
List-ID: <linux-nvdimm@lists.01.org>

shmem_get_unmapped_area() provides a functionality similar
to __thp_get_unmapped_area() as both allocate a pmd-aligned
address.  This patchset changes shmem_get_unmapped_area()
to call __thp_get_unmapped_area() to share the code.

Patch 1 fixes a bug in shmem_get_unmapped_area() first.
Patch 2 changes shmem_get_unmapped_area() to call
__thp_get_unmapped_area() for sharing the code.

This patch-set applies on top of my patchset below.
https://lkml.org/lkml/2016/8/29/560

---
Toshi Kani (2):
 1/2 shmem: fix tmpfs to handle the huge= option properly
 2/2 shmem: call __thp_get_unmapped_area to alloc a pmd-aligned addr

---
 include/linux/huge_mm.h | 10 +++++++
 mm/shmem.c              | 70 ++++++++++---------------------------------------
 2 files changed, 24 insertions(+), 56 deletions(-)

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

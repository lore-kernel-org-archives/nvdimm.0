Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8C6362255D6F3
 for <linux-nvdimm@lists.01.org>; Thu,  1 Mar 2018 19:51:53 -0800 (PST)
Subject: [PATCH v3 0/3] mm, smaps: MMUPageSize for device-dax
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 01 Mar 2018 19:48:56 -0800
Message-ID: <151996253609.27922.9983044853291257359.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: akpm@linux-foundation.org
Cc: Jane Chu <jane.chu@oracle.com>, linux-nvdimm@lists.01.org, Michael Ellerman <mpe@ellerman.id.au>, linux-mm@kvack.org, Paul Mackerras <paulus@samba.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>
List-ID: <linux-nvdimm@lists.01.org>

Changes since v2:
* Split the fix of the definition vma_mmu_pagesize() on powerpc to its
  own patch.

[1]: https://lists.01.org/pipermail/linux-nvdimm/2018-February/014101.html

---

Andrew,

Similar to commit 31383c6865a5 "mm, hugetlbfs: introduce ->split() to
vm_operations_struct" here is another occasion where we want
special-case hugetlbfs/hstate enabling to also apply to device-dax.

This begs the question what other hstate conversions we might do beyond
->split() and ->pagesize(), but this appears to be the last of the
usages of hstate_vma() in generic/non-hugetlbfs specific code paths.

---

Dan Williams (3):
      mm, powerpc: use vma_kernel_pagesize() in vma_mmu_pagesize()
      mm, hugetlbfs: introduce ->pagesize() to vm_operations_struct
      device-dax: implement ->pagesize() for smaps to report MMUPageSize


 arch/powerpc/include/asm/hugetlb.h |    6 ------
 arch/powerpc/mm/hugetlbpage.c      |    5 +----
 drivers/dax/device.c               |   10 ++++++++++
 include/linux/mm.h                 |    1 +
 mm/hugetlb.c                       |   27 ++++++++++++++-------------
 5 files changed, 26 insertions(+), 23 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

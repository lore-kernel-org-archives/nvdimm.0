Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C6E39222DE135
 for <linux-nvdimm@lists.01.org>; Fri,  9 Feb 2018 16:32:35 -0800 (PST)
Subject: [PATCH v2 0/2] mm, smaps: MMUPageSize for device-dax
From: Dave Jiang <dave.jiang@intel.com>
Date: Fri, 09 Feb 2018 17:38:21 -0700
Message-ID: <151822289999.52376.4998780583577188804.stgit@djiang5-desk3.ch.intel.com>
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
Cc: linux-mm@kvack.org, mhocko@kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Andrew,

>>From Dan Williams:
Here is another occasion where we want special-case hugetlbfs enabling
to also apply to device-dax. I started to wonder what other hstate
conversions we might do beyond ->split() and ->pagesize(), but this
appears to be the last of the usages of hstate_vma() in
generic/non-hugetlbfs specific code paths.

v2:
I fixed up the powerpc build issue that Michal reported by restoring the
original location of the function and making the symbol weak.

---

Dan Williams (2):
      mm, hugetlbfs: introduce ->pagesize() to vm_operations_struct
      device-dax: implement ->pagesize() for smaps to report MMUPageSize


 arch/powerpc/mm/hugetlbpage.c |    5 +----
 drivers/dax/device.c          |   10 ++++++++++
 include/linux/mm.h            |    1 +
 mm/hugetlb.c                  |   23 ++++++++++++-----------
 4 files changed, 24 insertions(+), 15 deletions(-)

--
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

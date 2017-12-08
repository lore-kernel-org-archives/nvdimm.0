Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C7E63221EA0B2
 for <linux-nvdimm@lists.01.org>; Thu,  7 Dec 2017 19:34:30 -0800 (PST)
Subject: [PATCH 0/2] mm, smaps: MMUPageSize for device-dax
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 07 Dec 2017 19:30:49 -0800
Message-ID: <151270384965.21215.2022156459463260344.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Andrew,

Here is another occasion where we want special-case hugetlbfs enabling
to also apply to device-dax. I started to wonder what other hstate
conversions we might do beyond ->split() and ->pagesize(), but this
appears to be the last of the usages of hstate_vma() in
generic/non-hugetlbfs specific code paths.

This is 4.16 material.

---

Dan Williams (2):
      mm, hugetlbfs: introduce ->pagesize() to vm_operations_struct
      device-dax: implement ->pagesize() for smaps to report MMUPageSize


 arch/powerpc/mm/hugetlbpage.c |    5 +----
 drivers/dax/device.c          |   10 ++++++++++
 include/linux/hugetlb.h       |   30 ++++++++++++++++++++++++------
 include/linux/mm.h            |    1 +
 mm/hugetlb.c                  |   38 ++++++++------------------------------
 5 files changed, 44 insertions(+), 40 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

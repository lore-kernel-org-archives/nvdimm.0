Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2E6D020359E99
 for <linux-nvdimm@lists.01.org>; Wed, 29 Nov 2017 10:09:31 -0800 (PST)
Subject: [PATCH v3 2/4] mm: fail get_vaddr_frames() for filesystem-dax mappings
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 29 Nov 2017 10:05:40 -0800
Message-ID: <151197874035.26211.4061781453123083667.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <151197872943.26211.6551382719053304996.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <151197872943.26211.6551382719053304996.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, Joonyoung Shim <jy0922.shim@samsung.com>, linux-nvdimm@lists.01.org, Seung-Woo Kim <sw0312.kim@samsung.com>, linux-kernel@vger.kernel.org, stable@vger.kernel.org, Inki Dae <inki.dae@samsung.com>, linux-mm@kvack.org, Kyungmin Park <kyungmin.park@samsung.com>, Mel Gorman <mgorman@suse.de>, Mauro Carvalho Chehab <mchehab@kernel.org>, hch@lst.de, Vlastimil Babka <vbabka@suse.cz>, linux-media@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Until there is a solution to the dma-to-dax vs truncate problem it is
not safe to allow V4L2, Exynos, and other frame vector users to create
long standing / irrevocable memory registrations against filesytem-dax
vmas.

Cc: Inki Dae <inki.dae@samsung.com>
Cc: Seung-Woo Kim <sw0312.kim@samsung.com>
Cc: Joonyoung Shim <jy0922.shim@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org
Cc: Mel Gorman <mgorman@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: <stable@vger.kernel.org>
Fixes: 3565fce3a659 ("mm, x86: get_user_pages() for dax mappings")
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 mm/frame_vector.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/mm/frame_vector.c b/mm/frame_vector.c
index 2f98df0d460e..297c7238f7d4 100644
--- a/mm/frame_vector.c
+++ b/mm/frame_vector.c
@@ -53,6 +53,18 @@ int get_vaddr_frames(unsigned long start, unsigned int nr_frames,
 		ret = -EFAULT;
 		goto out;
 	}
+
+	/*
+	 * While get_vaddr_frames() could be used for transient (kernel
+	 * controlled lifetime) pinning of memory pages all current
+	 * users establish long term (userspace controlled lifetime)
+	 * page pinning. Treat get_vaddr_frames() like
+	 * get_user_pages_longterm() and disallow it for filesystem-dax
+	 * mappings.
+	 */
+	if (vma_is_fsdax(vma))
+		return -EOPNOTSUPP;
+
 	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP))) {
 		vec->got_ref = true;
 		vec->is_pfns = false;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

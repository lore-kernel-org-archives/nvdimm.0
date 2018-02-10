Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 245BC222DE135
 for <linux-nvdimm@lists.01.org>; Fri,  9 Feb 2018 16:32:47 -0800 (PST)
Subject: [PATCH v2 2/2] device-dax: implement ->pagesize() for smaps to
 report MMUPageSize
From: Dave Jiang <dave.jiang@intel.com>
Date: Fri, 09 Feb 2018 17:38:32 -0700
Message-ID: <151822311257.52376.12067958018820885784.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <151822289999.52376.4998780583577188804.stgit@djiang5-desk3.ch.intel.com>
References: <151822289999.52376.4998780583577188804.stgit@djiang5-desk3.ch.intel.com>
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
Cc: Jane Chu <jane.chu@oracle.com>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, mhocko@kernel.org, linux-mm@kvack.org
List-ID: <linux-nvdimm@lists.01.org>

From: Dan Williams <dan.j.williams@intel.com>

Given that device-dax is making similar page mapping size guarantees as
hugetlbfs, emit the size in smaps and any other kernel path that
requests the mapping size of a vma.

Reported-by: Jane Chu <jane.chu@oracle.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/device.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/dax/device.c b/drivers/dax/device.c
index 7b0bf825c4e7..b57cd5a7b0bd 100644
--- a/drivers/dax/device.c
+++ b/drivers/dax/device.c
@@ -439,10 +439,20 @@ static int dev_dax_split(struct vm_area_struct *vma, unsigned long addr)
 	return 0;
 }
 
+static unsigned long dev_dax_pagesize(struct vm_area_struct *vma)
+{
+	struct file *filp = vma->vm_file;
+	struct dev_dax *dev_dax = filp->private_data;
+	struct dax_region *dax_region = dev_dax->region;
+
+	return dax_region->align;
+}
+
 static const struct vm_operations_struct dax_vm_ops = {
 	.fault = dev_dax_fault,
 	.huge_fault = dev_dax_huge_fault,
 	.split = dev_dax_split,
+	.pagesize = dev_dax_pagesize,
 };
 
 static int dax_mmap(struct file *filp, struct vm_area_struct *vma)

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

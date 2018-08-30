Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com
 [IPv6:2607:f8b0:4864:20::541])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3B90A21107187
 for <linux-nvdimm@lists.01.org>; Thu, 30 Aug 2018 08:35:13 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id e2-v6so4055122pgv.5
 for <linux-nvdimm@lists.01.org>; Thu, 30 Aug 2018 08:35:13 -0700 (PDT)
Date: Thu, 30 Aug 2018 21:08:13 +0530
From: Souptick Joarder <jrdr.linux@gmail.com>
Subject: [PATCH] device-dax: Convert variable to vm_fault_t type
Message-ID: <20180830153813.GA26059@jordon-HP-15-Notebook-PC>
MIME-Version: 1.0
Content-Disposition: inline
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
Cc: linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, willy@infradead.org, zwisler@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

As part of commit 226ab561075f ("device-dax: Convert to
vmf_insert_mixed and vm_fault_t") in 4.19-rc1,
'rc' was not converted to vm_fault_t. Now converted.

Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
---
 drivers/dax/device.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/dax/device.c b/drivers/dax/device.c
index 6fd4608..bbe4d72 100644
--- a/drivers/dax/device.c
+++ b/drivers/dax/device.c
@@ -392,7 +392,8 @@ static vm_fault_t dev_dax_huge_fault(struct vm_fault *vmf,
 {
 	struct file *filp = vmf->vma->vm_file;
 	unsigned long fault_size;
-	int rc, id;
+	vm_fault_t rc = VM_FAULT_SIGBUS;
+	int id;
 	pfn_t pfn;
 	struct dev_dax *dev_dax = filp->private_data;
 
-- 
1.9.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

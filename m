Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B487981EFA
 for <linux-nvdimm@lists.01.org>; Mon, 23 Jan 2017 16:06:34 -0800 (PST)
Subject: [PATCH] dax: put back __GFP_IO in the dax fault handler
From: Dave Jiang <dave.jiang@intel.com>
Date: Mon, 23 Jan 2017 17:06:30 -0700
Message-ID: <148521639006.25631.4184774582309071957.stgit@djiang5-desk3.ch.intel.com>
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
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

__GFP_IO got accidentally dropped in the dax fault handler during the
vmf parameter conversion. Putting it back.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 fs/dax.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/dax.c b/fs/dax.c
index 2e90f7a..20e9db8 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1332,6 +1332,7 @@ static int dax_iomap_pmd_fault(struct vm_fault *vmf, struct iomap_ops *ops)
 	loff_t pos;
 	int error;
 
+	vmf->gfp_mask |= __GFP_IO;
 	/*
 	 * Check whether offset isn't beyond end of file now. Caller is
 	 * supposed to hold locks serializing us with truncate / punch hole so
@@ -1423,6 +1424,7 @@ static int dax_iomap_pmd_fault(struct vm_fault *vmf, struct iomap_ops *ops)
 	}
 out:
 	trace_dax_pmd_fault_done(inode, vmf, max_pgoff, result);
+	vmf->gfp_mask &= ~__GFP_IO;
 	return result;
 }
 #else

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

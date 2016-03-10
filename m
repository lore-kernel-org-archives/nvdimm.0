Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3EF061A1F51
 for <linux-nvdimm@lists.01.org>; Thu, 10 Mar 2016 11:18:54 -0800 (PST)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 08/12] dax: Fix bogus fault return value on cow faults
Date: Thu, 10 Mar 2016 20:18:51 +0100
Message-Id: <1457637535-21633-9-git-send-email-jack@suse.cz>
In-Reply-To: <1457637535-21633-1-git-send-email-jack@suse.cz>
References: <1457637535-21633-1-git-send-email-jack@suse.cz>
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
To: linux-fsdevel@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, NeilBrown <neilb@suse.com>, "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

In case of cow fault when there is no page mapped at cow location, we
return VM_FAULT_LOCKED despite we don't return any page from the fault.
The code in do_cow_fault() carefully handled the case when no page was
actually returned so no harm was done but still this is a bug waiting to
happen.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/dax.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/dax.c b/fs/dax.c
index 4aa440f9305b..bf39f16e5390 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -680,7 +680,9 @@ int __dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 		if (error)
 			goto unlock_page;
 		vmf->page = page;
-		return VM_FAULT_LOCKED;
+		if (page)
+			return VM_FAULT_LOCKED;
+		return 0;
 	}
 
 	/* Check we didn't race with a read fault installing a new page */
-- 
2.6.2

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

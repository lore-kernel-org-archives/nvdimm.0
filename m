Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2423081F17
 for <linux-nvdimm@lists.01.org>; Tue,  6 Dec 2016 17:37:38 -0800 (PST)
Subject: [PATCH] device-dax: fix private mapping restriction, permit read-only
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 06 Dec 2016 17:33:28 -0800
Message-ID: <148107440842.10910.8233598770558303468.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: linux-nvdimm@lists.01.org
Cc: Dave Hansen <dave.hansen@linux.intel.com>, Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org, stable@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Hugh notes in response to commit 4cb19355ea19 "device-dax: fail all
private mapping attempts":

  "I think that is more restrictive than you intended: haven't tried, but I
  believe it rejects a PROT_READ, MAP_SHARED, O_RDONLY fd mmap, leaving no
  way to mmap /dev/dax without write permission to it."

Indeed it does restrict read-only mappings, switch to checking
VM_MAYSHARE, not VM_SHARED.

Cc: <stable@vger.kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Pawel Lebioda <pawel.lebioda@intel.com>
Fixes: 4cb19355ea19 ("device-dax: fail all private mapping attempts")
Reported-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/dax.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dax/dax.c b/drivers/dax/dax.c
index 3d94ff20fdca..286447a83dab 100644
--- a/drivers/dax/dax.c
+++ b/drivers/dax/dax.c
@@ -271,7 +271,7 @@ static int check_vma(struct dax_dev *dax_dev, struct vm_area_struct *vma,
 		return -ENXIO;
 
 	/* prevent private mappings from being established */
-	if ((vma->vm_flags & VM_SHARED) != VM_SHARED) {
+	if ((vma->vm_flags & VM_MAYSHARE) != VM_MAYSHARE) {
 		dev_info(dev, "%s: %s: fail, attempted private mapping\n",
 				current->comm, func);
 		return -EINVAL;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

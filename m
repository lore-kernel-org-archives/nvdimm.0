Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1D84E81EBD
 for <linux-nvdimm@lists.01.org>; Wed, 16 Nov 2016 09:29:50 -0800 (PST)
Subject: [PATCH] device-dax: fail all private mapping attempts
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 16 Nov 2016 09:26:53 -0800
Message-ID: <147931721349.37471.4835899844582504197.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-mm@kvack.org, Dave Hansen <dave.hansen@linux.intel.com>, linux-kernel@vger.kernel.org, stable@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

The device-dax implementation originally tried to be tricky and allow
private read-only mappings, but in the process allowed writable
MAP_PRIVATE + MAP_NORESERVE mappings.  For simplicity and predictability
just fail all private mapping attempts since device-dax memory is
statically allocated and will never support overcommit.

Cc: <stable@vger.kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Fixes: dee410792419 ("/dev/dax, core: file operations and dax-mmap")
Reported-by: Pawel Lebioda <pawel.lebioda@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/dax.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dax/dax.c b/drivers/dax/dax.c
index 0e499bfca41c..3d94ff20fdca 100644
--- a/drivers/dax/dax.c
+++ b/drivers/dax/dax.c
@@ -270,8 +270,8 @@ static int check_vma(struct dax_dev *dax_dev, struct vm_area_struct *vma,
 	if (!dax_dev->alive)
 		return -ENXIO;
 
-	/* prevent private / writable mappings from being established */
-	if ((vma->vm_flags & (VM_NORESERVE|VM_SHARED|VM_WRITE)) == VM_WRITE) {
+	/* prevent private mappings from being established */
+	if ((vma->vm_flags & VM_SHARED) != VM_SHARED) {
 		dev_info(dev, "%s: %s: fail, attempted private mapping\n",
 				current->comm, func);
 		return -EINVAL;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0523A2034CF7E
 for <linux-nvdimm@lists.01.org>; Tue, 31 Oct 2017 16:25:07 -0700 (PDT)
Subject: [PATCH 11/15] [media] v4l2: disable filesystem-dax mapping support
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 31 Oct 2017 16:22:35 -0700
Message-ID: <150949215507.24061.16244906635037694605.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <150949209290.24061.6283157778959640151.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <150949209290.24061.6283157778959640151.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org, Mauro Carvalho Chehab <mchehab@kernel.org>, hch@lst.de, linux-media@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

V4L2 memory registrations are incompatible with filesystem-dax that
needs the ability to revoke dma access to a mapping at will, or
otherwise allow the kernel to wait for completion of DMA. The
filesystem-dax implementation breaks the traditional solution of
truncate of active file backed mappings since there is no page-cache
page we can orphan to sustain ongoing DMA.

If v4l2 wants to support long lived DMA mappings it needs to arrange to
hold a file lease or use some other mechanism so that the kernel can
coordinate revoking DMA access when the filesystem needs to truncate
mappings.

Reported-by: Jan Kara <jack@suse.cz>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org
Cc: <stable@vger.kernel.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/media/v4l2-core/videobuf-dma-sg.c |   39 ++++++++++++++++++++++++++++-
 1 file changed, 37 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf-dma-sg.c b/drivers/media/v4l2-core/videobuf-dma-sg.c
index 0b5c43f7e020..37a4ae61b2c0 100644
--- a/drivers/media/v4l2-core/videobuf-dma-sg.c
+++ b/drivers/media/v4l2-core/videobuf-dma-sg.c
@@ -155,8 +155,9 @@ static int videobuf_dma_init_user_locked(struct videobuf_dmabuf *dma,
 			int direction, unsigned long data, unsigned long size)
 {
 	unsigned long first, last;
-	int err, rw = 0;
+	int err, rw = 0, i, nr_pages;
 	unsigned int flags = FOLL_FORCE;
+	struct vm_area_struct **vmas = NULL;
 
 	dma->direction = direction;
 	switch (dma->direction) {
@@ -179,6 +180,16 @@ static int videobuf_dma_init_user_locked(struct videobuf_dmabuf *dma,
 	if (NULL == dma->pages)
 		return -ENOMEM;
 
+	if (IS_ENABLED(CONFIG_FS_DAX)) {
+		vmas = kmalloc(dma->nr_pages * sizeof(struct vm_area_struct *),
+				GFP_KERNEL);
+		if (NULL == vmas) {
+			kfree(dma->pages);
+			dma->pages = NULL;
+			return -ENOMEM;
+		}
+	}
+
 	if (rw == READ)
 		flags |= FOLL_WRITE;
 
@@ -186,7 +197,31 @@ static int videobuf_dma_init_user_locked(struct videobuf_dmabuf *dma,
 		data, size, dma->nr_pages);
 
 	err = get_user_pages(data & PAGE_MASK, dma->nr_pages,
-			     flags, dma->pages, NULL);
+			     flags, dma->pages, vmas);
+	nr_pages = err;
+
+	for (i = 0; vmas && i < nr_pages; i++) {
+		struct vm_area_struct *vma = vmas[i];
+		struct inode *inode;
+
+		if (!vma_is_dax(vma))
+			continue;
+
+		/* device-dax is safe for long-lived v4l2 mappings... */
+		inode = file_inode(vma->vm_file);
+		if (inode->i_mode == S_IFCHR)
+			continue;
+
+		/* ...filesystem-dax is not. */
+		err = -EOPNOTSUPP;
+		break;
+
+		/*
+		 * FIXME: add a 'with lease' mechanism for v4l2 to
+		 * obtain time bounded access to filesytem-dax mappings
+		 */
+	}
+	kfree(vmas);
 
 	if (err != dma->nr_pages) {
 		dma->nr_pages = (err >= 0) ? err : 0;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

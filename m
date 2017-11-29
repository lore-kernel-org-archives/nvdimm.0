Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6F45C20359E99
 for <linux-nvdimm@lists.01.org>; Wed, 29 Nov 2017 10:09:36 -0800 (PST)
Subject: [PATCH v3 3/4] [media] v4l2: disable filesystem-dax mapping support
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 29 Nov 2017 10:05:46 -0800
Message-ID: <151197874598.26211.6120423884702550000.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, linux-mm@kvack.org, Mauro Carvalho Chehab <mchehab@kernel.org>, hch@lst.de, linux-media@vger.kernel.org
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
Fixes: 3565fce3a659 ("mm, x86: get_user_pages() for dax mappings")
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/media/v4l2-core/videobuf-dma-sg.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf-dma-sg.c b/drivers/media/v4l2-core/videobuf-dma-sg.c
index 0b5c43f7e020..f412429cf5ba 100644
--- a/drivers/media/v4l2-core/videobuf-dma-sg.c
+++ b/drivers/media/v4l2-core/videobuf-dma-sg.c
@@ -185,12 +185,13 @@ static int videobuf_dma_init_user_locked(struct videobuf_dmabuf *dma,
 	dprintk(1, "init user [0x%lx+0x%lx => %d pages]\n",
 		data, size, dma->nr_pages);
 
-	err = get_user_pages(data & PAGE_MASK, dma->nr_pages,
+	err = get_user_pages_longterm(data & PAGE_MASK, dma->nr_pages,
 			     flags, dma->pages, NULL);
 
 	if (err != dma->nr_pages) {
 		dma->nr_pages = (err >= 0) ? err : 0;
-		dprintk(1, "get_user_pages: err=%d [%d]\n", err, dma->nr_pages);
+		dprintk(1, "get_user_pages_longterm: err=%d [%d]\n", err,
+			dma->nr_pages);
 		return err < 0 ? err : -EINVAL;
 	}
 	return 0;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

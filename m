Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 491FE21A0480D
 for <linux-nvdimm@lists.01.org>; Thu, 30 Mar 2017 15:13:21 -0700 (PDT)
From: Logan Gunthorpe <logang@deltatee.com>
Date: Thu, 30 Mar 2017 16:12:36 -0600
Message-Id: <1490911959-5146-6-git-send-email-logang@deltatee.com>
In-Reply-To: <1490911959-5146-1-git-send-email-logang@deltatee.com>
References: <1490911959-5146-1-git-send-email-logang@deltatee.com>
Subject: [RFC 5/8] scatterlist: Modify SG copy functions to support io memory.
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
To: Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, Steve Wise <swise@opengridcomputing.com>, Stephen Bates <sbates@raithlin.com>, Max Gurtovoy <maxg@mellanox.com>, Dan Williams <dan.j.williams@intel.com>, Keith Busch <keith.busch@intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: linux-scsi@vger.kernel.org, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org
List-ID: <linux-nvdimm@lists.01.org>

Now that we are using p2pmem SG buffers we occasionally have to copy
to and from this memory. For this, we add an iomem flag to
sg_copy_buffer for copying with iomemcpy. We also add the sg_iocopy_
variants to use this more easily.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Stephen Bates <sbates@raithlin.com>
Signed-off-by: Steve Wise <swise@opengridcomputing.com>
---
 drivers/scsi/scsi_debug.c   |  7 ++---
 include/linux/scatterlist.h |  7 ++++-
 lib/scatterlist.c           | 64 ++++++++++++++++++++++++++++++++++++++-------
 3 files changed, 65 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 17249c3..70c0d9f 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -1309,7 +1309,7 @@ static int resp_inquiry(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 		int lu_id_num, port_group_id, target_dev_id, len;
 		char lu_id_str[6];
 		int host_no = devip->sdbg_host->shost->host_no;
-		
+
 		port_group_id = (((host_no + 1) & 0x7f) << 8) +
 		    (devip->channel & 0x7f);
 		if (sdebug_vpd_use_hostno == 0)
@@ -2381,14 +2381,15 @@ static int do_device_access(struct scsi_cmnd *scmd, u64 lba, u32 num,
 
 	ret = sg_copy_buffer(sdb->table.sgl, sdb->table.nents,
 		   fake_storep + (block * sdebug_sector_size),
-		   (num - rest) * sdebug_sector_size, 0, do_write);
+		   (num - rest) * sdebug_sector_size, 0, do_write, false);
 	if (ret != (num - rest) * sdebug_sector_size)
 		return ret;
 
 	if (rest) {
 		ret += sg_copy_buffer(sdb->table.sgl, sdb->table.nents,
 			    fake_storep, rest * sdebug_sector_size,
-			    (num - rest) * sdebug_sector_size, do_write);
+			    (num - rest) * sdebug_sector_size, do_write,
+				      false);
 	}
 
 	return ret;
diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index cb3c8fe..030b92b 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -267,7 +267,7 @@ int sg_alloc_table_from_pages(struct sg_table *sgt,
 	gfp_t gfp_mask);
 
 size_t sg_copy_buffer(struct scatterlist *sgl, unsigned int nents, void *buf,
-		      size_t buflen, off_t skip, bool to_buffer);
+		      size_t buflen, off_t skip, bool to_buffer, bool iomem);
 
 size_t sg_copy_from_buffer(struct scatterlist *sgl, unsigned int nents,
 			   const void *buf, size_t buflen);
@@ -279,6 +279,11 @@ size_t sg_pcopy_from_buffer(struct scatterlist *sgl, unsigned int nents,
 size_t sg_pcopy_to_buffer(struct scatterlist *sgl, unsigned int nents,
 			  void *buf, size_t buflen, off_t skip);
 
+size_t sg_iocopy_from_buffer(struct scatterlist *sgl, unsigned int nents,
+			     const void *buf, size_t buflen);
+size_t sg_iocopy_to_buffer(struct scatterlist *sgl, unsigned int nents,
+			   void *buf, size_t buflen);
+
 /*
  * Maximum number of entries that will be allocated in one piece, if
  * a list larger than this is required then chaining will be utilized.
diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index c6cf822..22abd94 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -647,7 +647,7 @@ EXPORT_SYMBOL(sg_miter_stop);
  *
  **/
 size_t sg_copy_buffer(struct scatterlist *sgl, unsigned int nents, void *buf,
-		      size_t buflen, off_t skip, bool to_buffer)
+		      size_t buflen, off_t skip, bool to_buffer, bool iomem)
 {
 	unsigned int offset = 0;
 	struct sg_mapping_iter miter;
@@ -668,10 +668,17 @@ size_t sg_copy_buffer(struct scatterlist *sgl, unsigned int nents, void *buf,
 
 		len = min(miter.length, buflen - offset);
 
-		if (to_buffer)
-			memcpy(buf + offset, miter.addr, len);
-		else
-			memcpy(miter.addr, buf + offset, len);
+		if (iomem) {
+			if (to_buffer)
+				memcpy_fromio(buf + offset,  miter.addr, len);
+			else
+				memcpy_toio(miter.addr, buf + offset, len);
+		} else {
+			if (to_buffer)
+				memcpy(buf + offset, miter.addr, len);
+			else
+				memcpy(miter.addr, buf + offset, len);
+		}
 
 		offset += len;
 	}
@@ -695,7 +702,8 @@ EXPORT_SYMBOL(sg_copy_buffer);
 size_t sg_copy_from_buffer(struct scatterlist *sgl, unsigned int nents,
 			   const void *buf, size_t buflen)
 {
-	return sg_copy_buffer(sgl, nents, (void *)buf, buflen, 0, false);
+	return sg_copy_buffer(sgl, nents, (void *)buf, buflen, 0, false,
+			      false);
 }
 EXPORT_SYMBOL(sg_copy_from_buffer);
 
@@ -712,7 +720,7 @@ EXPORT_SYMBOL(sg_copy_from_buffer);
 size_t sg_copy_to_buffer(struct scatterlist *sgl, unsigned int nents,
 			 void *buf, size_t buflen)
 {
-	return sg_copy_buffer(sgl, nents, buf, buflen, 0, true);
+	return sg_copy_buffer(sgl, nents, buf, buflen, 0, true, false);
 }
 EXPORT_SYMBOL(sg_copy_to_buffer);
 
@@ -730,7 +738,8 @@ EXPORT_SYMBOL(sg_copy_to_buffer);
 size_t sg_pcopy_from_buffer(struct scatterlist *sgl, unsigned int nents,
 			    const void *buf, size_t buflen, off_t skip)
 {
-	return sg_copy_buffer(sgl, nents, (void *)buf, buflen, skip, false);
+	return sg_copy_buffer(sgl, nents, (void *)buf, buflen, skip, false,
+			      false);
 }
 EXPORT_SYMBOL(sg_pcopy_from_buffer);
 
@@ -748,6 +757,43 @@ EXPORT_SYMBOL(sg_pcopy_from_buffer);
 size_t sg_pcopy_to_buffer(struct scatterlist *sgl, unsigned int nents,
 			  void *buf, size_t buflen, off_t skip)
 {
-	return sg_copy_buffer(sgl, nents, buf, buflen, skip, true);
+	return sg_copy_buffer(sgl, nents, buf, buflen, skip, true, false);
 }
 EXPORT_SYMBOL(sg_pcopy_to_buffer);
+
+/**
+ * sg_iocopy_from_buffer - Copy from a linear buffer to an SG list containing
+ *	IO memory.
+ * @sgl:		 The SG list
+ * @nents:		 Number of SG entries
+ * @buf:		 Where to copy from
+ * @buflen:		 The number of bytes to copy
+ *
+ * Returns the number of copied bytes.
+ *
+ **/
+size_t sg_iocopy_from_buffer(struct scatterlist *sgl, unsigned int nents,
+			     const void *buf, size_t buflen)
+{
+	return sg_copy_buffer(sgl, nents, (void *)buf, buflen, 0, false,
+			      true);
+}
+EXPORT_SYMBOL(sg_iocopy_from_buffer);
+
+/**
+ * sg_iocopy_to_buffer - Copy from an SG list containing IO memory
+ *	to a linear buffer
+ * @sgl:		 The SG list
+ * @nents:		 Number of SG entries
+ * @buf:		 Where to copy to
+ * @buflen:		 The number of bytes to copy
+ *
+ * Returns the number of copied bytes.
+ *
+ **/
+size_t sg_iocopy_to_buffer(struct scatterlist *sgl, unsigned int nents,
+			   void *buf, size_t buflen)
+{
+	return sg_copy_buffer(sgl, nents, buf, buflen, 0, true, true);
+}
+EXPORT_SYMBOL(sg_iocopy_to_buffer);
-- 
2.1.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D407521A6F108
 for <linux-nvdimm@lists.01.org>; Thu, 13 Apr 2017 15:06:24 -0700 (PDT)
From: Logan Gunthorpe <logang@deltatee.com>
Date: Thu, 13 Apr 2017 16:05:17 -0600
Message-Id: <1492121135-4437-5-git-send-email-logang@deltatee.com>
In-Reply-To: <1492121135-4437-1-git-send-email-logang@deltatee.com>
References: <1492121135-4437-1-git-send-email-logang@deltatee.com>
Subject: [PATCH 04/22] target: Make use of the new sg_map function at 16 call
 sites
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
To: Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagi@grimberg.me>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Matthew Wilcox <mawilcox@microsoft.com>, Sumit Semwal <sumit.semwal@linaro.org>, Ming Lin <ming.l@ssi.samsung.com>, linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, intel-gfx@lists.freedesktop.org, linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org, linux-nvme@lists.infradead.org, linux-nvdimm@lists.01.org, linux-scsi@vger.kernel.org, fcoe-devel@open-fcoe.org, open-iscsi@googlegroups.com, megaraidlinux.pdl@broadcom.com, sparmaintainer@unisys.com, devel@driverdev.osuosl.org, target-devel@vger.kernel.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
Cc: Steve Wise <swise@opengridcomputing.com>
List-ID: <linux-nvdimm@lists.01.org>

Fairly straightforward conversions in all spots. In a couple of cases
any error gets propogated up should sg_map fail. In other
cases a warning is issued if the kmap fails seeing there's no
clear error path. This should not be an issue until someone tries to
use unmappable memory in the sgl with this driver.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
---
 drivers/target/iscsi/iscsi_target.c    |  27 +++++---
 drivers/target/target_core_rd.c        |   3 +-
 drivers/target/target_core_sbc.c       | 122 +++++++++++++++++++++++----------
 drivers/target/target_core_transport.c |  18 +++--
 drivers/target/target_core_user.c      |  43 ++++++++----
 include/target/target_core_backend.h   |   4 +-
 6 files changed, 149 insertions(+), 68 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index a918024..e3e0d8f 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -579,7 +579,7 @@ iscsit_xmit_nondatain_pdu(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 }
 
 static int iscsit_map_iovec(struct iscsi_cmd *, struct kvec *, u32, u32);
-static void iscsit_unmap_iovec(struct iscsi_cmd *);
+static void iscsit_unmap_iovec(struct iscsi_cmd *, struct kvec *);
 static u32 iscsit_do_crypto_hash_sg(struct ahash_request *, struct iscsi_cmd *,
 				    u32, u32, u32, u8 *);
 static int
@@ -646,7 +646,7 @@ iscsit_xmit_datain_pdu(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 
 	ret = iscsit_fe_sendpage_sg(cmd, conn);
 
-	iscsit_unmap_iovec(cmd);
+	iscsit_unmap_iovec(cmd, &cmd->iov_data[1]);
 
 	if (ret < 0) {
 		iscsit_tx_thread_wait_for_tcp(conn);
@@ -925,7 +925,10 @@ static int iscsit_map_iovec(
 	while (data_length) {
 		u32 cur_len = min_t(u32, data_length, sg->length - page_off);
 
-		iov[i].iov_base = kmap(sg_page(sg)) + sg->offset + page_off;
+		iov[i].iov_base = sg_map_offset(sg, page_off, SG_KMAP);
+		if (IS_ERR(iov[i].iov_base))
+			goto map_err;
+
 		iov[i].iov_len = cur_len;
 
 		data_length -= cur_len;
@@ -937,17 +940,25 @@ static int iscsit_map_iovec(
 	cmd->kmapped_nents = i;
 
 	return i;
+
+map_err:
+	cmd->kmapped_nents = i - 1;
+	iscsit_unmap_iovec(cmd, iov);
+	return -1;
 }
 
-static void iscsit_unmap_iovec(struct iscsi_cmd *cmd)
+static void iscsit_unmap_iovec(struct iscsi_cmd *cmd, struct kvec *iov)
 {
 	u32 i;
 	struct scatterlist *sg;
+	unsigned int page_off = cmd->first_data_sg_off;
 
 	sg = cmd->first_data_sg;
 
-	for (i = 0; i < cmd->kmapped_nents; i++)
-		kunmap(sg_page(&sg[i]));
+	for (i = 0; i < cmd->kmapped_nents; i++) {
+		sg_unmap_offset(&sg[i], iov[i].iov_base, page_off, SG_KMAP);
+		page_off = 0;
+	}
 }
 
 static void iscsit_ack_from_expstatsn(struct iscsi_conn *conn, u32 exp_statsn)
@@ -1610,7 +1621,7 @@ iscsit_get_dataout(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 
 	rx_got = rx_data(conn, &cmd->iov_data[0], iov_count, rx_size);
 
-	iscsit_unmap_iovec(cmd);
+	iscsit_unmap_iovec(cmd, iov);
 
 	if (rx_got != rx_size)
 		return -1;
@@ -2626,7 +2637,7 @@ static int iscsit_handle_immediate_data(
 
 	rx_got = rx_data(conn, &cmd->iov_data[0], iov_count, rx_size);
 
-	iscsit_unmap_iovec(cmd);
+	iscsit_unmap_iovec(cmd, cmd->iov_data);
 
 	if (rx_got != rx_size) {
 		iscsit_rx_thread_wait_for_tcp(conn);
diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index ddc216c..22c5ad5 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -431,7 +431,8 @@ static sense_reason_t rd_do_prot_rw(struct se_cmd *cmd, bool is_read)
 				    cmd->t_prot_sg, 0);
 
 	if (!rc)
-		sbc_dif_copy_prot(cmd, sectors, is_read, prot_sg, prot_offset);
+		rc = sbc_dif_copy_prot(cmd, sectors, is_read, prot_sg,
+				       prot_offset);
 
 	return rc;
 }
diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index c194063..67cb420 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -420,17 +420,17 @@ static sense_reason_t xdreadwrite_callback(struct se_cmd *cmd, bool success,
 
 	offset = 0;
 	for_each_sg(cmd->t_bidi_data_sg, sg, cmd->t_bidi_data_nents, count) {
-		addr = kmap_atomic(sg_page(sg));
-		if (!addr) {
+		addr = sg_map(sg, SG_KMAP_ATOMIC);
+		if (IS_ERR(addr)) {
 			ret = TCM_OUT_OF_RESOURCES;
 			goto out;
 		}
 
 		for (i = 0; i < sg->length; i++)
-			*(addr + sg->offset + i) ^= *(buf + offset + i);
+			*(addr + i) ^= *(buf + offset + i);
 
 		offset += sg->length;
-		kunmap_atomic(addr);
+		sg_unmap(sg, addr, SG_KMAP_ATOMIC);
 	}
 
 out:
@@ -541,8 +541,8 @@ static sense_reason_t compare_and_write_callback(struct se_cmd *cmd, bool succes
 	 * Compare against SCSI READ payload against verify payload
 	 */
 	for_each_sg(cmd->t_bidi_data_sg, sg, cmd->t_bidi_data_nents, i) {
-		addr = (unsigned char *)kmap_atomic(sg_page(sg));
-		if (!addr) {
+		addr = sg_map(sg, SG_KMAP_ATOMIC);
+		if (IS_ERR(addr)) {
 			ret = TCM_OUT_OF_RESOURCES;
 			goto out;
 		}
@@ -552,10 +552,10 @@ static sense_reason_t compare_and_write_callback(struct se_cmd *cmd, bool succes
 		if (memcmp(addr, buf + offset, len)) {
 			pr_warn("Detected MISCOMPARE for addr: %p buf: %p\n",
 				addr, buf + offset);
-			kunmap_atomic(addr);
+			sg_unmap(sg, addr, SG_KMAP_ATOMIC);
 			goto miscompare;
 		}
-		kunmap_atomic(addr);
+		sg_unmap(sg, addr, SG_KMAP_ATOMIC);
 
 		offset += len;
 		compare_len -= len;
@@ -1262,8 +1262,14 @@ sbc_dif_generate(struct se_cmd *cmd)
 	unsigned int block_size = dev->dev_attrib.block_size;
 
 	for_each_sg(cmd->t_prot_sg, psg, cmd->t_prot_nents, i) {
-		paddr = kmap_atomic(sg_page(psg)) + psg->offset;
-		daddr = kmap_atomic(sg_page(dsg)) + dsg->offset;
+		paddr = sg_map(psg, SG_KMAP_ATOMIC);
+		if (IS_ERR(paddr))
+			goto sg_map_err;
+
+		daddr = sg_map(dsg, SG_KMAP_ATOMIC);
+		if (IS_ERR(daddr))
+			goto sg_map_err;
+
 
 		for (j = 0; j < psg->length;
 				j += sizeof(*sdt)) {
@@ -1272,26 +1278,32 @@ sbc_dif_generate(struct se_cmd *cmd)
 
 			if (offset >= dsg->length) {
 				offset -= dsg->length;
-				kunmap_atomic(daddr - dsg->offset);
+				sg_unmap(dsg, daddr, SG_KMAP_ATOMIC);
 				dsg = sg_next(dsg);
 				if (!dsg) {
-					kunmap_atomic(paddr - psg->offset);
+					sg_unmap(psg, paddr, SG_KMAP_ATOMIC);
 					return;
 				}
-				daddr = kmap_atomic(sg_page(dsg)) + dsg->offset;
+				daddr = sg_map(dsg, SG_KMAP_ATOMIC);
+				if (IS_ERR(daddr))
+					goto sg_map_err;
 			}
 
 			sdt = paddr + j;
 			avail = min(block_size, dsg->length - offset);
 			crc = crc_t10dif(daddr + offset, avail);
 			if (avail < block_size) {
-				kunmap_atomic(daddr - dsg->offset);
+				sg_unmap(dsg, daddr, SG_KMAP_ATOMIC);
 				dsg = sg_next(dsg);
 				if (!dsg) {
-					kunmap_atomic(paddr - psg->offset);
+					sg_unmap(psg, paddr, SG_KMAP_ATOMIC);
 					return;
 				}
-				daddr = kmap_atomic(sg_page(dsg)) + dsg->offset;
+
+				daddr = sg_map(dsg, SG_KMAP_ATOMIC);
+				if (IS_ERR(daddr))
+					goto sg_map_err;
+
 				offset = block_size - avail;
 				crc = crc_t10dif_update(crc, daddr, offset);
 			} else {
@@ -1313,9 +1325,24 @@ sbc_dif_generate(struct se_cmd *cmd)
 			sector++;
 		}
 
-		kunmap_atomic(daddr - dsg->offset);
-		kunmap_atomic(paddr - psg->offset);
+		sg_unmap(dsg, daddr, SG_KMAP_ATOMIC);
+		sg_unmap(psg, paddr, SG_KMAP_ATOMIC);
 	}
+
+	return;
+
+sg_map_err:
+	if (!IS_ERR_OR_NULL(paddr))
+		sg_unmap(psg, paddr, SG_KMAP_ATOMIC);
+
+	/*
+	 * This should really never happen unless
+	 * the code is changed to use memory that is
+	 * not mappable in the sg. Seeing there doesn't
+	 * seem to be any error path out of here,
+	 * we can only WARN.
+	 */
+	WARN(1, "Non-mappable memory used in sg!");
 }
 
 static sense_reason_t
@@ -1359,8 +1386,8 @@ sbc_dif_v1_verify(struct se_cmd *cmd, struct t10_pi_tuple *sdt,
 	return 0;
 }
 
-void sbc_dif_copy_prot(struct se_cmd *cmd, unsigned int sectors, bool read,
-		       struct scatterlist *sg, int sg_off)
+int sbc_dif_copy_prot(struct se_cmd *cmd, unsigned int sectors, bool read,
+		      struct scatterlist *sg, int sg_off)
 {
 	struct se_device *dev = cmd->se_dev;
 	struct scatterlist *psg;
@@ -1369,18 +1396,24 @@ void sbc_dif_copy_prot(struct se_cmd *cmd, unsigned int sectors, bool read,
 	unsigned int offset = sg_off;
 
 	if (!sg)
-		return;
+		return 0;
 
 	left = sectors * dev->prot_length;
 
 	for_each_sg(cmd->t_prot_sg, psg, cmd->t_prot_nents, i) {
 		unsigned int psg_len, copied = 0;
 
-		paddr = kmap_atomic(sg_page(psg)) + psg->offset;
+		paddr = sg_map(psg, SG_KMAP_ATOMIC);
+		if (IS_ERR(paddr))
+			return TCM_OUT_OF_RESOURCES;
+
 		psg_len = min(left, psg->length);
 		while (psg_len) {
 			len = min(psg_len, sg->length - offset);
-			addr = kmap_atomic(sg_page(sg)) + sg->offset + offset;
+			addr = sg_map_offset(sg, offset, SG_KMAP_ATOMIC);
+
+			if (IS_ERR(paddr))
+				return TCM_OUT_OF_RESOURCES;
 
 			if (read)
 				memcpy(paddr + copied, addr, len);
@@ -1392,15 +1425,17 @@ void sbc_dif_copy_prot(struct se_cmd *cmd, unsigned int sectors, bool read,
 			copied += len;
 			psg_len -= len;
 
-			kunmap_atomic(addr - sg->offset - offset);
+			sg_unmap_offset(sg, addr, offset, SG_KMAP_ATOMIC);
 
 			if (offset >= sg->length) {
 				sg = sg_next(sg);
 				offset = 0;
 			}
 		}
-		kunmap_atomic(paddr - psg->offset);
+		sg_unmap(psg, paddr, SG_KMAP_ATOMIC);
 	}
+
+	return 0;
 }
 EXPORT_SYMBOL(sbc_dif_copy_prot);
 
@@ -1419,8 +1454,15 @@ sbc_dif_verify(struct se_cmd *cmd, sector_t start, unsigned int sectors,
 	unsigned int block_size = dev->dev_attrib.block_size;
 
 	for (; psg && sector < start + sectors; psg = sg_next(psg)) {
-		paddr = kmap_atomic(sg_page(psg)) + psg->offset;
-		daddr = kmap_atomic(sg_page(dsg)) + dsg->offset;
+		paddr = sg_map(psg, SG_KMAP_ATOMIC);
+		if (IS_ERR(paddr))
+			goto sg_map_err;
+
+		daddr = sg_map(dsg, SG_KMAP_ATOMIC);
+		if (IS_ERR(daddr)) {
+			sg_unmap(psg, paddr, SG_KMAP_ATOMIC);
+			goto sg_map_err;
+		}
 
 		for (i = psg_off; i < psg->length &&
 				sector < start + sectors;
@@ -1430,13 +1472,13 @@ sbc_dif_verify(struct se_cmd *cmd, sector_t start, unsigned int sectors,
 
 			if (dsg_off >= dsg->length) {
 				dsg_off -= dsg->length;
-				kunmap_atomic(daddr - dsg->offset);
+				sg_unmap(dsg, daddr, SG_KMAP_ATOMIC);
 				dsg = sg_next(dsg);
 				if (!dsg) {
-					kunmap_atomic(paddr - psg->offset);
+					sg_unmap(psg, paddr, SG_KMAP_ATOMIC);
 					return 0;
 				}
-				daddr = kmap_atomic(sg_page(dsg)) + dsg->offset;
+				daddr = sg_map(dsg, SG_KMAP_ATOMIC);
 			}
 
 			sdt = paddr + i;
@@ -1454,13 +1496,13 @@ sbc_dif_verify(struct se_cmd *cmd, sector_t start, unsigned int sectors,
 			avail = min(block_size, dsg->length - dsg_off);
 			crc = crc_t10dif(daddr + dsg_off, avail);
 			if (avail < block_size) {
-				kunmap_atomic(daddr - dsg->offset);
+				sg_unmap(dsg, daddr, SG_KMAP_ATOMIC);
 				dsg = sg_next(dsg);
 				if (!dsg) {
-					kunmap_atomic(paddr - psg->offset);
+					sg_unmap(psg, paddr, SG_KMAP_ATOMIC);
 					return 0;
 				}
-				daddr = kmap_atomic(sg_page(dsg)) + dsg->offset;
+				daddr = sg_map(dsg, SG_KMAP_ATOMIC);
 				dsg_off = block_size - avail;
 				crc = crc_t10dif_update(crc, daddr, dsg_off);
 			} else {
@@ -1469,8 +1511,8 @@ sbc_dif_verify(struct se_cmd *cmd, sector_t start, unsigned int sectors,
 
 			rc = sbc_dif_v1_verify(cmd, sdt, crc, sector, ei_lba);
 			if (rc) {
-				kunmap_atomic(daddr - dsg->offset);
-				kunmap_atomic(paddr - psg->offset);
+				sg_unmap(dsg, daddr, SG_KMAP_ATOMIC);
+				sg_unmap(psg, paddr, SG_KMAP_ATOMIC);
 				cmd->bad_sector = sector;
 				return rc;
 			}
@@ -1480,10 +1522,16 @@ sbc_dif_verify(struct se_cmd *cmd, sector_t start, unsigned int sectors,
 		}
 
 		psg_off = 0;
-		kunmap_atomic(daddr - dsg->offset);
-		kunmap_atomic(paddr - psg->offset);
+		sg_unmap(dsg, daddr, SG_KMAP_ATOMIC);
+		sg_unmap(psg, paddr, SG_KMAP_ATOMIC);
 	}
 
 	return 0;
+
+sg_map_err:
+	if (!IS_ERR_OR_NULL(paddr))
+		sg_unmap(psg, paddr, SG_KMAP_ATOMIC);
+
+	return TCM_OUT_OF_RESOURCES;
 }
 EXPORT_SYMBOL(sbc_dif_verify);
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index b1a3cdb..6899ef9 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1504,11 +1504,11 @@ int target_submit_cmd_map_sgls(struct se_cmd *se_cmd, struct se_session *se_sess
 			unsigned char *buf = NULL;
 
 			if (sgl)
-				buf = kmap(sg_page(sgl)) + sgl->offset;
+				buf = sg_map(sgl, SG_KMAP);
 
-			if (buf) {
+			if (buf && !IS_ERR(buf)) {
 				memset(buf, 0, sgl->length);
-				kunmap(sg_page(sgl));
+				sg_unmap(sgl, buf, SG_KMAP);
 			}
 		}
 
@@ -2276,8 +2276,14 @@ void *transport_kmap_data_sg(struct se_cmd *cmd)
 		return NULL;
 
 	BUG_ON(!sg);
-	if (cmd->t_data_nents == 1)
-		return kmap(sg_page(sg)) + sg->offset;
+	if (cmd->t_data_nents == 1) {
+		cmd->t_data_vmap = sg_map(sg, SG_KMAP);
+		if (IS_ERR(cmd->t_data_vmap)) {
+			cmd->t_data_vmap = NULL;
+			return NULL;
+		}
+		return cmd->t_data_vmap;
+	}
 
 	/* >1 page. use vmap */
 	pages = kmalloc(sizeof(*pages) * cmd->t_data_nents, GFP_KERNEL);
@@ -2303,7 +2309,7 @@ void transport_kunmap_data_sg(struct se_cmd *cmd)
 	if (!cmd->t_data_nents) {
 		return;
 	} else if (cmd->t_data_nents == 1) {
-		kunmap(sg_page(cmd->t_data_sg));
+		sg_unmap(cmd->t_data_sg, cmd->t_data_vmap, SG_KMAP);
 		return;
 	}
 
diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index c6874c3..319fef5 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -260,7 +260,7 @@ static inline size_t iov_tail(struct tcmu_dev *udev, struct iovec *iov)
 	return (size_t)iov->iov_base + iov->iov_len;
 }
 
-static void alloc_and_scatter_data_area(struct tcmu_dev *udev,
+static int alloc_and_scatter_data_area(struct tcmu_dev *udev,
 	struct scatterlist *data_sg, unsigned int data_nents,
 	struct iovec **iov, int *iov_cnt, bool copy_data)
 {
@@ -272,7 +272,10 @@ static void alloc_and_scatter_data_area(struct tcmu_dev *udev,
 
 	for_each_sg(data_sg, sg, data_nents, i) {
 		int sg_remaining = sg->length;
-		from = kmap_atomic(sg_page(sg)) + sg->offset;
+		from = sg_map(sg, SG_KMAP_ATOMIC);
+		if (IS_ERR(from))
+			return PTR_ERR(from);
+
 		while (sg_remaining > 0) {
 			if (block_remaining == 0) {
 				block = find_first_zero_bit(udev->data_bitmap,
@@ -301,8 +304,10 @@ static void alloc_and_scatter_data_area(struct tcmu_dev *udev,
 			sg_remaining -= copy_bytes;
 			block_remaining -= copy_bytes;
 		}
-		kunmap_atomic(from - sg->offset);
+		sg_unmap(sg, from, SG_KMAP_ATOMIC);
 	}
+
+	return 0;
 }
 
 static void free_data_area(struct tcmu_dev *udev, struct tcmu_cmd *cmd)
@@ -311,7 +316,7 @@ static void free_data_area(struct tcmu_dev *udev, struct tcmu_cmd *cmd)
 		   DATA_BLOCK_BITS);
 }
 
-static void gather_data_area(struct tcmu_dev *udev, unsigned long *cmd_bitmap,
+static int gather_data_area(struct tcmu_dev *udev, unsigned long *cmd_bitmap,
 		struct scatterlist *data_sg, unsigned int data_nents)
 {
 	int i, block;
@@ -322,7 +327,10 @@ static void gather_data_area(struct tcmu_dev *udev, unsigned long *cmd_bitmap,
 
 	for_each_sg(data_sg, sg, data_nents, i) {
 		int sg_remaining = sg->length;
-		to = kmap_atomic(sg_page(sg)) + sg->offset;
+		to = sg_map(sg, SG_KMAP_ATOMIC);
+		if (IS_ERR(to))
+			return PTR_ERR(to);
+
 		while (sg_remaining > 0) {
 			if (block_remaining == 0) {
 				block = find_first_bit(cmd_bitmap,
@@ -342,8 +350,10 @@ static void gather_data_area(struct tcmu_dev *udev, unsigned long *cmd_bitmap,
 			sg_remaining -= copy_bytes;
 			block_remaining -= copy_bytes;
 		}
-		kunmap_atomic(to - sg->offset);
+		sg_unmap(sg, to, SG_KMAP_ATOMIC);
 	}
+
+	return 0;
 }
 
 static inline size_t spc_bitmap_free(unsigned long *bitmap)
@@ -505,15 +515,18 @@ tcmu_queue_cmd_ring(struct tcmu_cmd *tcmu_cmd)
 	iov_cnt = 0;
 	copy_to_data_area = (se_cmd->data_direction == DMA_TO_DEVICE
 		|| se_cmd->se_cmd_flags & SCF_BIDI);
-	alloc_and_scatter_data_area(udev, se_cmd->t_data_sg,
-		se_cmd->t_data_nents, &iov, &iov_cnt, copy_to_data_area);
+	if (alloc_and_scatter_data_area(udev, se_cmd->t_data_sg,
+		se_cmd->t_data_nents, &iov, &iov_cnt, copy_to_data_area))
+		return TCM_OUT_OF_RESOURCES;
+
 	entry->req.iov_cnt = iov_cnt;
 	entry->req.iov_dif_cnt = 0;
 
 	/* Handle BIDI commands */
 	iov_cnt = 0;
-	alloc_and_scatter_data_area(udev, se_cmd->t_bidi_data_sg,
-		se_cmd->t_bidi_data_nents, &iov, &iov_cnt, false);
+	if (alloc_and_scatter_data_area(udev, se_cmd->t_bidi_data_sg,
+		se_cmd->t_bidi_data_nents, &iov, &iov_cnt, false))
+		return TCM_OUT_OF_RESOURCES;
 	entry->req.iov_bidi_cnt = iov_cnt;
 
 	/* cmd's data_bitmap is what changed in process */
@@ -596,15 +609,17 @@ static void tcmu_handle_completion(struct tcmu_cmd *cmd, struct tcmu_cmd_entry *
 
 		/* Get Data-In buffer before clean up */
 		bitmap_copy(bitmap, cmd->data_bitmap, DATA_BLOCK_BITS);
-		gather_data_area(udev, bitmap,
-			se_cmd->t_bidi_data_sg, se_cmd->t_bidi_data_nents);
+		if (gather_data_area(udev, bitmap,
+			se_cmd->t_bidi_data_sg, se_cmd->t_bidi_data_nents))
+			entry->rsp.scsi_status = SAM_STAT_CHECK_CONDITION;
 		free_data_area(udev, cmd);
 	} else if (se_cmd->data_direction == DMA_FROM_DEVICE) {
 		DECLARE_BITMAP(bitmap, DATA_BLOCK_BITS);
 
 		bitmap_copy(bitmap, cmd->data_bitmap, DATA_BLOCK_BITS);
-		gather_data_area(udev, bitmap,
-			se_cmd->t_data_sg, se_cmd->t_data_nents);
+		if (gather_data_area(udev, bitmap,
+			se_cmd->t_data_sg, se_cmd->t_data_nents))
+			entry->rsp.scsi_status = SAM_STAT_CHECK_CONDITION;
 		free_data_area(udev, cmd);
 	} else if (se_cmd->data_direction == DMA_TO_DEVICE) {
 		free_data_area(udev, cmd);
diff --git a/include/target/target_core_backend.h b/include/target/target_core_backend.h
index 1b0f447..c39ecd9 100644
--- a/include/target/target_core_backend.h
+++ b/include/target/target_core_backend.h
@@ -82,8 +82,8 @@ sector_t	sbc_get_write_same_sectors(struct se_cmd *cmd);
 void	sbc_dif_generate(struct se_cmd *);
 sense_reason_t	sbc_dif_verify(struct se_cmd *, sector_t, unsigned int,
 				     unsigned int, struct scatterlist *, int);
-void sbc_dif_copy_prot(struct se_cmd *, unsigned int, bool,
-		       struct scatterlist *, int);
+int sbc_dif_copy_prot(struct se_cmd *, unsigned int, bool,
+		      struct scatterlist *, int);
 void	transport_set_vpd_proto_id(struct t10_vpd *, unsigned char *);
 int	transport_set_vpd_assoc(struct t10_vpd *, unsigned char *);
 int	transport_set_vpd_ident_type(struct t10_vpd *, unsigned char *);
-- 
2.1.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

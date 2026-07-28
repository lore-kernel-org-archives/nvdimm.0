Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BA0747ACD3
	for <nvdimm@lists.linux.dev>; Tue, 28 Jul 2026 21:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785274203; cv=none; b=Tq5F1nDRipYUHenHzHFtJnFjx5pxXHFF0qtXYDE+u3XlbGi0HWATwbB2JtF2gQAGL5ueMbTzIYTcyDTetWV9LI6wXERf4oj/wpjSWBbWUH/LrsIrfVEyR9AMml0RdSimrQNnnYyBESebUWShzBZc3O/N3APWCczN1Che2CxFs40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785274203; c=relaxed/simple;
	bh=Ek9/zpYAO8RF84Ew64S3Xx1sj4mJGu00MK0SEJbblHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CgT9ebu1PDmW1399scX1WL8VkjqC0gfgPS+CJcebUlVjz3sljrAfVLPiOA4DXD/uOa4Dkx4zS+bouIiyUwyohmdTrSSmh4sMD7Jq4J+pLAYVi6NftaTfnThzj6aOPClk63afcIGBD/hFY2UQHkrQZbwo3EfxoYQ7ezrHKm0zio8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eDJ1J9J0; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eDJ1J9J0"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-476a130c138so369247f8f.0
        for <nvdimm@lists.linux.dev>; Tue, 28 Jul 2026 14:30:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785274198; x=1785878998; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UGM8qfMwXI/3P025Z0b9EZLQT53P+qICI0imVsyn3Vs=;
        b=eDJ1J9J0F8GBM3ciGnEXNc58FJnwW3V2Lu1ZLBWCdK3YYZqusbLUjXDW1YZR/luzdS
         LL5tCk6EyGVfi6tZJC7AzKD9AyJkGT/oLqJcykG5QmiqJ0xsxsZblIuLM7Kq+Pw6a+y0
         Kc18utSpDixBfHfjNqBGUE4aWTPCFB7Sz1yor9SR+UzjU2u2ZkeSLZZNfYzOFn6HK1jM
         VSrIpKam6+0E6DmVWk9GkE0heAXXWFf5fN8DnVreHkpCG477Bd55Evn6qqv5R6WDeias
         235XeL9U+JZPt2Gs5NGJUvQJwuf8TI137WkzAIn5stQtCRtsdCE/nC94Dlc7neYizndU
         Jnrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785274198; x=1785878998;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=UGM8qfMwXI/3P025Z0b9EZLQT53P+qICI0imVsyn3Vs=;
        b=Tx1Drk6Lr5txzc42zDKQMzOI0yLBQYJ3aMcLxS+xILajGBrNNuQY3sa0tS+t2jrgMK
         hOLFAIsiHJtN/ChQQdxtZBuEE58ebZQa3ozWyiGT9rL2j2AInMfmweaMANiIaO6ma9iE
         XN8UVA74NUSdYOM/p46XwxDOySpGahrypElU9YuwXTwFWV0+dy/bbdZo5NILnu5BWUKM
         KwKsQzBqrpN2qVW3WXemnB/lhbXVQqwmS7nTWnWFVLJHpcGEL5VceNMfej2Tj3wvFknK
         mpJROKBHPGH+pra7ubTwJZMSUT32cPEewrpigxuWjM4+ecLdyPcvtQIMm82+nHTy/UJX
         qLAg==
X-Forwarded-Encrypted: i=1; AHgh+RpBYbJzf1v0JYumqhdaHKka88Yg/PtKQ47UsU2zrBBsb79skbW5siOrndD3f0i24/ZmKDoWoxk=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywza0MAk69IbqssX45i0H24YcKiek9lBQdun5bezceGsKZeNX+C
	cWCS7Y/qYFpcsNEoHSuxQf1IblaF1AFy/hc4/MdixjPfE49vfBmWnwfj
X-Gm-Gg: AR+sD10lydOC+qPu5PF80ECqBN9vLzCA2KEOhCjZJbkZ0n1KeiCKWfDuR8yp3KqJU6b
	4vTDd1+PQM5pamB9F6q+kSw7rSrTv09hbDczPXJOGBPf6KUTDYhbSs2sARv4C1x/TBRWCgC76ly
	3rW/gNxumJqhxwp/BVoNS1Eu3s1cmkXt0oImRd0t7YnZI9kWN1Ce6MzL8f//Srmejg4X3wGDbFI
	PVEH24Ky26S/I2updPpMJQhX2oqGMsmT7adqQKuNoRY4aGYSNepi9H9bqamDZQZVwBNOIEEtCaP
	0BCgGf5edAJ0YiD4R0RYLmGYPV8BJ3uplADZEFl8S4O1O44HUFygw3FipqcFBR+Jx6fyGlUtUgY
	LWB8bdd0WkD9qZV6IrjUglQ1kaO5hjWitiTZc1Uc+1LvJllPdhHeIR1GEKO8pzGnr+AaYXgh/0p
	zTI1SQskdHO4ai+iaeQ7AVlFNilhzZOvaAOjgyHefpgEZYaXrrEMGMYs5zko3qQeodi5qrms4qk
	qkp3lmn
X-Received: by 2002:a05:6000:4802:b0:47f:81a9:3f36 with SMTP id ffacd0b85a97d-47fb1e8e26cmr4897946f8f.18.1785274198573;
        Tue, 28 Jul 2026 14:29:58 -0700 (PDT)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fb6ac44bcsm2245329f8f.11.2026.07.28.14.29.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 14:29:57 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org,
	linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org
Cc: asml.silence@gmail.com,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Tushar Gohad <tushar.gohad@intel.com>,
	William Power <william.power@intel.com>,
	Phil Cayton <phil.cayton@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	David Sterba <dsterba@suse.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	dm-devel@lists.linux.dev,
	nvdimm@lists.linux.dev,
	linux-btrfs@vger.kernel.org,
	ceph-devel@vger.kernel.org
Subject: [PATCH v4 08/14] nvme-pci: implement dma_token backed requests
Date: Tue, 28 Jul 2026 22:29:20 +0100
Message-ID: <19e5c945ea8114320c10f7951d19197d48b59249.1785274111.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1785274111.git.asml.silence@gmail.com>
References: <cover.1785274111.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Enable BIO_DMABUF_MAP backed requests. It creates a prp list for the
dmabuf when it's mapped, which is then used to initialise requests.

Suggested-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 drivers/nvme/host/core.c |  12 ++
 drivers/nvme/host/nvme.h |   2 +
 drivers/nvme/host/pci.c  | 259 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 273 insertions(+)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 453c1f0b2dd0..ce66a1843bec 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2676,6 +2676,17 @@ static int nvme_report_zones(struct gendisk *disk, sector_t sector,
 #define nvme_report_zones	NULL
 #endif /* CONFIG_BLK_DEV_ZONED */
 
+static int nvme_init_dma_buf_io_ctx(struct block_device *bdev,
+				    struct dma_buf_io_ctx *ctx)
+{
+	struct nvme_ns *ns = bdev->bd_disk->private_data;
+	struct nvme_ctrl *ctrl = ns->ctrl;
+
+	if (!ctrl->ops->init_dma_buf_io_ctx)
+		return -EINVAL;
+	return ctrl->ops->init_dma_buf_io_ctx(ctrl, ctx);
+}
+
 const struct block_device_operations nvme_bdev_ops = {
 	.owner		= THIS_MODULE,
 	.ioctl		= nvme_ioctl,
@@ -2686,6 +2697,7 @@ const struct block_device_operations nvme_bdev_ops = {
 	.get_unique_id	= nvme_get_unique_id,
 	.report_zones	= nvme_report_zones,
 	.pr_ops		= &nvme_pr_ops,
+	.init_dma_buf_io_ctx = nvme_init_dma_buf_io_ctx,
 };
 
 static int nvme_wait_ready(struct nvme_ctrl *ctrl, u32 mask, u32 val,
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 824651cc898d..034c31af8fec 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -652,6 +652,8 @@ struct nvme_ctrl_ops {
 	int (*get_address)(struct nvme_ctrl *ctrl, char *buf, int size);
 	void (*print_device_info)(struct nvme_ctrl *ctrl);
 	bool (*supports_pci_p2pdma)(struct nvme_ctrl *ctrl);
+	int (*init_dma_buf_io_ctx)(struct nvme_ctrl *ctrl,
+				   struct dma_buf_io_ctx *ctx);
 	unsigned long (*get_virt_boundary)(struct nvme_ctrl *ctrl, bool is_admin);
 };
 
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 69932d640b53..f1b67c191892 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -27,6 +27,8 @@
 #include <linux/io-64-nonatomic-lo-hi.h>
 #include <linux/io-64-nonatomic-hi-lo.h>
 #include <linux/sed-opal.h>
+#include <linux/dma-buf-io.h>
+#include <linux/dma-resv.h>
 
 #include "trace.h"
 #include "nvme.h"
@@ -393,6 +395,13 @@ struct nvme_queue {
 	struct completion delete_done;
 };
 
+struct nvme_dmabuf_map {
+	struct dma_buf_io_map base;
+	struct sg_table *sgt;
+	unsigned nr_entries;
+	dma_addr_t dma_list[];
+};
+
 /* bits for iod->flags */
 enum nvme_iod_flags {
 	/* this command has been aborted by the timeout handler */
@@ -859,6 +868,138 @@ static void nvme_free_descriptors(struct request *req)
 	}
 }
 
+static inline struct nvme_dmabuf_map *
+to_nvme_dmabuf_map(struct dma_buf_io_map *map)
+{
+	return container_of(map, struct nvme_dmabuf_map, base);
+}
+
+static void nvme_dmabuf_map_sync_for_cpu(struct nvme_dev *nvme_dev,
+					 struct request *req)
+{
+	struct device *dev = nvme_dev->dev;
+	enum dma_data_direction dma_dir;
+	struct bio *bio = req->bio;
+	struct nvme_dmabuf_map *map = to_nvme_dmabuf_map(bio->bi_dmabuf_map);
+	dma_addr_t *dma_list = map->dma_list;
+	unsigned offset = bio->bi_iter.bi_offset;
+	unsigned map_idx = offset / NVME_CTRL_PAGE_SIZE;
+	int length = blk_rq_payload_bytes(req) +
+		     (offset & (NVME_CTRL_PAGE_SIZE - 1));
+
+	dma_dir = rq_data_dir(req) == READ ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
+
+	while (length > 0) {
+		dma_sync_single_for_cpu(dev, dma_list[map_idx++],
+					NVME_CTRL_PAGE_SIZE, dma_dir);
+		length -= NVME_CTRL_PAGE_SIZE;
+	}
+}
+
+static void nvme_dmabuf_map_sync_for_device(struct nvme_dev *nvme_dev,
+					    struct request *req)
+{
+	struct device *dev = nvme_dev->dev;
+	enum dma_data_direction dma_dir;
+	struct bio *bio = req->bio;
+	struct nvme_dmabuf_map *map = to_nvme_dmabuf_map(bio->bi_dmabuf_map);
+	dma_addr_t *dma_list = map->dma_list;
+	unsigned offset = bio->bi_iter.bi_offset;
+	unsigned map_idx = offset / NVME_CTRL_PAGE_SIZE;
+	int length = blk_rq_payload_bytes(req) +
+		     (offset & (NVME_CTRL_PAGE_SIZE - 1));
+
+	dma_dir = rq_data_dir(req) == READ ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
+
+	while (length > 0) {
+		dma_sync_single_for_device(dev, dma_list[map_idx++],
+					   NVME_CTRL_PAGE_SIZE, dma_dir);
+		length -= NVME_CTRL_PAGE_SIZE;
+	}
+}
+
+static void nvme_rq_clean_dmabuf_map(struct nvme_dev *dev,
+				      struct request *req)
+{
+	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
+
+	nvme_dmabuf_map_sync_for_cpu(dev, req);
+
+	if (!(iod->flags & IOD_SINGLE_SEGMENT))
+		nvme_free_descriptors(req);
+}
+
+static blk_status_t nvme_rq_setup_dmabuf_map(struct request *req,
+					     struct nvme_queue *nvmeq)
+{
+	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
+	struct bio *bio = req->bio;
+	struct nvme_dmabuf_map *map = to_nvme_dmabuf_map(bio->bi_dmabuf_map);
+	unsigned bvec_done = bio->bi_iter.bi_offset;
+	unsigned map_idx = bvec_done / NVME_CTRL_PAGE_SIZE;
+	unsigned offset = bvec_done & (NVME_CTRL_PAGE_SIZE - 1);
+	int length = blk_rq_payload_bytes(req) - (NVME_CTRL_PAGE_SIZE - offset);
+	dma_addr_t *dma_list = map->dma_list;
+	u64 prp1_dma = dma_list[map_idx++] + offset;
+	u64 dma_addr, prp2_dma;
+	dma_addr_t prp_dma;
+	__le64 *prp_list;
+	unsigned i;
+
+	nvme_dmabuf_map_sync_for_device(nvmeq->dev, req);
+
+	if (length <= 0) {
+		prp2_dma = 0;
+		goto done;
+	}
+
+	if (length <= NVME_CTRL_PAGE_SIZE) {
+		prp2_dma = dma_list[map_idx];
+		goto done;
+	}
+
+	if (DIV_ROUND_UP(length, NVME_CTRL_PAGE_SIZE) <=
+	    NVME_SMALL_POOL_SIZE / sizeof(__le64))
+		iod->flags |= IOD_SMALL_DESCRIPTOR;
+
+	prp_list = dma_pool_alloc(nvme_dma_pool(nvmeq, iod), GFP_ATOMIC,
+			&prp_dma);
+	if (!prp_list)
+		return BLK_STS_RESOURCE;
+
+	iod->descriptors[iod->nr_descriptors++] = prp_list;
+	prp2_dma = prp_dma;
+	i = 0;
+	for (;;) {
+		if (i == NVME_CTRL_PAGE_SIZE >> 3) {
+			__le64 *old_prp_list = prp_list;
+
+			prp_list = dma_pool_alloc(nvmeq->descriptor_pools.large,
+					GFP_ATOMIC, &prp_dma);
+			if (!prp_list)
+				goto free_prps;
+			iod->descriptors[iod->nr_descriptors++] = prp_list;
+			prp_list[0] = old_prp_list[i - 1];
+			old_prp_list[i - 1] = cpu_to_le64(prp_dma);
+			i = 1;
+		}
+
+		dma_addr = dma_list[map_idx++];
+		prp_list[i++] = cpu_to_le64(dma_addr);
+
+		length -= NVME_CTRL_PAGE_SIZE;
+		if (length <= 0)
+			break;
+	}
+done:
+	iod->cmd.common.dptr.prp1 = cpu_to_le64(prp1_dma);
+	iod->cmd.common.dptr.prp2 = cpu_to_le64(prp2_dma);
+	return BLK_STS_OK;
+free_prps:
+	nvme_free_descriptors(req);
+	return BLK_STS_RESOURCE;
+}
+
 static void nvme_free_prps(struct request *req, unsigned int attrs)
 {
 	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
@@ -937,6 +1078,11 @@ static void nvme_unmap_data(struct request *req)
 	struct device *dma_dev = nvmeq->dev->dev;
 	unsigned int attrs = 0;
 
+	if (blk_mq_rq_is_dmabuf(req)) {
+		nvme_rq_clean_dmabuf_map(nvmeq->dev, req);
+		return;
+	}
+
 	if (iod->flags & IOD_SINGLE_SEGMENT) {
 		static_assert(offsetof(union nvme_data_ptr, prp1) ==
 				offsetof(union nvme_data_ptr, sgl.addr));
@@ -1251,6 +1397,9 @@ static blk_status_t nvme_map_data(struct request *req)
 	struct blk_dma_iter iter;
 	blk_status_t ret;
 
+	if (blk_mq_rq_is_dmabuf(req))
+		return nvme_rq_setup_dmabuf_map(req, nvmeq);
+
 	/*
 	 * Try to skip the DMA iterator for single segment requests, as that
 	 * significantly improves performances for small I/O sizes.
@@ -2269,6 +2418,112 @@ static int nvme_create_queue(struct nvme_queue *nvmeq, int qid, bool polled)
 	return result;
 }
 
+#if defined(CONFIG_DMA_SHARED_BUFFER)
+static void nvme_dmabuf_invalidate_mappings(struct dma_buf_attachment *attach)
+{
+	struct dma_buf_io_ctx *ctx = attach->importer_priv;
+
+	dma_buf_io_invalidate_mappings(ctx);
+}
+
+const struct dma_buf_attach_ops nvme_dmabuf_importer_ops = {
+	.invalidate_mappings	= nvme_dmabuf_invalidate_mappings,
+	.allow_peer2peer	= true,
+};
+
+static struct dma_buf_io_map *nvme_dma_buf_io_map(struct dma_buf_io_ctx *ctx)
+{
+	unsigned nr_entries = ctx->dmabuf->size / NVME_CTRL_PAGE_SIZE;
+	struct dma_buf_attachment *attach = ctx->dev_priv;
+	unsigned long tmp, i = 0;
+	struct nvme_dmabuf_map *map;
+	struct scatterlist *sg;
+	struct sg_table *sgt;
+	int ret;
+
+	dma_resv_assert_held(ctx->dmabuf->resv);
+
+	map = kmalloc_flex(*map, dma_list, nr_entries);
+	if (!map)
+		return ERR_PTR(-ENOMEM);
+
+	sgt = dma_buf_map_attachment(attach, ctx->dir);
+	if (IS_ERR(sgt)) {
+		ret = PTR_ERR(sgt);
+		sgt = NULL;
+		goto err;
+	}
+
+	for_each_sgtable_dma_sg(sgt, sg, tmp) {
+		dma_addr_t dma_addr = sg_dma_address(sg);
+		unsigned long sg_len = sg_dma_len(sg);
+
+		if (sg_len % NVME_CTRL_PAGE_SIZE) {
+			ret = -EINVAL;
+			goto err;
+		}
+
+		while (sg_len) {
+			map->dma_list[i++] = dma_addr;
+			dma_addr += NVME_CTRL_PAGE_SIZE;
+			sg_len -= NVME_CTRL_PAGE_SIZE;
+		}
+	}
+
+	ret = dma_buf_io_init_map(ctx, &map->base);
+	if (ret)
+		goto err;
+	map->nr_entries = nr_entries;
+	map->sgt = sgt;
+	return &map->base;
+err:
+	if (sgt)
+		dma_buf_unmap_attachment(attach, sgt, ctx->dir);
+	kfree(map);
+	return ERR_PTR(ret);
+}
+
+static void nvme_dma_buf_io_unmap(struct dma_buf_io_ctx *ctx,
+				  struct dma_buf_io_map *map_base)
+{
+	struct dma_buf_attachment *attach = ctx->dev_priv;
+	struct nvme_dmabuf_map *map = to_nvme_dmabuf_map(map_base);
+
+	dma_resv_assert_held(ctx->dmabuf->resv);
+
+	dma_buf_unmap_attachment(attach, map->sgt, ctx->dir);
+}
+
+static void nvme_dma_buf_io_release(struct dma_buf_io_ctx *ctx)
+{
+	struct dma_buf_attachment *attach = ctx->dev_priv;
+
+	dma_buf_detach(ctx->dmabuf, attach);
+}
+
+const struct dma_buf_io_ops nvme_dma_buf_io_ops = {
+	.map		= nvme_dma_buf_io_map,
+	.unmap		= nvme_dma_buf_io_unmap,
+	.release	= nvme_dma_buf_io_release,
+};
+
+static int nvme_pci_init_dma_buf_io_ctx(struct nvme_ctrl *ctrl,
+					struct dma_buf_io_ctx *ctx)
+{
+	struct dma_buf_attachment *attach;
+	struct nvme_dev *dev = to_nvme_dev(ctrl);
+
+	attach = dma_buf_dynamic_attach(ctx->dmabuf, dev->dev,
+					&nvme_dmabuf_importer_ops, ctx);
+	if (IS_ERR(attach))
+		return PTR_ERR(attach);
+
+	ctx->dev_priv = attach;
+	ctx->dev_ops = &nvme_dma_buf_io_ops;
+	return 0;
+}
+#endif
+
 static const struct blk_mq_ops nvme_mq_admin_ops = {
 	.queue_rq	= nvme_queue_rq,
 	.complete	= nvme_pci_complete_rq,
@@ -3563,6 +3818,9 @@ static const struct nvme_ctrl_ops nvme_pci_ctrl_ops = {
 	.print_device_info	= nvme_pci_print_device_info,
 	.supports_pci_p2pdma	= nvme_pci_supports_pci_p2pdma,
 	.get_virt_boundary	= nvme_pci_get_virt_boundary,
+#if defined(CONFIG_DMA_SHARED_BUFFER)
+	.init_dma_buf_io_ctx	= nvme_pci_init_dma_buf_io_ctx,
+#endif
 };
 
 static int nvme_dev_map(struct nvme_dev *dev)
@@ -4327,5 +4585,6 @@ MODULE_AUTHOR("Matthew Wilcox <willy@linux.intel.com>");
 MODULE_LICENSE("GPL");
 MODULE_VERSION("1.0");
 MODULE_DESCRIPTION("NVMe host PCIe transport driver");
+MODULE_IMPORT_NS("DMA_BUF");
 module_init(nvme_init);
 module_exit(nvme_exit);
-- 
2.54.0


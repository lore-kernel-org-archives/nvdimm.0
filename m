Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89E8A2C89
	for <nvdimm@lists.linux.dev>; Fri, 15 Oct 2021 23:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=bWrYy27/Ft+aLDChsLBGCGZJ9I29Pbmku4dc9v02/r0=; b=IY2ti5CFu7tk7l/1b1dOBrzqFV
	aY9UvoJKkeTLc2QMRNWX6uc1JjZmitgQWYAqCJrHP3ukaJAS1Znz/MF42OZxUAt/7nUAnIiAlaBdw
	qxqWz+L6WdoNhUxemK8IqK8TTz5PiYshQ9/0IYTCEPZsgX8UFxP25gp3gw4mI5zwxPE0jpzsJMdNF
	piTCgmlnkXlxAQxhoX2yeSSTMZLJghSLJlHFu34Sux+hr4llFOQyl8BtkdxpGRy5hn40pVSQcZxr9
	8NMljnWNJV+SY+YkxBhw9vXuVPxdhVfyQszbzyQE3EdW1D1TeSngbhl2jloBhz2cfG6cuZlUSHqj0
	9sJQoaow==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mbWzt-009C2x-0D; Fri, 15 Oct 2021 23:52:21 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: axboe@kernel.dk,
	geoff@infradead.org,
	mpe@ellerman.id.au,
	benh@kernel.crashing.org,
	paulus@samba.org,
	jim@jtan.com,
	minchan@kernel.org,
	ngupta@vflare.org,
	senozhatsky@chromium.org,
	richard@nod.at,
	miquel.raynal@bootlin.com,
	vigneshr@ti.com,
	dan.j.williams@intel.com,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	ira.weiny@intel.com,
	kbusch@kernel.org,
	hch@lst.de,
	sagi@grimberg.me
Cc: linux-block@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-mtd@lists.infradead.org,
	nvdimm@lists.linux.dev,
	linux-nvme@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH 02/13] nvme-multipath: add error handling support for add_disk()
Date: Fri, 15 Oct 2021 16:52:08 -0700
Message-Id: <20211015235219.2191207-3-mcgrof@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211015235219.2191207-1-mcgrof@kernel.org>
References: <20211015235219.2191207-1-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>

We never checked for errors on add_disk() as this function
returned void. Now that this is fixed, use the shiny new
error handling.

Since we now can tell for sure when a disk was added, move
setting the bit NVME_NSHEAD_DISK_LIVE only when we did
add the disk successfully.

Nothing to do here as the cleanup is done elsewhere. We take
care and use test_and_set_bit() because it is protects against
two nvme paths simultaneously calling device_add_disk() on the
same namespace head.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 drivers/nvme/host/multipath.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index e8ccdd398f78..022837f7be41 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -496,13 +496,23 @@ int nvme_mpath_alloc_disk(struct nvme_ctrl *ctrl, struct nvme_ns_head *head)
 static void nvme_mpath_set_live(struct nvme_ns *ns)
 {
 	struct nvme_ns_head *head = ns->head;
+	int rc;
 
 	if (!head->disk)
 		return;
 
+	/*
+	 * test_and_set_bit() is used because it is protecting against two nvme
+	 * paths simultaneously calling device_add_disk() on the same namespace
+	 * head.
+	 */
 	if (!test_and_set_bit(NVME_NSHEAD_DISK_LIVE, &head->flags)) {
-		device_add_disk(&head->subsys->dev, head->disk,
-				nvme_ns_id_attr_groups);
+		rc = device_add_disk(&head->subsys->dev, head->disk,
+				     nvme_ns_id_attr_groups);
+		if (rc) {
+			clear_bit(NVME_NSHEAD_DISK_LIVE, &ns->flags);
+			return;
+		}
 		nvme_add_ns_head_cdev(head);
 	}
 
-- 
2.30.2


Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 174C43FED
	for <nvdimm@lists.linux.dev>; Mon, 27 Sep 2021 22:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=7F58wxD/dEQonKrzNoWM7DkNk/UH9ZF8NZLJCFZZJo4=; b=ZnlFI8fLEZC+pXL09OaLsKjdn8
	sG2hdDcnkdd7ZQAAOmWguGc7OnVMevoBr9Iei6cSMyXAQixEc8APBeN/A8M4gCqUCYojYyBiRia7O
	7wDEec/aFp7xuN5F775zNLNzsTp/rSR3Ay3VTbK1PNHfZokfRNvqNAX9BvqfJMUKuSdi3rm3MuWeX
	L6a8Q4FjRtkn9UeJ4Lhp3Lt/jbaePXbm+u8tO6lhIOBWl8Zvgdk3hjBymTruCXrQy+1R0u429f+a4
	B0bkzO9hXCn6QDiaV77uGrK+Hfqt+kENvWzGuFAfXSbunwOgQu1cHy4uiqeb5kU5vGXxTPlHBSNa9
	7+WGTsLw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mUyfw-004Suk-EY; Mon, 27 Sep 2021 22:00:40 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: axboe@kernel.dk,
	colyli@suse.de,
	kent.overstreet@gmail.com,
	kbusch@kernel.org,
	sagi@grimberg.me,
	vishal.l.verma@intel.com,
	dan.j.williams@intel.com,
	dave.jiang@intel.com,
	ira.weiny@intel.com,
	konrad.wilk@oracle.com,
	roger.pau@citrix.com,
	boris.ostrovsky@oracle.com,
	jgross@suse.com,
	sstabellini@kernel.org,
	minchan@kernel.org,
	ngupta@vflare.org,
	senozhatsky@chromium.org
Cc: xen-devel@lists.xenproject.org,
	nvdimm@lists.linux.dev,
	linux-nvme@lists.infradead.org,
	linux-bcache@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH v2 03/10] nvme-multipath: add error handling support for add_disk()
Date: Mon, 27 Sep 2021 15:00:32 -0700
Message-Id: <20210927220039.1064193-4-mcgrof@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210927220039.1064193-1-mcgrof@kernel.org>
References: <20210927220039.1064193-1-mcgrof@kernel.org>
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
 drivers/nvme/host/multipath.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index e8ccdd398f78..35cace4f3f5f 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -496,13 +496,22 @@ int nvme_mpath_alloc_disk(struct nvme_ctrl *ctrl, struct nvme_ns_head *head)
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
+		if (rc)
+			return;
+		set_bit(NVME_NSHEAD_DISK_LIVE, &head->flags);
 		nvme_add_ns_head_cdev(head);
 	}
 
-- 
2.30.2


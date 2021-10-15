Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7597E2C81
	for <nvdimm@lists.linux.dev>; Fri, 15 Oct 2021 23:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=HyZ2KI/h/gpVdjlPSyGH7uhBE8wL3JrrLi6b2qQqvAU=; b=yj5zwz6Fs1lJD22XifEcv2Orrv
	prK+DP1Qo/XEWtRbfWO8+3LeJ2D/W40Mrnlx/po3H3Bj1sdJ7LjC46VZzVbijZLDUfyDQ0lcraB4A
	O1+ZnXCViST9WOLXPEp6QEw5iFwg7Nl2NTJjTFNWAiBSCkRT/eFF+ufsLZ35VSvWT+Me6Bl5b+zW4
	qnUeG+hWSyDlJEc6UGDHcC2VRpwbRbnamAoY23a1KoJTax19zGzqc5vZVqn6CEFYHaBNHVowexejt
	7tFP6vpdjs9kA32INEEkgOr2mGidDR806UqktII1c799hggCz3zG9h/QDk29AdLY2mx1RJDCSEpjY
	mzPuYCUA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mbWzt-009C3J-DB; Fri, 15 Oct 2021 23:52:21 +0000
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
Subject: [PATCH 12/13] block/sunvdc: add error handling support for add_disk()
Date: Fri, 15 Oct 2021 16:52:18 -0700
Message-Id: <20211015235219.2191207-13-mcgrof@kernel.org>
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

We re-use the same free tag call, so we also add a label for
that as well.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 drivers/block/sunvdc.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/block/sunvdc.c b/drivers/block/sunvdc.c
index 4d4bb810c2ae..6f45a53f7cbf 100644
--- a/drivers/block/sunvdc.c
+++ b/drivers/block/sunvdc.c
@@ -826,8 +826,8 @@ static int probe_disk(struct vdc_port *port)
 	if (IS_ERR(g)) {
 		printk(KERN_ERR PFX "%s: Could not allocate gendisk.\n",
 		       port->vio.name);
-		blk_mq_free_tag_set(&port->tag_set);
-		return PTR_ERR(g);
+		err = PTR_ERR(g);
+		goto out_free_tag;
 	}
 
 	port->disk = g;
@@ -879,9 +879,17 @@ static int probe_disk(struct vdc_port *port)
 	       port->vdisk_size, (port->vdisk_size >> (20 - 9)),
 	       port->vio.ver.major, port->vio.ver.minor);
 
-	device_add_disk(&port->vio.vdev->dev, g, NULL);
+	err = device_add_disk(&port->vio.vdev->dev, g, NULL);
+	if (err)
+		goto out_cleanup_disk;
 
 	return 0;
+
+out_cleanup_disk:
+	blk_cleanup_disk(g);
+out_free_tag:
+	blk_mq_free_tag_set(&port->tag_set);
+	return err;
 }
 
 static struct ldc_channel_config vdc_ldc_cfg = {
-- 
2.30.2


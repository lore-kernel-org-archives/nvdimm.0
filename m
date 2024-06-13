Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3096213D8A6;
	Thu, 13 Jun 2024 08:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718268536; cv=none; b=PeeHSxDrm3SR0zWg5NFJ2lnWSB33Jg6uYJe+vT8q0IhN0p+bIOKmzVHOibUcthJVf2yB5Lv8oS7jhDgeRbC6okEvCbvttW67y+Yvj98ZKYYeR2+YJZcJN+kdrUBMYdAiBMkg6SH75HyhXTIa7F0xM3Hd4m6jyV9ZyyrQvEhydZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718268536; c=relaxed/simple;
	bh=0AmtyARSaCfpKYoEJ5CCQgZ2tTPFVkXy8IxqhQ0K9zY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VUKCzCFf+rxdw73V2/Epk7/m68FXFKDDRT7JB7qFF16eZ+quxRher1j4KKWd/hTqaHrMSA2EBgDRdHoOwfdOp/7OPukxpP8wTh0lLL3O2m25qsM7knYRh+1TytWcZzT++0YqoDCHtH3rIiQ2ksn0dL8u9BV2xAmGUFASfV79oS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ZFLy+zD1; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZFLy+zD1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=xt/cEzI4CksO34TKlgliy2AxvKCGUtTFve6xzQi8/jQ=; b=ZFLy+zD1SYY6PByLnylvEoMMkr
	CLkNFUhAogQDFqJ51lVh2avS43WhEd4dQ5Hwv9E4YDGxlgnNWgm1H2qEsSef/7AeWU4hWVX5nYFbm
	KuGM9fEcglzDSYWFda+EBVKg4B6PGc0gGUriDz3PiLn0FV7fp2EgwtKZDzoI20uF4vPLotLSmiEGe
	6QXmlxQBZB/7aKw+J291tQOKK2H1zyfS/O6ENCxZyGItU/YG9sZQH0/4ogoNKOwa344QLaniqEjew
	fBQXtCQb449arxK2JiyMkiq47Lap3GtX7GaWzLxvkw5YsNOiw2ioMoWMv4ityEBxYglA5nkMOtmwj
	5eLLx/3A==;
Received: from 2a02-8389-2341-5b80-034b-6bc2-b258-c831.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:34b:6bc2:b258:c831] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sHg8W-0000000Fn1R-06kc;
	Thu, 13 Jun 2024 08:48:49 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org
Subject: [PATCH 02/12] md/raid0: don't free conf on raid0_run failure
Date: Thu, 13 Jun 2024 10:48:12 +0200
Message-ID: <20240613084839.1044015-3-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240613084839.1044015-1-hch@lst.de>
References: <20240613084839.1044015-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The core md code calls the ->free method which already frees conf.

Fixes: 0c031fd37f69 ("md: Move alloc/free acct bioset in to personality")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/raid0.c | 21 +++++----------------
 1 file changed, 5 insertions(+), 16 deletions(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index c5d4aeb68404c9..81c01347cd24e6 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -365,18 +365,13 @@ static sector_t raid0_size(struct mddev *mddev, sector_t sectors, int raid_disks
 	return array_sectors;
 }
 
-static void free_conf(struct mddev *mddev, struct r0conf *conf)
-{
-	kfree(conf->strip_zone);
-	kfree(conf->devlist);
-	kfree(conf);
-}
-
 static void raid0_free(struct mddev *mddev, void *priv)
 {
 	struct r0conf *conf = priv;
 
-	free_conf(mddev, conf);
+	kfree(conf->strip_zone);
+	kfree(conf->devlist);
+	kfree(conf);
 }
 
 static int raid0_set_limits(struct mddev *mddev)
@@ -415,7 +410,7 @@ static int raid0_run(struct mddev *mddev)
 	if (!mddev_is_dm(mddev)) {
 		ret = raid0_set_limits(mddev);
 		if (ret)
-			goto out_free_conf;
+			return ret;
 	}
 
 	/* calculate array device size */
@@ -427,13 +422,7 @@ static int raid0_run(struct mddev *mddev)
 
 	dump_zones(mddev);
 
-	ret = md_integrity_register(mddev);
-	if (ret)
-		goto out_free_conf;
-	return 0;
-out_free_conf:
-	free_conf(mddev, conf);
-	return ret;
+	return md_integrity_register(mddev);
 }
 
 /*
-- 
2.43.0


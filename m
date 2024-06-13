Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 358301419AA;
	Thu, 13 Jun 2024 08:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718268538; cv=none; b=opbtkWvBTefyP0Mpq6jL4LYOjFH7s1mn5zQKiWKp6mwpoNOrIuHsXFq5tvHC21yGMGNwuijoR1H6dwa1RPTnEOiICzFQ0z5gF/yQaBSEo9fMgS4des1SJ8dzJBqkuvkPn+k9ZtKbBeZwlpkdPyQZRM8OvwrwhwKjt7Vr6hrBfnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718268538; c=relaxed/simple;
	bh=+BjGuLr/gI1Gue5e119TjF+mdnq/PomOY8egq7ncYII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r19v/C6UoyhfDpFwItI7lbuPN0mDVaDr6nkfWjiKme0RIfsoS9aa/LMpRTRmUYmBGESdYPvcQZZSj/Anj2W+D5mkhWEBWojfioBqAfbd2+lNXD5pfdhU9lePlthNzwuzhP0NBZ8+kEE8Om6Qhd05wZdhodjcjL7bDtsxIqHtX0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=5ELtCIzd; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="5ELtCIzd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=mKcyvM4r/2P84aZxmwMfKhF19qmlYUHCRYKugbswj8M=; b=5ELtCIzdPynKEeaB9S+3gwH71W
	uRLgl5l6+5E3kdFTLMN0ijMGlQkr8YZCZMCPTvND2vFNh0E/0EZsOyz6cN4Z7K+F8G65VIF5Mi6Jl
	NXcMgn046y08IE1GGU8nA/iE3A1Mm3Atpj5d9Va/2F1dVByHKHVmqZKGa1zjRWyyk7bDM4Gn2a3yd
	pBZhbvKoYtT/j0SssDzMkg4nHdLkZd6GLSplvObAFkC9Bwn1+R9l4IUM8DJpHeVhBTLeD2Of+PJou
	j4MChGJUw/Fiu8ukjaV4ehDnbIhUdEFGfT4LgiVbPT17KuTeWtkv45FWUZsREt9HFEpp/8ApWUkt1
	uWMDwVhw==;
Received: from 2a02-8389-2341-5b80-034b-6bc2-b258-c831.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:34b:6bc2:b258:c831] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sHg8Z-0000000Fn3n-0mAX;
	Thu, 13 Jun 2024 08:48:51 +0000
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
Subject: [PATCH 03/12] md/raid1: don't free conf on raid0_run failure
Date: Thu, 13 Jun 2024 10:48:13 +0200
Message-ID: <20240613084839.1044015-4-hch@lst.de>
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

Fixes: 07f1a6850c5d ("md/raid1: fail run raid1 array when active disk less than one")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/raid1.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 7b8a71ca66dde0..1f321826ef02ba 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -3204,7 +3204,6 @@ static int raid1_set_limits(struct mddev *mddev)
 	return queue_limits_set(mddev->gendisk->queue, &lim);
 }
 
-static void raid1_free(struct mddev *mddev, void *priv);
 static int raid1_run(struct mddev *mddev)
 {
 	struct r1conf *conf;
@@ -3238,7 +3237,7 @@ static int raid1_run(struct mddev *mddev)
 	if (!mddev_is_dm(mddev)) {
 		ret = raid1_set_limits(mddev);
 		if (ret)
-			goto abort;
+			return ret;
 	}
 
 	mddev->degraded = 0;
@@ -3252,8 +3251,7 @@ static int raid1_run(struct mddev *mddev)
 	 */
 	if (conf->raid_disks - mddev->degraded < 1) {
 		md_unregister_thread(mddev, &conf->thread);
-		ret = -EINVAL;
-		goto abort;
+		return -EINVAL;
 	}
 
 	if (conf->raid_disks - mddev->degraded == 1)
@@ -3277,14 +3275,8 @@ static int raid1_run(struct mddev *mddev)
 	md_set_array_sectors(mddev, raid1_size(mddev, 0, 0));
 
 	ret = md_integrity_register(mddev);
-	if (ret) {
+	if (ret)
 		md_unregister_thread(mddev, &mddev->thread);
-		goto abort;
-	}
-	return 0;
-
-abort:
-	raid1_free(mddev, conf);
 	return ret;
 }
 
-- 
2.43.0


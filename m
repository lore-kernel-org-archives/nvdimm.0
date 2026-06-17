Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 103823F6C4E;
	Wed, 17 Jun 2026 12:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781699128; cv=pass; b=MpVMNhC+T/voMTPMOjfL7oj8V+uePEl7CnN8J2+J/7RO9W1n1cVX3J30rYusab4V1B65Y5McQFrSDx5rcH5plDUoXZE8OsaUN8MU82IHAA8hfYt6M+XNyHb4KxKjOdtcHt3JK8U6neHBndUFhNdTAn8s8dIsE4Wu0mvXiesfjks=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781699128; c=relaxed/simple;
	bh=xYg6RdVJqxPfPqNbHgYFS2kPR0Urad+r7bj1Nya2jVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Deqrjl6vKq362Fv06vgOqlFVJry9/bqqvftR1aWhb/PrQEDPK0jt0s0eSwq3AlZMIccftnXwD1vHoocsVb7d3O3s/7r/zP68sfgwbSYuHZI9QG8rjE71SHHqK+CM8SwwnT42H+CANrAmIk3IvXtGXnUs4wDad3Bicy0oTRZuaeQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=VX4urOIx; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="VX4urOIx"
ARC-Seal: i=1; a=rsa-sha256; t=1781699110; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=LA75qyfW4Ajki05Jac1JrjmZkprSkEGv0NOtIVYsjQ+N0yjCTsWSTEH6A+4Hh3/Y9pLYadryGfgCG0KnqDJQCpzRAeE0qrplVQSuZj3VTT1/OnItO59KPIlacHrgFkFX0T4CxkazD1ND/b2+Bmc8Pts8yPGnMW65KLEiEEPzCbQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1781699110; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=NjlQz3w+nlvULsJXZpfBcVkikEpG5553MRXGN2Qhp8w=; 
	b=ch4GqeJ57ACxRt7161wrIuJxg8EV5yyBU+B/LiN9fRzy37ay5vR6hn5eHkbpAvzEP2xK5AnAnEyULoJXSIEWW9glov7dq1udWQ04wk8ZCl9DnLplnrLQtZEZum4r/OJNG45pg4b7rW0pmkmg2RuC6uWWp6y8+CW/xqBPl2m6yPU=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1781699110;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=NjlQz3w+nlvULsJXZpfBcVkikEpG5553MRXGN2Qhp8w=;
	b=VX4urOIxzKMGOhWXpF540eZlP54T9MjRvLcToAchSjY7sz+oGYVjD77CQCjduE7H
	xOl7725dD0nZbCLuRR2TAXk/+TdgXyjSicQTvYRpqzVWM33HeVn5kdtqA/liqNVPnSM
	xF1+MiRVYb66BUbPJdI+b8BAMB2YCGjXvL8zzM6I=
Received: by mx.zohomail.com with SMTPS id 1781699107540136.4106343353842;
	Wed, 17 Jun 2026 05:25:07 -0700 (PDT)
From: Li Chen <me@linux.beauty>
To: Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	virtualization@lists.linux.dev,
	nvdimm@lists.linux.dev
Cc: linux-kernel@vger.kernel.org,
	Li Chen <me@linux.beauty>
Subject: [PATCH v5 2/8] nvdimm: pmem: keep PREFLUSH before data writes
Date: Wed, 17 Jun 2026 20:24:34 +0800
Message-ID: <20260617122442.2118957-3-me@linux.beauty>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260617122442.2118957-1-me@linux.beauty>
References: <20260617122442.2118957-1-me@linux.beauty>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

pmem_submit_bio() records a REQ_PREFLUSH error, but continues to copy the
bio data and can later overwrite the error with a successful REQ_FUA flush.
That lets data writes run after a failed preflush and can complete the bio
successfully despite the failed ordering barrier.

Run the REQ_PREFLUSH flush synchronously before touching the bio data and
complete the bio with the flush error if it fails. Keep asynchronous flush
chaining for REQ_FUA. At that point, data copy has completed and the parent
bio can wait for the chained flush bio.

Signed-off-by: Li Chen <me@linux.beauty>
---
 drivers/nvdimm/pmem.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 92c67fbbc1c85..05d3de33e2706 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -208,8 +208,14 @@ static void pmem_submit_bio(struct bio *bio)
 	struct pmem_device *pmem = bio->bi_bdev->bd_disk->private_data;
 	struct nd_region *nd_region = to_region(pmem);
 
-	if (bio->bi_opf & REQ_PREFLUSH)
-		ret = nvdimm_flush(nd_region, bio);
+	if (bio->bi_opf & REQ_PREFLUSH) {
+		ret = nvdimm_flush(nd_region, NULL);
+		if (ret) {
+			bio->bi_status = errno_to_blk_status(ret);
+			bio_endio(bio);
+			return;
+		}
+	}
 
 	do_acct = blk_queue_io_stat(bio->bi_bdev->bd_disk->queue);
 	if (do_acct)
@@ -229,7 +235,7 @@ static void pmem_submit_bio(struct bio *bio)
 	if (do_acct)
 		bio_end_io_acct(bio, start);
 
-	if (bio->bi_opf & REQ_FUA)
+	if ((bio->bi_opf & REQ_FUA) && !bio->bi_status)
 		ret = nvdimm_flush(nd_region, bio);
 
 	if (ret)
-- 
2.52.0


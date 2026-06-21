Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1C15366052;
	Sun, 21 Jun 2026 13:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782047000; cv=pass; b=dyfk4FSMFHmH6T22eUKpHaKrf0oRc8CSAQWpPy0gNASyp1Mc29kt1CmtLYd/3YC5bQjWMSHt3P9vs+jzBbJA3yFmUUZE0YR5ECL2H0T9C92iJjv3mOjxZG6BxnxeakwuX+5iauesrC2Zv8JCOJ1k5eG9HSZBnfbo3ylUTQATaJ8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782047000; c=relaxed/simple;
	bh=yNGrEJlXC/3Kj2L50w8PBQwDVtyNG/aExJYIOATyaIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UVfCyJ1l48fYmU5DOFWtvHIxm5gYF42ywJHdJpC5Bsi+HoR8+/l4/8QyNWlx8jRH+pyPBZijqBMydWbfd2l5maPh2rNUlf0AOs24uyj/jCP2Vua9sCWTauwuMrYwfDaAX0maThNm7FIBYthPQJUbzWwOfvbmaD6V/b3RxNDGs8o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=Ky0hFX24; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="Ky0hFX24"
ARC-Seal: i=1; a=rsa-sha256; t=1782046992; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=UJVQ/eeoSQUxw+Rkm3csEyxOpJ4G20yx880ZLVfX8X1gcmPeR1Xhee3dSD80I28TUFz54zA5SIk4zRF9Mv5USJkhceX2hq5x6fENQu7T9hTxBUVKxmr4FI+qy6LFNhI9UeQIkX77h/wJ+vXk8ifN1leF8d7ZIOhSTA75uS4JT/s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1782046992; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=l+TairmX9egfA9LqMO7TzDhHCGZIpaTe4WqZKhyGKds=; 
	b=lAyelh7nWepCHQziXdcpBWwyxSg6WRfeddmhoDp4j9vuZ9X5jg65LB/a9v8aZ50KDeuGqsoAe0CxfJ+ehPSSbxD7RfmExzWWD7bXhcW7CDgHK2Zzvw/zXgoPdCu5gb1F8+9gftTIcZeca4i3I/8C1YXjZcFSGKynPEw1anNOR90=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1782046992;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=l+TairmX9egfA9LqMO7TzDhHCGZIpaTe4WqZKhyGKds=;
	b=Ky0hFX24OAgnKFHKLCuhmowMj4REFAr9ynAnCywtiNnitG1l+95Z+fW4xi79sNLn
	Q0sN4dpzoZ2KYYHSybuP0Gy3xIPgBdYt4cyniGu/XdMedQN5SUQK888EIZ1SvPoUrKk
	LFuzMPfg74n4Ik3PSdLWnSLE7fO7hvQaWewNSPBI=
Received: by mx.zohomail.com with SMTPS id 1782046989260929.7539967088986;
	Sun, 21 Jun 2026 06:03:09 -0700 (PDT)
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
Subject: [PATCH v6 02/12] nvdimm: pmem: keep PREFLUSH before data writes
Date: Sun, 21 Jun 2026 21:02:33 +0800
Message-ID: <20260621130246.2973254-3-me@linux.beauty>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260621130246.2973254-1-me@linux.beauty>
References: <20260621130246.2973254-1-me@linux.beauty>
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
Changes in v5:
- New patch.

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

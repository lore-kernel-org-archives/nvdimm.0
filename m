Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A9923EA962;
	Tue, 30 Jun 2026 09:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782811472; cv=pass; b=qns+R4demesUzgV86xL4eL71YtQqo7kS0/FLZf1wa0I06ZuHI72lqiotVh7UV7MlPPFMedc+jTYigFLBno02iqHkjg4DX/N0Jf89BVYnSujR755EtWqJ63K1PdKXmJFwhNHIEq7gizo3vVC7LQpNOge8PO+u+ua4oGa7fGAwIKM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782811472; c=relaxed/simple;
	bh=itjLrkKJEW81RURIxDECsGtTLBhbeI004y7GPmhHinc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WpIegWFUottgaqdRBbksqkuAzsI4qYTmXFB76YLWeUWG0HbbBnIm/KVFDEZJRrMVpCOrBwYyhryVu7+0lHJi2T89iWiiFTZNBRNvEypeBb8veeBFQdrYA/YXUcGjUPM8O8Qne1Z6ZcmHsvstBC0DGU+4CeqGFkEga2uHc401naQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=UnzDV7p9; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="UnzDV7p9"
ARC-Seal: i=1; a=rsa-sha256; t=1782811448; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=j0g2+QchVXmaHb562lqJQVpKMeZpGIYvRq6Zs8e0yBz6rip0qarIPQNwFZa7kb8CbdOzb9FWpDJOLPoHsDsVxexOrVn+GcYWjWlwIJy/YYBNqDU5oMIKoTpUz0Wl6wjxViMl3dvLtpNEWOG265SlihbtVDZ0pYSylyHZ5JLmd3I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1782811448; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=c0EOLBoih0cc+8cnP+Tzr7COxL+v2rD15YCFnpCQMeg=; 
	b=U10akDiquNs49nNkMvjna9rHYjAQuy03qw2ri7IqYmGVAkf/GWXD5nGfuXHjhD/MmXcT03iu+2Q17fSPOSVrJxDHfEx5KLP4GqtgMIPB+e9pV8I37pXGZPxhBY4/hMMEI9XBocIsMCwy78foBuiTsr6hI/GzhlHYkXVg8ZggRXw=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1782811447;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=c0EOLBoih0cc+8cnP+Tzr7COxL+v2rD15YCFnpCQMeg=;
	b=UnzDV7p9cs1YJdwVOZsKWXm36T5ni3GJnPgAJijWozTAtvtED6iMP90elKTtZIlE
	VpbE9PtQ3zXfmxtpa+PLvzVYEnlDatC7AkKF5RLJEwIaZKP8kJ1X8VXEBMQw9RsYx/t
	Og/tLAtLkHD1xIB+L+HHCbwv2QJFIxestlP9/OhM=
Received: by mx.zohomail.com with SMTPS id 1782811445296720.8994094732811;
	Tue, 30 Jun 2026 02:24:05 -0700 (PDT)
From: Li Chen <me@linux.beauty>
To: Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	virtualization@lists.linux.dev,
	nvdimm@lists.linux.dev
Cc: linux-kernel@vger.kernel.org,
	Li Chen <me@linux.beauty>
Subject: [PATCH v7 03/12] nvdimm: pmem: guard data loop for dataless bios
Date: Tue, 30 Jun 2026 17:23:28 +0800
Message-ID: <20260630092338.2094628-4-me@linux.beauty>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260630092338.2094628-1-me@linux.beauty>
References: <20260630092338.2094628-1-me@linux.beauty>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

pmem_submit_bio() handles flush-only bios before and after the data
loop. Keep dataless bios out of bio_for_each_segment() so the data path
only walks bios that actually carry bvec data.

Signed-off-by: Li Chen <me@linux.beauty>
---
Changes in v6:
- New patch.

 drivers/nvdimm/pmem.c | 36 +++++++++++++++++++++---------------
 1 file changed, 21 insertions(+), 15 deletions(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 05d3de33e2706..82ee1ddb3a445 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -217,23 +217,29 @@ static void pmem_submit_bio(struct bio *bio)
 		}
 	}
 
-	do_acct = blk_queue_io_stat(bio->bi_bdev->bd_disk->queue);
-	if (do_acct)
-		start = bio_start_io_acct(bio);
-	bio_for_each_segment(bvec, bio, iter) {
-		if (op_is_write(bio_op(bio)))
-			rc = pmem_do_write(pmem, bvec.bv_page, bvec.bv_offset,
-				iter.bi_sector, bvec.bv_len);
-		else
-			rc = pmem_do_read(pmem, bvec.bv_page, bvec.bv_offset,
-				iter.bi_sector, bvec.bv_len);
-		if (rc) {
-			bio->bi_status = rc;
-			break;
+	if (bio_has_data(bio)) {
+		do_acct = blk_queue_io_stat(bio->bi_bdev->bd_disk->queue);
+		if (do_acct)
+			start = bio_start_io_acct(bio);
+		bio_for_each_segment(bvec, bio, iter) {
+			if (op_is_write(bio_op(bio)))
+				rc = pmem_do_write(pmem, bvec.bv_page,
+						   bvec.bv_offset,
+						   iter.bi_sector,
+						   bvec.bv_len);
+			else
+				rc = pmem_do_read(pmem, bvec.bv_page,
+						  bvec.bv_offset,
+						  iter.bi_sector,
+						  bvec.bv_len);
+			if (rc) {
+				bio->bi_status = rc;
+				break;
+			}
 		}
+		if (do_acct)
+			bio_end_io_acct(bio, start);
 	}
-	if (do_acct)
-		bio_end_io_acct(bio, start);
 
 	if ((bio->bi_opf & REQ_FUA) && !bio->bi_status)
 		ret = nvdimm_flush(nd_region, bio);
-- 
2.52.0

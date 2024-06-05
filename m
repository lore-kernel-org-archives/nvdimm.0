Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E3D718F2DF;
	Wed,  5 Jun 2024 06:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717569064; cv=none; b=dfFUpP7x9m/1ZQS8N5w8duSAyx/df7ESmIDjev2lsGi5pSGxC7HUSMya/CZZZK5Is7/CKylf1+YKOpWemj1Utj8SdHCumeafYhd3E6G1iSfw4SqVkDUVSlmY8mG2c/Chu+xp5/u8AJIV3TsjNovJUCCWnsNrwmvVrLN+CnjGdDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717569064; c=relaxed/simple;
	bh=QKnlKtvCPMCYs2Aj1HKRJA+JkdjbhqH5PBvy8R8VJv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pg7k7NFoJn0553nm5DKQ1rrG/dF2AprPaP//+fAjllpGR+PpExi0+fZat5/72NbhDpER6iurJ96jsrrEKUdKT7+fmt8zUSwmRxRngSvV7Wi9bGUD+/EzEy7TrsSwjvhnf8cvSg8YqhM2Gg78NMT3zQ9yrPo8/L6KCj+rjJ+u9T4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=tlrjyPJJ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tlrjyPJJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=aJl7wp0u5LBKVaAXb9FrQp7PdLwwPnXgf+wQoRmK4Q8=; b=tlrjyPJJd92iaok5z7Q8KfP04Y
	NOu5dSS5Av5fExgGAFLkoDCbxXSEMHxcj217TNm6VEIty4QqpAQBx8nZ9cgx8iVvizyduPCuwO5Xs
	7YTBZZaVuy0HiR85vQQZKFonlqhgLU50EErzZ+T57Gi8zq1LUN+CuYY3P6fIakS/Tru0VPfl9+h9T
	Mk9+JTiSytn2Pg6eubIBtqA9evCM8BrV8u1iGXGQL+o3ziSFpzwUxL3Uf+XcdOxwG3lPkzjEgsERS
	EsNgQgIKtXxrnmNcjT7XyfGs9A/b2gu2mKstosG8WUrnU4pED3vG/0yvRKTBjxB3brU77cjsTHJu6
	VUgpjtvQ==;
Received: from 2a02-8389-2341-5b80-5bcb-678a-c0a8-08fe.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:5bcb:678a:c0a8:8fe] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sEkAk-00000004mj9-33wv;
	Wed, 05 Jun 2024 06:30:59 +0000
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
Subject: [PATCH 07/12] block: use kstrtoul in flag_store
Date: Wed,  5 Jun 2024 08:28:36 +0200
Message-ID: <20240605063031.3286655-8-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240605063031.3286655-1-hch@lst.de>
References: <20240605063031.3286655-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Use the text to integer helper that has error handling and doesn't modify
the input pointer.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-integrity.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/block/blk-integrity.c b/block/blk-integrity.c
index 686b6adf0ea5c7..bb3cd1e0eeb58e 100644
--- a/block/blk-integrity.c
+++ b/block/blk-integrity.c
@@ -245,8 +245,12 @@ static ssize_t flag_store(struct device *dev, struct device_attribute *attr,
 		const char *page, size_t count, unsigned char flag)
 {
 	struct blk_integrity *bi = dev_to_bi(dev);
-	char *p = (char *) page;
-	unsigned long val = simple_strtoul(p, &p, 10);
+	unsigned long val;
+	int err;
+
+	err = kstrtoul(page, 10, &val);
+	if (err)
+		return err;
 
 	if (val)
 		bi->flags |= flag;
-- 
2.43.0


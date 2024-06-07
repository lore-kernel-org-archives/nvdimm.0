Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 420701552E6;
	Fri,  7 Jun 2024 05:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717739990; cv=none; b=tMd6N6omp9bY6O009OcJo3eYbqpuGM0TNGtjdbHDIkNiXw/ECC1UDXDraYkE5ix5T4IzCzoWFD6U/37MrgIj/m6aE9L6LAjKzbRr6dkEl4jcFPbxPFCgbwkmyomv4gi3uRs5o3t6evzWYNlr40mv63YlJlfiuB9Bst9KlrRprfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717739990; c=relaxed/simple;
	bh=unlnV+CG5XjBHEC3u/giCHThOcMy/s2Tsig1F7iBUy8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cRlXktz3d5rSkWViGsFgdXobBMJUDcsaqul8Fp8ysLf+G14L0HeaP+QXCfR28ql0ZMbXuMVpA6jzUFNgi91usuyEX9oYng8tivThxJsId5alVnHLM0X/GM7Cpp65SDMWtaVTSaDWqQhwgA00V4oVlQkYpNCOFHpmpV1XGkyy8og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=wPD/S+1E; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="wPD/S+1E"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=NEvcTF83bXOZ23el9r2TCn477dSWKAC8oqWBmZ1SUxc=; b=wPD/S+1ERpv3xRaqWYRjMpTxJo
	W95gtHCkPi6N+LIhBtXBOK7ZQqSIUZ5tNUikRSfEfkDlm1Q140wgGwcG6EoRWq96yXaJCIt9RE8uf
	Jp4zrOn3WpG4hHNobDMSAvQcKTmmMXZQVwxCvevq/KYZan22mGNd7YQiwBhqGp+fSMm6aiVcIBkUV
	bTBifJ40IP5zPeQ+ScRvRaDlSmvyWtL8hU8tT4VHwOylhlUjo6S77MBhpuTLk6o4jjZLSVq6V/5w1
	No0utZRT19nW4jXdWYV6/8yZ4CDKHGcn3tRmkWT+QUXzjhdYdaWrUua++UMJTztQo/JDI72ZNgg1S
	LbdfaBRw==;
Received: from [2001:4bb8:2dd:aa7c:2c19:fa33:48d4:a32f] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sFSda-0000000Ca4f-0ktN;
	Fri, 07 Jun 2024 05:59:42 +0000
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
Subject: [PATCH 07/11] block: use kstrtoul in flag_store
Date: Fri,  7 Jun 2024 07:59:01 +0200
Message-ID: <20240607055912.3586772-8-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240607055912.3586772-1-hch@lst.de>
References: <20240607055912.3586772-1-hch@lst.de>
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
Reviewed-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
---
 block/blk-integrity.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/block/blk-integrity.c b/block/blk-integrity.c
index 24671d9f90a124..58760a6d6b2209 100644
--- a/block/blk-integrity.c
+++ b/block/blk-integrity.c
@@ -247,8 +247,12 @@ static ssize_t flag_store(struct device *dev, struct device_attribute *attr,
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


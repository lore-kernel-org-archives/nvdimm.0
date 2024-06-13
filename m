Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 405561428F2;
	Thu, 13 Jun 2024 08:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718268553; cv=none; b=aM0wvmDFdJGdgtNa2nYcuh6GdnVjRXRX2UjWAqDY9Hkci+XckUa1w4A9nRo713xWJtEZBm73iYlK619qb7IjiDVqMWEgO/U7MrhBV/FE8cG09yAJZVn22TfHZ9NSCcMR/mF/aE9gDtQ119TSyUt5Oz/Qqo81IcYE5rAAjt/E1JE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718268553; c=relaxed/simple;
	bh=FmtxdkCNtQTCGgmgxOQ9OCDaPcUZUNNpBwNIz/AnRsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VQogGAdGEFI3DpKG2zvI7dSeEFEaOCLQW1bMphrSFaJb9NJ3IjUz5Is0gS+MXGed7vAd8I6gYmPTgcASMhykJr2gQxMhm7c3DuINllVxpeVwLwnj0iZvqrpuKC2o+v/yCQBiyDfi7qZJhsretdRFDK667iyJvv/JkQr03M31+xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=VKrnBhos; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VKrnBhos"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=vQb3U/bV54yLHMnuTsiHBSf7xNhCnQOB1ATjVIIrVHA=; b=VKrnBhos1DKBvHoaiaVx8RihFq
	6zPgjLf40QnMS+mQvpy8bvG+IJzyi0Gw0Oy8SPPp9CX8AM8/ILHdy/cg9IUWQh2ZFIHG/UE7wGTu2
	OkNXcWcC4DPHUj0KFvkhn9AgqjJvhc3fEA9C12r1AjkWdicIZbApDJKJzBE0018I+VOWb6wZmwOQJ
	exC2X6ZyH/ahxeymL54tj2bn9VPzBoIDRs/QG2YZKYb8NbtRzG+hWKKOPXhjYb+occ4IqIuPcC0Ou
	eWIDG8zEZxiDOjvYlyh0/LY8laNx0Va+y5Z2wBark2Zhr0GxiigxSNxthoLvti/sTWBDXrD3NyZwK
	zx9ZBqaQ==;
Received: from 2a02-8389-2341-5b80-034b-6bc2-b258-c831.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:34b:6bc2:b258:c831] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sHg8n-0000000FnE8-07lW;
	Thu, 13 Jun 2024 08:49:05 +0000
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
	linux-scsi@vger.kernel.org,
	Hannes Reinecke <hare@suse.de>
Subject: [PATCH 08/12] block: use kstrtoul in flag_store
Date: Thu, 13 Jun 2024 10:48:18 +0200
Message-ID: <20240613084839.1044015-9-hch@lst.de>
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

Use the text to integer helper that has error handling and doesn't modify
the input pointer.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
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


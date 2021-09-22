Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37DD03FC8
	for <nvdimm@lists.linux.dev>; Wed, 22 Sep 2021 18:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=ohPa6Lwajw8vhCwLerBSIvFxJRh0fJUxeCrs38Mhz8E=; b=AoAgqjmDBM8Ozc0Y0/j389Ho37
	V/kjpHRoXAqWH9xHbnjCA+QjjKNja7sHT2nGxzyijpzbE4EfdEWHk2dk5VKWj+Bi1xdV9VxVR14lw
	P5jVLPjh57TRGlWFCGS5U5hGFsKf5OrRrVBT0LTdBNDIvWKKp+SHXa5OM+E/ZvCZmihYj2kC+8Wna
	Y6tvEbJpk9PiEit7SB+l9zMl/kUNGCGs3/ssop/dcizhUK8sLkIp5WxeoWhZnd3HS9ar4iAyi5hVi
	td73ncJ9LujZ/5K/iDO/16Hrts53cK2OvwnkG/XJ4dN0O+j09iusisHivozKuuBio6TQkqz+zg88c
	cUrHREGA==;
Received: from [2001:4bb8:184:72db:3a8e:1992:6715:6960] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mT74O-0052Ln-1r; Wed, 22 Sep 2021 18:34:25 +0000
From: Christoph Hellwig <hch@lst.de>
To: Dan Williams <dan.j.williams@intel.com>,
	Jens Axboe <axboe@kernel.dk>
Cc: Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	linux-block@vger.kernel.org,
	nvdimm@lists.linux.dev
Subject: [PATCH 1/3] nvdimm/pmem: fix creating the dax group
Date: Wed, 22 Sep 2021 20:33:29 +0200
Message-Id: <20210922183331.2455043-2-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210922183331.2455043-1-hch@lst.de>
References: <20210922183331.2455043-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html

The recent block layer refactoring broke the way how the pmem driver
abused device_add_disk.  Fix this by properly passing the attribute groups
to device_add_disk.

Fixes: 52b85909f85d ("block: fold register_disk into device_add_disk")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/pmem.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 72de88ff0d30d..ef4950f808326 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -380,7 +380,6 @@ static int pmem_attach_disk(struct device *dev,
 	struct nd_pfn_sb *pfn_sb;
 	struct pmem_device *pmem;
 	struct request_queue *q;
-	struct device *gendev;
 	struct gendisk *disk;
 	void *addr;
 	int rc;
@@ -489,10 +488,8 @@ static int pmem_attach_disk(struct device *dev,
 	}
 	dax_write_cache(dax_dev, nvdimm_has_cache(nd_region));
 	pmem->dax_dev = dax_dev;
-	gendev = disk_to_dev(disk);
-	gendev->groups = pmem_attribute_groups;
 
-	device_add_disk(dev, disk, NULL);
+	device_add_disk(dev, disk, pmem_attribute_groups);
 	if (devm_add_action_or_reset(dev, pmem_release_disk, pmem))
 		return -ENOMEM;
 
-- 
2.30.2


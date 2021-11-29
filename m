Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6443B2C8B
	for <nvdimm@lists.linux.dev>; Mon, 29 Nov 2021 10:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=EtUdF5ha7yqxEKuy3O5Q7OCQvEJW4CJkzYemIeRo6WA=; b=PdlpNBCuXiytsVQKYpLT7CRD2o
	vEQZzU8QZisqWnYNsF3U7RXEsM0okrG4lcJF2rqIbTMjOZGu/ePZRNhPIik+2y2KudRYX2MwutPYJ
	xptsVQsYDVCDiFsR+c0O/BkjvCKhGmyyjkOhf7g+/eptXbTBwyr/2JiLcOPf+v61JvE1IBi6BaPkR
	dlkaVJdcgkdaY1gmXlH9RB7XWWgNwMSqrXXt4b7gsTveo89MI8AxCoNUFny5gPGyJsCdUzA3Dcdjk
	ZHSV7cMfHvQk89MvdMwJlZj6DUfe5C1dXU9+z7SO1+2EAtkPF2BPCPGQWdo5WDb8QZgXzxW5LHaNz
	ULZl3aSw==;
Received: from [2001:4bb8:184:4a23:724a:c057:c7bf:4643] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mrdnT-0073JW-Re; Mon, 29 Nov 2021 10:22:08 +0000
From: Christoph Hellwig <hch@lst.de>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Mike Snitzer <snitzer@redhat.com>,
	Ira Weiny <ira.weiny@intel.com>,
	dm-devel@redhat.com,
	linux-xfs@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-s390@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-erofs@lists.ozlabs.org,
	linux-ext4@vger.kernel.org,
	virtualization@lists.linux-foundation.org
Subject: [PATCH 03/29] dax: remove CONFIG_DAX_DRIVER
Date: Mon, 29 Nov 2021 11:21:37 +0100
Message-Id: <20211129102203.2243509-4-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211129102203.2243509-1-hch@lst.de>
References: <20211129102203.2243509-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html

CONFIG_DAX_DRIVER only selects CONFIG_DAX now, so remove it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/Kconfig        | 4 ----
 drivers/nvdimm/Kconfig     | 2 +-
 drivers/s390/block/Kconfig | 2 +-
 fs/fuse/Kconfig            | 2 +-
 4 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/dax/Kconfig b/drivers/dax/Kconfig
index d2834c2cfa10d..954ab14ba7778 100644
--- a/drivers/dax/Kconfig
+++ b/drivers/dax/Kconfig
@@ -1,8 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0-only
-config DAX_DRIVER
-	select DAX
-	bool
-
 menuconfig DAX
 	tristate "DAX: direct access to differentiated memory"
 	select SRCU
diff --git a/drivers/nvdimm/Kconfig b/drivers/nvdimm/Kconfig
index b7d1eb38b27d4..347fe7afa5830 100644
--- a/drivers/nvdimm/Kconfig
+++ b/drivers/nvdimm/Kconfig
@@ -22,7 +22,7 @@ if LIBNVDIMM
 config BLK_DEV_PMEM
 	tristate "PMEM: Persistent memory block device support"
 	default LIBNVDIMM
-	select DAX_DRIVER
+	select DAX
 	select ND_BTT if BTT
 	select ND_PFN if NVDIMM_PFN
 	help
diff --git a/drivers/s390/block/Kconfig b/drivers/s390/block/Kconfig
index d0416dbd0cd81..e3710a762abae 100644
--- a/drivers/s390/block/Kconfig
+++ b/drivers/s390/block/Kconfig
@@ -5,7 +5,7 @@ comment "S/390 block device drivers"
 config DCSSBLK
 	def_tristate m
 	select FS_DAX_LIMITED
-	select DAX_DRIVER
+	select DAX
 	prompt "DCSSBLK support"
 	depends on S390 && BLOCK
 	help
diff --git a/fs/fuse/Kconfig b/fs/fuse/Kconfig
index 40ce9a1c12e5d..038ed0b9aaa5d 100644
--- a/fs/fuse/Kconfig
+++ b/fs/fuse/Kconfig
@@ -45,7 +45,7 @@ config FUSE_DAX
 	select INTERVAL_TREE
 	depends on VIRTIO_FS
 	depends on FS_DAX
-	depends on DAX_DRIVER
+	depends on DAX
 	help
 	  This allows bypassing guest page cache and allows mapping host page
 	  cache directly in guest address space.
-- 
2.30.2


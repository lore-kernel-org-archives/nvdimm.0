Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <54F844B3.9050303@plexistor.com>
Date: Thu, 05 Mar 2015 13:57:39 +0200
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: [PATCH 4/8] pmem: Add support for direct_access()
References: <54F82CE0.4040502@plexistor.com> <54F830D4.7030205@plexistor.com>
In-Reply-To: <54F830D4.7030205@plexistor.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@redhat.com>, x86@kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, "Roger C. Pao" <rcpao.enmotus@gmail.com>, Dan Williams <dan.j.williams@intel.com>, Thomas Gleixner <tglx@linutronix.de>, linux-nvdimm <linux-nvdimm@lists.01.org>, "H. Peter Anvin" <hpa@zytor.com>, Matthew Wilcox <willy@linux.intel.com>, Andy Lutomirski <luto@amacapital.net>, Christoph Hellwig <hch@infradead.org>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

From: Ross Zwisler <ross.zwisler@linux.intel.com>

Also fixed a top the initial version
[boaz]
  SQUASHME pmem: Micro optimization the hotpath 002

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Boaz Harrosh <boaz@plexistor.com>
---
 drivers/block/pmem.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/block/pmem.c b/drivers/block/pmem.c
index 750ffdf..f0f0ba0 100644
--- a/drivers/block/pmem.c
+++ b/drivers/block/pmem.c
@@ -111,9 +111,25 @@ static int pmem_rw_page(struct block_device *bdev, sector_t sector,
 	return 0;
 }
 
+static long pmem_direct_access(struct block_device *bdev, sector_t sector,
+			      void **kaddr, unsigned long *pfn, long size)
+{
+	struct pmem_device *pmem = bdev->bd_disk->private_data;
+	size_t offset = sector << 9;
+
+	if (unlikely(!pmem))
+		return -ENODEV;
+
+	*kaddr = pmem->virt_addr + offset;
+	*pfn = (pmem->phys_addr + offset) >> PAGE_SHIFT;
+
+	return pmem->size - offset;
+}
+
 static const struct block_device_operations pmem_fops = {
 	.owner =		THIS_MODULE,
 	.rw_page =		pmem_rw_page,
+	.direct_access =	pmem_direct_access,
 };
 
 /* Kernel module stuff */
-- 
1.9.3


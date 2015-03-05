Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <54F84474.6010507@plexistor.com>
Date: Thu, 05 Mar 2015 13:56:36 +0200
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: [PATCH 3/8] pmem: Add support for rw_page()
References: <54F82CE0.4040502@plexistor.com> <54F830D4.7030205@plexistor.com>
In-Reply-To: <54F830D4.7030205@plexistor.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@redhat.com>, x86@kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, "Roger C. Pao" <rcpao.enmotus@gmail.com>, Dan Williams <dan.j.williams@intel.com>, Thomas Gleixner <tglx@linutronix.de>, linux-nvdimm <linux-nvdimm@lists.01.org>, "H. Peter Anvin" <hpa@zytor.com>, Matthew Wilcox <willy@linux.intel.com>, Andy Lutomirski <luto@amacapital.net>, Christoph Hellwig <hch@infradead.org>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

From: Ross Zwisler <ross.zwisler@linux.intel.com>

Based on commit a72132c31d58 ("brd: add support for rw_page()")

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 drivers/block/pmem.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/block/pmem.c b/drivers/block/pmem.c
index bba53af..750ffdf 100644
--- a/drivers/block/pmem.c
+++ b/drivers/block/pmem.c
@@ -101,8 +101,19 @@ out:
 	bio_endio(bio, err);
 }
 
+static int pmem_rw_page(struct block_device *bdev, sector_t sector,
+		       struct page *page, int rw)
+{
+	struct pmem_device *pmem = bdev->bd_disk->private_data;
+
+	pmem_do_bvec(pmem, page, PAGE_CACHE_SIZE, 0, rw, sector);
+	page_endio(page, rw & WRITE, 0);
+	return 0;
+}
+
 static const struct block_device_operations pmem_fops = {
 	.owner =		THIS_MODULE,
+	.rw_page =		pmem_rw_page,
 };
 
 /* Kernel module stuff */
-- 
1.9.3


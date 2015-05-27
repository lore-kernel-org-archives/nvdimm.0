Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v4 10/21] pmem: Dynamically allocate partition numbers
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 27 May 2015 18:25:37 -0400
Message-ID: <20150527222536.17965.84039.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150527210155.17965.74864.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150527210155.17965.74864.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: sfr@canb.auug.org.au, akpm@linux-foundation.org, linux-nvdimm@lists.01.org, neilb@suse.de, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, mingo@kernel.org, linux-acpi@vger.kernel.org, jmoyer@redhat.com, Ross Zwisler <ross.zwisler@linux.intel.com>, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

From: Ross Zwisler <ross.zwisler@linux.intel.com>

Dynamically allocate minor numbers for partitions instead of statically
preallocating them.

It gives us a simpler minors scheme, and makes it so we get a consistent
major when moving past partition 16.  Here's what happens with the
current code:

 pmem0      249:0    0 63.5G  0 rom
 ├─pmem0p1  249:1    0    1G  0 part
 ├─pmem0p2  249:2    0    1G  0 part
 ├─pmem0p3  249:3    0    1G  0 part
 ├─pmem0p4  249:4    0    1G  0 part
 ├─pmem0p5  249:5    0    1G  0 part
 ├─pmem0p6  249:6    0    1G  0 part
 ├─pmem0p7  249:7    0    1G  0 part
 ├─pmem0p8  249:8    0    1G  0 part
 ├─pmem0p9  249:9    0    1G  0 part
 ├─pmem0p10 249:10   0    1G  0 part
 ├─pmem0p11 249:11   0    1G  0 part
 ├─pmem0p12 249:12   0    1G  0 part
 ├─pmem0p13 249:13   0    1G  0 part
 ├─pmem0p14 249:14   0    1G  0 part
 ├─pmem0p15 249:15   0    1G  0 part
 ├─pmem0p16 259:0    0    1G  0 part
 ├─pmem0p17 259:1    0    1G  0 part
 └─pmem0p18 259:2    0    1G  0 part

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/block/nd/pmem.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/block/nd/pmem.c b/drivers/block/nd/pmem.c
index cf5d53eda9e5..0842d27ffc8d 100644
--- a/drivers/block/nd/pmem.c
+++ b/drivers/block/nd/pmem.c
@@ -26,8 +26,6 @@
 #include <linux/nd.h>
 #include "nd.h"
 
-#define PMEM_MINORS		16
-
 struct pmem_device {
 	struct request_queue	*pmem_queue;
 	struct gendisk		*pmem_disk;
@@ -156,12 +154,12 @@ static struct pmem_device *pmem_alloc(struct device *dev, struct resource *res,
 	blk_queue_max_hw_sectors(pmem->pmem_queue, 1024);
 	blk_queue_bounce_limit(pmem->pmem_queue, BLK_BOUNCE_ANY);
 
-	disk = alloc_disk(PMEM_MINORS);
+	disk = alloc_disk(0);
 	if (!disk)
 		goto out_free_queue;
 
 	disk->major		= pmem_major;
-	disk->first_minor	= PMEM_MINORS * id;
+	disk->first_minor	= 0;
 	disk->fops		= &pmem_fops;
 	disk->private_data	= pmem;
 	disk->queue		= pmem->pmem_queue;


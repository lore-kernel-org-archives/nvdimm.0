Return-Path: <linux-fsdevel-owner@vger.kernel.org>
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 2/4] pmem: Add support for getgeo()
Date: Wed, 27 Aug 2014 15:12:00 -0600
Message-Id: <1409173922-7484-3-git-send-email-ross.zwisler@linux.intel.com>
In-Reply-To: <1409173922-7484-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1409173922-7484-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Matthew Wilcox <matthew.r.wilcox@intel.com>, Boaz Harrosh <boaz@plexistor.com>, Nick Piggin <npiggin@kernel.dk>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

Some programs require HDIO_GETGEO work, which requires we implement
getgeo.  Based off of the work done to the NVMe driver in this commit:

commit 4cc09e2dc4cb ("NVMe: Add getgeo to block ops")

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 drivers/block/pmem.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/block/pmem.c b/drivers/block/pmem.c
index d366b9b..60bbe0d 100644
--- a/drivers/block/pmem.c
+++ b/drivers/block/pmem.c
@@ -50,6 +50,15 @@ struct pmem_device {
 	size_t			size;
 };
 
+static int pmem_getgeo(struct block_device *bd, struct hd_geometry *geo)
+{
+	/* some standard values */
+	geo->heads = 1 << 6;
+	geo->sectors = 1 << 5;
+	geo->cylinders = get_capacity(bd->bd_disk) >> 11;
+	return 0;
+}
+
 /*
  * direct translation from (pmem,sector) => void*
  * We do not require that sector be page aligned.
@@ -176,6 +185,7 @@ out:
 
 static const struct block_device_operations pmem_fops = {
 	.owner =		THIS_MODULE,
+	.getgeo =		pmem_getgeo,
 };
 
 /* Kernel module stuff */
-- 
1.9.3


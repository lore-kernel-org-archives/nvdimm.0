Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EBD42C87
	for <nvdimm@lists.linux.dev>; Wed, 27 Oct 2021 12:09:43 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10149"; a="290980277"
X-IronPort-AV: E=Sophos;i="5.87,186,1631602800"; 
   d="scan'208";a="290980277"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2021 05:09:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,186,1631602800"; 
   d="scan'208";a="486649998"
Received: from dev01.bj.intel.com ([10.238.158.57])
  by orsmga007.jf.intel.com with ESMTP; 27 Oct 2021 05:09:40 -0700
From: Huaisheng Ye <huaisheng.ye@intel.com>
To: dan.j.williams@intel.com,
	hch@lst.de,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	ira.weiny@intel.com
Cc: nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Huaisheng Ye <huaisheng.ye@intel.com>
Subject: [PATCH 1/4] libnvdimm: add a ro state control function for nvdimm
Date: Wed, 27 Oct 2021 20:09:34 +0800
Message-Id: <20211027120937.1163744-2-huaisheng.ye@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211027120937.1163744-1-huaisheng.ye@intel.com>
References: <20211027120937.1163744-1-huaisheng.ye@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

libndctl failed to pass when writing pmem disk.
Here is the error message below,

    namespace6.0: failed to write /dev/pmem6
    check_namespaces: namespace6.0 validate_bdev failed
    ndctl-test1 failed: -6

Commit 98f49b63e84d4ee1a5c327d0b5f4e8699f6c70fe removes set_device_ro and
e00adcadf3af7a8335026d71ab9f0e0a922191ac adds a new set_read_only method
to allow for driver-specific processing when changing the block device's
read-only state.

Current drivers nd_pmem, nd_blk and nd_btt don't have the capability to
enable or disable write protect (read-only) state. Without that,
blkdev_roset just modifies the value of bd_read_only of struct block_device
and returns success to ioctl of block device. Error would happen when writing
read-only disk next.

Add ro state control function in libnvdimm for this purpose.

Signed-off-by: Huaisheng Ye <huaisheng.ye@intel.com>
---
 drivers/nvdimm/bus.c | 17 +++++++++++++++++
 drivers/nvdimm/nd.h  |  1 +
 2 files changed, 18 insertions(+)

diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index 9dc7f3edd42b..299dd5e11ae7 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -636,6 +636,23 @@ void nvdimm_check_and_set_ro(struct gendisk *disk)
 }
 EXPORT_SYMBOL(nvdimm_check_and_set_ro);
 
+int nd_set_ro(struct block_device *bdev, bool ro)
+{
+	struct gendisk *disk = bdev->bd_disk;
+	struct device *dev = disk_to_dev(disk)->parent;
+	int disk_ro = get_disk_ro(disk);
+
+	/* nothing to change with ro state */
+	if (disk_ro == ro)
+		return 0;
+
+	dev_info(dev, "set %s to read-%s\n",
+		 disk->disk_name, ro ? "only" : "write");
+	set_disk_ro(disk, ro);
+	return 0;
+}
+EXPORT_SYMBOL(nd_set_ro);
+
 static ssize_t modalias_show(struct device *dev, struct device_attribute *attr,
 		char *buf)
 {
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index 5467ebbb4a6b..f1cf3eb21292 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -512,6 +512,7 @@ void nvdimm_bus_lock(struct device *dev);
 void nvdimm_bus_unlock(struct device *dev);
 bool is_nvdimm_bus_locked(struct device *dev);
 void nvdimm_check_and_set_ro(struct gendisk *disk);
+int nd_set_ro(struct block_device *bdev, bool ro);
 void nvdimm_drvdata_release(struct kref *kref);
 void put_ndd(struct nvdimm_drvdata *ndd);
 int nd_label_reserve_dpa(struct nvdimm_drvdata *ndd);
-- 
2.27.0


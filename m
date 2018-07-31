Return-Path: <linux-kernel-owner@vger.kernel.org>
From: oceanhe@zoho.com.cn
Subject: [PATCH] libnvdimm, bus: check if type of nd_device_driver within valid scope
Date: Tue, 31 Jul 2018 08:02:32 -0400
Message-Id: <1533038552-6195-1-git-send-email-oceanhe@zoho.com.cn>
Sender: linux-kernel-owner@vger.kernel.org
To: dan.j.williams@intel.com, zwisler@kernel.org, vishal.l.verma@intel.com, dave.jiang@intel.com
Cc: linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, Ocean He <hehy1@lenovo.com>
List-ID: <linux-nvdimm@lists.01.org>

From: Ocean He <hehy1@lenovo.com>

According to enum nd_driver_flags, the valid type of nd_device_driver
start from 0x02 and end up with 0x80. Both 0x00 and 0x01 are invalid, and
the value larger than 0x80 is invalid.

To filter valid type, ND_DRIVER_FLAGS_MASK is defined as
(((ND_DRIVER_FLAGS_MAX) << 1) - 2). For example, when ND_DRIVER_FLAGS_MAX
equals to ND_DRIVER_DAX_PMEM(0x80), then ND_DRIVER_FLAGS_MASK equals
to 0xFE.

Signed-off-by: Ocean He <hehy1@lenovo.com>
---
 drivers/nvdimm/bus.c       | 2 +-
 include/uapi/linux/ndctl.h | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index 27902a8..ec8cf4b 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -546,7 +546,7 @@ int __nd_driver_register(struct nd_device_driver *nd_drv, struct module *owner,
 {
 	struct device_driver *drv = &nd_drv->drv;
 
-	if (!nd_drv->type) {
+	if (!(nd_drv->type & ND_DRIVER_FLAGS_MASK)) {
 		pr_debug("driver type bitmask not set (%pf)\n",
 				__builtin_return_address(0));
 		return -EINVAL;
diff --git a/include/uapi/linux/ndctl.h b/include/uapi/linux/ndctl.h
index 7e27070..2a1ce06 100644
--- a/include/uapi/linux/ndctl.h
+++ b/include/uapi/linux/ndctl.h
@@ -207,6 +207,8 @@ enum nd_driver_flags {
 	ND_DRIVER_NAMESPACE_BLK   = 1 << ND_DEVICE_NAMESPACE_BLK,
 	ND_DRIVER_DAX_PMEM	  = 1 << ND_DEVICE_DAX_PMEM,
 };
+#define ND_DRIVER_FLAGS_MAX	ND_DRIVER_DAX_PMEM
+#define ND_DRIVER_FLAGS_MASK	(((ND_DRIVER_FLAGS_MAX) << 1) - 2)
 
 enum {
 	ND_MIN_NAMESPACE_SIZE = PAGE_SIZE,
-- 
1.8.3.1

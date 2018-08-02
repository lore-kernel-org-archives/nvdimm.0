Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-qt0-x242.google.com (mail-qt0-x242.google.com
 [IPv6:2607:f8b0:400d:c0d::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C1B6C210C2D81
 for <linux-nvdimm@lists.01.org>; Thu,  2 Aug 2018 01:19:45 -0700 (PDT)
Received: by mail-qt0-x242.google.com with SMTP id m13-v6so1403382qth.1
 for <linux-nvdimm@lists.01.org>; Thu, 02 Aug 2018 01:19:45 -0700 (PDT)
From: oceanhehy@gmail.com
Subject: [PATCH v2] libnvdimm,
 bus: check if type of nd_device_driver within valid scope
Date: Thu,  2 Aug 2018 04:19:36 -0400
Message-Id: <1533197976-27391-1-git-send-email-oceanhehy@gmail.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: dan.j.williams@intel.com, zwisler@kernel.org, vishal.l.verma@intel.com, dave.jiang@intel.com
Cc: Ocean He <hehy1@lenovo.com>, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
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
v1: https://www.spinics.net/lists/kernel/msg2869760.html
v2: Sorry for noise. I got an email problem, so I have to resend to loop 
linux-nvdimm@lists.01.org.

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

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

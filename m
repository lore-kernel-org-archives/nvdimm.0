Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by ml01.01.org (Postfix) with ESMTP id E5C5E202E2D61
 for <linux-nvdimm@lists.01.org>; Fri, 16 Aug 2019 04:20:49 -0700 (PDT)
From: Jia He <justin.he@arm.com>
Subject: [PATCH 2/2] drivers/dax/kmem: give a warning if
 CONFIG_DEV_DAX_PMEM_COMPAT is enabled
Date: Fri, 16 Aug 2019 19:18:44 +0800
Message-Id: <20190816111844.87442-3-justin.he@arm.com>
In-Reply-To: <20190816111844.87442-1-justin.he@arm.com>
References: <20190816111844.87442-1-justin.he@arm.com>
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
To: Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>
Cc: Jia He <justin.he@arm.com>, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

commit c221c0b0308f ("device-dax: "Hotplug" persistent memory for use
like normal RAM") helps to add persistent memory as normal RAM blocks.
But this driver doesn't work if CONFIG_DEV_DAX_PMEM_COMPAT is enabled.

Here is the debugging call trace when CONFIG_DEV_DAX_PMEM_COMPAT is
enabled.
[    4.443730]  devm_memremap_pages+0x4b9/0x540
[    4.443733]  dev_dax_probe+0x112/0x220 [device_dax]
[    4.443735]  dax_pmem_compat_probe+0x58/0x92 [dax_pmem_compat]
[    4.443737]  nvdimm_bus_probe+0x6b/0x150
[    4.443739]  really_probe+0xf5/0x3d0
[    4.443740]  driver_probe_device+0x11b/0x130
[    4.443741]  device_driver_attach+0x58/0x60
[    4.443742]  __driver_attach+0xa3/0x140

Then the dax0.0 device will be registered as "nd" bus instead of
"dax" bus. This causes the error as follows:
root@ubuntu:~# echo dax0.0 > /sys/bus/dax/drivers/device_dax/unbind
-bash: echo: write error: No such device

This gives a warning to notify the user.

Signed-off-by: Jia He <justin.he@arm.com>
---
 drivers/dax/kmem.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index ad62d551d94e..b77f0e880598 100644
--- a/drivers/dax/kmem.c
+++ b/drivers/dax/kmem.c
@@ -93,6 +93,11 @@ static struct dax_device_driver device_dax_kmem_driver = {
 
 static int __init dax_kmem_init(void)
 {
+	if (IS_ENABLED(CONFIG_DEV_DAX_PMEM_COMPAT)) {
+		pr_warn("CONFIG_DEV_DAX_PMEM_COMPAT is not compatible\n");
+		pr_warn("kmem dax driver might not be workable\n");
+	}
+
 	return dax_driver_register(&device_dax_kmem_driver);
 }
 
-- 
2.17.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

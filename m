Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0ECF021E49038
 for <linux-nvdimm@lists.01.org>; Wed, 14 Mar 2018 11:19:28 -0700 (PDT)
From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH 1/3] libnvdimm: provide module_nd_driver wrapper
Date: Wed, 14 Mar 2018 19:25:06 +0100
Message-Id: <20180314182508.10351-2-jthumshirn@suse.de>
In-Reply-To: <20180314182508.10351-1-jthumshirn@suse.de>
References: <20180314182508.10351-1-jthumshirn@suse.de>
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
To: Dan Williams <dan.j.williams@intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux NV-DIMM Mailing List <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Provide a module_nd_driver() wrapper over simple nd_driver_register()
nd_driver_unregister() combinations in module_init() and module_exit()
respectively.

Note an explicit nd_driver_unregister() had to be implemented as nd
bus drivers did call device_unregister() direcly in the module_exit()
function.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 include/linux/nd.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/linux/nd.h b/include/linux/nd.h
index 5dc6b695437d..43c181a6add5 100644
--- a/include/linux/nd.h
+++ b/include/linux/nd.h
@@ -180,6 +180,12 @@ struct nd_region;
 void nvdimm_region_notify(struct nd_region *nd_region, enum nvdimm_event event);
 int __must_check __nd_driver_register(struct nd_device_driver *nd_drv,
 		struct module *module, const char *mod_name);
+static inline void nd_driver_unregister(struct nd_device_driver *drv)
+{
+	driver_unregister(&drv->drv);
+}
 #define nd_driver_register(driver) \
 	__nd_driver_register(driver, THIS_MODULE, KBUILD_MODNAME)
+#define module_nd_driver(driver) \
+	module_driver(driver, nd_driver_register, nd_driver_unregister)
 #endif /* __LINUX_ND_H__ */
-- 
2.13.6

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

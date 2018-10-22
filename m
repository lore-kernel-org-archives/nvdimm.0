Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CF72A2117CEB1
 for <linux-nvdimm@lists.01.org>; Mon, 22 Oct 2018 13:18:42 -0700 (PDT)
Subject: [PATCH 4/9] dax/kmem: allow PMEM devices to bind to KMEM driver
From: Dave Hansen <dave.hansen@linux.intel.com>
Date: Mon, 22 Oct 2018 13:13:24 -0700
References: <20181022201317.8558C1D8@viggo.jf.intel.com>
In-Reply-To: <20181022201317.8558C1D8@viggo.jf.intel.com>
Message-Id: <20181022201324.EBB64302@viggo.jf.intel.com>
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
To: linux-kernel@vger.kernel.org
Cc: thomas.lendacky@amd.com, mhocko@suse.com, linux-nvdimm@lists.01.org, Dave Hansen <dave.hansen@linux.intel.com>, ying.huang@intel.com, linux-mm@kvack.org, zwisler@kernel.org, fengguang.wu@intel.com, akpm@linux-foundation.org
List-ID: <linux-nvdimm@lists.01.org>


Currently, a persistent memory device's mode must be coordinated
with the driver to which it needs to bind.  To change it from the
fsdax to the device-dax driver, you first change the mode of the
device itself.

Instead of adding a new device mode, allow the PMEM mode to also
bind to the KMEM driver.

As I write this, I'm realizing that it might have just been
better to add a new device mode, rather than hijacking the PMEM
eode.  If this is the case, please speak up, NVDIMM folks.  :)

Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Ross Zwisler <zwisler@kernel.org>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: linux-nvdimm@lists.01.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: Huang Ying <ying.huang@intel.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>

---

 b/drivers/nvdimm/bus.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff -puN drivers/nvdimm/bus.c~dax-kmem-try-again-2018-3-bus-match-override drivers/nvdimm/bus.c
--- a/drivers/nvdimm/bus.c~dax-kmem-try-again-2018-3-bus-match-override	2018-10-22 13:12:22.522930391 -0700
+++ b/drivers/nvdimm/bus.c	2018-10-22 13:12:22.525930391 -0700
@@ -464,11 +464,24 @@ static struct nd_device_driver nd_bus_dr
 static int nvdimm_bus_match(struct device *dev, struct device_driver *drv)
 {
 	struct nd_device_driver *nd_drv = to_nd_device_driver(drv);
+	bool match;
 
 	if (is_nvdimm_bus(dev) && nd_drv == &nd_bus_driver)
 		return true;
 
-	return !!test_bit(to_nd_device_type(dev), &nd_drv->type);
+	match = !!test_bit(to_nd_device_type(dev), &nd_drv->type);
+
+	/*
+	 * We allow PMEM devices to be bound to the KMEM driver.
+	 * Force a match if we detect a PMEM device type but
+	 * a KMEM device driver.
+	 */
+	if (!match &&
+	    (to_nd_device_type(dev) == ND_DEVICE_DAX_PMEM) &&
+	    (nd_drv->type == ND_DRIVER_DAX_KMEM))
+		match = true;
+
+	return match;
 }
 
 static ASYNC_DOMAIN_EXCLUSIVE(nd_async_domain);
_
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99A438484
	for <nvdimm@lists.linux.dev>; Sat,  3 Jun 2023 06:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685772835; x=1717308835;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2Sru+PZzAiBMACd6GX9GYf+KilWjQZ3NHiyt4Y0GtYg=;
  b=BuniVuKSisyvzWGICTTpdgx89tYWlehowUPtBrMowmjjecg1B5J/8Jli
   9jwk03V1n8AkA9AL3DiBWMvXSwAR0k0oUcz8rmw8ENqhwZ3LJWqlScPID
   ycEJWlTX2fjXzCpqyy5nKPjSk1tbptSFf5Ilcgqht5ucJKfcoEk1tQk7C
   CLAS8IcwSPVOmeJMDTBOKeTLSTkgKzFd3DgSxiBKN9XauC0wByhjavqUN
   UM4NX4LdMKYqwOs1//Z+AcDsjCNc9jKfX8LrDC60bT+OABHZ9YHHvrFlU
   YheoqyK2N58I2xsoqQ7ywCiUsdZqRZmDtyKROdSx9tYVbugeScFdMHc/v
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10729"; a="442417594"
X-IronPort-AV: E=Sophos;i="6.00,215,1681196400"; 
   d="scan'208";a="442417594"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2023 23:13:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10729"; a="711211563"
X-IronPort-AV: E=Sophos;i="6.00,215,1681196400"; 
   d="scan'208";a="711211563"
Received: from rjkoval-mobl.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.212.230.247])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2023 23:13:54 -0700
Subject: [PATCH 1/4] dax: Fix dax_mapping_release() use after free
From: Dan Williams <dan.j.williams@intel.com>
To: nvdimm@lists.linux.dev
Cc: linux-cxl@vger.kernel.org
Date: Fri, 02 Jun 2023 23:13:54 -0700
Message-ID: <168577283412.1672036.16111545266174261446.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <168577282846.1672036.13848242151310480001.stgit@dwillia2-xfh.jf.intel.com>
References: <168577282846.1672036.13848242151310480001.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

A CONFIG_DEBUG_KOBJECT_RELEASE test of removing a device-dax region
provider (like modprobe -r dax_hmem) yields:

 kobject: 'mapping0' (ffff93eb460e8800): kobject_release, parent 0000000000000000 (delayed 2000)
 [..]
 DEBUG_LOCKS_WARN_ON(1)
 WARNING: CPU: 23 PID: 282 at kernel/locking/lockdep.c:232 __lock_acquire+0x9fc/0x2260
 [..]
 RIP: 0010:__lock_acquire+0x9fc/0x2260
 [..]
 Call Trace:
  <TASK>
 [..]
  lock_acquire+0xd4/0x2c0
  ? ida_free+0x62/0x130
  _raw_spin_lock_irqsave+0x47/0x70
  ? ida_free+0x62/0x130
  ida_free+0x62/0x130
  dax_mapping_release+0x1f/0x30
  device_release+0x36/0x90
  kobject_delayed_cleanup+0x46/0x150

Due to attempting ida_free() on an ida object that has already been
freed. Devices typically only hold a reference on their parent while
registered. If a child needs a parent object to complete its release it
needs to hold a reference that it drops from its release callback.
Arrange for a dax_mapping to pin its parent dev_dax instance until
dax_mapping_release().

Fixes: 0b07ce872a9e ("device-dax: introduce 'mapping' devices")
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/bus.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index 227800053309..aee695f86b44 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -635,10 +635,12 @@ EXPORT_SYMBOL_GPL(alloc_dax_region);
 static void dax_mapping_release(struct device *dev)
 {
 	struct dax_mapping *mapping = to_dax_mapping(dev);
-	struct dev_dax *dev_dax = to_dev_dax(dev->parent);
+	struct device *parent = dev->parent;
+	struct dev_dax *dev_dax = to_dev_dax(parent);
 
 	ida_free(&dev_dax->ida, mapping->id);
 	kfree(mapping);
+	put_device(parent);
 }
 
 static void unregister_dax_mapping(void *data)
@@ -778,6 +780,7 @@ static int devm_register_dax_mapping(struct dev_dax *dev_dax, int range_id)
 	dev = &mapping->dev;
 	device_initialize(dev);
 	dev->parent = &dev_dax->dev;
+	get_device(dev->parent);
 	dev->type = &dax_mapping_type;
 	dev_set_name(dev, "mapping%d", mapping->id);
 	rc = device_add(dev);


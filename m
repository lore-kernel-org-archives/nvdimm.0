Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63AF92CA5
	for <nvdimm@lists.linux.dev>; Tue, 14 Feb 2023 21:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676410906; x=1707946906;
  h=subject:from:to:cc:date:message-id:mime-version:
   content-transfer-encoding;
  bh=VmvWynx/DS4JgHhcma2OQyB9hsnf2YHZTnsJ/MsAltI=;
  b=jrQ77xBiGsm3VLM3kZnpDVZaIThU2DOUoLPv7g9A7OJjNvD6pEd3Szn6
   Q7jP9XOH4jCRczRh5Ci99+h/gch4Dul08WAsfs1dEPp5niLmgIUSNlyx9
   fbPC8JlEsTYgWazcq/b4UFHCd1zHyC+Vt7pSLNV0huwriqJHvTBer2qES
   C//3G6AYZoRM5wJ+BxmAX5N7FzozRHMSdJUM0alTgK/DLYdkYzH2UytXX
   UXcd8UFcpPXZ6/JU1lPb+uBfiEXJfoTFbnsMILPrjK6udJ9f/Yhl9hNlP
   r132KxR03eHOpBQtvtAXivFUIsoQcMoNiMz0L3BVdXa4fFedoEg/qVKaf
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="319309707"
X-IronPort-AV: E=Sophos;i="5.97,297,1669104000"; 
   d="scan'208";a="319309707"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 13:41:45 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="671377270"
X-IronPort-AV: E=Sophos;i="5.97,297,1669104000"; 
   d="scan'208";a="671377270"
Received: from mofarooq-mobl1.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.209.68.16])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 13:41:45 -0800
Subject: [PATCH] cxl/pmem: Fix nvdimm registration races
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: stable@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>,
 Dave Jiang <dave.jiang@intel.com>, nvdimm@lists.linux.dev
Date: Tue, 14 Feb 2023 13:41:44 -0800
Message-ID: <167641090468.954904.2931923185712477447.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

A loop of the form:

    while true; do modprobe cxl_pci; modprobe -r cxl_pci; done

...fails with the following crash signature:

    BUG: kernel NULL pointer dereference, address: 0000000000000040
    [..]
    RIP: 0010:cxl_internal_send_cmd+0x5/0xb0 [cxl_core]
    [..]
    Call Trace:
     <TASK>
     cxl_pmem_ctl+0x121/0x240 [cxl_pmem]
     nvdimm_get_config_data+0xd6/0x1a0 [libnvdimm]
     nd_label_data_init+0x135/0x7e0 [libnvdimm]
     nvdimm_probe+0xd6/0x1c0 [libnvdimm]
     nvdimm_bus_probe+0x7a/0x1e0 [libnvdimm]
     really_probe+0xde/0x380
     __driver_probe_device+0x78/0x170
     driver_probe_device+0x1f/0x90
     __device_attach_driver+0x85/0x110
     bus_for_each_drv+0x7d/0xc0
     __device_attach+0xb4/0x1e0
     bus_probe_device+0x9f/0xc0
     device_add+0x445/0x9c0
     nd_async_device_register+0xe/0x40 [libnvdimm]
     async_run_entry_fn+0x30/0x130

...namely that the bottom half of async nvdimm device registration runs
after cxlmd_release_nvdimm() has already torn down the context that
cxl_pmem_ctl() needs. Unlike the ACPI NFIT case that benefits from
launching multiple nvdimm device registrations in parallel from those
listed in the table, CXL is already marked PROBE_PREFER_ASYNCHRONOUS. So
provide for a synchronous registration path to preclude this scenario.

Fixes: 21083f51521f ("cxl/pmem: Register 'pmem' / cxl_nvdimm devices")
Cc: <stable@vger.kernel.org>
Reported-by: Dave Jiang <dave.jiang@intel.com>
Tested-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/cxl/pmem.c         |    1 +
 drivers/nvdimm/bus.c       |   19 ++++++++++++++++---
 drivers/nvdimm/dimm_devs.c |    5 ++++-
 drivers/nvdimm/nd-core.h   |    1 +
 include/linux/libnvdimm.h  |    3 +++
 5 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/drivers/cxl/pmem.c b/drivers/cxl/pmem.c
index 08bbbac9a6d0..71cfa1fdf902 100644
--- a/drivers/cxl/pmem.c
+++ b/drivers/cxl/pmem.c
@@ -76,6 +76,7 @@ static int cxl_nvdimm_probe(struct device *dev)
 		return rc;
 
 	set_bit(NDD_LABELING, &flags);
+	set_bit(NDD_REGISTER_SYNC, &flags);
 	set_bit(ND_CMD_GET_CONFIG_SIZE, &cmd_mask);
 	set_bit(ND_CMD_GET_CONFIG_DATA, &cmd_mask);
 	set_bit(ND_CMD_SET_CONFIG_DATA, &cmd_mask);
diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index b38d0355b0ac..5ad49056921b 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -508,7 +508,7 @@ static void nd_async_device_unregister(void *d, async_cookie_t cookie)
 	put_device(dev);
 }
 
-void nd_device_register(struct device *dev)
+static void __nd_device_register(struct device *dev, bool sync)
 {
 	if (!dev)
 		return;
@@ -531,11 +531,24 @@ void nd_device_register(struct device *dev)
 	}
 	get_device(dev);
 
-	async_schedule_dev_domain(nd_async_device_register, dev,
-				  &nd_async_domain);
+	if (sync)
+		nd_async_device_register(dev, 0);
+	else
+		async_schedule_dev_domain(nd_async_device_register, dev,
+					  &nd_async_domain);
+}
+
+void nd_device_register(struct device *dev)
+{
+	__nd_device_register(dev, false);
 }
 EXPORT_SYMBOL(nd_device_register);
 
+void nd_device_register_sync(struct device *dev)
+{
+	__nd_device_register(dev, true);
+}
+
 void nd_device_unregister(struct device *dev, enum nd_async_mode mode)
 {
 	bool killed;
diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index 1fc081dcf631..6d3b03a9fa02 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -624,7 +624,10 @@ struct nvdimm *__nvdimm_create(struct nvdimm_bus *nvdimm_bus,
 	nvdimm->sec.ext_flags = nvdimm_security_flags(nvdimm, NVDIMM_MASTER);
 	device_initialize(dev);
 	lockdep_set_class(&dev->mutex, &nvdimm_key);
-	nd_device_register(dev);
+	if (test_bit(NDD_REGISTER_SYNC, &flags))
+		nd_device_register_sync(dev);
+	else
+		nd_device_register(dev);
 
 	return nvdimm;
 }
diff --git a/drivers/nvdimm/nd-core.h b/drivers/nvdimm/nd-core.h
index cc86ee09d7c0..845408f10655 100644
--- a/drivers/nvdimm/nd-core.h
+++ b/drivers/nvdimm/nd-core.h
@@ -107,6 +107,7 @@ int nvdimm_bus_create_ndctl(struct nvdimm_bus *nvdimm_bus);
 void nvdimm_bus_destroy_ndctl(struct nvdimm_bus *nvdimm_bus);
 void nd_synchronize(void);
 void nd_device_register(struct device *dev);
+void nd_device_register_sync(struct device *dev);
 struct nd_label_id;
 char *nd_label_gen_id(struct nd_label_id *label_id, const uuid_t *uuid,
 		      u32 flags);
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index af38252ad704..e772aae71843 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -41,6 +41,9 @@ enum {
 	 */
 	NDD_INCOHERENT = 7,
 
+	/* dimm provider wants synchronous registration by __nvdimm_create() */
+	NDD_REGISTER_SYNC = 8,
+
 	/* need to set a limit somewhere, but yes, this is likely overkill */
 	ND_IOCTL_MAX_BUFLEN = SZ_4M,
 	ND_CMD_MAX_ELEM = 5,


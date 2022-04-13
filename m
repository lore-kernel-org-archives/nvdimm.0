Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AAA423D3
	for <nvdimm@lists.linux.dev>; Wed, 13 Apr 2022 06:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649829747; x=1681365747;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aSeTDj0W2XFMu9PYXuSRlRhFrP+VndjIlxTuiHIALMw=;
  b=SKwx41aZnak/CemJBqi0v27y+Yn+IJoU1Uti9b6pzmZY0e2jVg3fFVLB
   4ZqYgLZmJJPPtXAChgFtOxLGoAzGYAOCkQcBKejcexsflpTn0s7xhATnF
   Eo/C2x9NJt5bvjrBskEdPja5HNEYfVTWS+C4dVRcZ1MuYcuMwI3zDX9IA
   ErRdESww5uoEWWi5Qh84ze3t30iJvPfeavY02M9IOx2jjb5aHVwU46Vw9
   rt1Q/BcPGOwD3ZSFOCn325DRPMcYD4vuEsOn+Nn/S+a0NDS/BGD6akrFh
   nprV+n1d1JhHxpbEYSQHmS0bIADolAO9OM4wpvf8OrrCJf9dD3nKtV4Od
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10315"; a="262026027"
X-IronPort-AV: E=Sophos;i="5.90,256,1643702400"; 
   d="scan'208";a="262026027"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2022 23:02:26 -0700
X-IronPort-AV: E=Sophos;i="5.90,256,1643702400"; 
   d="scan'208";a="552064642"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2022 23:02:26 -0700
Subject: [PATCH v2 11/12] libnvdimm: Enable lockdep validation
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 Ira Weiny <ira.weiny@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 Kevin Tian <kevin.tian@intel.com>, peterz@infradead.org,
 alison.schofield@intel.com, gregkh@linuxfoundation.org,
 linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev
Date: Tue, 12 Apr 2022 23:02:26 -0700
Message-ID: <164982974651.684294.17717238362306260099.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <164982968798.684294.15817853329823976469.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <164982968798.684294.15817853329823976469.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Register libnvdimm subsystem devices with a non-zero lock_class to
enable the device-core to track lock dependencies.

Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/bus.c     |    3 +++
 drivers/nvdimm/nd-core.h |    9 +++++++++
 2 files changed, 12 insertions(+)

diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index b5a1317c30dd..f2ae6825f533 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -360,6 +360,7 @@ struct nvdimm_bus *nvdimm_bus_register(struct device *parent,
 	if (rc)
 		goto err;
 
+	nvdimm_set_lock_class(&nvdimm_bus->dev);
 	rc = device_add(&nvdimm_bus->dev);
 	if (rc) {
 		dev_dbg(&nvdimm_bus->dev, "registration failed: %d\n", rc);
@@ -485,6 +486,7 @@ static void nd_async_device_register(void *d, async_cookie_t cookie)
 {
 	struct device *dev = d;
 
+	nvdimm_set_lock_class(dev);
 	if (device_add(dev) != 0) {
 		dev_err(dev, "%s: failed\n", __func__);
 		put_device(dev);
@@ -738,6 +740,7 @@ int nvdimm_bus_create_ndctl(struct nvdimm_bus *nvdimm_bus)
 	if (rc)
 		goto err;
 
+	nvdimm_set_lock_class(dev);
 	rc = device_add(dev);
 	if (rc) {
 		dev_dbg(&nvdimm_bus->dev, "failed to register ndctl%d: %d\n",
diff --git a/drivers/nvdimm/nd-core.h b/drivers/nvdimm/nd-core.h
index 1668a10e41ba..75892e43b2c9 100644
--- a/drivers/nvdimm/nd-core.h
+++ b/drivers/nvdimm/nd-core.h
@@ -191,5 +191,14 @@ static inline int nvdimm_lock_class(struct device *dev)
 	else
 		return -1;
 }
+
+static inline void nvdimm_set_lock_class(struct device *dev)
+{
+	device_set_lock_class(dev, nvdimm_lock_class(dev));
+}
+#else
+static inline void nvdimm_set_lock_class(struct device *dev)
+{
+}
 #endif
 #endif /* __ND_CORE_H__ */


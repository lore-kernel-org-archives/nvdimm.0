Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E57227460
	for <nvdimm@lists.linux.dev>; Fri, 15 Jul 2022 00:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657843537; x=1689379537;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TgQ3wfpkvJiu1CZKehyIA3pvixwKsN+GwHLtVvvU30k=;
  b=KsxSUKyl8y9comsYSNKa3xedaH2AoCtujomZQnfX/rf0VeTZBKWQ6rqk
   4SDqMtu1decR/RCn7KEG59QB9pRW78v1VBRVms+MlOgFqfM4pYCoVckXA
   sKk3jYN2TFvX6j7mD9dDJciE7bj5jrUD1JWBK1J5LJA+i+h1VDklntfP6
   w596btWB87r9wgWVSOA3h43/S1lh1E/BX9uf2p2lguCDPYAwjlbqnas/Z
   Xim+ZJrVyV6f31D7YpN+XKoSD6IvZdXZEzuQ1uQIt1cCsOi0xWnTmUegu
   tFjFFQVOjJA0m6ZCr9nT/tSZiGoVZDiuOdJYh+wtPxuYYPjMzT+gnPam/
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10408"; a="286402098"
X-IronPort-AV: E=Sophos;i="5.92,272,1650956400"; 
   d="scan'208";a="286402098"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 17:03:16 -0700
X-IronPort-AV: E=Sophos;i="5.92,272,1650956400"; 
   d="scan'208";a="571303156"
Received: from jlcone-mobl1.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.209.2.90])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 17:03:15 -0700
Subject: [PATCH v2 27/28] cxl/pmem: Fix offline_nvdimm_bus() to offline by
 bridge
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: hch@lst.de, nvdimm@lists.linux.dev, linux-pci@vger.kernel.org
Date: Thu, 14 Jul 2022 17:03:15 -0700
Message-ID: <165784339569.1758207.1557084545278004577.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <165784324066.1758207.15025479284039479071.stgit@dwillia2-xfh.jf.intel.com>
References: <165784324066.1758207.15025479284039479071.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Be careful to only disable cxl_pmem objects related to a given
cxl_nvdimm_bridge. Otherwise, offline_nvdimm_bus() reaches across CXL
domains and disables more than is expected.

Fixes: 21083f51521f ("cxl/pmem: Register 'pmem' / cxl_nvdimm devices")
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/cxl/cxl.h  |    1 +
 drivers/cxl/pmem.c |   21 +++++++++++++++++----
 2 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 9aedd471193a..a32093602df9 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -418,6 +418,7 @@ struct cxl_nvdimm_bridge {
 struct cxl_nvdimm {
 	struct device dev;
 	struct cxl_memdev *cxlmd;
+	struct cxl_nvdimm_bridge *bridge;
 };
 
 /**
diff --git a/drivers/cxl/pmem.c b/drivers/cxl/pmem.c
index 0aaa70b4e0f7..b271f6e90b91 100644
--- a/drivers/cxl/pmem.c
+++ b/drivers/cxl/pmem.c
@@ -26,7 +26,10 @@ static void clear_exclusive(void *cxlds)
 
 static void unregister_nvdimm(void *nvdimm)
 {
+	struct cxl_nvdimm *cxl_nvd = nvdimm_provider_data(nvdimm);
+
 	nvdimm_delete(nvdimm);
+	cxl_nvd->bridge = NULL;
 }
 
 static int cxl_nvdimm_probe(struct device *dev)
@@ -66,6 +69,7 @@ static int cxl_nvdimm_probe(struct device *dev)
 	}
 
 	dev_set_drvdata(dev, nvdimm);
+	cxl_nvd->bridge = cxl_nvb;
 	rc = devm_add_action_or_reset(dev, unregister_nvdimm, nvdimm);
 out:
 	device_unlock(&cxl_nvb->dev);
@@ -204,15 +208,23 @@ static bool online_nvdimm_bus(struct cxl_nvdimm_bridge *cxl_nvb)
 	return cxl_nvb->nvdimm_bus != NULL;
 }
 
-static int cxl_nvdimm_release_driver(struct device *dev, void *data)
+static int cxl_nvdimm_release_driver(struct device *dev, void *cxl_nvb)
 {
+	struct cxl_nvdimm *cxl_nvd;
+
 	if (!is_cxl_nvdimm(dev))
 		return 0;
+
+	cxl_nvd = to_cxl_nvdimm(dev);
+	if (cxl_nvd->bridge != cxl_nvb)
+		return 0;
+
 	device_release_driver(dev);
 	return 0;
 }
 
-static void offline_nvdimm_bus(struct nvdimm_bus *nvdimm_bus)
+static void offline_nvdimm_bus(struct cxl_nvdimm_bridge *cxl_nvb,
+			       struct nvdimm_bus *nvdimm_bus)
 {
 	if (!nvdimm_bus)
 		return;
@@ -222,7 +234,8 @@ static void offline_nvdimm_bus(struct nvdimm_bus *nvdimm_bus)
 	 * nvdimm_bus_unregister() rips the nvdimm objects out from
 	 * underneath them.
 	 */
-	bus_for_each_dev(&cxl_bus_type, NULL, NULL, cxl_nvdimm_release_driver);
+	bus_for_each_dev(&cxl_bus_type, NULL, cxl_nvb,
+			 cxl_nvdimm_release_driver);
 	nvdimm_bus_unregister(nvdimm_bus);
 }
 
@@ -260,7 +273,7 @@ static void cxl_nvb_update_state(struct work_struct *work)
 
 		dev_dbg(&cxl_nvb->dev, "rescan: %d\n", rc);
 	}
-	offline_nvdimm_bus(victim_bus);
+	offline_nvdimm_bus(cxl_nvb, victim_bus);
 
 	put_device(&cxl_nvb->dev);
 }


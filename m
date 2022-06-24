Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B133628F4;
	Fri, 24 Jun 2022 04:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656044421; x=1687580421;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gavlelRZmhRVxfC9YWBfVgcdtFPtB4GEpy8NZudDjyI=;
  b=N9uoRyA/GGG8gljkJ8ZIYC+j0UjeAzf8/vfR3SAwOzO9QegL7iK/QnP2
   4uX5/4l6AWHXDaYpTpg7oqHHfCkQVWwrewrPrFr22LXxwH2rKGMJjWeZd
   QZ9FyCTUr5rzIDwcPI/G5IBg8A74DuomE8leUDrwoOtvv1etm2Ev63u3P
   kpLj87shZSIs3B7ccmEKDRNaHay1cHWv5U2bUI9Yr0YAP6SmyyJ6o5VOg
   CW0+igEHKW94hThpaSG5Asuw0DxWoENhmN9MKP6LuCeWVsFgDIOdLz1v6
   C4GW/DsebQUJeF1roMUK1BhsFQety9J5ZZ2ZckhXpq8FndsaWxN5dMrXZ
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10387"; a="344912829"
X-IronPort-AV: E=Sophos;i="5.92,218,1650956400"; 
   d="scan'208";a="344912829"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2022 21:20:16 -0700
X-IronPort-AV: E=Sophos;i="5.92,218,1650956400"; 
   d="scan'208";a="645092968"
Received: from daharell-mobl2.amr.corp.intel.com (HELO dwillia2-xfh.intel.com) ([10.209.66.176])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2022 21:20:16 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev,
	linux-pci@vger.kernel.org,
	patches@lists.linux.dev,
	hch@lst.de,
	Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 45/46] cxl/pmem: Fix offline_nvdimm_bus() to offline by bridge
Date: Thu, 23 Jun 2022 21:19:49 -0700
Message-Id: <20220624041950.559155-20-dan.j.williams@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <165603869943.551046.3498980330327696732.stgit@dwillia2-xfh>
References: <165603869943.551046.3498980330327696732.stgit@dwillia2-xfh>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Be careful to only disable cxl_pmem objects related to a given
cxl_nvdimm_bridge. Otherwise, offline_nvdimm_bus() reaches across CXL
domains and disables more than is expected.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/cxl/cxl.h  |  1 +
 drivers/cxl/pmem.c | 21 +++++++++++++++++----
 2 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index d6ff6337aa49..95f486bc1b41 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -411,6 +411,7 @@ struct cxl_nvdimm_bridge {
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
-- 
2.36.1


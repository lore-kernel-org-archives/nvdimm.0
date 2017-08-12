Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 970CA2007D094
 for <linux-nvdimm@lists.01.org>; Fri, 11 Aug 2017 22:16:25 -0700 (PDT)
Subject: [PATCH 1/3] libnvdimm: rename nd_sector_size_{show,
 store} to nd_size_select_{show, store}
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 11 Aug 2017 22:12:22 -0700
Message-ID: <150251474264.11236.1325459850307173049.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <150251473716.11236.9462897790331942583.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <150251473716.11236.9462897790331942583.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
Cc: linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Prepare for other another consumer of this size selection scheme that is
not a 'sector size'.

Cc: Oliver O'Halloran <oohall@gmail.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/btt_devs.c       |    4 ++--
 drivers/nvdimm/core.c           |   10 +++++-----
 drivers/nvdimm/namespace_devs.c |    6 +++---
 drivers/nvdimm/nd.h             |    6 +++---
 4 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/nvdimm/btt_devs.c b/drivers/nvdimm/btt_devs.c
index 3e359d282f8e..d58925295aa7 100644
--- a/drivers/nvdimm/btt_devs.c
+++ b/drivers/nvdimm/btt_devs.c
@@ -61,7 +61,7 @@ static ssize_t sector_size_show(struct device *dev,
 {
 	struct nd_btt *nd_btt = to_nd_btt(dev);
 
-	return nd_sector_size_show(nd_btt->lbasize, btt_lbasize_supported, buf);
+	return nd_size_select_show(nd_btt->lbasize, btt_lbasize_supported, buf);
 }
 
 static ssize_t sector_size_store(struct device *dev,
@@ -72,7 +72,7 @@ static ssize_t sector_size_store(struct device *dev,
 
 	device_lock(dev);
 	nvdimm_bus_lock(dev);
-	rc = nd_sector_size_store(dev, buf, &nd_btt->lbasize,
+	rc = nd_size_select_store(dev, buf, &nd_btt->lbasize,
 			btt_lbasize_supported);
 	dev_dbg(dev, "%s: result: %zd wrote: %s%s", __func__,
 			rc, buf, buf[len - 1] == '\n' ? "" : "\n");
diff --git a/drivers/nvdimm/core.c b/drivers/nvdimm/core.c
index 75bc08c6838c..bb71f0cf8f5d 100644
--- a/drivers/nvdimm/core.c
+++ b/drivers/nvdimm/core.c
@@ -277,14 +277,14 @@ int nd_uuid_store(struct device *dev, u8 **uuid_out, const char *buf,
 	return 0;
 }
 
-ssize_t nd_sector_size_show(unsigned long current_lbasize,
+ssize_t nd_size_select_show(unsigned long current_size,
 		const unsigned long *supported, char *buf)
 {
 	ssize_t len = 0;
 	int i;
 
 	for (i = 0; supported[i]; i++)
-		if (current_lbasize == supported[i])
+		if (current_size == supported[i])
 			len += sprintf(buf + len, "[%ld] ", supported[i]);
 		else
 			len += sprintf(buf + len, "%ld ", supported[i]);
@@ -292,8 +292,8 @@ ssize_t nd_sector_size_show(unsigned long current_lbasize,
 	return len;
 }
 
-ssize_t nd_sector_size_store(struct device *dev, const char *buf,
-		unsigned long *current_lbasize, const unsigned long *supported)
+ssize_t nd_size_select_store(struct device *dev, const char *buf,
+		unsigned long *current_size, const unsigned long *supported)
 {
 	unsigned long lbasize;
 	int rc, i;
@@ -310,7 +310,7 @@ ssize_t nd_sector_size_store(struct device *dev, const char *buf,
 			break;
 
 	if (supported[i]) {
-		*current_lbasize = lbasize;
+		*current_size = lbasize;
 		return 0;
 	} else {
 		return -EINVAL;
diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index 5f1c6756e57c..1427a386a033 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -1313,14 +1313,14 @@ static ssize_t sector_size_show(struct device *dev,
 	if (is_namespace_blk(dev)) {
 		struct nd_namespace_blk *nsblk = to_nd_namespace_blk(dev);
 
-		return nd_sector_size_show(nsblk->lbasize,
+		return nd_size_select_show(nsblk->lbasize,
 				blk_lbasize_supported, buf);
 	}
 
 	if (is_namespace_pmem(dev)) {
 		struct nd_namespace_pmem *nspm = to_nd_namespace_pmem(dev);
 
-		return nd_sector_size_show(nspm->lbasize,
+		return nd_size_select_show(nspm->lbasize,
 				pmem_lbasize_supported, buf);
 	}
 	return -ENXIO;
@@ -1352,7 +1352,7 @@ static ssize_t sector_size_store(struct device *dev,
 	if (to_ndns(dev)->claim)
 		rc = -EBUSY;
 	if (rc >= 0)
-		rc = nd_sector_size_store(dev, buf, lbasize, supported);
+		rc = nd_size_select_store(dev, buf, lbasize, supported);
 	if (rc >= 0)
 		rc = nd_namespace_label_update(nd_region, dev);
 	dev_dbg(dev, "%s: result: %zd %s: %s%s", __func__,
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index a08fc2e24fb3..251c7e6d2588 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -234,10 +234,10 @@ void nd_device_unregister(struct device *dev, enum nd_async_mode mode);
 void nd_device_notify(struct device *dev, enum nvdimm_event event);
 int nd_uuid_store(struct device *dev, u8 **uuid_out, const char *buf,
 		size_t len);
-ssize_t nd_sector_size_show(unsigned long current_lbasize,
+ssize_t nd_size_select_show(unsigned long current_size,
 		const unsigned long *supported, char *buf);
-ssize_t nd_sector_size_store(struct device *dev, const char *buf,
-		unsigned long *current_lbasize, const unsigned long *supported);
+ssize_t nd_size_select_store(struct device *dev, const char *buf,
+		unsigned long *current_size, const unsigned long *supported);
 int __init nvdimm_init(void);
 int __init nd_region_init(void);
 int __init nd_label_init(void);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

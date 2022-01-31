Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 824A52C80
	for <nvdimm@lists.linux.dev>; Mon, 31 Jan 2022 23:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643672119; x=1675208119;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eEJU5QLLSBr1mXOJ8eM9Ty+9C3BosFULoxCbvemD8DM=;
  b=eQqEn+qYKmPLBHr+0a5pZ6IAMUQxRo/QDnkgeZmgegsdoVl+0QUtOy2M
   AH5pdHkXeaTyvb0kkqKKl2iLnLGIdi0F6Nu6PGkN+rQJYB8iA/WrowdbA
   NBRAdyIEA7qABMnq1MRS/1Y58I2iUHr5kOz0tAjF4gI2beD8XFQnW+v8x
   2Rm9nUV4+q7/SGCYlnqtZe//Rumdvth+ujmX6BmJz8/0/t9XibQJqxcXU
   aVO4ClycMdulqiUBCfLfgIq4zgh8GQdzzcyT4lv/hIUOObf5+JomULblZ
   TOGc7NlUiPu1ZoDpr9tp3HaSpSM35mQSXPnPo16wwD31iP3P55CNoj+Fg
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10244"; a="227547569"
X-IronPort-AV: E=Sophos;i="5.88,332,1635231600"; 
   d="scan'208";a="227547569"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2022 15:35:18 -0800
X-IronPort-AV: E=Sophos;i="5.88,332,1635231600"; 
   d="scan'208";a="479394016"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2022 15:35:18 -0800
Subject: [PATCH v5 16/40] cxl/core/port: Use dedicated lock for decoder
 target list
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Ben Widawsky <ben.widawsky@intel.com>, linux-pci@vger.kernel.org,
 nvdimm@lists.linux.dev
Date: Mon, 31 Jan 2022 15:35:18 -0800
Message-ID: <164367209095.208169.1171673319121271280.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <164316562430.3437160.122223070771602475.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <164316562430.3437160.122223070771602475.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Lockdep reports:

 ======================================================
 WARNING: possible circular locking dependency detected
 5.16.0-rc1+ #142 Tainted: G           OE
 ------------------------------------------------------
 cxl/1220 is trying to acquire lock:
 ffff979b85475460 (kn->active#144){++++}-{0:0}, at: __kernfs_remove+0x1ab/0x1e0

 but task is already holding lock:
 ffff979b87ab38e8 (&dev->lockdep_mutex#2/4){+.+.}-{3:3}, at: cxl_remove_ep+0x50c/0x5c0 [cxl_core]

...where cxl_remove_ep() is a helper that wants to delete ports while
holding a lock on the host device for that port. That sets up a lockdep
violation whereby target_list_show() can not rely holding the decoder's
device lock while walking the target_list. Switch to a dedicated seqlock
for this purpose.

Reported-by: Ben Widawsky <ben.widawsky@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
Changes since v4:
- Cleanup error exit condition (Jonathan)

 drivers/cxl/core/port.c |   30 +++++++++++++++++++++++-------
 drivers/cxl/cxl.h       |    2 ++
 2 files changed, 25 insertions(+), 7 deletions(-)

diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index 9285cdb734b2..fc5d86222bc3 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -104,14 +104,11 @@ static ssize_t target_type_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(target_type);
 
-static ssize_t target_list_show(struct device *dev,
-			       struct device_attribute *attr, char *buf)
+static ssize_t emit_target_list(struct cxl_decoder *cxld, char *buf)
 {
-	struct cxl_decoder *cxld = to_cxl_decoder(dev);
 	ssize_t offset = 0;
 	int i, rc = 0;
 
-	cxl_device_lock(dev);
 	for (i = 0; i < cxld->interleave_ways; i++) {
 		struct cxl_dport *dport = cxld->target[i];
 		struct cxl_dport *next = NULL;
@@ -124,13 +121,29 @@ static ssize_t target_list_show(struct device *dev,
 		rc = sysfs_emit_at(buf, offset, "%d%s", dport->port_id,
 				   next ? "," : "");
 		if (rc < 0)
-			break;
+			return rc;
 		offset += rc;
 	}
-	cxl_device_unlock(dev);
+
+	return offset;
+}
+
+static ssize_t target_list_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct cxl_decoder *cxld = to_cxl_decoder(dev);
+	ssize_t offset;
+	unsigned int seq;
+	int rc;
+
+	do {
+		seq = read_seqbegin(&cxld->target_lock);
+		rc = emit_target_list(cxld, buf);
+	} while (read_seqretry(&cxld->target_lock, seq));
 
 	if (rc < 0)
 		return rc;
+	offset = rc;
 
 	rc = sysfs_emit_at(buf, offset, "\n");
 	if (rc < 0)
@@ -494,15 +507,17 @@ static int decoder_populate_targets(struct cxl_decoder *cxld,
 		goto out_unlock;
 	}
 
+	write_seqlock(&cxld->target_lock);
 	for (i = 0; i < cxld->nr_targets; i++) {
 		struct cxl_dport *dport = find_dport(port, target_map[i]);
 
 		if (!dport) {
 			rc = -ENXIO;
-			goto out_unlock;
+			break;
 		}
 		cxld->target[i] = dport;
 	}
+	write_sequnlock(&cxld->target_lock);
 
 out_unlock:
 	cxl_device_unlock(&port->dev);
@@ -543,6 +558,7 @@ static struct cxl_decoder *cxl_decoder_alloc(struct cxl_port *port,
 
 	cxld->id = rc;
 	cxld->nr_targets = nr_targets;
+	seqlock_init(&cxld->target_lock);
 	dev = &cxld->dev;
 	device_initialize(dev);
 	device_set_pm_not_required(dev);
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 6a38d2e1f3dd..e79162999088 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -185,6 +185,7 @@ enum cxl_decoder_type {
  * @interleave_granularity: data stride per dport
  * @target_type: accelerator vs expander (type2 vs type3) selector
  * @flags: memory type capabilities and locking
+ * @target_lock: coordinate coherent reads of the target list
  * @nr_targets: number of elements in @target
  * @target: active ordered target list in current decoder configuration
  */
@@ -199,6 +200,7 @@ struct cxl_decoder {
 	int interleave_granularity;
 	enum cxl_decoder_type target_type;
 	unsigned long flags;
+	seqlock_t target_lock;
 	int nr_targets;
 	struct cxl_dport *target[];
 };


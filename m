Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FC382CA3
	for <nvdimm@lists.linux.dev>; Mon, 24 Jan 2022 00:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642984205; x=1674520205;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FcGP9UfUD/LbEw6S0A8Va8xKxsRRlJUeb6Yo9y9BI9A=;
  b=N2pxVXbreR1VoDXIXayJqUprvOKNsDUFikJ3xv6f4uP3KJE8aHNueJBY
   dZ417pUkLZYDVLKWbfWzqIHL6JfztVdtmMRvv+5bQ/C+j7dn/L2IfJQbt
   4B09tyUyyNU7KuezdacuTSne0+V32MJfH4zt5FMIGrcwt7QxGt0sp+t5M
   GqMqR97pEVvxZsiUpgC0NZIV9T8Sv0qpJ49jgoIMHi1936TOkRCL06Ylk
   8WdIDEizjuSv4EZAiPP7pSV/PMb7jYyzTjrZh5UEzu/DdscrNmayFCQCJ
   euxwtP3Shjy3PtMROEHcIfTiJEmPSWn4RQJqd/fkReazjMsLv75vDjDKa
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10236"; a="226608060"
X-IronPort-AV: E=Sophos;i="5.88,311,1635231600"; 
   d="scan'208";a="226608060"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2022 16:30:04 -0800
X-IronPort-AV: E=Sophos;i="5.88,311,1635231600"; 
   d="scan'208";a="494436135"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2022 16:30:04 -0800
Subject: [PATCH v3 16/40] cxl/core/port: Use dedicated lock for decoder
 target list
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: linux-pci@vger.kernel.org, nvdimm@lists.linux.dev
Date: Sun, 23 Jan 2022 16:30:04 -0800
Message-ID: <164298420439.3018233.5113217660229718675.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <164298411792.3018233.7493009997525360044.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <164298411792.3018233.7493009997525360044.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/cxl/core/port.c |   28 +++++++++++++++++++++++-----
 drivers/cxl/cxl.h       |    2 ++
 2 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index f58b2d502ac8..58089ea09aa3 100644
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
@@ -127,10 +124,28 @@ static ssize_t target_list_show(struct device *dev,
 			break;
 		offset += rc;
 	}
-	cxl_device_unlock(dev);
 
 	if (rc < 0)
 		return rc;
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
+
+	if (rc < 0)
+		return rc;
+	offset = rc;
 
 	rc = sysfs_emit_at(buf, offset, "\n");
 	if (rc < 0)
@@ -494,6 +509,7 @@ static int decoder_populate_targets(struct cxl_decoder *cxld,
 		goto out_unlock;
 	}
 
+	write_seqlock(&cxld->target_lock);
 	for (i = 0; i < cxld->nr_targets; i++) {
 		struct cxl_dport *dport = find_dport(port, target_map[i]);
 
@@ -503,6 +519,7 @@ static int decoder_populate_targets(struct cxl_decoder *cxld,
 		}
 		cxld->target[i] = dport;
 	}
+	write_sequnlock(&cxld->target_lock);
 
 out_unlock:
 	cxl_device_unlock(&port->dev);
@@ -543,6 +560,7 @@ static struct cxl_decoder *cxl_decoder_alloc(struct cxl_port *port,
 
 	cxld->id = rc;
 	cxld->nr_targets = nr_targets;
+	seqlock_init(&cxld->target_lock);
 	dev = &cxld->dev;
 	device_initialize(dev);
 	device_set_pm_not_required(dev);
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 569cbe7f23d6..47c256ad105f 100644
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


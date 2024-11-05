Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 588A03BB48
	for <nvdimm@lists.linux.dev>; Tue,  5 Nov 2024 02:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730772672; cv=none; b=QLfZ/jhthlRT5E82xJb5iNfbFnz3iPg3Z8sQwqu+l6dVMJhmvNsWfDk3JxecQQ1omhHM0aVCroC4l6e1huqmWRYNETvjbPrTbyv/HqggQcumV4Gq4lgOOWurupWnWngHYlp4749PALobWjPELQcQ59c4FNegHQ+iuPN9PYWKoGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730772672; c=relaxed/simple;
	bh=LIQ+4ujocGInLdjTo8MJ1n7kTR/xhH67XvAW1aV3zdQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=KsoOBuXUP9o5i3x4ExNO7jZ1zRkJHi3iE3PbHKBCmYLqShxGk2Q/4AxuvqIgR/CT0+rABNLlZTGFM2vXnjacFVAAzsC14JFAe5Ebck+KFStXj+TRToa56UPZJBjIZ/zzCoJabg3S0NltMNCvkThKzWwl7fQx91OpkkUg1lFuJjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=C8dUpS2j; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="C8dUpS2j"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730772670; x=1762308670;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=LIQ+4ujocGInLdjTo8MJ1n7kTR/xhH67XvAW1aV3zdQ=;
  b=C8dUpS2jCucEm2i+VENWuNZ5p42RnvOF0n0587Z1MEatesvt21CCtLrB
   gLJpWr8WZVOFz3Czct+0+w/FLQaRhH/D3XEvZSMHdHUZhyOvddzjJ5Bdp
   7LoASdje5LobA42UVYc03WwNKRkkrTenJnW0/wrXbBibdoyC3xTEqBnRD
   meMViWu/2pXSTsWp+4mmFmyPKIPgmyTRzNzR2pN8TetRzXXB4aTMBL/I+
   BuFptloVHy1WAxhqpxHpcHfyIje8XVbjdDcn/NCMb3UywWGKGXfydjGEp
   mVz8YuI03Oo+3sYZgHOUP+BfcOplMgoHOXQyS1/qzl9fDH/n+WzxJbQCa
   w==;
X-CSE-ConnectionGUID: DXP+Us46TJiZ84oQ38I5tQ==
X-CSE-MsgGUID: LZ3KXa9eR/6Itdg5IE7IkQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11246"; a="30613086"
X-IronPort-AV: E=Sophos;i="6.11,258,1725346800"; 
   d="scan'208";a="30613086"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 18:11:10 -0800
X-CSE-ConnectionGUID: TnrEQklQRGCRMAmC2Lu18Q==
X-CSE-MsgGUID: +5LnPlUuROaQex11iViZzQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,258,1725346800"; 
   d="scan'208";a="107176479"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.125.109.226])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 18:11:08 -0800
From: Ira Weiny <ira.weiny@intel.com>
Date: Mon, 04 Nov 2024 20:10:47 -0600
Subject: [ndctl PATCH v2 3/6] ndctl: Separate region mode from decoder mode
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241104-dcd-region2-v2-3-be057b479eeb@intel.com>
References: <20241104-dcd-region2-v2-0-be057b479eeb@intel.com>
In-Reply-To: <20241104-dcd-region2-v2-0-be057b479eeb@intel.com>
To: Alison Schofield <alison.schofield@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>, 
 Jonathan Cameron <jonathan.cameron@Huawei.com>, Fan Ni <fan.ni@samsung.com>, 
 Navneet Singh <navneet.singh@intel.com>, 
 Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
 linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev, 
 Ira Weiny <ira.weiny@intel.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1730772649; l=6625;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=LIQ+4ujocGInLdjTo8MJ1n7kTR/xhH67XvAW1aV3zdQ=;
 b=zXIvWzvefZ+0We2yxh5yt9mNQQQ4C3hFIuhCNhPcdb1jzngBZFXdYOSDE6LbNUKEAo5xkMWXw
 55GP3lpJNWxDgZEyvvGQgxPJcbly6aKhma3P+nOHvmdhgrhk+N76AbK
X-Developer-Key: i=ira.weiny@intel.com; a=ed25519;
 pk=noldbkG+Wp1qXRrrkfY1QJpDf7QsOEthbOT7vm0PqsE=

With the introduction of DCD, region mode and decoder mode no longer
remain a 1:1 relation.  An interleaved region may be made up of Dynamic
Capacity partitions with different indexes on each of the target
devices.

Introduce a new region mode enumeration and access function.

To maintain compatibility with existing software the region mode values
are defined the same as the current decoder mode.  In addition
cxl_region_get_mode() is retained.

Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 cxl/json.c         |  6 +++---
 cxl/lib/libcxl.c   | 15 ++++++++++-----
 cxl/lib/libcxl.sym |  1 +
 cxl/lib/private.h  |  2 +-
 cxl/libcxl.h       | 35 +++++++++++++++++++++++++++++++++++
 5 files changed, 50 insertions(+), 9 deletions(-)

diff --git a/cxl/json.c b/cxl/json.c
index 5066d3bed13f8fcc36ab8f0ea127685c246d94d7..dcd3cc28393faf7e8adf299a857531ecdeaac50a 100644
--- a/cxl/json.c
+++ b/cxl/json.c
@@ -1147,7 +1147,7 @@ void util_cxl_mappings_append_json(struct json_object *jregion,
 struct json_object *util_cxl_region_to_json(struct cxl_region *region,
 					     unsigned long flags)
 {
-	enum cxl_decoder_mode mode = cxl_region_get_mode(region);
+	enum cxl_region_mode mode = cxl_region_get_region_mode(region);
 	const char *devname = cxl_region_get_devname(region);
 	struct json_object *jregion, *jobj;
 	u64 val;
@@ -1174,8 +1174,8 @@ struct json_object *util_cxl_region_to_json(struct cxl_region *region,
 			json_object_object_add(jregion, "size", jobj);
 	}
 
-	if (mode != CXL_DECODER_MODE_NONE) {
-		jobj = json_object_new_string(cxl_decoder_mode_name(mode));
+	if (mode != CXL_REGION_MODE_NONE) {
+		jobj = json_object_new_string(cxl_region_mode_name(mode));
 		if (jobj)
 			json_object_object_add(jregion, "type", jobj);
 	}
diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index 63aa4ef3acdc2fb3c4ec6c13be5feb802e817d0d..5cbfb3e7d466b491ef87ea285f7e50d3bac230db 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -431,10 +431,10 @@ CXL_EXPORT bool cxl_region_qos_class_mismatch(struct cxl_region *region)
 		if (!memdev)
 			continue;
 
-		if (region->mode == CXL_DECODER_MODE_RAM) {
+		if (region->mode == CXL_REGION_MODE_RAM) {
 			if (root_decoder->qos_class != memdev->ram_qos_class)
 				return true;
-		} else if (region->mode == CXL_DECODER_MODE_PMEM) {
+		} else if (region->mode == CXL_REGION_MODE_PMEM) {
 			if (root_decoder->qos_class != memdev->pmem_qos_class)
 				return true;
 		}
@@ -619,9 +619,9 @@ static void *add_cxl_region(void *parent, int id, const char *cxlregion_base)
 
 	sprintf(path, "%s/mode", cxlregion_base);
 	if (sysfs_read_attr(ctx, path, buf) < 0)
-		region->mode = CXL_DECODER_MODE_NONE;
+		region->mode = CXL_REGION_MODE_NONE;
 	else
-		region->mode = cxl_decoder_mode_from_ident(buf);
+		region->mode = cxl_region_mode_from_ident(buf);
 
 	sprintf(path, "%s/modalias", cxlregion_base);
 	if (sysfs_read_attr(ctx, path, buf) == 0)
@@ -748,11 +748,16 @@ CXL_EXPORT unsigned long long cxl_region_get_resource(struct cxl_region *region)
 	return region->start;
 }
 
-CXL_EXPORT enum cxl_decoder_mode cxl_region_get_mode(struct cxl_region *region)
+CXL_EXPORT enum cxl_region_mode cxl_region_get_region_mode(struct cxl_region *region)
 {
 	return region->mode;
 }
 
+CXL_EXPORT enum cxl_decoder_mode cxl_region_get_mode(struct cxl_region *region)
+{
+	return (enum cxl_decoder_mode)cxl_region_get_region_mode(region);
+}
+
 CXL_EXPORT unsigned int
 cxl_region_get_interleave_ways(struct cxl_region *region)
 {
diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
index 0c155a40ad4765106f0eab1745281d462af782fe..b5d9bdcc38e09812f26afc1cb0e804f86784b8e6 100644
--- a/cxl/lib/libcxl.sym
+++ b/cxl/lib/libcxl.sym
@@ -287,4 +287,5 @@ LIBECXL_8 {
 global:
 	cxl_memdev_trigger_poison_list;
 	cxl_region_trigger_poison_list;
+	cxl_region_get_region_mode;
 } LIBCXL_7;
diff --git a/cxl/lib/private.h b/cxl/lib/private.h
index b6cd910e93359b53cac34427acfe84c7abcb78b0..0f45be89b6a00477d13fb6d7f1906213a3073c48 100644
--- a/cxl/lib/private.h
+++ b/cxl/lib/private.h
@@ -171,7 +171,7 @@ struct cxl_region {
 	unsigned int interleave_ways;
 	unsigned int interleave_granularity;
 	enum cxl_decode_state decode_state;
-	enum cxl_decoder_mode mode;
+	enum cxl_region_mode mode;
 	struct daxctl_region *dax_region;
 	struct kmod_module *module;
 	struct list_head mappings;
diff --git a/cxl/libcxl.h b/cxl/libcxl.h
index 0a5fd0e13cc24e0032d4a83d780278fbe0038d32..06b87a0924faafec6c80eca83ea7551d4e117256 100644
--- a/cxl/libcxl.h
+++ b/cxl/libcxl.h
@@ -303,6 +303,39 @@ int cxl_memdev_is_enabled(struct cxl_memdev *memdev);
 	for (endpoint = cxl_endpoint_get_first(port); endpoint != NULL;        \
 	     endpoint = cxl_endpoint_get_next(endpoint))
 
+enum cxl_region_mode {
+	CXL_REGION_MODE_NONE = CXL_DECODER_MODE_NONE,
+	CXL_REGION_MODE_MIXED = CXL_DECODER_MODE_MIXED,
+	CXL_REGION_MODE_PMEM = CXL_DECODER_MODE_PMEM,
+	CXL_REGION_MODE_RAM = CXL_DECODER_MODE_RAM,
+};
+
+static inline const char *cxl_region_mode_name(enum cxl_region_mode mode)
+{
+	static const char *names[] = {
+		[CXL_REGION_MODE_NONE] = "none",
+		[CXL_REGION_MODE_MIXED] = "mixed",
+		[CXL_REGION_MODE_PMEM] = "pmem",
+		[CXL_REGION_MODE_RAM] = "ram",
+	};
+
+	if (mode < CXL_REGION_MODE_NONE || mode > CXL_REGION_MODE_RAM)
+		mode = CXL_REGION_MODE_NONE;
+	return names[mode];
+}
+
+static inline enum cxl_region_mode
+cxl_region_mode_from_ident(const char *ident)
+{
+	if (strcmp(ident, "ram") == 0)
+		return CXL_REGION_MODE_RAM;
+	else if (strcmp(ident, "volatile") == 0)
+		return CXL_REGION_MODE_RAM;
+	else if (strcmp(ident, "pmem") == 0)
+		return CXL_REGION_MODE_PMEM;
+	return CXL_REGION_MODE_NONE;
+}
+
 struct cxl_region;
 struct cxl_region *cxl_region_get_first(struct cxl_decoder *decoder);
 struct cxl_region *cxl_region_get_next(struct cxl_region *region);
@@ -318,6 +351,8 @@ const char *cxl_region_get_devname(struct cxl_region *region);
 void cxl_region_get_uuid(struct cxl_region *region, uuid_t uu);
 unsigned long long cxl_region_get_size(struct cxl_region *region);
 unsigned long long cxl_region_get_resource(struct cxl_region *region);
+enum cxl_region_mode cxl_region_get_region_mode(struct cxl_region *region);
+/* Deprecated: use cxl_region_get_region_mode() */
 enum cxl_decoder_mode cxl_region_get_mode(struct cxl_region *region);
 unsigned int cxl_region_get_interleave_ways(struct cxl_region *region);
 unsigned int cxl_region_get_interleave_granularity(struct cxl_region *region);

-- 
2.47.0


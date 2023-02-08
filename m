Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A5047493
	for <nvdimm@lists.linux.dev>; Wed,  8 Feb 2023 20:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675886445; x=1707422445;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=8hK5Al9UALbv4ZwmwWP/1InDqHqxyjYu1ZTySNiyJ7g=;
  b=BiWkGiQUCDqiaPBMTU0dhraM28eFK8YN9aXA8MUdryMQmaX+tzkYOr87
   VynQbPUB3vMfB+j8D1ZBwQ/P1Jb2qhcbYzqTAnUr3faVlOwdNG3Tq3OCI
   9GD0Rh30zMyc9Os3AjBwDlkQ+cEj+ONMPv42Nqmr5jvtya3cRYDQQHw+N
   abDVvXCSdz1gaj+XVuoN2VufWwQ/95OQfAODRGODTwoQTf/Eg0yypDGxq
   qGe2bvTroMhbEtc0tN9kMLqEczE6Ewjws79GAi6J8aQ7IVoega4+XYhVK
   RwIwZjWbJx0YJ7KdAkS2Xo5nvXK6C/RifPFRmJCFntd5BeKfdj2mxNEU9
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="329935459"
X-IronPort-AV: E=Sophos;i="5.97,281,1669104000"; 
   d="scan'208";a="329935459"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2023 12:00:43 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="776174670"
X-IronPort-AV: E=Sophos;i="5.97,281,1669104000"; 
   d="scan'208";a="776174670"
Received: from laarmstr-mobl.amr.corp.intel.com (HELO vverma7-desk1.local) ([10.251.6.109])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2023 12:00:42 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
Date: Wed, 08 Feb 2023 13:00:30 -0700
Subject: [PATCH ndctl v2 2/7] cxl: add a type attribute to region listings
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230120-vv-volatile-regions-v2-2-4ea6253000e5@intel.com>
References: <20230120-vv-volatile-regions-v2-0-4ea6253000e5@intel.com>
In-Reply-To: <20230120-vv-volatile-regions-v2-0-4ea6253000e5@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Gregory Price <gregory.price@memverge.com>, 
 Jonathan Cameron <Jonathan.Cameron@Huawei.com>, 
 Davidlohr Bueso <dave@stgolabs.net>, 
 Dan Williams <dan.j.williams@intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>, nvdimm@lists.linux.dev, 
 Ira Weiny <ira.weiny@intel.com>
X-Mailer: b4 0.13-dev-ada30
X-Developer-Signature: v=1; a=openpgp-sha256; l=4978;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=8hK5Al9UALbv4ZwmwWP/1InDqHqxyjYu1ZTySNiyJ7g=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDMmP/2c6656+onzyV5iv6veYmj/uyj1SU7+KLhR52/Go+
 XWrwIGejlIWBjEuBlkxRZa/ez4yHpPbns8TmOAIM4eVCWQIAxenAEyk9iDD/5D7K9bPbvPSK2aq
 ORx+7TlDpvqT9BNTWDu+7HhXZ9O+7ygjw52zFukdbGvWv2VfPyNCL9eo8Un1hSfLr8trNWw6feX
 pWk4A
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp;
 fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF

In preparation for enumerating and creating 'volatile' or 'ram' type
regions, add a 'type' attribute to region listings, so these can be
distinguished from 'pmem' type regions easily. This depends on a new
'mode' attribute for region objects in sysfs. For older kernels that
lack this, region listings will simply omit emitting this attribute,
but otherwise not treat it as a failure.

Cc: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 Documentation/cxl/lib/libcxl.txt |  1 +
 cxl/lib/private.h                |  1 +
 cxl/lib/libcxl.c                 | 11 +++++++++++
 cxl/libcxl.h                     |  1 +
 cxl/json.c                       |  7 +++++++
 cxl/lib/libcxl.sym               |  5 +++++
 6 files changed, 26 insertions(+)

diff --git a/Documentation/cxl/lib/libcxl.txt b/Documentation/cxl/lib/libcxl.txt
index f9af376..dbc4b56 100644
--- a/Documentation/cxl/lib/libcxl.txt
+++ b/Documentation/cxl/lib/libcxl.txt
@@ -550,6 +550,7 @@ int cxl_region_get_id(struct cxl_region *region);
 const char *cxl_region_get_devname(struct cxl_region *region);
 void cxl_region_get_uuid(struct cxl_region *region, uuid_t uu);
 unsigned long long cxl_region_get_size(struct cxl_region *region);
+enum cxl_decoder_mode cxl_region_get_mode(struct cxl_region *region);
 unsigned long long cxl_region_get_resource(struct cxl_region *region);
 unsigned int cxl_region_get_interleave_ways(struct cxl_region *region);
 unsigned int cxl_region_get_interleave_granularity(struct cxl_region *region);
diff --git a/cxl/lib/private.h b/cxl/lib/private.h
index f8871bd..306dc3a 100644
--- a/cxl/lib/private.h
+++ b/cxl/lib/private.h
@@ -149,6 +149,7 @@ struct cxl_region {
 	unsigned int interleave_ways;
 	unsigned int interleave_granularity;
 	enum cxl_decode_state decode_state;
+	enum cxl_decoder_mode mode;
 	struct kmod_module *module;
 	struct list_head mappings;
 };
diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index 4205a58..83f628b 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -561,6 +561,12 @@ static void *add_cxl_region(void *parent, int id, const char *cxlregion_base)
 	else
 		region->decode_state = strtoul(buf, NULL, 0);
 
+	sprintf(path, "%s/mode", cxlregion_base);
+	if (sysfs_read_attr(ctx, path, buf) < 0)
+		region->mode = CXL_DECODER_MODE_NONE;
+	else
+		region->mode = cxl_decoder_mode_from_ident(buf);
+
 	sprintf(path, "%s/modalias", cxlregion_base);
 	if (sysfs_read_attr(ctx, path, buf) == 0)
 		region->module = util_modalias_to_module(ctx, buf);
@@ -686,6 +692,11 @@ CXL_EXPORT unsigned long long cxl_region_get_resource(struct cxl_region *region)
 	return region->start;
 }
 
+CXL_EXPORT enum cxl_decoder_mode cxl_region_get_mode(struct cxl_region *region)
+{
+	return region->mode;
+}
+
 CXL_EXPORT unsigned int
 cxl_region_get_interleave_ways(struct cxl_region *region)
 {
diff --git a/cxl/libcxl.h b/cxl/libcxl.h
index d699af8..e6cca11 100644
--- a/cxl/libcxl.h
+++ b/cxl/libcxl.h
@@ -273,6 +273,7 @@ const char *cxl_region_get_devname(struct cxl_region *region);
 void cxl_region_get_uuid(struct cxl_region *region, uuid_t uu);
 unsigned long long cxl_region_get_size(struct cxl_region *region);
 unsigned long long cxl_region_get_resource(struct cxl_region *region);
+enum cxl_decoder_mode cxl_region_get_mode(struct cxl_region *region);
 unsigned int cxl_region_get_interleave_ways(struct cxl_region *region);
 unsigned int cxl_region_get_interleave_granularity(struct cxl_region *region);
 struct cxl_decoder *cxl_region_get_target_decoder(struct cxl_region *region,
diff --git a/cxl/json.c b/cxl/json.c
index 0fc44e4..16b6cb8 100644
--- a/cxl/json.c
+++ b/cxl/json.c
@@ -827,6 +827,7 @@ void util_cxl_mappings_append_json(struct json_object *jregion,
 struct json_object *util_cxl_region_to_json(struct cxl_region *region,
 					     unsigned long flags)
 {
+	enum cxl_decoder_mode mode = cxl_region_get_mode(region);
 	const char *devname = cxl_region_get_devname(region);
 	struct json_object *jregion, *jobj;
 	u64 val;
@@ -853,6 +854,12 @@ struct json_object *util_cxl_region_to_json(struct cxl_region *region,
 			json_object_object_add(jregion, "size", jobj);
 	}
 
+	if (mode != CXL_DECODER_MODE_NONE) {
+		jobj = json_object_new_string(cxl_decoder_mode_name(mode));
+		if (jobj)
+			json_object_object_add(jregion, "type", jobj);
+	}
+
 	val = cxl_region_get_interleave_ways(region);
 	if (val < INT_MAX) {
 		jobj = json_object_new_int(val);
diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
index 6bc0810..9832d09 100644
--- a/cxl/lib/libcxl.sym
+++ b/cxl/lib/libcxl.sym
@@ -242,3 +242,8 @@ global:
 	cxl_target_get_firmware_node;
 	cxl_dport_get_firmware_node;
 } LIBCXL_3;
+
+LIBCXL_5 {
+global:
+	cxl_region_get_mode;
+} LIBCXL_4;

-- 
2.39.1


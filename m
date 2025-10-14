Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ADD621E0AD;
	Tue, 14 Oct 2025 18:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760466975; cv=none; b=jp6lME24o7L6Jfsk9mY0/wWoFwYqDBSUPOw21p43c6ULw3sg75qQqinsoqJNAwpTkdlqdMM+CO58K303ZXy0mMmX9md5/bwq+QYL8hrsN8Hpl7V7ePZ4bbZfH9a8v8Fvby3fG76N78lrPCbX43x7SjEn3zLHUsfIteVozZ8kRvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760466975; c=relaxed/simple;
	bh=GUTdYF0h43Ye6bYurXtSBA08HW0HtwtpZFiTIVqD/Qg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HeUVwOoFGiE15/4QST2g0sdQCLy1H28vzhflIV2MknSvwJPSp8joV4TaOIA/OTxUnQvncnY3FLUUcP6Y8eXZdcxXXIy/4eoz3JgjN4uLOj5mnOxaonQuGzqrH/K1zJa2o/VKBT/66Ns69dQFj1PhvvxczwM1rLu9c/6eVuRIBRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3468C4CEF9;
	Tue, 14 Oct 2025 18:36:14 +0000 (UTC)
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: alison.schofield@intel.com,
	vishal.l.verma@intel.com
Subject: [NDCTL PATCH] cxl: Add support for extended linear cache
Date: Tue, 14 Oct 2025 11:36:13 -0700
Message-ID: <20251014183613.1699995-1-dave.jiang@intel.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add the retrieval of extended linear cache if the sysfs attribute exists
and the libcxl function that retrieves the size of the extended linear
cache. Support for cxl list also is added and presents the json
attribute if the extended linear cache size is greater than 0.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 cxl/json.c         | 10 ++++++++++
 cxl/lib/libcxl.c   | 10 ++++++++++
 cxl/lib/libcxl.sym |  5 +++++
 cxl/lib/private.h  |  1 +
 cxl/libcxl.h       |  2 ++
 5 files changed, 28 insertions(+)

diff --git a/cxl/json.c b/cxl/json.c
index bde4589065e7..e9cb88afa43f 100644
--- a/cxl/json.c
+++ b/cxl/json.c
@@ -994,6 +994,16 @@ struct json_object *util_cxl_region_to_json(struct cxl_region *region,
 			json_object_object_add(jregion, "size", jobj);
 	}
 
+	val = cxl_region_get_extended_linear_cache_size(region);
+	if (val > 0) {
+		jobj = util_json_object_size(val, flags);
+		if (jobj) {
+			json_object_object_add(jregion,
+					       "extended_linear_cache_size",
+					       jobj);
+		}
+	}
+
 	if (mode != CXL_DECODER_MODE_NONE) {
 		jobj = json_object_new_string(cxl_decoder_mode_name(mode));
 		if (jobj)
diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index cafde1cee4e8..32728de9cab6 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -585,6 +585,10 @@ static void *add_cxl_region(void *parent, int id, const char *cxlregion_base)
 	else
 		region->size = strtoull(buf, NULL, 0);
 
+	sprintf(path, "%s/extended_linear_cache_size", cxlregion_base);
+	if (sysfs_read_attr(ctx, path, buf) == 0)
+		region->cache_size = strtoull(buf, NULL, 0);
+
 	sprintf(path, "%s/resource", cxlregion_base);
 	if (sysfs_read_attr(ctx, path, buf) == 0)
 		resource = strtoull(buf, NULL, 0);
@@ -744,6 +748,12 @@ CXL_EXPORT unsigned long long cxl_region_get_size(struct cxl_region *region)
 	return region->size;
 }
 
+CXL_EXPORT unsigned long long
+cxl_region_get_extended_linear_cache_size(struct cxl_region *region)
+{
+	return region->cache_size;
+}
+
 CXL_EXPORT unsigned long long cxl_region_get_resource(struct cxl_region *region)
 {
 	return region->start;
diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
index e01a676cdeb9..36a93c3c262a 100644
--- a/cxl/lib/libcxl.sym
+++ b/cxl/lib/libcxl.sym
@@ -300,3 +300,8 @@ LIBCXL_10 {
 global:
 	cxl_memdev_is_port_ancestor;
 } LIBCXL_9;
+
+LIBCXL_11 {
+global:
+	cxl_region_get_extended_linear_cache_size;
+} LIBCXL_10;
diff --git a/cxl/lib/private.h b/cxl/lib/private.h
index 7d5a1bcc14ac..542cdb7eec7c 100644
--- a/cxl/lib/private.h
+++ b/cxl/lib/private.h
@@ -174,6 +174,7 @@ struct cxl_region {
 	uuid_t uuid;
 	u64 start;
 	u64 size;
+	u64 cache_size;
 	unsigned int interleave_ways;
 	unsigned int interleave_granularity;
 	enum cxl_decode_state decode_state;
diff --git a/cxl/libcxl.h b/cxl/libcxl.h
index 54bc025b121d..9371aac943fb 100644
--- a/cxl/libcxl.h
+++ b/cxl/libcxl.h
@@ -327,6 +327,8 @@ int cxl_region_get_id(struct cxl_region *region);
 const char *cxl_region_get_devname(struct cxl_region *region);
 void cxl_region_get_uuid(struct cxl_region *region, uuid_t uu);
 unsigned long long cxl_region_get_size(struct cxl_region *region);
+unsigned long long
+cxl_region_get_extended_linear_cache_size(struct cxl_region *region);
 unsigned long long cxl_region_get_resource(struct cxl_region *region);
 enum cxl_decoder_mode cxl_region_get_mode(struct cxl_region *region);
 unsigned int cxl_region_get_interleave_ways(struct cxl_region *region);

base-commit: 38f04b06ac0b0d116b24cefc603cdeb479ab205b
-- 
2.51.0


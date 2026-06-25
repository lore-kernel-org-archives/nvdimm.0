Received: from mail-dl1-f42.google.com (mail-dl1-f42.google.com [74.125.82.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CB433E0220
	for <nvdimm@lists.linux.dev>; Thu, 25 Jun 2026 12:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782389598; cv=none; b=WuL6XrDQJnn5yEtl3Oruei4grgnaqht+ddMH6Zv9bViMYovFeEWZ3sFbN/BZF+HXRWLNzRaWlL07FKAlViPKObqIsPRQdqYaLTcq6LGE/SXJa2jDijZM+szHsaoVbZUB8r8UXnI4RZFaILt6eW1TmGSDaPLGIGTeqBCkHVdeeTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782389598; c=relaxed/simple;
	bh=NGqG0z5kg5hD+sbahy7l1//i5IIwDROx1lw8ryP0hm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n2YkpayIr2SUIiGMqufPFnGuq3nq50GuDPo42eJSWSCimgopm+O+NSbMrxX3elgxV0ut9iNov2uvqbQnizsgl+vKNraBwyi3VvTKRBmTTYT9FjjXHcf1O+isPD/xQ8rz2QiKXYy6uQnGN4zmog2qdKsvwoTDYoyEDhtnubXhgP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e7+2godW; arc=none smtp.client-ip=74.125.82.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e7+2godW"
Received: by mail-dl1-f42.google.com with SMTP id a92af1059eb24-1397e093f90so6206474c88.1
        for <nvdimm@lists.linux.dev>; Thu, 25 Jun 2026 05:13:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782389597; x=1782994397; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nLN4RMNO6Z04sqs9IuRaj34hm6j4WxJm7vW3NC89bcE=;
        b=e7+2godWZtjB9VnkZ7ReKst5jIiRQUmvwLqXMrbVJtNyuyZIak8n/3hYxJFTho9Coq
         1rMK0zCzHYj9aJ2ccDnEd3p5uSuan7oo1E5s9fT1UKulnMlAxY67CUDodXlhQcmnF9HA
         ki9qctzzTQgFTnW8kDT5I+EaqP9YJD9WYhrF14EIhtPgkzOX9lnVnRQDVmwO6T1vK3RA
         X+7p2rlKasNR/doAnh282mD4apX+ttDOXSONtdwIB6snN5cTpRB6BjYUdJdtUZHWahHO
         D8PKE++7jjSJcpwxv8o7UXhC0CikNUEpVY8yt6fbgYvxYuSgnCKZ9PSoa+fXV2/ySAU6
         akHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782389597; x=1782994397;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nLN4RMNO6Z04sqs9IuRaj34hm6j4WxJm7vW3NC89bcE=;
        b=nJCrbRlANOhtwAmDGkVrgi/7FnKbBIw75t5By2hDpEkvNveIfDM+cu53pVEGFYg+Wm
         SbOAA7+P0pgI1mGVlmHnfuCxqs7jZvS7m5HS6SeA4Z3O7t3i9bjnMFp/LJHGyNSHeEqX
         4SrUDeZhMXMVgKr1tKOYIdtXhhn3ogkDyTgRq1DZbGiuqoOYu/oujTkiO9hNWFSJ6X2p
         cpKq31gAr2LoTcQYiMWWpQfeQtJ4Z+O2BXFNIwPTajtJK3ZWDrn19k9kVFBdjVlLCDdv
         XIewAr6mDwtLNDRSx8i6MQcqUhllIfbWWPMYGx/qva2Vp/k0OM/ksIB2fiTcDvKaIQdC
         uEBw==
X-Gm-Message-State: AOJu0YykWDulg32NjKjAHvPipUf0xf78P37tE2FVKtA+FInWr4tObsqe
	zZyrdywHlVaCXkUiUpY1x0ZO0ArNee1TF4x/XOHKHVhHpakEUmrRVQie
X-Gm-Gg: AfdE7ckJv2eerAWxkQJpHrT9yIWhI+jCkRC5wdNDdcOqvDw5ZlAfVOBI6btImXR8uXG
	COnwK+o4K5eLXYjRD68gA5SCEkIqm1mhawbtaBYCyY4h4pvyGqOYYtEaGkEVfRWSNbfNsdH7506
	8qf9eprSUZDmhEhgv7Czkzgpv8zOM+np5J/ZUeI+lsNqWLVxkSinRfF+y+8TEACoD5IlPx1NAYG
	DXEvfPRmQLAQS578UUJaiKnRTpNLk6fVHMCACeE4nh2AOs4Pm+5vd8EMHBLeNIbXH7TTo1yG/An
	yuDc2BbGgLlSJFzX/mLtBtJYOBdWQpxY6fDsp4mJkp9ywcyRpoWHoFpNbmAOiSybLV2tuP3280D
	HPAkijP2dr/2c3voeEmECslB8V2aofn54H81ETzUG8c7j0U4Kq65tik5v0p0oZth+MuXf5lPfLE
	g3r1DrIN2qIIl2Tlo8TfDqDbhnsxgjzwZuYfVIg+iEPW8Dn8syLw8kTh4xxwqmQNpzpwD5
X-Received: by 2002:a05:7022:6299:b0:138:407c:1d20 with SMTP id a92af1059eb24-139dbadf918mr2191847c88.35.1782389596491;
        Thu, 25 Jun 2026 05:13:16 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-139d8f77602sm7422206c88.8.2026.06.25.05.13.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2026 05:13:16 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
To: linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: nvdimm@lists.linux.dev,
	Dan Williams <djbw@kernel.org>,
	Jonathan Cameron <jic23@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dave Jiang <dave.jiang@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Ira Weiny <iweiny@kernel.org>,
	Alison Schofield <alison.schofield@intel.com>,
	John Groves <John@Groves.net>,
	Gregory Price <gourry@gourry.net>,
	Anisa Su <anisa.su@samsung.com>
Subject: [NDCTL PATCH v7 3/5] cxl/region: Add extent output to region query
Date: Thu, 25 Jun 2026 05:09:37 -0700
Message-ID: <20260625121242.603807-4-anisa.su@samsung.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260625121242.603807-1-anisa.su@samsung.com>
References: <20260625121242.603807-1-anisa.su@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ira Weiny <iweiny@kernel.org>

DCD regions have 0 or more extents.  The ability to list those and their
properties is useful to end users.

Add an option for extent output to region queries.  An example of this
is:

	$ ./build/cxl/cxl list -r 8 -Nu
	{
	  "region":"region8",
	  ...
	  "type":"dc",
	  ...
	  "extents":[
	    {
	      "offset":"0x10000000",
	      "length":"64.00 MiB (67.11 MB)",
	      "uuid":"00000000-0000-0000-0000-000000000000"
	    },
	    {
	      "offset":"0x8000000",
	      "length":"64.00 MiB (67.11 MB)",
	      "uuid":"00000000-0000-0000-0000-000000000000"
	    }
	  ]
	}

Signed-off-by: Ira Weiny <iweiny@kernel.org>
Signed-off-by: Anisa Su <anisa.su@samsung.com>

---
Changes:
1. guard util_cxl_extents_append_json() on cxl_extent_get_first(region) != NULL
so emmpty extents array doesn't show up for non-DC regions
---
 Documentation/cxl/cxl-list.txt | 29 ++++++++++++++++++++
 cxl/filter.h                   |  3 ++
 cxl/json.c                     | 50 ++++++++++++++++++++++++++++++++++
 cxl/json.h                     |  3 ++
 cxl/list.c                     |  3 ++
 util/json.h                    |  1 +
 6 files changed, 89 insertions(+)

diff --git a/Documentation/cxl/cxl-list.txt b/Documentation/cxl/cxl-list.txt
index 193860b..7512687 100644
--- a/Documentation/cxl/cxl-list.txt
+++ b/Documentation/cxl/cxl-list.txt
@@ -426,6 +426,35 @@ OPTIONS
 }
 ----
 
+-N::
+--extents::
+	Append Dynamic Capacity extent information.
+----
+13:34:28 > ./build/cxl/cxl list -r 8 -Nu
+{
+  "region":"region8",
+  "resource":"0xf030000000",
+  "size":"512.00 MiB (536.87 MB)",
+  "type":"dc",
+  "interleave_ways":1,
+  "interleave_granularity":256,
+  "decode_state":"commit",
+  "extents":[
+    {
+      "offset":"0x10000000",
+      "length":"64.00 MiB (67.11 MB)",
+      "uuid":"00000000-0000-0000-0000-000000000000"
+    },
+    {
+      "offset":"0x8000000",
+      "length":"64.00 MiB (67.11 MB)",
+      "uuid":"00000000-0000-0000-0000-000000000000"
+    }
+  ]
+}
+----
+
+
 -r::
 --region::
 	Specify CXL region device name(s), or device id(s), to filter the listing.
diff --git a/cxl/filter.h b/cxl/filter.h
index 70463c4..30e7fe2 100644
--- a/cxl/filter.h
+++ b/cxl/filter.h
@@ -31,6 +31,7 @@ struct cxl_filter_params {
 	bool alert_config;
 	bool dax;
 	bool media_errors;
+	bool extents;
 	int verbose;
 	struct log_ctx ctx;
 };
@@ -93,6 +94,8 @@ static inline unsigned long cxl_filter_to_flags(struct cxl_filter_params *param)
 		flags |= UTIL_JSON_DAX | UTIL_JSON_DAX_DEVS;
 	if (param->media_errors)
 		flags |= UTIL_JSON_MEDIA_ERRORS;
+	if (param->extents)
+		flags |= UTIL_JSON_EXTENTS;
 	return flags;
 }
 
diff --git a/cxl/json.c b/cxl/json.c
index e832982..7b856f9 100644
--- a/cxl/json.c
+++ b/cxl/json.c
@@ -1022,6 +1022,53 @@ void util_cxl_mappings_append_json(struct json_object *jregion,
 	json_object_object_add(jregion, "mappings", jmappings);
 }
 
+void util_cxl_extents_append_json(struct json_object *jregion,
+				  struct cxl_region *region,
+				  unsigned long flags)
+{
+	struct json_object *jextents;
+	struct cxl_region_extent *extent;
+
+	if (!cxl_extent_get_first(region))
+		return;
+
+	jextents = json_object_new_array();
+	if (!jextents)
+		return;
+
+	cxl_extent_foreach(region, extent) {
+		struct json_object *jextent, *jobj;
+		unsigned long long val;
+		char uuid_str[40];
+		uuid_t uuid;
+
+		jextent = json_object_new_object();
+		if (!jextent)
+			continue;
+
+		val = cxl_extent_get_offset(extent);
+		jobj = util_json_object_hex(val, flags);
+		if (jobj)
+			json_object_object_add(jextent, "offset", jobj);
+
+		val = cxl_extent_get_length(extent);
+		jobj = util_json_object_size(val, flags);
+		if (jobj)
+			json_object_object_add(jextent, "length", jobj);
+
+		cxl_extent_get_uuid(extent, uuid);
+		uuid_unparse(uuid, uuid_str);
+		jobj = json_object_new_string(uuid_str);
+		if (jobj)
+			json_object_object_add(jextent, "uuid", jobj);
+
+		json_object_array_add(jextents, jextent);
+		json_object_set_userdata(jextent, extent, NULL);
+	}
+
+	json_object_object_add(jregion, "extents", jextents);
+}
+
 struct json_object *util_cxl_region_to_json(struct cxl_region *region,
 					     unsigned long flags)
 {
@@ -1126,6 +1173,9 @@ struct json_object *util_cxl_region_to_json(struct cxl_region *region,
 		}
 	}
 
+	if (flags & UTIL_JSON_EXTENTS)
+		util_cxl_extents_append_json(jregion, region, flags);
+
 	if (cxl_region_qos_class_mismatch(region)) {
 		jobj = json_object_new_boolean(true);
 		if (jobj)
diff --git a/cxl/json.h b/cxl/json.h
index eb7572b..f9c07ab 100644
--- a/cxl/json.h
+++ b/cxl/json.h
@@ -20,6 +20,9 @@ struct json_object *util_cxl_region_to_json(struct cxl_region *region,
 void util_cxl_mappings_append_json(struct json_object *jregion,
 				  struct cxl_region *region,
 				  unsigned long flags);
+void util_cxl_extents_append_json(struct json_object *jregion,
+				  struct cxl_region *region,
+				  unsigned long flags);
 void util_cxl_targets_append_json(struct json_object *jdecoder,
 				  struct cxl_decoder *decoder,
 				  const char *ident, const char *serial,
diff --git a/cxl/list.c b/cxl/list.c
index 0b25d78..47d1351 100644
--- a/cxl/list.c
+++ b/cxl/list.c
@@ -59,6 +59,8 @@ static const struct option options[] = {
 		    "include alert configuration information"),
 	OPT_BOOLEAN('L', "media-errors", &param.media_errors,
 		    "include media-error information "),
+	OPT_BOOLEAN('N', "extents", &param.extents,
+		    "include extent information (Dynamic Capacity regions only)"),
 	OPT_INCR('v', "verbose", &param.verbose, "increase output detail"),
 #ifdef ENABLE_DEBUG
 	OPT_BOOLEAN(0, "debug", &debug, "debug list walk"),
@@ -135,6 +137,7 @@ int cmd_list(int argc, const char **argv, struct cxl_ctx *ctx)
 		param.decoders = true;
 		param.targets = true;
 		param.regions = true;
+		param.extents = true;
 		/*fallthrough*/
 	case 0:
 		break;
diff --git a/util/json.h b/util/json.h
index 560f845..79ae324 100644
--- a/util/json.h
+++ b/util/json.h
@@ -21,6 +21,7 @@ enum util_json_flags {
 	UTIL_JSON_TARGETS	= (1 << 11),
 	UTIL_JSON_PARTITION	= (1 << 12),
 	UTIL_JSON_ALERT_CONFIG	= (1 << 13),
+	UTIL_JSON_EXTENTS	= (1 << 14),
 };
 
 void util_display_json_array(FILE *f_out, struct json_object *jarray,
-- 
2.43.0


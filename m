Received: from mail-dy1-f181.google.com (mail-dy1-f181.google.com [74.125.82.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DC54388866
	for <nvdimm@lists.linux.dev>; Sat, 23 May 2026 09:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779529864; cv=none; b=FX1Az/AhJ4q8G7iXaFKNfcuy3h8P7Pay4cLb+XCNPJMXc/jCWcBtKJaHFr35kP1S2qDP6wev81pqMW1wn7jeR/nOqtx3ZvYAOGUHFGmORg6uuCVBsdzmfC0EhClD5RERB0xfWvCxZ/XfDcLszhmnrfDbV9nxQY9nASvRAm/Mr/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779529864; c=relaxed/simple;
	bh=XAtL8ZNQB+UMV46RTZI81AvySwEc98mjFW4sJB0Qh1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LXH6MFuHtCy+Xkjmx5QctPSOa8i15eoLpHAtRD93tCwBnpykESdWsRo4p2ZgKyPq64W2xd4++62Lks6fV6LtZWsN1foI6A0anVRwvFZgIzFkgijJT+IyPw8OCNPebaAwn51b69HTZ+rUapWG1Zzb8T2F3xMuoLPy+qkyhBQ5/do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=oBakKAP9; arc=none smtp.client-ip=74.125.82.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oBakKAP9"
Received: by mail-dy1-f181.google.com with SMTP id 5a478bee46e88-3044857f09aso2983000eec.1
        for <nvdimm@lists.linux.dev>; Sat, 23 May 2026 02:51:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779529861; x=1780134661; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8vCXGNdEs9vHqblHAZzawp3kqEBF6AaU1uhZMV0FElU=;
        b=oBakKAP9jkM8C8j4gk8NfKsIG0R9cACBB8/hptNd2KHHxUobG2pPEXHr0vCviJYc5D
         g+O8Sc1+v1gyr1eyKKbPLqYSoy0xL8AcaGVz9yeXWbBl2/efz/whNR4eZAjwaLocPS5I
         m2d1FrJBrsoMJpfXQnTHtEfZwN2MQwVqlI49cdL7iAJR/q8izVefO2RrK+wNFV3jyC51
         Zn3+GpR0zh4TAjUq4zkBHg4LS0iWDmmxNFA3VAB7+0WTZcdJbVjJfviarAJ+eKxN9piy
         ZIv6pePZF2L1J3F4kBkcgMvfzyebqhXKQJwYbQwwNW9OSO+18zK+0e+zmqTSUHTNy4I7
         O6bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779529861; x=1780134661;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8vCXGNdEs9vHqblHAZzawp3kqEBF6AaU1uhZMV0FElU=;
        b=PRHNU/DN7MegF5ZW5hj2r7CxBQe2YB/etN743BD7CTuveBA9kNe19TlQO+CXgQv5Ea
         bTBOY4isxInREvraC+jPICPB/Lf7BYs6tBCIB/x2m1UIBu1lEyxz0oGMgN+LdwFmo22l
         f/X20T2Pu71G48nPdmXny4ODj7eOwqWDgRkVMyfguVZk7cdxRh9Eeucx8hsRkyj36tTj
         sXAcwK/S3fWNjgSX/0fVXGp5s3w2cQo8iQL3gUmpilrHuLUjBU82X8cNracYfOXjRMrX
         IcJYqqM7AC5oDbAb7E9FZALP+ojuazzy/PGXCDkpdead+d3ll9ldfxoTI+wWbrXjAp6H
         6m/g==
X-Gm-Message-State: AOJu0YzxscCOTqt451SmgeM7Z3bE4rBKIvHvIJhjn2G/ZvSQc3/sL9Am
	+BVW4llRjiqrupfLC8dHN1RmFvc2yRb6UysyUVI8OLjQ3pKCR1s/Ynsi
X-Gm-Gg: Acq92OGzMlcgpy06IC0vcTJVOTTSUUxhKZ+Ky+wi9Imr7bYCrBG0mRYMbA69yb+oe4p
	MamgGLwF+W7QQZXKK1V7nWy3RljaViV9ooA26pO+Vlcq7J5ihVET7rw+O9lLo1+pM01BIf0WhN2
	iGQKgivhJ4kqRhJzSN4SmMQ6o+igNxZ2B9LRkKGNLemwD+IJOf+hE2Bx/pl3CH1dy8xIVLOK5Li
	8qLGArukL7g0XB86hHm/AkfinX9PYeSsztj5kQvZBr4XD8it9aC5gh+s4kHUA3oLUnK14lDZdg2
	NCrrX4t+uAiBr5i5Q4fcb5cz2XRi33/KdWl8ZGNUX3npO2su/9Fmqps3C//wUZyifph8U7gHU9G
	YrmtJmuIkumU5VDXfrvZFbKibPijmDpxLidsDJWYOWEMaktL1mRvXbArG2yJlzG5NZzN8sXK1z3
	C1KSqo77iClU1JulJxZrMhxU4DmCg4BtYbikCh9zP+onGaxQeMp9+oqBQcyeUIcRQMByWVl56S8
	oyNuCxaDOzoB2D95g==
X-Received: by 2002:a05:7300:ef89:b0:2da:45f8:1b41 with SMTP id 5a478bee46e88-30449051989mr3513344eec.19.1779529861205;
        Sat, 23 May 2026 02:51:01 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3045225b7b6sm4595756eec.25.2026.05.23.02.51.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 May 2026 02:51:00 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
To: linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: nvdimm@lists.linux.dev,
	Dan Williams <djbw@kernel.org>,
	Jonathan Cameron <jic23@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <iweiny@kernel.org>,
	Alison Schofield <alison.schofield@intel.com>,
	John Groves <John@Groves.net>,
	Gregory Price <gourry@gourry.net>,
	Ira Weiny <ira.weiny@intel.com>
Subject: [PATCH v6 5/7] cxl/region: Add extent output to region query
Date: Sat, 23 May 2026 02:50:40 -0700
Message-ID: <20260523095043.471098-6-anisa.su@samsung.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260523095043.471098-1-anisa.su@samsung.com>
References: <20260523095043.471098-1-anisa.su@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ira Weiny <ira.weiny@intel.com>

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
	      "tag":"00000000-0000-0000-0000-000000000000"
	    },
	    {
	      "offset":"0x8000000",
	      "length":"64.00 MiB (67.11 MB)",
	      "tag":"00000000-0000-0000-0000-000000000000"
	    }
	  ]
	}

Signed-off-by: Ira Weiny <ira.weiny@intel.com>

---
Changes:
[iweiny: s/tag/uuid/]
---
 Documentation/cxl/cxl-list.txt | 29 +++++++++++++++++++++
 cxl/filter.h                   |  3 +++
 cxl/json.c                     | 47 ++++++++++++++++++++++++++++++++++
 cxl/json.h                     |  3 +++
 cxl/list.c                     |  3 +++
 util/json.h                    |  1 +
 6 files changed, 86 insertions(+)

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
index e94c809..7922b32 100644
--- a/cxl/json.c
+++ b/cxl/json.c
@@ -1022,6 +1022,50 @@ void util_cxl_mappings_append_json(struct json_object *jregion,
 	json_object_object_add(jregion, "mappings", jmappings);
 }
 
+void util_cxl_extents_append_json(struct json_object *jregion,
+				  struct cxl_region *region,
+				  unsigned long flags)
+{
+	struct json_object *jextents;
+	struct cxl_region_extent *extent;
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
@@ -1126,6 +1170,9 @@ struct json_object *util_cxl_region_to_json(struct cxl_region *region,
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


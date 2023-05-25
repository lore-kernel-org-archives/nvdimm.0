Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14C3B1EA8B
	for <nvdimm@lists.linux.dev>; Thu, 25 May 2023 21:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685050839; x=1716586839;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VBusEgp/qdttRBFMETL2Tcjm2v6lrGYiex0SFBZqxGI=;
  b=V2OeZ2IrAz7qgkITFwxT9B7Hk+hcx6lF7GcC8LG33+lQ5s/3mG/tTbGd
   iezQ3iXpEnjnT9JblwPV5IvTHfQY6SkS1cb02Ir5ZJl4RW17dBnj4SqL7
   5Z7aARLbiY/lonMFwRA4bTU0Xvd7GMW58Ag6g356eOxS6ZW6rYQv9JL2F
   EOqGf9sZzxa4CSniRrWeTQi6KJT6vE4qjB5ntp5CcMMMU76U4ZRU5nPCJ
   Aj3lKxtCgU3fnJ9K8L3Hqhl9/M6BjLZBTRXVzZfKG93JElHY0nKvjsFau
   qm1pnxbGwg5FxPsedQvLfJ46ZnL/AQXRyEWct6lly98pokrrPsQONgToH
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10721"; a="351544754"
X-IronPort-AV: E=Sophos;i="6.00,192,1681196400"; 
   d="scan'208";a="351544754"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2023 14:40:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10721"; a="879297336"
X-IronPort-AV: E=Sophos;i="6.00,192,1681196400"; 
   d="scan'208";a="879297336"
Received: from djiang5-mobl3.amr.corp.intel.com (HELO [192.168.1.177]) ([10.212.85.172])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2023 14:40:38 -0700
Subject: [ndctl PATCH v2 1/3] ndctl: cxl: Add QoS class retrieval for the root
 decoder
From: Dave Jiang <dave.jiang@intel.com>
To: vishal.l.verma@intel.com
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Date: Thu, 25 May 2023 14:40:37 -0700
Message-ID: <168505083769.2768411.11179519312272146947.stgit@djiang5-mobl3>
In-Reply-To: <168505076089.2768411.10498775803334230215.stgit@djiang5-mobl3>
References: <168505076089.2768411.10498775803334230215.stgit@djiang5-mobl3>
User-Agent: StGit/1.5
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Add libcxl API to retrieve the QoS class for the root decoder. Also add
support to display the QoS class for the root decoder through the 'cxl
list' command. The qos_class is displayed behind -vvv verbose level.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>

---
v2:
- Don't display qos class if not valid. (Alison)
---
 cxl/filter.h       |    4 ++++
 cxl/json.c         |   10 ++++++++++
 cxl/lib/libcxl.c   |   14 ++++++++++++++
 cxl/lib/libcxl.sym |    4 ++++
 cxl/lib/private.h  |    1 +
 cxl/libcxl.h       |    3 +++
 cxl/list.c         |    1 +
 util/json.h        |    1 +
 8 files changed, 38 insertions(+)

diff --git a/cxl/filter.h b/cxl/filter.h
index c486514cf06e..b6ed94139738 100644
--- a/cxl/filter.h
+++ b/cxl/filter.h
@@ -29,6 +29,7 @@ struct cxl_filter_params {
 	bool partition;
 	bool alert_config;
 	bool dax;
+	bool qos;
 	int verbose;
 	struct log_ctx ctx;
 };
@@ -83,6 +84,9 @@ static inline unsigned long cxl_filter_to_flags(struct cxl_filter_params *param)
 		flags |= UTIL_JSON_ALERT_CONFIG;
 	if (param->dax)
 		flags |= UTIL_JSON_DAX | UTIL_JSON_DAX_DEVS;
+	if (param->qos)
+		flags |= UTIL_JSON_QOS_CLASS;
+
 	return flags;
 }
 
diff --git a/cxl/json.c b/cxl/json.c
index 9a4b5c77c850..293ba807b44b 100644
--- a/cxl/json.c
+++ b/cxl/json.c
@@ -760,6 +760,16 @@ struct json_object *util_cxl_decoder_to_json(struct cxl_decoder *decoder,
 					       jobj);
 	}
 
+	if ((flags & UTIL_JSON_QOS_CLASS) && cxl_port_is_root(port)) {
+		int qos_class = cxl_root_decoder_get_qos_class(decoder);
+
+		if (qos_class != CXL_QOS_CLASS_NONE) {
+			jobj = json_object_new_int(qos_class);
+			if (jobj)
+				json_object_object_add(jdecoder, "qos_class", jobj);
+		}
+	}
+
 	json_object_set_userdata(jdecoder, decoder, NULL);
 	return jdecoder;
 }
diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index 769cd8a75de9..6312676a6d22 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -1907,6 +1907,12 @@ static void *add_cxl_decoder(void *parent, int id, const char *cxldecoder_base)
 	else
 		decoder->interleave_ways = strtoul(buf, NULL, 0);
 
+	sprintf(path, "%s/qos_class", cxldecoder_base);
+	if (sysfs_read_attr(ctx, path, buf) < 0)
+		decoder->qos_class = CXL_QOS_CLASS_NONE;
+	else
+		decoder->qos_class = atoi(buf);
+
 	switch (port->type) {
 	case CXL_PORT_ENDPOINT:
 		sprintf(path, "%s/dpa_resource", cxldecoder_base);
@@ -2101,6 +2107,14 @@ CXL_EXPORT unsigned long long cxl_decoder_get_size(struct cxl_decoder *decoder)
 	return decoder->size;
 }
 
+CXL_EXPORT int cxl_root_decoder_get_qos_class(struct cxl_decoder *decoder)
+{
+	if (!cxl_port_is_root(decoder->port))
+		return -EINVAL;
+
+	return decoder->qos_class;
+}
+
 CXL_EXPORT unsigned long long
 cxl_decoder_get_dpa_resource(struct cxl_decoder *decoder)
 {
diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
index c6545c717d50..134406258ddf 100644
--- a/cxl/lib/libcxl.sym
+++ b/cxl/lib/libcxl.sym
@@ -250,3 +250,7 @@ global:
 	cxl_region_get_daxctl_region;
 	cxl_port_get_parent_dport;
 } LIBCXL_4;
+
+LIBCXL_6 {
+	cxl_root_decoder_get_qos_class;
+} LIBCXL_5;
diff --git a/cxl/lib/private.h b/cxl/lib/private.h
index d49b560bead3..b00aa4752de5 100644
--- a/cxl/lib/private.h
+++ b/cxl/lib/private.h
@@ -128,6 +128,7 @@ struct cxl_decoder {
 	struct list_head targets;
 	struct list_head regions;
 	struct list_head stale_regions;
+	int qos_class;
 };
 
 enum cxl_decode_state {
diff --git a/cxl/libcxl.h b/cxl/libcxl.h
index 0218d730298f..9684a8571e88 100644
--- a/cxl/libcxl.h
+++ b/cxl/libcxl.h
@@ -136,6 +136,8 @@ struct cxl_dport *cxl_port_get_dport_by_memdev(struct cxl_port *port,
 	for (dport = cxl_dport_get_first(port); dport != NULL;                 \
 	     dport = cxl_dport_get_next(dport))
 
+#define CXL_QOS_CLASS_NONE		-1
+
 struct cxl_decoder;
 struct cxl_decoder *cxl_decoder_get_first(struct cxl_port *port);
 struct cxl_decoder *cxl_decoder_get_next(struct cxl_decoder *decoder);
@@ -147,6 +149,7 @@ unsigned long long cxl_decoder_get_dpa_resource(struct cxl_decoder *decoder);
 unsigned long long cxl_decoder_get_dpa_size(struct cxl_decoder *decoder);
 unsigned long long
 cxl_decoder_get_max_available_extent(struct cxl_decoder *decoder);
+int cxl_root_decoder_get_qos_class(struct cxl_decoder *decoder);
 
 enum cxl_decoder_mode {
 	CXL_DECODER_MODE_NONE,
diff --git a/cxl/list.c b/cxl/list.c
index c01154e7723e..57365d245850 100644
--- a/cxl/list.c
+++ b/cxl/list.c
@@ -118,6 +118,7 @@ int cmd_list(int argc, const char **argv, struct cxl_ctx *ctx)
 		param.partition = true;
 		param.alert_config = true;
 		param.dax = true;
+		param.qos = true;
 		/* fallthrough */
 	case 2:
 		param.idle = true;
diff --git a/util/json.h b/util/json.h
index ea370df4d1b7..b07055005084 100644
--- a/util/json.h
+++ b/util/json.h
@@ -21,6 +21,7 @@ enum util_json_flags {
 	UTIL_JSON_TARGETS	= (1 << 11),
 	UTIL_JSON_PARTITION	= (1 << 12),
 	UTIL_JSON_ALERT_CONFIG	= (1 << 13),
+	UTIL_JSON_QOS_CLASS	= (1 << 14),
 };
 
 void util_display_json_array(FILE *f_out, struct json_object *jarray,



Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE9A01353F7
	for <nvdimm@lists.linux.dev>; Wed, 24 Jan 2024 20:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706129684; cv=none; b=P0wT/YPcmsza4aI3vM6kIOQ6M9pJmnQDJR5kRGKXTPeHtZ74tiV+KUofenT3jIt4YtlqhmScmDN9sBUXRbwtiXgA72bkGCpmZYk+4+zuFBQnSCdmSVIkHxHo0RGVui1UTQp7jWxSqyPsZI6H/P/RKLmT7yk466pS95dC2QqkdHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706129684; c=relaxed/simple;
	bh=RRgYTbTGJgj7ds2qiWMgw3dA5temJ98eeP73+jUyyA8=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RFpsL60GAtjUtKB/ir2E5YAaWu24OknflfkxKaa5TqIwXnUL0yuTR0PQsKWcbTEYYChEEVClfrPLiK5YwRuz79L814STCeakyeZFNGqe1McyzJIrTmp8D/qaDkyVbJQ6zEszeu3v+syWwa6hEIYD3+JghAhth0TAHNoh3gleQOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=c6Gmg402; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="c6Gmg402"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706129683; x=1737665683;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RRgYTbTGJgj7ds2qiWMgw3dA5temJ98eeP73+jUyyA8=;
  b=c6Gmg402J+DaV8+PINoANXK3K0jQIYwjGMpXSMHoxmv7X1vVuZm2dvTK
   DW9q9mTQ4bYZvnh4/G9t/d3BAfoBfuns7Es8OLMUlRY2qP7sjzcWjoXh7
   uLrH1+WjaLYLVQtjbLErcIgzxCxO9of90cb0ZgewXI3OtAyWDjfhVmSLx
   SsLiM0e7ScV/Ys1R2IvKHU2C/TLlAQtoH06lESNfppIvjeb8ysDvtLcXc
   ENBHUIcvUp2N7hTVYvHRuR+OsrP6l1aaRcRHoO/uiTQHAT/aSwYFjeBc3
   G5l8edFpD/qQHnz9SIO46r5/8RipVfes17X+T22JkMscWFmasvYTM/jC4
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="20524132"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="20524132"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2024 12:54:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="786538937"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="786538937"
Received: from djiang5-mobl3.amr.corp.intel.com (HELO [192.168.1.177]) ([10.209.164.29])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2024 12:54:42 -0800
Subject: [NDCTL PATCH v3 1/3] ndctl: cxl: Add QoS class retrieval for the root
 decoder
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Cc: vishal.l.verma@intel.com
Date: Wed, 24 Jan 2024 13:54:41 -0700
Message-ID: <170612968166.2745924.10491030984129768174.stgit@djiang5-mobl3>
In-Reply-To: <170612961495.2745924.4942817284170536877.stgit@djiang5-mobl3>
References: <170612961495.2745924.4942817284170536877.stgit@djiang5-mobl3>
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
v3:
- Rebase to latest pending branch
---
 cxl/filter.h       |    4 ++++
 cxl/json.c         |   10 ++++++++++
 cxl/lib/libcxl.c   |   14 ++++++++++++++
 cxl/lib/libcxl.sym |    1 +
 cxl/lib/private.h  |    1 +
 cxl/libcxl.h       |    3 +++
 cxl/list.c         |    1 +
 util/json.h        |    1 +
 8 files changed, 35 insertions(+)

diff --git a/cxl/filter.h b/cxl/filter.h
index 1241f72ccf62..3c5f9e8a0452 100644
--- a/cxl/filter.h
+++ b/cxl/filter.h
@@ -31,6 +31,7 @@ struct cxl_filter_params {
 	bool alert_config;
 	bool dax;
 	bool poison;
+	bool qos;
 	int verbose;
 	struct log_ctx ctx;
 };
@@ -91,6 +92,9 @@ static inline unsigned long cxl_filter_to_flags(struct cxl_filter_params *param)
 		flags |= UTIL_JSON_DAX | UTIL_JSON_DAX_DEVS;
 	if (param->poison)
 		flags |= UTIL_JSON_MEDIA_ERRORS;
+	if (param->qos)
+		flags |= UTIL_JSON_QOS_CLASS;
+
 	return flags;
 }
 
diff --git a/cxl/json.c b/cxl/json.c
index 6fb17582a1cb..48a43ddf14b0 100644
--- a/cxl/json.c
+++ b/cxl/json.c
@@ -1062,6 +1062,16 @@ struct json_object *util_cxl_decoder_to_json(struct cxl_decoder *decoder,
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
index 1537a33d370e..9a1ac7001803 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -2229,6 +2229,12 @@ static void *add_cxl_decoder(void *parent, int id, const char *cxldecoder_base)
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
@@ -2423,6 +2429,14 @@ CXL_EXPORT unsigned long long cxl_decoder_get_size(struct cxl_decoder *decoder)
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
index 2149f84d764e..384fea2c25e3 100644
--- a/cxl/lib/libcxl.sym
+++ b/cxl/lib/libcxl.sym
@@ -282,4 +282,5 @@ global:
 LIBCXL_8 {
 global:
 	cxl_memdev_wait_sanitize;
+	cxl_root_decoder_get_qos_class;
 } LIBCXL_7;
diff --git a/cxl/lib/private.h b/cxl/lib/private.h
index b26a8629e047..4847ff448f71 100644
--- a/cxl/lib/private.h
+++ b/cxl/lib/private.h
@@ -144,6 +144,7 @@ struct cxl_decoder {
 	struct list_head targets;
 	struct list_head regions;
 	struct list_head stale_regions;
+	int qos_class;
 };
 
 enum cxl_decode_state {
diff --git a/cxl/libcxl.h b/cxl/libcxl.h
index 352b3a866f63..e5c08da77f77 100644
--- a/cxl/libcxl.h
+++ b/cxl/libcxl.h
@@ -173,6 +173,8 @@ struct cxl_dport *cxl_port_get_dport_by_memdev(struct cxl_port *port,
 	for (dport = cxl_dport_get_first(port); dport != NULL;                 \
 	     dport = cxl_dport_get_next(dport))
 
+#define CXL_QOS_CLASS_NONE		-1
+
 struct cxl_decoder;
 struct cxl_decoder *cxl_decoder_get_first(struct cxl_port *port);
 struct cxl_decoder *cxl_decoder_get_next(struct cxl_decoder *decoder);
@@ -184,6 +186,7 @@ unsigned long long cxl_decoder_get_dpa_resource(struct cxl_decoder *decoder);
 unsigned long long cxl_decoder_get_dpa_size(struct cxl_decoder *decoder);
 unsigned long long
 cxl_decoder_get_max_available_extent(struct cxl_decoder *decoder);
+int cxl_root_decoder_get_qos_class(struct cxl_decoder *decoder);
 
 enum cxl_decoder_mode {
 	CXL_DECODER_MODE_NONE,
diff --git a/cxl/list.c b/cxl/list.c
index 13fef8569340..f6446f98c2bd 100644
--- a/cxl/list.c
+++ b/cxl/list.c
@@ -123,6 +123,7 @@ int cmd_list(int argc, const char **argv, struct cxl_ctx *ctx)
 		param.fw = true;
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



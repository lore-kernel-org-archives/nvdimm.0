Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3C5453A3
	for <nvdimm@lists.linux.dev>; Tue, 12 Jul 2022 19:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657652898; x=1689188898;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=R/HiYanKlcDyL1XhX9Xghwwfcblt81s6EZC3V86Gj74=;
  b=km7JRJUSORp2984t0ELCcdOlbmz3a/I05JisDxrGIf1vMiv2F0l8tMZP
   xAgDUqWz/HTd0td2lB96eJZr6B2fYh/iBgzmUsQuyLpxy7toHb+wbTktq
   2pJbC3ANmHqpx0QT9SLcwdBaQfROMf8+ISbx8WCJFDQ05V9V5ybZDu2E3
   6vNv/1VtPxuJQA6FtHeKfMlFlJKxxDMU+Z1nQA7OKmZ8H70eIspp1FhOe
   xgXZQMe+15nIq2QTs8fI5LO28X5zIbYFvpmcMYmc03o9HLzio4MjwLE8Q
   kDr3cLpxS3Mec4Nw9pqBFk2SRYYyFaodZQEkwAPc1HCPN2t7ih9WfMvk+
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10406"; a="348995662"
X-IronPort-AV: E=Sophos;i="5.92,266,1650956400"; 
   d="scan'208";a="348995662"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2022 12:08:04 -0700
X-IronPort-AV: E=Sophos;i="5.92,266,1650956400"; 
   d="scan'208";a="570316728"
Received: from sheyting-mobl3.amr.corp.intel.com (HELO [192.168.1.117]) ([10.212.147.156])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2022 12:08:04 -0700
Subject: [ndctl PATCH 07/11] cxl/list: Emit 'mode' for endpoint decoder
 objects
From: Dan Williams <dan.j.williams@intel.com>
To: vishal.l.verma@intel.com
Cc: alison.schofield@intel.com, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org
Date: Tue, 12 Jul 2022 12:08:04 -0700
Message-ID: <165765288431.435671.16717399045469099284.stgit@dwillia2-xfh>
In-Reply-To: <165765284365.435671.13173937566404931163.stgit@dwillia2-xfh>
References: <165765284365.435671.13173937566404931163.stgit@dwillia2-xfh>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

The 'mode' property of an endpoint decoder indicates the access
properties of the DPA (device physical address) mapped into HPA (host
physical address) by the decoder. Where the modes are 'none'
(decoder-disabled), 'ram' (voltaile memory), 'pmem' (persistent memory),
and 'mixed' (an unexpected, but possible, case where the decoder
straddles a mode / partition boundary).

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Documentation/cxl/lib/libcxl.txt |    9 +++++++++
 cxl/json.c                       |    8 ++++++++
 cxl/lib/libcxl.c                 |   30 ++++++++++++++++++++++++++++++
 cxl/lib/libcxl.sym               |    1 +
 cxl/lib/private.h                |    1 +
 cxl/libcxl.h                     |   23 +++++++++++++++++++++++
 6 files changed, 72 insertions(+)

diff --git a/Documentation/cxl/lib/libcxl.txt b/Documentation/cxl/lib/libcxl.txt
index 2aef489e8e12..90fe33887821 100644
--- a/Documentation/cxl/lib/libcxl.txt
+++ b/Documentation/cxl/lib/libcxl.txt
@@ -405,6 +405,15 @@ enum cxl_decoder_target_type {
 };
 
 cxl_decoder_get_target_type(struct cxl_decoder *decoder);
+
+enum cxl_decoder_mode {
+	CXL_DECODER_MODE_NONE,
+	CXL_DECODER_MODE_MIXED,
+	CXL_DECODER_MODE_PMEM,
+	CXL_DECODER_MODE_RAM,
+};
+enum cxl_decoder_mode cxl_decoder_get_mode(struct cxl_decoder *decoder);
+
 bool cxl_decoder_is_pmem_capable(struct cxl_decoder *decoder);
 bool cxl_decoder_is_volatile_capable(struct cxl_decoder *decoder);
 bool cxl_decoder_is_mem_capable(struct cxl_decoder *decoder);
diff --git a/cxl/json.c b/cxl/json.c
index 3f52d3bbff45..ae9c8126f14f 100644
--- a/cxl/json.c
+++ b/cxl/json.c
@@ -473,6 +473,8 @@ struct json_object *util_cxl_decoder_to_json(struct cxl_decoder *decoder,
 	}
 
 	if (cxl_port_is_endpoint(port)) {
+		enum cxl_decoder_mode mode = cxl_decoder_get_mode(decoder);
+
 		size = cxl_decoder_get_dpa_size(decoder);
 		val = cxl_decoder_get_dpa_resource(decoder);
 		if (size && val < ULLONG_MAX) {
@@ -488,6 +490,12 @@ struct json_object *util_cxl_decoder_to_json(struct cxl_decoder *decoder,
 				json_object_object_add(jdecoder, "dpa_size",
 						       jobj);
 		}
+
+		if (mode > CXL_DECODER_MODE_NONE) {
+			jobj = json_object_new_string(cxl_decoder_mode_name(mode));
+			if (jobj)
+				json_object_object_add(jdecoder, "mode", jobj);
+		}
 	}
 
 	if (cxl_port_is_root(port) && cxl_decoder_is_mem_capable(decoder)) {
diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index e4c5d3819e88..a4709175678d 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -960,6 +960,21 @@ static void *add_cxl_decoder(void *parent, int id, const char *cxldecoder_base)
 	else
 		decoder->size = strtoull(buf, NULL, 0);
 
+	sprintf(path, "%s/mode", cxldecoder_base);
+	if (sysfs_read_attr(ctx, path, buf) == 0) {
+		if (strcmp(buf, "ram") == 0)
+			decoder->mode = CXL_DECODER_MODE_RAM;
+		else if (strcmp(buf, "pmem") == 0)
+			decoder->mode = CXL_DECODER_MODE_PMEM;
+		else if (strcmp(buf, "mixed") == 0)
+			decoder->mode = CXL_DECODER_MODE_MIXED;
+		else if (strcmp(buf, "none") == 0)
+			decoder->mode = CXL_DECODER_MODE_NONE;
+		else
+			decoder->mode = CXL_DECODER_MODE_MIXED;
+	} else
+		decoder->mode = CXL_DECODER_MODE_NONE;
+
 	switch (port->type) {
 	case CXL_PORT_ENDPOINT:
 		sprintf(path, "%s/dpa_resource", cxldecoder_base);
@@ -1160,6 +1175,21 @@ cxl_decoder_get_dpa_size(struct cxl_decoder *decoder)
 	return decoder->dpa_size;
 }
 
+CXL_EXPORT enum cxl_decoder_mode
+cxl_decoder_get_mode(struct cxl_decoder *decoder)
+{
+	struct cxl_port *port = cxl_decoder_get_port(decoder);
+	struct cxl_ctx *ctx = cxl_decoder_get_ctx(decoder);
+
+	if (!cxl_port_is_endpoint(port)) {
+		err(ctx, "%s: not an endpoint decoder\n",
+		    cxl_decoder_get_devname(decoder));
+		return CXL_DECODER_MODE_NONE;
+	}
+
+	return decoder->mode;
+}
+
 CXL_EXPORT enum cxl_decoder_target_type
 cxl_decoder_get_target_type(struct cxl_decoder *decoder)
 {
diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
index 8e2fc75557f9..88c5a7edd33e 100644
--- a/cxl/lib/libcxl.sym
+++ b/cxl/lib/libcxl.sym
@@ -172,4 +172,5 @@ LIBCXL_3 {
 global:
 	cxl_decoder_get_dpa_resource;
 	cxl_decoder_get_dpa_size;
+	cxl_decoder_get_mode;
 } LIBCXL_2;
diff --git a/cxl/lib/private.h b/cxl/lib/private.h
index 24a2ae6787be..f6d4573757fd 100644
--- a/cxl/lib/private.h
+++ b/cxl/lib/private.h
@@ -108,6 +108,7 @@ struct cxl_decoder {
 	char *dev_path;
 	int nr_targets;
 	int id;
+	enum cxl_decoder_mode mode;
 	bool pmem_capable;
 	bool volatile_capable;
 	bool mem_capable;
diff --git a/cxl/libcxl.h b/cxl/libcxl.h
index 76aebe3efda8..1436dc4601cc 100644
--- a/cxl/libcxl.h
+++ b/cxl/libcxl.h
@@ -127,10 +127,33 @@ struct cxl_dport *cxl_port_get_dport_by_memdev(struct cxl_port *port,
 struct cxl_decoder;
 struct cxl_decoder *cxl_decoder_get_first(struct cxl_port *port);
 struct cxl_decoder *cxl_decoder_get_next(struct cxl_decoder *decoder);
+struct cxl_decoder *cxl_decoder_get_last(struct cxl_port *port);
+struct cxl_decoder *cxl_decoder_get_prev(struct cxl_decoder *decoder);
 unsigned long long cxl_decoder_get_resource(struct cxl_decoder *decoder);
 unsigned long long cxl_decoder_get_size(struct cxl_decoder *decoder);
 unsigned long long cxl_decoder_get_dpa_resource(struct cxl_decoder *decoder);
 unsigned long long cxl_decoder_get_dpa_size(struct cxl_decoder *decoder);
+enum cxl_decoder_mode {
+	CXL_DECODER_MODE_NONE,
+	CXL_DECODER_MODE_MIXED,
+	CXL_DECODER_MODE_PMEM,
+	CXL_DECODER_MODE_RAM,
+};
+static inline const char *cxl_decoder_mode_name(enum cxl_decoder_mode mode)
+{
+	static const char *names[] = {
+		[CXL_DECODER_MODE_NONE] = "none",
+		[CXL_DECODER_MODE_MIXED] = "mixed",
+		[CXL_DECODER_MODE_PMEM] = "pmem",
+		[CXL_DECODER_MODE_RAM] = "ram",
+	};
+
+	if (mode < CXL_DECODER_MODE_NONE || mode > CXL_DECODER_MODE_RAM)
+		mode = CXL_DECODER_MODE_NONE;
+	return names[mode];
+}
+
+enum cxl_decoder_mode cxl_decoder_get_mode(struct cxl_decoder *decoder);
 const char *cxl_decoder_get_devname(struct cxl_decoder *decoder);
 struct cxl_target *cxl_decoder_get_target_by_memdev(struct cxl_decoder *decoder,
 						    struct cxl_memdev *memdev);


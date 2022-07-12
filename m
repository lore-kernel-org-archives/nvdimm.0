Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CA99538B
	for <nvdimm@lists.linux.dev>; Tue, 12 Jul 2022 19:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657652868; x=1689188868;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NR3xEc9IRdzsHzkHzpnmoYhBLcYxBL8o1b4hDwqsDX8=;
  b=Efyec0DQPwglpLAzLtG0z4K+AycUsPNgDj/RIHm4uEEo4icSk5LdhBo7
   9gx3lhmXD4J5pbaGo2D09G7AsM/IdP44Lwd4op/cHWljem3S5aB4IS0YI
   R6SSoUbps8JxygXk5mAx2o9SXW4BC5hEBJIseSlk0mr7WRLN2ma+rzphG
   0/dfJG6qLtp3LZjItAf3m0AxztrZAH/zDLcUNMos7zxh4KYCshs4W/EXN
   qA7Mwe134GfX5IJ72kW6Nfsvo0RUBCpvX1kvV8R6ASEgvc4rA6O9ho+Wf
   C4CAHdnsobUCSkb8D6uFMfox/9DbkS/Ng3rlEXsVAEnlV7xM6PIpej4Aq
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10406"; a="264810896"
X-IronPort-AV: E=Sophos;i="5.92,266,1650956400"; 
   d="scan'208";a="264810896"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2022 12:07:47 -0700
X-IronPort-AV: E=Sophos;i="5.92,266,1650956400"; 
   d="scan'208";a="771986148"
Received: from sheyting-mobl3.amr.corp.intel.com (HELO [192.168.1.117]) ([10.212.147.156])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2022 12:07:47 -0700
Subject: [ndctl PATCH 04/11] cxl/list: Add DPA span to endpoint decoder
 listings
From: Dan Williams <dan.j.williams@intel.com>
To: vishal.l.verma@intel.com
Cc: alison.schofield@intel.com, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org
Date: Tue, 12 Jul 2022 12:07:47 -0700
Message-ID: <165765286728.435671.6495930203063433208.stgit@dwillia2-xfh>
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

Optionally include in decoder listings the device local address space for
endpoint decoders with active / allocated capacity.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Documentation/cxl/lib/libcxl.txt |    2 ++
 cxl/json.c                       |   18 ++++++++++++++++
 cxl/lib/libcxl.c                 |   43 +++++++++++++++++++++++++++++++++++++-
 cxl/lib/libcxl.sym               |    6 +++++
 cxl/lib/private.h                |    2 ++
 cxl/libcxl.h                     |    2 ++
 6 files changed, 72 insertions(+), 1 deletion(-)

diff --git a/Documentation/cxl/lib/libcxl.txt b/Documentation/cxl/lib/libcxl.txt
index f8f0e668ab59..2aef489e8e12 100644
--- a/Documentation/cxl/lib/libcxl.txt
+++ b/Documentation/cxl/lib/libcxl.txt
@@ -392,6 +392,8 @@ more CXL decoder objects.
 ----
 unsigned long long cxl_decoder_get_resource(struct cxl_decoder *decoder);
 unsigned long long cxl_decoder_get_size(struct cxl_decoder *decoder);
+unsigned long long cxl_decoder_get_dpa_resource(struct cxl_decoder *decoder);
+unsigned long long cxl_decoder_get_dpa_size(struct cxl_decoder *decoder);
 const char *cxl_decoder_get_devname(struct cxl_decoder *decoder);
 int cxl_decoder_get_id(struct cxl_decoder *decoder);
 int cxl_decoder_get_nr_targets(struct cxl_decoder *decoder);
diff --git a/cxl/json.c b/cxl/json.c
index a213fdad55fd..3f52d3bbff45 100644
--- a/cxl/json.c
+++ b/cxl/json.c
@@ -472,6 +472,24 @@ struct json_object *util_cxl_decoder_to_json(struct cxl_decoder *decoder,
 			json_object_object_add(jdecoder, "state", jobj);
 	}
 
+	if (cxl_port_is_endpoint(port)) {
+		size = cxl_decoder_get_dpa_size(decoder);
+		val = cxl_decoder_get_dpa_resource(decoder);
+		if (size && val < ULLONG_MAX) {
+			jobj = util_json_object_hex(val, flags);
+			if (jobj)
+				json_object_object_add(jdecoder, "dpa_resource",
+						       jobj);
+		}
+
+		if (size && size < ULLONG_MAX) {
+			jobj = util_json_object_size(size, flags);
+			if (jobj)
+				json_object_object_add(jdecoder, "dpa_size",
+						       jobj);
+		}
+	}
+
 	if (cxl_port_is_root(port) && cxl_decoder_is_mem_capable(decoder)) {
 		if (cxl_decoder_is_pmem_capable(decoder)) {
 			jobj = json_object_new_boolean(true);
diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index c988ce2ddea9..f36edcfc735a 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -955,8 +955,19 @@ static void *add_cxl_decoder(void *parent, int id, const char *cxldecoder_base)
 		decoder->size = strtoull(buf, NULL, 0);
 
 	switch (port->type) {
-	case CXL_PORT_SWITCH:
 	case CXL_PORT_ENDPOINT:
+		sprintf(path, "%s/dpa_resource", cxldecoder_base);
+		if (sysfs_read_attr(ctx, path, buf) < 0)
+			decoder->dpa_resource = ULLONG_MAX;
+		else
+			decoder->dpa_resource = strtoull(buf, NULL, 0);
+		sprintf(path, "%s/dpa_size", cxldecoder_base);
+		if (sysfs_read_attr(ctx, path, buf) < 0)
+			decoder->dpa_size = ULLONG_MAX;
+		else
+			decoder->dpa_size = strtoull(buf, NULL, 0);
+
+	case CXL_PORT_SWITCH:
 		decoder->pmem_capable = true;
 		decoder->volatile_capable = true;
 		decoder->mem_capable = true;
@@ -1113,6 +1124,36 @@ CXL_EXPORT unsigned long long cxl_decoder_get_size(struct cxl_decoder *decoder)
 	return decoder->size;
 }
 
+CXL_EXPORT unsigned long long
+cxl_decoder_get_dpa_resource(struct cxl_decoder *decoder)
+{
+	struct cxl_port *port = cxl_decoder_get_port(decoder);
+	struct cxl_ctx *ctx = cxl_decoder_get_ctx(decoder);
+
+	if (!cxl_port_is_endpoint(port)) {
+		err(ctx, "%s: not an endpoint decoder\n",
+		    cxl_decoder_get_devname(decoder));
+		return ULLONG_MAX;
+	}
+
+	return decoder->dpa_resource;
+}
+
+CXL_EXPORT unsigned long long
+cxl_decoder_get_dpa_size(struct cxl_decoder *decoder)
+{
+	struct cxl_port *port = cxl_decoder_get_port(decoder);
+	struct cxl_ctx *ctx = cxl_decoder_get_ctx(decoder);
+
+	if (!cxl_port_is_endpoint(port)) {
+		err(ctx, "%s: not an endpoint decoder\n",
+		    cxl_decoder_get_devname(decoder));
+		return ULLONG_MAX;
+	}
+
+	return decoder->dpa_size;
+}
+
 CXL_EXPORT enum cxl_decoder_target_type
 cxl_decoder_get_target_type(struct cxl_decoder *decoder)
 {
diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
index dffcb60b8dd0..8e2fc75557f9 100644
--- a/cxl/lib/libcxl.sym
+++ b/cxl/lib/libcxl.sym
@@ -167,3 +167,9 @@ global:
 	cxl_cmd_new_set_partition;
 	cxl_cmd_partition_set_mode;
 } LIBCXL_1;
+
+LIBCXL_3 {
+global:
+	cxl_decoder_get_dpa_resource;
+	cxl_decoder_get_dpa_size;
+} LIBCXL_2;
diff --git a/cxl/lib/private.h b/cxl/lib/private.h
index c6d88f7140f2..24a2ae6787be 100644
--- a/cxl/lib/private.h
+++ b/cxl/lib/private.h
@@ -101,6 +101,8 @@ struct cxl_decoder {
 	struct cxl_ctx *ctx;
 	u64 start;
 	u64 size;
+	u64 dpa_resource;
+	u64 dpa_size;
 	void *dev_buf;
 	size_t buf_len;
 	char *dev_path;
diff --git a/cxl/libcxl.h b/cxl/libcxl.h
index 0007f4d9bcee..76aebe3efda8 100644
--- a/cxl/libcxl.h
+++ b/cxl/libcxl.h
@@ -129,6 +129,8 @@ struct cxl_decoder *cxl_decoder_get_first(struct cxl_port *port);
 struct cxl_decoder *cxl_decoder_get_next(struct cxl_decoder *decoder);
 unsigned long long cxl_decoder_get_resource(struct cxl_decoder *decoder);
 unsigned long long cxl_decoder_get_size(struct cxl_decoder *decoder);
+unsigned long long cxl_decoder_get_dpa_resource(struct cxl_decoder *decoder);
+unsigned long long cxl_decoder_get_dpa_size(struct cxl_decoder *decoder);
 const char *cxl_decoder_get_devname(struct cxl_decoder *decoder);
 struct cxl_target *cxl_decoder_get_target_by_memdev(struct cxl_decoder *decoder,
 						    struct cxl_memdev *memdev);


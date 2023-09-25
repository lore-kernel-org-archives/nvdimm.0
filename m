Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9ABA63A8
	for <nvdimm@lists.linux.dev>; Mon, 25 Sep 2023 19:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695669656; x=1727205656;
  h=subject:from:to:cc:date:message-id:mime-version:
   content-transfer-encoding;
  bh=cDOL2eXoZSza+lnGD6m5Vo6JPrvw/3wUjDKfPXsQ1Cg=;
  b=m7s51OdXpiiZD9+tHlV0scdLc06e6MBnHWnqH/LgJqqe0A8LvKUjcta8
   +bcjFuNb3tsgdO/OCz8rqe4qJJrC838vfyNM7Odn38r+Eg/yus7+2O+OZ
   0eiDdepRXpga9ZCt7Fr2CYga4Fdln1vCnutVidFaGMnSQzYm2VOqH+Ufa
   eWw7wjgPFWfAuMHFTdeYxZAU50bEDhkGgAui0ze/vYz4g74rGpJau+a2y
   Br4X7CptKeL7upRyAA6O/dstpqX6ebnuEAy0TGW9jeQite8Yb0aCtzWro
   1atlz2e2NrsfVur4xUmXAUKJYRqf5AKMnjAdA/sMR1Yjkz5onwDCHOXzu
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10843"; a="380223065"
X-IronPort-AV: E=Sophos;i="6.03,175,1694761200"; 
   d="scan'208";a="380223065"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2023 12:20:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10843"; a="995504780"
X-IronPort-AV: E=Sophos;i="6.03,175,1694761200"; 
   d="scan'208";a="995504780"
Received: from djiang5-mobl3.amr.corp.intel.com (HELO [192.168.1.177]) ([10.209.161.86])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2023 12:20:34 -0700
Subject: [PATCH 1/2] cxl: Save the decoder committed state
From: Dave Jiang <dave.jiang@intel.com>
To: vishal.l.verma@intel.com
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev, lizhijian@fujitsu.com,
 yangx.jy@fujitsu.com, caoqq@fujitsu.com
Date: Mon, 25 Sep 2023 12:20:34 -0700
Message-ID: <169566963425.3704458.5249885814603187091.stgit@djiang5-mobl3>
User-Agent: StGit/1.5
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Save the decoder committed state exported by the kernel to the libcxl
decoder context. The attribute is helpful for determing if a region is active.
Add libcxl API to determine if decoder is committed.
Add the committed state to the decoder for cxl list command.

Links: https://lore.kernel.org/linux-cxl/169566515694.3697523.714600762835841180.stgit@djiang5-mobl3/
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 Documentation/cxl/lib/libcxl.txt |    4 ++++
 cxl/json.c                       |    4 ++++
 cxl/lib/libcxl.c                 |    9 +++++++++
 cxl/lib/libcxl.sym               |    5 +++++
 cxl/lib/private.h                |    1 +
 cxl/libcxl.h                     |    1 +
 6 files changed, 24 insertions(+)

diff --git a/Documentation/cxl/lib/libcxl.txt b/Documentation/cxl/lib/libcxl.txt
index 31bc85511270..4a2d1affa5a7 100644
--- a/Documentation/cxl/lib/libcxl.txt
+++ b/Documentation/cxl/lib/libcxl.txt
@@ -424,6 +424,7 @@ bool cxl_decoder_is_volatile_capable(struct cxl_decoder *decoder);
 bool cxl_decoder_is_mem_capable(struct cxl_decoder *decoder);
 bool cxl_decoder_is_accelmem_capable(struct cxl_decoder *decoder);
 bool cxl_decoder_is_locked(struct cxl_decoder *decoder);
+bool cxl_decoder_is_committed(struct cxl_decoder *decoder);
 ----
 The kernel protects the enumeration of the physical address layout of
 the system. Without CAP_SYS_ADMIN cxl_decoder_get_resource() returns
@@ -449,6 +450,9 @@ Platform firmware may setup the CXL decode hierarchy before the OS
 boots, and may additionally require that the OS not change the decode
 settings. This property is indicated by the cxl_decoder_is_locked() API.
 
+cxl_decoder_is_committed() provides a snapshot of the decoder state
+from the OS indicating if the decoder is committed or free.
+
 When a decoder is associated with a region cxl_decoder_get_region()
 returns that region object. Note that it is only applicable to switch
 and endpoint decoders as root decoders have a 1:N relationship with
diff --git a/cxl/json.c b/cxl/json.c
index 7678d02020b6..56ab42c747a0 100644
--- a/cxl/json.c
+++ b/cxl/json.c
@@ -857,6 +857,10 @@ struct json_object *util_cxl_decoder_to_json(struct cxl_decoder *decoder,
 					       jobj);
 	}
 
+	jobj = json_object_new_boolean(cxl_decoder_is_committed(decoder));
+	if (jobj)
+		json_object_object_add(jdecoder, "committed", jobj);
+
 	json_object_set_userdata(jdecoder, decoder, NULL);
 	return jdecoder;
 }
diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index af4ca44eae19..094e14d6be8f 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -2116,6 +2116,10 @@ static void *add_cxl_decoder(void *parent, int id, const char *cxldecoder_base)
 	else
 		decoder->interleave_ways = strtoul(buf, NULL, 0);
 
+	sprintf(path, "%s/committed", cxldecoder_base);
+	if (sysfs_read_attr(ctx, path, buf) == 0)
+		decoder->committed = !!strtoul(buf, NULL, 0);
+
 	switch (port->type) {
 	case CXL_PORT_ENDPOINT:
 		sprintf(path, "%s/dpa_resource", cxldecoder_base);
@@ -2464,6 +2468,11 @@ CXL_EXPORT bool cxl_decoder_is_locked(struct cxl_decoder *decoder)
 	return decoder->locked;
 }
 
+CXL_EXPORT bool cxl_decoder_is_committed(struct cxl_decoder *decoder)
+{
+	return decoder->committed;
+}
+
 CXL_EXPORT unsigned int
 cxl_decoder_get_interleave_granularity(struct cxl_decoder *decoder)
 {
diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
index 8fa1cca3d0d7..eb8b5829851d 100644
--- a/cxl/lib/libcxl.sym
+++ b/cxl/lib/libcxl.sym
@@ -264,3 +264,8 @@ global:
 	cxl_memdev_update_fw;
 	cxl_memdev_cancel_fw_update;
 } LIBCXL_5;
+
+LIBCXL_7 {
+global:
+	cxl_decoder_is_committed;
+} LIBCXL_6;
diff --git a/cxl/lib/private.h b/cxl/lib/private.h
index a641727000f1..c79190827258 100644
--- a/cxl/lib/private.h
+++ b/cxl/lib/private.h
@@ -139,6 +139,7 @@ struct cxl_decoder {
 	bool mem_capable;
 	bool accelmem_capable;
 	bool locked;
+	bool committed;
 	enum cxl_decoder_target_type target_type;
 	int regions_init;
 	struct list_head targets;
diff --git a/cxl/libcxl.h b/cxl/libcxl.h
index 0f4f4b2648fb..a7fad3e30055 100644
--- a/cxl/libcxl.h
+++ b/cxl/libcxl.h
@@ -245,6 +245,7 @@ bool cxl_decoder_is_volatile_capable(struct cxl_decoder *decoder);
 bool cxl_decoder_is_mem_capable(struct cxl_decoder *decoder);
 bool cxl_decoder_is_accelmem_capable(struct cxl_decoder *decoder);
 bool cxl_decoder_is_locked(struct cxl_decoder *decoder);
+bool cxl_decoder_is_committed(struct cxl_decoder *decoder);
 unsigned int
 cxl_decoder_get_interleave_granularity(struct cxl_decoder *decoder);
 unsigned int cxl_decoder_get_interleave_ways(struct cxl_decoder *decoder);



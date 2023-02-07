Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08709748F
	for <nvdimm@lists.linux.dev>; Tue,  7 Feb 2023 19:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675797416; x=1707333416;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=5RP4k+V4+dDbK8p5nfiWV6/Y3/lsDqlc5lbLducb3Pk=;
  b=Vjh6hygiG5/8twUVyhYhxZRG2tV9dcrbmd5xY1JbC51A5URxKCJK+aP7
   YhlJLxksTcEqbZieGZD7Qap8rDLFfUyswXsvFHBR9oubL28VUGaCzIBl/
   ldTosmiV48YEY0+NCOEp8W7hCehq7VOameBH+nOMwtZbaXKaW6OaLHYCY
   ngRHfkZXKsXa/+xos8VMuFvVEi81ztx+P4q2loTLsGfd3N9qqtv1uJNNe
   ErKpBTuX+V6uQ/gWwLbvPImQnv/tcUtqoxOO+iYAyZjGZdDfr97eEWxss
   rXH1qHh/AjdsHd94Lt+a3UiWdEWQXRNsi47/nzLkBxb6qphFs23w8XjF9
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="331733999"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="331733999"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2023 11:16:55 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="735649814"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="735649814"
Received: from fvanegas-mobl.amr.corp.intel.com (HELO vverma7-desk1.local) ([10.209.109.6])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2023 11:16:54 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
Date: Tue, 07 Feb 2023 12:16:30 -0700
Subject: [PATCH ndctl 4/7] cxl/region: accept user-supplied UUIDs for pmem
 regions
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230120-vv-volatile-regions-v1-4-b42b21ee8d0b@intel.com>
References: <20230120-vv-volatile-regions-v1-0-b42b21ee8d0b@intel.com>
In-Reply-To: <20230120-vv-volatile-regions-v1-0-b42b21ee8d0b@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Gregory Price <gregory.price@memverge.com>, 
 Jonathan Cameron <Jonathan.Cameron@Huawei.com>, 
 Davidlohr Bueso <dave@stgolabs.net>, 
 Dan Williams <dan.j.williams@intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>, nvdimm@lists.linux.dev
X-Mailer: b4 0.13-dev-ada30
X-Developer-Signature: v=1; a=openpgp-sha256; l=3086;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=5RP4k+V4+dDbK8p5nfiWV6/Y3/lsDqlc5lbLducb3Pk=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDMmPFi9RuTRNLajhm+T5i7ZubO4ci5QO/eu4/uZESzvz2
 /4Jj3Y87yhlYRDjYpAVU2T5u+cj4zG57fk8gQmOMHNYmUCGMHBxCsBESr4y/Ga16T05cY7J64aZ
 J3YpM7xYWt2cdPPzXtW3r+IXJnD+tbnGyDDr1fEdPZUFJcqHI19O2lF7ascLoSnZ7x4yMjdOOTq
 F8QkzAA==
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp;
 fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF

Attempting to add additional checking around user-supplied UUIDs against
'ram' type regions revealed that commit 21b089025178 ("cxl: add a 'create-region' command")
completely neglected to add the requisite support for accepting
user-supplied UUIDs, even though the man page for cxl-create-region
advertised the option.

Fix this by actually adding this option now, and add checks to validate
the user-supplied UUID, and refuse it for ram regions.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 cxl/region.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/cxl/region.c b/cxl/region.c
index 0945a14..9079b2d 100644
--- a/cxl/region.c
+++ b/cxl/region.c
@@ -22,6 +22,7 @@ static struct region_params {
 	const char *bus;
 	const char *size;
 	const char *type;
+	const char *uuid;
 	const char *root_decoder;
 	const char *region;
 	int ways;
@@ -40,6 +41,7 @@ struct parsed_params {
 	u64 ep_min_size;
 	int ways;
 	int granularity;
+	uuid_t uuid;
 	struct json_object *memdevs;
 	int num_memdevs;
 	int argc;
@@ -74,6 +76,8 @@ OPT_INTEGER('g', "granularity", &param.granularity,  \
 	    "granularity of the interleave set"), \
 OPT_STRING('t', "type", &param.type, \
 	   "region type", "region type - 'pmem' or 'ram'"), \
+OPT_STRING('U', "uuid", &param.uuid, \
+	   "region uuid", "uuid for the new region (default: autogenerate)"), \
 OPT_BOOLEAN('m', "memdevs", &param.memdevs, \
 	    "non-option arguments are memdevs"), \
 OPT_BOOLEAN('u', "human", &param.human, "use human friendly number formats")
@@ -293,6 +297,11 @@ static int parse_create_options(struct cxl_ctx *ctx, int count,
 
 	if (param.type) {
 		p->mode = cxl_decoder_mode_from_ident(param.type);
+		if (p->mode == CXL_DECODER_MODE_RAM && param.uuid) {
+			log_err(&rl,
+				"can't set UUID for ram / volatile regions");
+			return -EINVAL;
+		}
 		if (p->mode == CXL_DECODER_MODE_NONE) {
 			log_err(&rl, "unsupported type: %s\n", param.type);
 			return -EINVAL;
@@ -341,6 +350,13 @@ static int parse_create_options(struct cxl_ctx *ctx, int count,
 		}
 	}
 
+	if (param.uuid) {
+		if (uuid_parse(param.uuid, p->uuid)) {
+			error("failed to parse uuid: '%s'\n", param.uuid);
+			return -EINVAL;
+		}
+	}
+
 	return 0;
 }
 
@@ -566,7 +582,6 @@ static int create_region(struct cxl_ctx *ctx, int *count,
 	int i, rc, granularity;
 	u64 size, max_extent;
 	const char *devname;
-	uuid_t uuid;
 
 	rc = create_region_validate_config(ctx, p);
 	if (rc)
@@ -627,8 +642,9 @@ static int create_region(struct cxl_ctx *ctx, int *count,
 	try(cxl_region, set_interleave_granularity, region, granularity);
 	try(cxl_region, set_interleave_ways, region, p->ways);
 	if (p->mode == CXL_DECODER_MODE_PMEM) {
-		uuid_generate(uuid);
-		try(cxl_region, set_uuid, region, uuid);
+		if (!param.uuid)
+			uuid_generate(p->uuid);
+		try(cxl_region, set_uuid, region, p->uuid);
 	}
 	try(cxl_region, set_size, region, size);
 

-- 
2.39.1


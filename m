Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 361D4749D
	for <nvdimm@lists.linux.dev>; Wed,  8 Feb 2023 20:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675886447; x=1707422447;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=7L/lAAG8yThVoZsO9V1nVeSvNDX9fTaRIBY0YDNX1d4=;
  b=PKDDRYnyGrDhj7mMrhsEwv3P4NtT6yLXXiu6w30kx+B94q5Mq0DnyRDk
   ccQDDK/OqWEBA0CG1SPaFU/nilvRLdrgz9wEBX7mokdnCDGjPurXvuBtL
   IHdf7tCfkkkmQSW8DWLWN6jFQRrHkbXxuBczfA9cQ0JyYqXeBof4pF0vE
   dgxjcjYFxK+a35ihmvBbeLrl0R7iDB2jS16PvO0c8JstKVRcbZleScIf7
   4wsRnSN/E8zh+BexxV41cUIOdIFoFZmSnKwL5XZBDrzbL0A6V7UU5JUPv
   sBYUMxLgfbXO/WpY6jYnZ4K5khL1XtQN52dNZrguH7zzN8WGUPi9YjG0d
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="329935472"
X-IronPort-AV: E=Sophos;i="5.97,281,1669104000"; 
   d="scan'208";a="329935472"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2023 12:00:44 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="776174678"
X-IronPort-AV: E=Sophos;i="5.97,281,1669104000"; 
   d="scan'208";a="776174678"
Received: from laarmstr-mobl.amr.corp.intel.com (HELO vverma7-desk1.local) ([10.251.6.109])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2023 12:00:44 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
Date: Wed, 08 Feb 2023 13:00:32 -0700
Subject: [PATCH ndctl v2 4/7] cxl/region: accept user-supplied UUIDs for
 pmem regions
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230120-vv-volatile-regions-v2-4-4ea6253000e5@intel.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3186;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=7L/lAAG8yThVoZsO9V1nVeSvNDX9fTaRIBY0YDNX1d4=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDMmP/2fyyJ28N2PRsweuT19G7my6EOaTlGllf8pbV+dq6
 sGHEaWTO0pZGMS4GGTFFFn+7vnIeExuez5PYIIjzBxWJpAhDFycAjCR9reMDJe/SLNeX+LtsS2/
 KXXtTbFK/6szD57dPM39SKtwc3rD900M/32rD52fyxZQ7jFD2nz6i8N9lmL7slisyk4m7ltWLmb
 0lh8A
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
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 cxl/region.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/cxl/region.c b/cxl/region.c
index c69cb9a..5c908bb 100644
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
 
@@ -562,7 +578,6 @@ static int create_region(struct cxl_ctx *ctx, int *count,
 	int i, rc, granularity;
 	u64 size, max_extent;
 	const char *devname;
-	uuid_t uuid;
 
 	rc = create_region_validate_config(ctx, p);
 	if (rc)
@@ -623,8 +638,9 @@ static int create_region(struct cxl_ctx *ctx, int *count,
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


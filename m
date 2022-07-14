Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF6C36002
	for <nvdimm@lists.linux.dev>; Thu, 14 Jul 2022 17:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657818126; x=1689354126;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NgVTcO/N8lNlztGxQoim/NbcYQnweRCnSkSjx/KcjhI=;
  b=VfV1q8AnSpUVewbj/ganq7q/v4JupmkxArjtcpIPSpfrblqIqY3Oug1k
   wSbygV4UqUZpx3TKF5rJ5+3GdnnAfvESFjALjvbMbkMd8Kljfh+2mDik3
   P5SkdjVmpdTvepPUl7sahaUsBJePBwe/WMyVAQ/tmO7yLpcNWT2UZq19+
   JqnUwlOIGKr0KQ3vsaqef7a8ciIHnZE37mFIt194bN5UVFmxiqbpw9RFj
   NIoRdpU88fmMQkU66/20IfAYmLS6yKSPnu6Vg/bnPoCGHHDVHNClHfvR6
   0ZKJWSI5MglGHJtYTm+YbsT0Kin1yTB5CnHPONtrvXO869D2DiUuCeVP7
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10408"; a="265364058"
X-IronPort-AV: E=Sophos;i="5.92,271,1650956400"; 
   d="scan'208";a="265364058"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 10:02:04 -0700
X-IronPort-AV: E=Sophos;i="5.92,271,1650956400"; 
   d="scan'208";a="772693904"
Received: from jlcone-mobl1.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.209.2.90])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 10:02:04 -0700
Subject: [ndctl PATCH v2 03/12] cxl/list: Hide 0s in disabled decoder
 listings
From: Dan Williams <dan.j.williams@intel.com>
To: vishal.l.verma@intel.com
Cc: Davidlohr Bueso <dave@stgolabs.net>, alison.schofield@intel.com,
 nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
Date: Thu, 14 Jul 2022 10:02:04 -0700
Message-ID: <165781812427.1555691.5252994293073680408.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <165781810717.1555691.1411727384567016588.stgit@dwillia2-xfh.jf.intel.com>
References: <165781810717.1555691.1411727384567016588.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Trim some redundant information from decoder listings when they are
disabled.

Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 cxl/json.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/cxl/json.c b/cxl/json.c
index fdc6f73a86c1..a213fdad55fd 100644
--- a/cxl/json.c
+++ b/cxl/json.c
@@ -442,7 +442,7 @@ struct json_object *util_cxl_decoder_to_json(struct cxl_decoder *decoder,
 	const char *devname = cxl_decoder_get_devname(decoder);
 	struct cxl_port *port = cxl_decoder_get_port(decoder);
 	struct json_object *jdecoder, *jobj;
-	u64 val;
+	u64 val, size;
 
 	jdecoder = json_object_new_object();
 	if (!jdecoder)
@@ -452,21 +452,21 @@ struct json_object *util_cxl_decoder_to_json(struct cxl_decoder *decoder,
 	if (jobj)
 		json_object_object_add(jdecoder, "decoder", jobj);
 
+	size = cxl_decoder_get_size(decoder);
 	val = cxl_decoder_get_resource(decoder);
-	if (val < ULLONG_MAX) {
+	if (size && val < ULLONG_MAX) {
 		jobj = util_json_object_hex(val, flags);
 		if (jobj)
 			json_object_object_add(jdecoder, "resource", jobj);
 	}
 
-	val = cxl_decoder_get_size(decoder);
-	if (val < ULLONG_MAX) {
-		jobj = util_json_object_size(val, flags);
+	if (size && size < ULLONG_MAX) {
+		jobj = util_json_object_size(size, flags);
 		if (jobj)
 			json_object_object_add(jdecoder, "size", jobj);
 	}
 
-	if (val == 0) {
+	if (size == 0) {
 		jobj = json_object_new_string("disabled");
 		if (jobj)
 			json_object_object_add(jdecoder, "state", jobj);


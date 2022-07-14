Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33C616002
	for <nvdimm@lists.linux.dev>; Thu, 14 Jul 2022 17:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657818191; x=1689354191;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=z2SMMm41uIRd5DJN5abWRnM6MsMByqAH5tJ7qm43uuc=;
  b=EMIx7pQycska+Mrtt3wUSc92fxxthYMg0tjs8Lfs1mLhZvEyiwFYp9qb
   /lUOM9OK155cOtUFhuM1XsqzBJ5O1HsBQFRoIOM2HzdGDuJiHWC9iG0Vo
   TH+RXcCCbedV7WUXQSBW0qiwYZzuntS50t6aVoIw+fMl7q54vB6bCsXao
   s8wtAk16AvYzHfskoFyWulc9EjYik7ZogFfo808Jocz2ia2t1BDgDBsCb
   cZyLnmuEYUU4TnXdot0Ze4KOLopBNIA5MBhQsHS/MkfPs++SoIaxoW9uG
   QQoE7ZVzd8NSy+xy+vXP+iqv+tbkdHU7jcfMTy478wyrJntlLlhUI6YcA
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10408"; a="284331794"
X-IronPort-AV: E=Sophos;i="5.92,271,1650956400"; 
   d="scan'208";a="284331794"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 10:02:28 -0700
X-IronPort-AV: E=Sophos;i="5.92,271,1650956400"; 
   d="scan'208";a="653953199"
Received: from jlcone-mobl1.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.209.2.90])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 10:02:27 -0700
Subject: [ndctl PATCH v2 07/12] cxl/memdev: Fix json for multi-device
 partitioning
From: Dan Williams <dan.j.williams@intel.com>
To: vishal.l.verma@intel.com
Cc: Alison Schofield <alison.schofield@intel.com>, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org
Date: Thu, 14 Jul 2022 10:02:27 -0700
Message-ID: <165781814737.1555691.889129128205037941.stgit@dwillia2-xfh.jf.intel.com>
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

In the case when someone partitions several devices at once, collect all
the affected memdevs into a json array.

With the move to use util_display_json_array() that also requires a set of
flags to be specifiied. Apply the UTIL_JSON_HUMAN flag for all interactive
command result output to bring this command in line with other tools.

Cc: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 cxl/memdev.c |   26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/cxl/memdev.c b/cxl/memdev.c
index 91d914db5af6..9fcd8ae5724b 100644
--- a/cxl/memdev.c
+++ b/cxl/memdev.c
@@ -19,6 +19,7 @@
 struct action_context {
 	FILE *f_out;
 	FILE *f_in;
+	struct json_object *jdevs;
 };
 
 static struct parameters {
@@ -339,12 +340,13 @@ out:
 }
 
 static int action_setpartition(struct cxl_memdev *memdev,
-		struct action_context *actx)
+			       struct action_context *actx)
 {
 	const char *devname = cxl_memdev_get_devname(memdev);
 	enum cxl_setpart_type type = CXL_SETPART_PMEM;
 	unsigned long long size = ULLONG_MAX;
 	struct json_object *jmemdev;
+	unsigned long flags;
 	struct cxl_cmd *cmd;
 	int rc;
 
@@ -396,10 +398,12 @@ out_err:
 	if (rc)
 		log_err(&ml, "%s error: %s\n", devname, strerror(-rc));
 
-	jmemdev = util_cxl_memdev_to_json(memdev, UTIL_JSON_PARTITION);
-	if (jmemdev)
-		printf("%s\n", json_object_to_json_string_ext(jmemdev,
-		       JSON_C_TO_STRING_PRETTY));
+	flags = UTIL_JSON_PARTITION;
+	if (actx->f_out == stdout && isatty(1))
+		flags |= UTIL_JSON_HUMAN;
+	jmemdev = util_cxl_memdev_to_json(memdev, flags);
+	if (actx->jdevs && jmemdev)
+		json_object_array_add(actx->jdevs, jmemdev);
 
 	return rc;
 }
@@ -446,6 +450,9 @@ static int memdev_action(int argc, const char **argv, struct cxl_ctx *ctx,
 		err++;
 	}
 
+	if (action == action_setpartition)
+		actx.jdevs = json_object_new_array();
+
 	if (err == argc) {
 		usage_with_options(u, options);
 		return -EINVAL;
@@ -528,6 +535,15 @@ static int memdev_action(int argc, const char **argv, struct cxl_ctx *ctx,
 	if (actx.f_in != stdin)
 		fclose(actx.f_in);
 
+	if (actx.jdevs) {
+		unsigned long flags = 0;
+
+		if (actx.f_out == stdout && isatty(1))
+			flags |= UTIL_JSON_HUMAN;
+		util_display_json_array(actx.f_out, actx.jdevs, flags);
+	}
+
+
  out_close_fout:
 	if (actx.f_out != stdout)
 		fclose(actx.f_out);


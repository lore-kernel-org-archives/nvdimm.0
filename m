Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A891FD500
	for <nvdimm@lists.linux.dev>; Sun,  6 Nov 2022 23:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667778464; x=1699314464;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wH0kGeai/cpvOxG0zFKnev7rIw6TBDR69wboanX1i7Q=;
  b=GgvHS5cJmQ4i8zhlh9zWXHzmYoyQDquubXfGURgIJejUbqvzjoMR0+lq
   4PcATOUfW0pWrPJ8/u/bCci6uzzXUVScWkASHCxHUprj05jl0i68ehk0m
   cqn2f8uLC4426/aGG/J8J3MDe4zAcykBaL/8Ar077x3U29r1GAvqQLHCk
   9TvWL5ccGcAb33EaKGIKqzKk1YK56GUlei4L+GBMIWA5buOPY1GYtoaCo
   Lh2NndkT9rqJl3/9/xpSWyZF3uU91/jigy7OlpfDJD0hVPL4dW9BDpi8m
   XZbjpBALk9aLTBV6WY4yrVRpIAsty96GZ7u3fECzJ3Xoo7yDq1w1lKsYF
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10523"; a="307916112"
X-IronPort-AV: E=Sophos;i="5.96,143,1665471600"; 
   d="scan'208";a="307916112"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2022 15:47:44 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10523"; a="704674795"
X-IronPort-AV: E=Sophos;i="5.96,143,1665471600"; 
   d="scan'208";a="704674795"
Received: from durgasin-mobl.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.212.240.219])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2022 15:47:43 -0800
Subject: [ndctl PATCH 10/15] cxl/region: Make granularity an integer argument
From: Dan Williams <dan.j.williams@intel.com>
To: vishal.l.verma@intel.com
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Date: Sun, 06 Nov 2022 15:47:43 -0800
Message-ID: <166777846318.1238089.17514328437318093896.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <166777840496.1238089.5601286140872803173.stgit@dwillia2-xfh.jf.intel.com>
References: <166777840496.1238089.5601286140872803173.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Since --granularity does not take a unit value like --size, just make it an
integer argument directly and skip the hand coded conversion.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 cxl/region.c |   26 +++++++++++---------------
 1 file changed, 11 insertions(+), 15 deletions(-)

diff --git a/cxl/region.c b/cxl/region.c
index 494da5139c05..c6d7d1a973a8 100644
--- a/cxl/region.c
+++ b/cxl/region.c
@@ -21,24 +21,25 @@
 static struct region_params {
 	const char *bus;
 	const char *size;
-	const char *granularity;
 	const char *type;
 	const char *root_decoder;
 	const char *region;
 	int ways;
+	int granularity;
 	bool memdevs;
 	bool force;
 	bool human;
 	bool debug;
 } param = {
 	.ways = INT_MAX,
+	.granularity = INT_MAX,
 };
 
 struct parsed_params {
 	u64 size;
 	u64 ep_min_size;
 	int ways;
-	unsigned int granularity;
+	int granularity;
 	const char **targets;
 	int num_targets;
 	struct cxl_decoder *root_decoder;
@@ -67,9 +68,8 @@ OPT_STRING('s', "size", &param.size, \
 	   "total size desired for the resulting region."), \
 OPT_INTEGER('w', "ways", &param.ways, \
 	    "number of memdevs participating in the regions interleave set"), \
-OPT_STRING('g', "granularity", \
-	   &param.granularity, "interleave granularity", \
-	   "granularity of the interleave set"), \
+OPT_INTEGER('g', "granularity", &param.granularity,  \
+	    "granularity of the interleave set"), \
 OPT_STRING('t', "type", &param.type, \
 	   "region type", "region type - 'pmem' or 'ram'"), \
 OPT_BOOLEAN('m', "memdevs", &param.memdevs, \
@@ -140,18 +140,15 @@ static int parse_create_options(int argc, const char **argv,
 		return -EINVAL;
 	}
 
-	if (param.granularity) {
-		unsigned long granularity = strtoul(param.granularity, NULL, 0);
-
-		if (granularity == ULONG_MAX || (int)granularity <= 0) {
-			log_err(&rl, "Invalid interleave granularity: %s\n",
+	if (param.granularity < INT_MAX) {
+		if (param.granularity <= 0) {
+			log_err(&rl, "Invalid interleave granularity: %d\n",
 				param.granularity);
 			return -EINVAL;
 		}
-		p->granularity = granularity;
+		p->granularity = param.granularity;
 	}
 
-
 	if (argc > p->ways) {
 		for (i = p->ways; i < argc; i++)
 			log_err(&rl, "extra argument: %s\n", p->targets[i]);
@@ -390,12 +387,11 @@ static int cxl_region_determine_granularity(struct cxl_region *region,
 					    struct parsed_params *p)
 {
 	const char *devname = cxl_region_get_devname(region);
-	unsigned int granularity;
-	int ways;
+	int granularity, ways;
 
 	/* Default granularity will be the root decoder's granularity */
 	granularity = cxl_decoder_get_interleave_granularity(p->root_decoder);
-	if (granularity == 0 || granularity == UINT_MAX) {
+	if (granularity == 0 || granularity == -1) {
 		log_err(&rl, "%s: unable to determine root decoder granularity\n",
 			devname);
 		return -ENXIO;


Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8E294C76
	for <nvdimm@lists.linux.dev>; Thu, 14 Jul 2022 17:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657818122; x=1689354122;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EpKSZRUg6s+nHr80Ig7EQknua3MGIHFjqj++oJFMvrE=;
  b=bLVtHL0q3wC78PQXVU5dcg0eI5DSpqu38ARX0GxnovuCjKVWG1FMLvZJ
   8WQzSp+TbQFhAFBTVqEAHsNuKlZSF7uUHs0wTnNs3OAruLelgmxS1KxRz
   v9mgIBCaHH97JjW4z1HIzrybSD5yQMllUguS6jPnLMKk7RrY0+XgBSlGp
   mUDq3zGrd8XoBjdn+BrHhir8z0rmrLF6R5HdceJblBrfdLewrIFw+bjC+
   vsBENlYgwRWCUXe/5e3j1UUVVAFnzSYUYloPtZnWrvSIvNZIulERLZV+V
   gvvngQU3RDwVYibMs5UxjJEHZhbAUTq3Q9DUCb8sLr4/tR9yvD/dvLCk7
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10408"; a="347254264"
X-IronPort-AV: E=Sophos;i="5.92,271,1650956400"; 
   d="scan'208";a="347254264"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 10:01:53 -0700
X-IronPort-AV: E=Sophos;i="5.92,271,1650956400"; 
   d="scan'208";a="772693773"
Received: from jlcone-mobl1.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.209.2.90])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 10:01:53 -0700
Subject: [ndctl PATCH v2 01/12] cxl/list: Reformat option list
From: Dan Williams <dan.j.williams@intel.com>
To: vishal.l.verma@intel.com
Cc: Davidlohr Bueso <dave@stgolabs.net>, alison.schofield@intel.com,
 nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
Date: Thu, 14 Jul 2022 10:01:52 -0700
Message-ID: <165781811294.1555691.6271986101970794441.stgit@dwillia2-xfh.jf.intel.com>
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

Cleanup some spurious spaces and let clang-format re-layout the options.

Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 cxl/list.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/cxl/list.c b/cxl/list.c
index 940782d33a10..1b5f58328047 100644
--- a/cxl/list.c
+++ b/cxl/list.c
@@ -36,8 +36,7 @@ static const struct option options[] = {
 		   "filter by CXL endpoint device name(s)"),
 	OPT_BOOLEAN('E', "endpoints", &param.endpoints,
 		    "include CXL endpoint info"),
-	OPT_STRING('d', "decoder", &param.decoder_filter,
-		   "decoder device name",
+	OPT_STRING('d', "decoder", &param.decoder_filter, "decoder device name",
 		   "filter by CXL decoder device name(s) / class"),
 	OPT_BOOLEAN('D', "decoders", &param.decoders,
 		    "include CXL decoder info"),
@@ -45,11 +44,11 @@ static const struct option options[] = {
 		    "include CXL target data with decoders or ports"),
 	OPT_BOOLEAN('i', "idle", &param.idle, "include disabled devices"),
 	OPT_BOOLEAN('u', "human", &param.human,
-		    "use human friendly number formats "),
+		    "use human friendly number formats"),
 	OPT_BOOLEAN('H', "health", &param.health,
-		    "include memory device health information "),
+		    "include memory device health information"),
 	OPT_BOOLEAN('I', "partition", &param.partition,
-		    "include memory device partition information "),
+		    "include memory device partition information"),
 #ifdef ENABLE_DEBUG
 	OPT_BOOLEAN(0, "debug", &debug, "debug list walk"),
 #endif


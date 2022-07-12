Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0DE953B2
	for <nvdimm@lists.linux.dev>; Tue, 12 Jul 2022 19:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657652851; x=1689188851;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3XEEQ2shlsXB1UcMa1ofYK+LWnGEANhuw7/bWmk4khg=;
  b=jlOM7xilJBSYOYa4HzmuvsIIt4raqvs4dfxmNe2oE9kUjIpzPFf4XGqr
   de96S98URM39FWTe8VJguhSWKT1BK07/E81BCMIpYtXUDkh9BPb3AaIlV
   B5WCcpYYIRXGi79FXjXNjqMnMAcKsFoVHFtTYmeLEhfCJc7iChpd0Jgmv
   gZli86fynX7pYuZAoRhCxv9TwYpalO5hq8laHMBJ1y6ud7dXu6QXJblVR
   /gjsva84ZtkkqHgNj4s33FA9l278KPDJEVsnm9Y6rbeS6+ipyOyxn44FP
   xRp1nrLqQ81AHsSuo0jt6PiGg52NDD/IucXZzgmg9XlESJZbG/4IjGVYL
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10406"; a="371332949"
X-IronPort-AV: E=Sophos;i="5.92,266,1650956400"; 
   d="scan'208";a="371332949"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2022 12:07:31 -0700
X-IronPort-AV: E=Sophos;i="5.92,266,1650956400"; 
   d="scan'208";a="922326367"
Received: from sheyting-mobl3.amr.corp.intel.com (HELO [192.168.1.117]) ([10.212.147.156])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2022 12:07:30 -0700
Subject: [ndctl PATCH 01/11] cxl/list: Reformat option list
From: Dan Williams <dan.j.williams@intel.com>
To: vishal.l.verma@intel.com
Cc: alison.schofield@intel.com, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org
Date: Tue, 12 Jul 2022 12:07:29 -0700
Message-ID: <165765284992.435671.17218875214208199972.stgit@dwillia2-xfh>
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

Cleanup some spurious spaces and let clang-format re-layout the options.

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


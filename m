Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0321E138F
	for <nvdimm@lists.linux.dev>; Thu, 28 Apr 2022 22:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651183812; x=1682719812;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RFAyZN2/4uvSqxhe+/wCCpJLam8t6Vv9GJQX9Qczqpo=;
  b=jWqcWTSZcKg2LmqWMIby6LqXNVsUC+VMVyNOi5klGhrxzoAOMMq8Ekp3
   5Y035rRTdPBwyocVcaDSu1HQ5dRTozQXFANFEnCx6MycQDZHw655cJuNk
   lnRRfF8GhZ1a1/jUaD8vGcCxu+h8Xgw6Sb4R52ZqbzVytGY7nqcZYf57z
   rXxQhtQ13dEju+wS1faW76tazIG34STvx5oq+T+ZIvT5YoFbEtrjheBl7
   y2j/d7hRavUJ5ZZK56K2ByyekcJcuyStUQDyvJnkt94SO05+VYAhSAJIb
   0C6QFA+/4zBgtqZqF3X5TrGUrk+7A74Z1otaaN41nLHYhFAkiYXjuMRVj
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10331"; a="266597231"
X-IronPort-AV: E=Sophos;i="5.91,296,1647327600"; 
   d="scan'208";a="266597231"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 15:10:11 -0700
X-IronPort-AV: E=Sophos;i="5.91,296,1647327600"; 
   d="scan'208";a="618356191"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 15:10:11 -0700
Subject: [ndctl PATCH 02/10] util: Use SZ_ size macros in display size
From: Dan Williams <dan.j.williams@intel.com>
To: vishal.l.verma@intel.com
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Date: Thu, 28 Apr 2022 15:10:11 -0700
Message-ID: <165118381109.1676208.8857362319985041575.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <165118380037.1676208.7644295506592461996.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <165118380037.1676208.7644295506592461996.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

In preparation for adding "Terabyte" support, cleanup the "1024"
multiplication with the SZ_* macros.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 util/json.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/util/json.c b/util/json.c
index f8cc81f6e706..ebdf8d9eedd9 100644
--- a/util/json.c
+++ b/util/json.c
@@ -5,6 +5,7 @@
 #include <stdio.h>
 #include <util/util.h>
 #include <util/json.h>
+#include <util/size.h>
 #include <json-c/json.h>
 #include <json-c/printbuf.h>
 
@@ -27,24 +28,24 @@ static int display_size(struct json_object *jobj, struct printbuf *pbuf,
 	 * If prefix == JEDEC, we mean prefixes like kilo,mega,giga etc.
 	 */
 
-	if (bytes < 5000*1024)
+	if (bytes < 5000*SZ_1K)
 		snprintf(buf, sizeof(buf), "%lld", bytes);
 	else {
 		/* IEC */
-		if (bytes < 2*1024LL*1024LL*1024LL) {
-			long cMiB = (bytes * 200LL / (1LL<<20) +1) /2;
+		if (bytes < 2L*SZ_1G) {
+			long cMiB = (bytes * 200LL / SZ_1M+1) /2;
 
 			c = snprintf(buf, sizeof(buf), "\"%ld.%02ld MiB",
 					cMiB/100 , cMiB % 100);
 		} else {
-			long cGiB = (bytes * 200LL / (1LL<<30) +1) /2;
+			long cGiB = (bytes * 200LL / SZ_1G+1) /2;
 
 			c = snprintf(buf, sizeof(buf), "\"%ld.%02ld GiB",
 					cGiB/100 , cGiB % 100);
 		}
 
 		/* JEDEC */
-		if (bytes < 2*1024LL*1024LL*1024LL) {
+		if (bytes < 2L*SZ_1G) {
 			long cMB  = (bytes / (1000000LL / 200LL) + 1) / 2;
 
 			snprintf(buf + c, sizeof(buf) - c, " (%ld.%02ld MB)\"",


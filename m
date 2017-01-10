Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 37BF781B10
 for <linux-nvdimm@lists.01.org>; Mon,  9 Jan 2017 17:12:08 -0800 (PST)
Subject: [PATCH 7/9] ndctl: return unit size from parse_size64()
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 09 Jan 2017 17:08:01 -0800
Message-ID: <148401048177.16217.14743190895800442308.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <148401044568.16217.6942951063735168785.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <148401044568.16217.6942951063735168785.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

In preparation for suggesting namespace sizes that satisfy alignment
requirements, add the ability to track the size suffix. The suggestions
will be aligned to the size suffix by default.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 util/size.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/util/size.c b/util/size.c
index 1ca2dcff5e28..6ad622781a27 100644
--- a/util/size.c
+++ b/util/size.c
@@ -2,7 +2,8 @@
 #include <limits.h>
 #include <util/size.h>
 
-unsigned long long parse_size64(const char *str)
+static unsigned long long __parse_size64(const char *str,
+		unsigned long long *units)
 {
 	unsigned long long val, check;
 	char *end;
@@ -14,25 +15,35 @@ unsigned long long parse_size64(const char *str)
 	switch (*end) {
 		case 'k':
 		case 'K':
+			if (units)
+				*units = SZ_1K;
 			val *= SZ_1K;
 			end++;
 			break;
 		case 'm':
 		case 'M':
+			if (units)
+				*units = SZ_1M;
 			val *= SZ_1M;
 			end++;
 			break;
 		case 'g':
 		case 'G':
+			if (units)
+				*units = SZ_1G;
 			val *= SZ_1G;
 			end++;
 			break;
 		case 't':
 		case 'T':
+			if (units)
+				*units = SZ_1T;
 			val *= SZ_1T;
 			end++;
 			break;
 		default:
+			if (units)
+				*units = 1;
 			break;
 	}
 
@@ -40,3 +51,8 @@ unsigned long long parse_size64(const char *str)
 		val = ULLONG_MAX;
 	return val;
 }
+
+unsigned long long parse_size64(const char *str)
+{
+	return __parse_size64(str, NULL);
+}

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

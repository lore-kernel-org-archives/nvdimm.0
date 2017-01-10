Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BB2C381B17
 for <linux-nvdimm@lists.01.org>; Mon,  9 Jan 2017 17:12:18 -0800 (PST)
Subject: [PATCH 9/9] ndctl,
 create-namespace: enforce --size must be even multiple of
 interleave-width
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 09 Jan 2017 17:08:12 -0800
Message-ID: <148401049211.16217.1553285320779246446.stgit@dwillia2-desk3.amr.corp.intel.com>
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

If we don't check the size is properly aligned then the kernel will
cause the create-namespace request to abort. When the size is not
properly aligned suggest an alternative (rounded to the same units that
user specified) and bail out early without disturbing the current
configuration.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/builtin-xaction-namespace.c |   34 +++++++++++++++++++++++++++++++++-
 util/size.c                       |    3 +--
 util/size.h                       |    1 +
 3 files changed, 35 insertions(+), 3 deletions(-)

diff --git a/ndctl/builtin-xaction-namespace.c b/ndctl/builtin-xaction-namespace.c
index eb289b0e392f..5a19729b6376 100644
--- a/ndctl/builtin-xaction-namespace.c
+++ b/ndctl/builtin-xaction-namespace.c
@@ -26,6 +26,7 @@
 #include <util/filter.h>
 #include <ndctl/libndctl.h>
 #include <util/parse-options.h>
+#include <ccan/minmax/minmax.h>
 #include <ccan/array_size/array_size.h>
 
 #ifdef HAVE_NDCTL_H
@@ -398,6 +399,8 @@ static int validate_namespace_options(struct ndctl_region *region,
 		struct ndctl_namespace *ndns, struct parsed_parameters *p)
 {
 	const char *region_name = ndctl_region_get_devname(region);
+	unsigned long long size_align, units = 1;
+	unsigned int ways;
 	int rc = 0;
 
 	memset(p, 0, sizeof(*p));
@@ -408,7 +411,7 @@ static int validate_namespace_options(struct ndctl_region *region,
 	}
 
 	if (param.size)
-		p->size = parse_size64(param.size);
+		p->size = __parse_size64(param.size, &units);
 	else if (ndns)
 		p->size = ndctl_namespace_get_size(ndns);
 
@@ -487,6 +490,35 @@ static int validate_namespace_options(struct ndctl_region *region,
 	} else
 		p->align = SZ_2M;
 
+	/* (re-)validate that the size satisfies the alignment */
+	if (param.align)
+		size_align = p->align;
+	else
+		size_align = SZ_4K;
+	ways = ndctl_region_get_interleave_ways(region);
+	size_align = max(units, size_align) * ways;
+	if (p->size % size_align) {
+		char *suffix = "";
+
+		if (units == SZ_1K)
+			suffix = "K";
+		else if (units == SZ_1M)
+			suffix = "M";
+		else if (units == SZ_1G)
+			suffix = "G";
+		else if (units == SZ_1T)
+			suffix = "T";
+
+		p->size /= size_align;
+		p->size++;
+		p->size *= size_align;
+		p->size /= units;
+		error("'--size=' must align to interleave-width: %d and alignment: %ld\n"
+				"  did you intend --size=%lld%s?\n", ways, param.align
+				? p->align : SZ_4K, p->size, suffix);
+		return -EINVAL;
+	}
+
 	if (param.sector_size) {
 		struct ndctl_btt *btt;
 		int num, i;
diff --git a/util/size.c b/util/size.c
index 6ad622781a27..da76bd94aebd 100644
--- a/util/size.c
+++ b/util/size.c
@@ -2,8 +2,7 @@
 #include <limits.h>
 #include <util/size.h>
 
-static unsigned long long __parse_size64(const char *str,
-		unsigned long long *units)
+unsigned long long __parse_size64(const char *str, unsigned long long *units)
 {
 	unsigned long long val, check;
 	char *end;
diff --git a/util/size.h b/util/size.h
index 634c92621bdc..776363fd19e9 100644
--- a/util/size.h
+++ b/util/size.h
@@ -12,5 +12,6 @@
 #define SZ_1T 0x10000000000ULL
 
 unsigned long long parse_size64(const char *str);
+unsigned long long __parse_size64(const char *str, unsigned long long *units);
 
 #endif /* _NDCTL_SIZE_H_ */

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

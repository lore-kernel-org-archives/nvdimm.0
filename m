Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B72D02095A6D4
 for <linux-nvdimm@lists.01.org>; Mon, 26 Jun 2017 11:57:48 -0700 (PDT)
Subject: [ndctl PATCH] ndctl: clamp dimm formats
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 26 Jun 2017 11:52:51 -0700
Message-ID: <149850317133.1029.10640606828642185986.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Static analysis warns about unbounded values of 'formats' being passed
to calloc. Clamp to the known allowed values.

This also updates the max() macro to avoid 'variable shadowed' warnings.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ccan/minmax/minmax.h |    8 ++++----
 ndctl/lib/libndctl.c |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/ccan/minmax/minmax.h b/ccan/minmax/minmax.h
index d111d1bc3809..54f246cc112d 100644
--- a/ccan/minmax/minmax.h
+++ b/ccan/minmax/minmax.h
@@ -32,10 +32,10 @@
 
 #define max(a, b) \
 	({ \
-		typeof(a) _a = (a); \
-		typeof(b) _b = (b); \
-		MINMAX_ASSERT_COMPATIBLE(typeof(_a), typeof(_b)); \
-		_a > _b ? _a : _b; \
+		typeof(a) __a = (a); \
+		typeof(b) __b = (b); \
+		MINMAX_ASSERT_COMPATIBLE(typeof(__a), typeof(__b)); \
+		__a > __b ? __a : __b; \
 	})
 
 #define clamp(v, f, c)	(max(min((v), (c)), (f)))
diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index 4acebc05d6db..3b34a10fd429 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -1170,7 +1170,7 @@ static void *add_dimm(void *parent, int id, const char *dimm_base)
 	if (sysfs_read_attr(ctx, path, buf) < 0)
 		formats = 1;
 	else
-		formats = strtoul(buf, NULL, 0);
+		formats = clamp(strtoul(buf, NULL, 0), 1UL, 2UL);
 
 	dimm = calloc(1, sizeof(*dimm) + sizeof(int) * formats);
 	if (!dimm)

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

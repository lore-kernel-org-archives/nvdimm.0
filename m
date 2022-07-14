Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F39F6002
	for <nvdimm@lists.linux.dev>; Thu, 14 Jul 2022 17:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657818156; x=1689354156;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8pHDEH3ziJVotJ1oYBiooCwlZBWAUamzVCenaWfGOWU=;
  b=aiftfanPxMMj6MMkQnf4psmp2ALZfiyRrp3rxWr4vqrDq6aXZtzsFVth
   i38oatHLRxq8O2of11rGjeu+IRnymcy1Q9SFSnCXhRe5m3vUac4SPHTVE
   MwMy+VcrIiSIbQashaHUOiPfWQGavO7f+7Hc0XHl5A4bi1H2afLK2hzgv
   D66h11M4xKXbhCfp3ClO5jf6pMWgE/IiZlM3/LedBloGt/w/mGIOAKNOn
   GGapSFwrKienW7aAs12nCUipzknc0tokR/OFDQw00Ou0NGTTo9wTqPBZg
   fKYQpq3Plv8ZSzrcLSWLIQByGNc4eJqxT7CfkpwZEOf5Y9+X0zgFQ1+Rs
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10408"; a="268602718"
X-IronPort-AV: E=Sophos;i="5.92,271,1650956400"; 
   d="scan'208";a="268602718"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 10:02:31 -0700
X-IronPort-AV: E=Sophos;i="5.92,271,1650956400"; 
   d="scan'208";a="842214200"
Received: from jlcone-mobl1.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.209.2.90])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 10:02:22 -0700
Subject: [ndctl PATCH v2 06/12] cxl/lib: Maintain decoders in id order
From: Dan Williams <dan.j.williams@intel.com>
To: vishal.l.verma@intel.com
Cc: Davidlohr Bueso <dave@stgolabs.net>, alison.schofield@intel.com,
 nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
Date: Thu, 14 Jul 2022 10:02:21 -0700
Message-ID: <165781814167.1555691.14895625637451030942.stgit@dwillia2-xfh.jf.intel.com>
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

Given that decoder instance order is fundamental to the DPA translation
sequence for endpoint decoders, enforce that cxl_decoder_for_each() returns
decoders in instance order. Otherwise, they show up in readddir() order
which is not predictable.

Add a list_add_sorted() to generically handle inserting into a sorted list.

Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 cxl/lib/libcxl.c |    8 +++++++-
 util/list.h      |   39 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 46 insertions(+), 1 deletion(-)
 create mode 100644 util/list.h

diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index f36edcfc735a..e4c5d3819e88 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -19,6 +19,7 @@
 #include <ccan/short_types/short_types.h>
 
 #include <util/log.h>
+#include <util/list.h>
 #include <util/size.h>
 #include <util/sysfs.h>
 #include <util/bitmap.h>
@@ -908,6 +909,11 @@ cxl_endpoint_get_memdev(struct cxl_endpoint *endpoint)
 	return NULL;
 }
 
+static int decoder_id_cmp(struct cxl_decoder *d1, struct cxl_decoder *d2)
+{
+	return d1->id - d2->id;
+}
+
 static void *add_cxl_decoder(void *parent, int id, const char *cxldecoder_base)
 {
 	const char *devname = devpath_to_devname(cxldecoder_base);
@@ -1049,7 +1055,7 @@ static void *add_cxl_decoder(void *parent, int id, const char *cxldecoder_base)
 			return decoder_dup;
 		}
 
-	list_add(&port->decoders, &decoder->list);
+	list_add_sorted(&port->decoders, decoder, list, decoder_id_cmp);
 
 	free(path);
 	return decoder;
diff --git a/util/list.h b/util/list.h
new file mode 100644
index 000000000000..cb7727123ea8
--- /dev/null
+++ b/util/list.h
@@ -0,0 +1,39 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2022 Intel Corporation. All rights reserved. */
+#ifndef _NDCTL_LIST_H_
+#define _NDCTL_LIST_H_
+
+#include <ccan/list/list.h>
+
+#define list_add_sorted(head, n, node, cmp)                                    \
+	do {                                                                   \
+		struct list_head *__head = (head);                             \
+		typeof(n) __iter, __next;                                      \
+		typeof(n) __new = (n);                                         \
+                                                                               \
+		if (list_empty(__head)) {                                      \
+			list_add(__head, &__new->node);                        \
+			break;                                                 \
+		}                                                              \
+                                                                               \
+		list_for_each (__head, __iter, node) {                         \
+			if (cmp(__new, __iter) < 0) {                          \
+				list_add_before(__head, &__iter->node,         \
+						&__new->node);                 \
+				break;                                         \
+			}                                                      \
+			__next = list_next(__head, __iter, node);              \
+			if (!__next) {                                         \
+				list_add_after(__head, &__iter->node,          \
+					       &__new->node);                  \
+				break;                                         \
+			}                                                      \
+			if (cmp(__new, __next) < 0) {                          \
+				list_add_before(__head, &__next->node,         \
+						&__new->node);                 \
+				break;                                         \
+			}                                                      \
+		}                                                              \
+	} while (0)
+
+#endif /* _NDCTL_LIST_H_ */


Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwym04.jp.fujitsu.com (mgwym04.jp.fujitsu.com [211.128.242.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 167F02041B281
 for <linux-nvdimm@lists.01.org>; Wed, 25 Apr 2018 00:40:28 -0700 (PDT)
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
 by yt-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 8DD1BAC046F
 for <linux-nvdimm@lists.01.org>;
 Wed, 25 Apr 2018 16:40:24 +0900 (JST)
From: QI Fuli <qi.fuli@jp.fujitsu.com>
Subject: [PATCH] ndctl,
 filter: fix "keyword 'all' is ignored" in util_<obj>_filter()
Date: Wed, 25 Apr 2018 16:38:43 +0900
Message-Id: <20180425073843.19900-1-qi.fuli@jp.fujitsu.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

This is a follow up patch for commit c70adc3cf6bf ("ndctl, filter: refactor
util_<obj>_filter() to support multiple space-seperated arguments")
refactored util_<obj>_filter() to support multiple space-seperated arguments.
But, when the keyword "all" is included in space-seperated arguments,
it will be treaded as <object>'s name. This patch fixes it.

Signed-off-by: QI Fuli <qi.fuli@jp.fujitsu.com>
---
 util/filter.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/util/filter.c b/util/filter.c
index 0d3cc02..9081a6d 100644
--- a/util/filter.c
+++ b/util/filter.c
@@ -40,6 +40,9 @@ struct ndctl_bus *util_bus_filter(struct ndctl_bus *bus, const char *__ident)
 
 	for (name = strtok_r(ident, " ", &save); name;
 			name = strtok_r(NULL, " ", &save)) {
+		if (strcmp(ident, "all") == 0)
+			break;
+
 		bus_id = strtoul(ident, &end, 0);
 		if (end == ident || end[0])
 			bus_id = ULONG_MAX;
@@ -78,6 +81,9 @@ struct ndctl_region *util_region_filter(struct ndctl_region *region,
 
 	for (name = strtok_r(ident, " ", &save); name;
 			name = strtok_r(NULL, " ", &save)) {
+		if (strcmp(ident, "all") == 0)
+			break;
+
 		region_id = strtoul(ident, &end, 0);
 		if (end == ident || end[0])
 			region_id = ULONG_MAX;
@@ -115,6 +121,9 @@ struct ndctl_namespace *util_namespace_filter(struct ndctl_namespace *ndns,
 
 	for (name = strtok_r(ident, " ", &save); name;
 			name = strtok_r(NULL, " ", &save)) {
+		if (strcmp(ident, "all") == 0)
+			break;
+
 		if (strcmp(name, ndctl_namespace_get_devname(ndns)) == 0)
 			break;
 
@@ -146,6 +155,9 @@ struct ndctl_dimm *util_dimm_filter(struct ndctl_dimm *dimm,
 
 	for (name = strtok_r(ident, " ", &save); name;
 			name = strtok_r(NULL, " ", &save)) {
+		if (strcmp(ident, "all") == 0)
+			break;
+
 		dimm_id = strtoul(ident, &end, 0);
 		if (end == ident || end[0])
 			dimm_id = ULONG_MAX;
-- 
2.17.0.140.g0b0cc9f86


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

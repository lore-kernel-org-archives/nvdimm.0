Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AF1BA21A10961
 for <linux-nvdimm@lists.01.org>; Fri,  1 Dec 2017 15:28:49 -0800 (PST)
Subject: [ndctl PATCH 06/17] ndctl, test: emit smart field names
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 01 Dec 2017 15:25:02 -0800
Message-ID: <151217070197.28402.15413187772658826772.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <151217066885.28402.7962437173336388439.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <151217066885.28402.7962437173336388439.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Make the SMART tests easier to debug by emitting the field name.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/libndctl.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/test/libndctl.c b/test/libndctl.c
index 5189f7886481..b534b640cb8d 100644
--- a/test/libndctl.c
+++ b/test/libndctl.c
@@ -2122,8 +2122,9 @@ static int check_set_config_data(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
 
 #define __check_smart(dimm, cmd, field) ({ \
 	if (ndctl_cmd_smart_get_##field(cmd) != smart_data.field) { \
-		fprintf(stderr, "%s dimm: %#x expected field %#x got: %#x\n", \
-				__func__, ndctl_dimm_get_handle(dimm), \
+		fprintf(stderr, "%s dimm: %#x expected \'" #field \
+				"\' %#x got: %#x\n", __func__, \
+				ndctl_dimm_get_handle(dimm), \
 				smart_data.field, \
 				ndctl_cmd_smart_get_##field(cmd)); \
 		ndctl_cmd_unref(cmd); \
@@ -2187,8 +2188,9 @@ static int check_smart(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
 
 #define __check_smart_threshold(dimm, cmd, field) ({ \
 	if (ndctl_cmd_smart_threshold_get_##field(cmd) != smart_t_data.field) { \
-		fprintf(stderr, "%s dimm: %#x expected field %#x got: %#x\n", \
-				__func__, ndctl_dimm_get_handle(dimm), \
+		fprintf(stderr, "%s dimm: %#x expected \'" #field \
+				"\' %#x got: %#x\n", __func__, \
+				ndctl_dimm_get_handle(dimm), \
 				smart_t_data.field, \
 				ndctl_cmd_smart_threshold_get_##field(cmd)); \
 		ndctl_cmd_unref(cmd); \

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

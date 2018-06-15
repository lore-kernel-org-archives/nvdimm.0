Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8A42B21114792
 for <linux-nvdimm@lists.01.org>; Thu, 14 Jun 2018 17:37:13 -0700 (PDT)
Subject: [ndctl PATCH 2/2] ndctl,
 test: Update libndctl test for controller temperature valid
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 14 Jun 2018 17:27:15 -0700
Message-ID: <152902243580.9861.7729384829710178825.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <152902243071.9861.114193928672557044.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <152902243071.9861.114193928672557044.stgit@dwillia2-desk3.amr.corp.intel.com>
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

nfit_test is growing support for emitting the controller temperature.
Permit use of the flag, i.e. do not fail upon seeing 'CTEMP_VALID'.

Rather than add a kernel version gate, just be tolerant of any value of
the flag.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/libndctl.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/test/libndctl.c b/test/libndctl.c
index 8098c1c45051..edff0af33c7d 100644
--- a/test/libndctl.c
+++ b/test/libndctl.c
@@ -2177,8 +2177,8 @@ static int check_set_config_data(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
 	return 0;
 }
 
-#define __check_smart(dimm, cmd, field) ({ \
-	if (ndctl_cmd_smart_get_##field(cmd) != smart_data.field) { \
+#define __check_smart(dimm, cmd, field, mask) ({ \
+	if ((ndctl_cmd_smart_get_##field(cmd) & mask) != smart_data.field) { \
 		fprintf(stderr, "%s dimm: %#x expected \'" #field \
 				"\' %#x got: %#x\n", __func__, \
 				ndctl_dimm_get_handle(dimm), \
@@ -2230,14 +2230,14 @@ static int check_smart(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
 		return rc;
 	}
 
-	__check_smart(dimm, cmd, flags);
-	__check_smart(dimm, cmd, health);
-	__check_smart(dimm, cmd, temperature);
-	__check_smart(dimm, cmd, spares);
-	__check_smart(dimm, cmd, alarm_flags);
-	__check_smart(dimm, cmd, life_used);
-	__check_smart(dimm, cmd, shutdown_state);
-	__check_smart(dimm, cmd, vendor_size);
+	__check_smart(dimm, cmd, flags, ~ND_SMART_CTEMP_VALID);
+	__check_smart(dimm, cmd, health, -1);
+	__check_smart(dimm, cmd, temperature, -1);
+	__check_smart(dimm, cmd, spares, -1);
+	__check_smart(dimm, cmd, alarm_flags, -1);
+	__check_smart(dimm, cmd, life_used, -1);
+	__check_smart(dimm, cmd, shutdown_state, -1);
+	__check_smart(dimm, cmd, vendor_size, -1);
 
 	check->cmd = cmd;
 	return 0;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

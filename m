Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CB3FB21E0B9F2
 for <linux-nvdimm@lists.01.org>; Wed, 14 Feb 2018 12:40:45 -0800 (PST)
Subject: [ndctl PATCH] ndctl, smart: fix threshold temperature helper
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 14 Feb 2018 12:37:31 -0800
Message-ID: <151864065168.18750.1020126363573957723.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Dariusz Dokupil <dariusz.dokupil@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

In version v53 libndctl gained smart support and the 'get_temperature'
helper that retrieved media temperature. In v59 libndctl gained
threshold support, and the 'get_temperature_threshold' helper. The
implementation of 'set_temperature_threshold' was inadvertently omitted
from v59. Add a definition so that applications that use the declared
symbol can build.

Reported-by: Dariusz Dokupil <dariusz.dokupil@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/lib/smart.c |    6 ++++++
 test/libndctl.c   |    3 ++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/ndctl/lib/smart.c b/ndctl/lib/smart.c
index 4ab94bb780cf..b76a4de1db62 100644
--- a/ndctl/lib/smart.c
+++ b/ndctl/lib/smart.c
@@ -117,6 +117,12 @@ smart_cmd_set_op(smart_threshold_set_media_temperature)
 smart_cmd_set_op(smart_threshold_set_ctrl_temperature)
 smart_cmd_set_op(smart_threshold_set_spares)
 
+NDCTL_EXPORT int ndctl_cmd_smart_threshold_set_temperature(
+		struct ndctl_cmd *cmd, unsigned int val)
+{
+	return ndctl_cmd_smart_threshold_set_media_temperature(cmd, val);
+}
+
 NDCTL_EXPORT struct ndctl_cmd *ndctl_dimm_cmd_new_smart_inject(
 		struct ndctl_dimm *dimm)
 {
diff --git a/test/libndctl.c b/test/libndctl.c
index 7fecfe2e804b..a66bcb7dfe87 100644
--- a/test/libndctl.c
+++ b/test/libndctl.c
@@ -2297,7 +2297,8 @@ static int check_smart_threshold(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
 		 */
 		rc = ndctl_cmd_smart_threshold_set_alarm_control(cmd_set,
 				ndctl_cmd_smart_threshold_get_supported_alarms(cmd_set));
-		rc |= ndctl_cmd_smart_threshold_set_media_temperature(cmd_set,
+		/* 'set_temperature' and 'set_media_temperature' are aliases */
+		rc |= ndctl_cmd_smart_threshold_set_temperature(cmd_set,
 				ndctl_cmd_smart_get_media_temperature(cmd_smart));
 		rc |= ndctl_cmd_smart_threshold_set_ctrl_temperature(cmd_set,
 				ndctl_cmd_smart_get_ctrl_temperature(cmd_smart));

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

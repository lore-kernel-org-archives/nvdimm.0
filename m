Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g9t5009.houston.hpe.com (g9t5009.houston.hpe.com [15.241.48.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 73F591A1F24
 for <linux-nvdimm@lists.01.org>; Fri, 16 Sep 2016 13:12:02 -0700 (PDT)
From: Brian Boylston <brian.boylston@hpe.com>
Subject: [ndctl PATCH v3 3/4] libndctl: enable ND_CMD_CALL
Date: Fri, 16 Sep 2016 15:10:12 -0500
Message-Id: <20160916201013.555-4-brian.boylston@hpe.com>
In-Reply-To: <20160916201013.555-1-brian.boylston@hpe.com>
References: <20160916201013.555-1-brian.boylston@hpe.com>
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

. Enable parsing /sys/bus/nd/devices/nmemX/commands for ND_CMD_CALL
. Enable translation of ND_CMD_CALL to ND_IOCTL_CALL

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Brian Boylston <brian.boylston@hpe.com>
---
 ndctl/lib/libndctl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index 99938be..7a847fa 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -719,7 +719,7 @@ static int to_dsm_index(const char *name, int dimm)
 	int i, end_cmd;
 
 	if (dimm) {
-		end_cmd = ND_CMD_VENDOR;
+		end_cmd = ND_CMD_CALL;
 		cmd_name_fn = nvdimm_cmd_name;
 	} else {
 		end_cmd = nd_cmd_clear_error;
@@ -2183,6 +2183,7 @@ static int to_ioctl_cmd(int cmd, int dimm)
 	case ND_CMD_GET_CONFIG_DATA:        return ND_IOCTL_GET_CONFIG_DATA;
 	case ND_CMD_SET_CONFIG_DATA:        return ND_IOCTL_SET_CONFIG_DATA;
 	case ND_CMD_VENDOR:                 return ND_IOCTL_VENDOR;
+	case ND_CMD_CALL:                   return ND_IOCTL_CALL;
 	case ND_CMD_VENDOR_EFFECT_LOG_SIZE:
 	case ND_CMD_VENDOR_EFFECT_LOG:
 	default:
-- 
2.8.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

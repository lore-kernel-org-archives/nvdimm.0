Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com
 [IPv6:2607:f8b0:4864:20::444])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 079B6211B85E8
 for <linux-nvdimm@lists.01.org>; Wed, 30 Jan 2019 02:27:01 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id c123so11243669pfb.0
 for <linux-nvdimm@lists.01.org>; Wed, 30 Jan 2019 02:27:01 -0800 (PST)
From: Oliver O'Halloran <oohall@gmail.com>
Subject: [PATCH] libndctl, dimm: Don't require an xlat function
Date: Wed, 30 Jan 2019 21:26:45 +1100
Message-Id: <20190130102645.31032-1-oohall@gmail.com>
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

commit 62bbfce3cb62 ("libndctl, intel: Add infrastructure for
firmware_status translation") has the unfortunate side effect of making
all NDCTL commands fail with -ENOMSG unless an xlat_firmware_status
function is defined for the DIMM family. This means that none of the
DIMM label manipulation commands work anymore, unless you happen to be
using an Intel DIMM.

Cc: Vishal Verma <vishal.l.verma@intel.com>
Fixes: 62bbfce3cb62 ("libndctl, intel: Add infrastructure for firmware_status translation")
Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
---
 ndctl/lib/libndctl.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index 06f835d76117..80d107394a74 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -2846,6 +2846,9 @@ NDCTL_EXPORT int ndctl_cmd_submit_xlat(struct ndctl_cmd *cmd)
 	 * useful), then the xlat function is available separately as well.
 	 */
 	xlat_rc = ndctl_cmd_xlat_firmware_status(cmd);
+	if (xlat_rc == -ENOMSG)
+		return rc;
+
 	return (xlat_rc == 0) ? rc : xlat_rc;
 }
 
-- 
2.20.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

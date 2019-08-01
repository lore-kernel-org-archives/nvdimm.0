Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2F926212FE8B7
 for <linux-nvdimm@lists.01.org>; Thu,  1 Aug 2019 14:57:28 -0700 (PDT)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: [patch] nfit: report frozen security state
Date: Thu, 01 Aug 2019 17:54:56 -0400
Message-ID: <x49k1bw7dqn.fsf@segfault.boston.devel.redhat.com>
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
To: dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

If a dimm is frozen, it is currently reported as being "locked".  While
that's not technically wrong, it is misleading as the dimm can't be
unlocked.  Fix the confusion.

Thanks to Dan for pointing this out.

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>

diff --git a/drivers/acpi/nfit/intel.c b/drivers/acpi/nfit/intel.c
index cddd0fcf622c..0df2216b2c68 100644
--- a/drivers/acpi/nfit/intel.c
+++ b/drivers/acpi/nfit/intel.c
@@ -54,12 +54,12 @@ static enum nvdimm_security_state intel_security_state(struct nvdimm *nvdimm,
 		if (nd_cmd.cmd.state & ND_INTEL_SEC_STATE_UNSUPPORTED)
 			return -ENXIO;
 		else if (nd_cmd.cmd.state & ND_INTEL_SEC_STATE_ENABLED) {
-			if (nd_cmd.cmd.state & ND_INTEL_SEC_STATE_LOCKED)
-				return NVDIMM_SECURITY_LOCKED;
-			else if (nd_cmd.cmd.state & ND_INTEL_SEC_STATE_FROZEN
+			if (nd_cmd.cmd.state & ND_INTEL_SEC_STATE_FROZEN
 					|| nd_cmd.cmd.state &
 					ND_INTEL_SEC_STATE_PLIMIT)
 				return NVDIMM_SECURITY_FROZEN;
+			else if (nd_cmd.cmd.state & ND_INTEL_SEC_STATE_LOCKED)
+				return NVDIMM_SECURITY_LOCKED;
 			else
 				return NVDIMM_SECURITY_UNLOCKED;
 		}
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

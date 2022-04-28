Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 998551843
	for <nvdimm@lists.linux.dev>; Thu, 28 Apr 2022 23:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651190098; x=1682726098;
  h=subject:from:to:cc:date:message-id:mime-version:
   content-transfer-encoding;
  bh=9ghc5xys4b5mMhFTJ7wpef3dneV4GyoA6BP0qu8W56o=;
  b=VFwO+dnVRaANZfHtqUcK32fQetngLtnAB7Bm4M07HJZQt1n0YuvKny0l
   udkAAhimpUtpGgi8QKsU7/WA+svHV7AMregwhl7xGN8OPvfJn5LZ96JO1
   2Ba8Kjo+LtU2f1nak1eulTRCPTj0lJZzFF9k8NoP/mxT79QkFikmwoHYQ
   smGTgPcyRVjDB7XzpcLBkX4vVwOdfBXE9KCceP8Wvif6qKLstE0MoAPTf
   DREerfcVba1d9FrA2LFPmt8rUe0cV1ATDsDlopCiV8M/TsPV/s+imdvzZ
   EgxFLRxoKfT2K6Gc1kvxKwXbUsPqlMdmjp675aUe5PFGuJtYM/P+PTUuA
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10331"; a="264052605"
X-IronPort-AV: E=Sophos;i="5.91,296,1647327600"; 
   d="scan'208";a="264052605"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 16:54:48 -0700
X-IronPort-AV: E=Sophos;i="5.91,296,1647327600"; 
   d="scan'208";a="581720253"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 16:54:48 -0700
Subject: [ndctl PATCH] ndctl/dimm: Flush invalidated labels after overwrite
From: Dan Williams <dan.j.williams@intel.com>
To: vishal.l.verma@intel.com
Cc: Jeff Moyer <jmoyer@redhat.com>, Dave Jiang <dave.jiang@intel.com>,
 linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Date: Thu, 28 Apr 2022 16:54:48 -0700
Message-ID: <165119008839.1783158.3766085644383173318.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Similar to "ndctl write-labels", after "ndctl sanitize-dimm --overwrite"
the kernel may contain a cached copy of the label area that has been
invalidated by the overwrite. Toggle the enabled state of the dimm-device
to trigger the kernel to release the cached copy.

Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/all/165118817010.1772793.5101398830527716084.stgit@dwillia2-desk3.amr.corp.intel.com/
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/dimm.c |   34 ++++++++++++++++++++++------------
 1 file changed, 22 insertions(+), 12 deletions(-)

diff --git a/ndctl/dimm.c b/ndctl/dimm.c
index d9718a33b22f..ac7c5270e971 100644
--- a/ndctl/dimm.c
+++ b/ndctl/dimm.c
@@ -354,6 +354,23 @@ static int rw_bin(FILE *f, struct ndctl_cmd *cmd, ssize_t size,
 	return 0;
 }
 
+static int revalidate_labels(struct ndctl_dimm *dimm)
+{
+	int rc;
+
+	/*
+	 * If the dimm is already disabled the kernel is not holding a cached
+	 * copy of the label space.
+	 */
+	if (!ndctl_dimm_is_enabled(dimm))
+		return 0;
+
+	rc = ndctl_dimm_disable(dimm);
+	if (rc)
+		return rc;
+	return ndctl_dimm_enable(dimm);
+}
+
 static int action_write(struct ndctl_dimm *dimm, struct action_context *actx)
 {
 	struct ndctl_cmd *cmd_read, *cmd_write;
@@ -377,18 +394,10 @@ static int action_write(struct ndctl_dimm *dimm, struct action_context *actx)
 
 	size = ndctl_cmd_cfg_read_get_size(cmd_read);
 	rc = rw_bin(actx->f_in, cmd_write, size, param.offset, WRITE);
-
-	/*
-	 * If the dimm is already disabled the kernel is not holding a cached
-	 * copy of the label space.
-	 */
-	if (!ndctl_dimm_is_enabled(dimm))
-		goto out;
-
-	rc = ndctl_dimm_disable(dimm);
 	if (rc)
 		goto out;
-	rc = ndctl_dimm_enable(dimm);
+
+	rc = revalidate_labels(dimm);
 
  out:
 	ndctl_cmd_unref(cmd_read);
@@ -1043,7 +1052,7 @@ static int action_security_freeze(struct ndctl_dimm *dimm,
 static int action_sanitize_dimm(struct ndctl_dimm *dimm,
 		struct action_context *actx)
 {
-	int rc;
+	int rc = 0;
 	enum ndctl_key_type key_type;
 
 	if (ndctl_dimm_get_security(dimm) < 0) {
@@ -1085,9 +1094,10 @@ static int action_sanitize_dimm(struct ndctl_dimm *dimm,
 		rc = ndctl_dimm_overwrite_key(dimm);
 		if (rc < 0)
 			return rc;
+		rc = revalidate_labels(dimm);
 	}
 
-	return 0;
+	return rc;
 }
 
 static int action_wait_overwrite(struct ndctl_dimm *dimm,


Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 913A0139566
	for <nvdimm@lists.linux.dev>; Tue,  4 Mar 2025 00:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741048644; cv=none; b=prxA69D7GzBlPLipH9BX93jNycWMsapeNZtZpIYZBf2CPdKHIZK6RgEBC545SgkFv2YIuFzNiTCnot/jzg7nHkxzl7LkNGuNDWt26jIJMXdknb4nam06N8F5mnCZghDZcH3fQOI11zGo7ohg7ApSc68JmmWj8+DBEUSYjtKeIfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741048644; c=relaxed/simple;
	bh=XKQZM1BVeY1A7e2GNG/fabJUyRi3qzw+5EVyRi2EZbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=taam9aB6StN57OusKbbbhqQOZEaSEPPLYC0YFxQd/p4SXRjskR7RTskb0brhWRoXE9IWibM6fxN6DflYCEEJ4w05CTFD+fS8aJpQJwdByISuLMgc57wsAEHoyfmcG0Cn3AXcCxg5VClY57NHuAhOwzy5a11bt75MiXITRSpex+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HK4kKwu+; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HK4kKwu+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741048643; x=1772584643;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XKQZM1BVeY1A7e2GNG/fabJUyRi3qzw+5EVyRi2EZbM=;
  b=HK4kKwu+7cc8+0EZyrjG0Nokimgr5e1bwKnZhQdavbTqty5UrEYF+yBu
   ux2/3O/Q/wiWUrFJSxIqvnkFyze0DG/EAR7X5KqxinqvTGLz4y2e3IMVi
   94wzm8ErDytbARsRrEV8Ycz5On4hjmIWCfAaHeFIgprqSasqSYCBfOk9v
   k7LM5Trvq0amtsKMIME/UUTG3F0+Q99nCA/xz5CcYL00NbeelkK8RN+HX
   me+CpBJyOLfzES5080paAGH7tywaXmpIaUFBq0vZK40ef4hvFB/GVL4Nk
   Hg3tNpE0j3C/A3+SoyVjVgmQb9hnvOQPmcNxcZGht2TMoz5tWrhBXY80J
   Q==;
X-CSE-ConnectionGUID: yxhw/gKBQxqqPnrclEtMAA==
X-CSE-MsgGUID: GT7RGR91T8uWzjZaM2e+aA==
X-IronPort-AV: E=McAfee;i="6700,10204,11362"; a="41975319"
X-IronPort-AV: E=Sophos;i="6.13,331,1732608000"; 
   d="scan'208";a="41975319"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2025 16:37:21 -0800
X-CSE-ConnectionGUID: s3AeArtzTwangCunbV9g2w==
X-CSE-MsgGUID: aOZcVb5zTUKZxzlNmJsHVA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,331,1732608000"; 
   d="scan'208";a="141427142"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.125.109.46])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2025 16:37:20 -0800
From: alison.schofield@intel.com
To: nvdimm@lists.linux.dev
Cc: Alison Schofield <alison.schofield@intel.com>
Subject: [ndctl PATCH 2/5] ndctl/namespace: close file descriptor in do_xaction_namespace()
Date: Mon,  3 Mar 2025 16:37:08 -0800
Message-ID: <60a9535a8ff1f14b9a251ebdbbd8f57265128260.1741047738.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <cover.1741047738.git.alison.schofield@intel.com>
References: <cover.1741047738.git.alison.schofield@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alison Schofield <alison.schofield@intel.com>

A coverity scan highlighted a resource leak caused by not freeing
the open file descriptor upon exit of do_xaction_namespace().

Move the fclose() to a 'goto out_close' and route all returns through
that path.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 ndctl/namespace.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/ndctl/namespace.c b/ndctl/namespace.c
index bb0c2f2e28c7..5eb9e1e98e11 100644
--- a/ndctl/namespace.c
+++ b/ndctl/namespace.c
@@ -2133,7 +2133,7 @@ static int do_xaction_namespace(const char *namespace,
 				util_display_json_array(ri_ctx.f_out, ri_ctx.jblocks, 0);
 			if (rc >= 0)
 				(*processed)++;
-			return rc;
+			goto out_close;
 		}
 	}
 
@@ -2144,11 +2144,11 @@ static int do_xaction_namespace(const char *namespace,
 		rc = file_write_infoblock(param.outfile);
 		if (rc >= 0)
 			(*processed)++;
-		return rc;
+		goto out_close;
 	}
 
 	if (!namespace && action != ACTION_CREATE)
-		return rc;
+		goto out_close;
 
 	if (namespace && (strcmp(namespace, "all") == 0))
 		rc = 0;
@@ -2207,7 +2207,7 @@ static int do_xaction_namespace(const char *namespace,
 						saved_rc = rc;
 						continue;
 				}
-				return rc;
+				goto out_close;
 			}
 			ndctl_namespace_foreach_safe(region, ndns, _n) {
 				ndns_name = ndctl_namespace_get_devname(ndns);
@@ -2286,9 +2286,6 @@ static int do_xaction_namespace(const char *namespace,
 	if (ri_ctx.jblocks)
 		util_display_json_array(ri_ctx.f_out, ri_ctx.jblocks, 0);
 
-	if (ri_ctx.f_out && ri_ctx.f_out != stdout)
-		fclose(ri_ctx.f_out);
-
 	if (action == ACTION_CREATE && rc == -EAGAIN) {
 		/*
 		 * Namespace creation searched through all candidate
@@ -2303,6 +2300,10 @@ static int do_xaction_namespace(const char *namespace,
 		else
 			rc = -ENOSPC;
 	}
+
+out_close:
+	if (ri_ctx.f_out && ri_ctx.f_out != stdout)
+		fclose(ri_ctx.f_out);
 	if (saved_rc)
 		rc = saved_rc;
 
-- 
2.37.3


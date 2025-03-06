Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19935276D23
	for <nvdimm@lists.linux.dev>; Thu,  6 Mar 2025 23:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741305023; cv=none; b=mYFBB2cvF6t43gH8Fkjd9hsI4R6+219wzGwZFQXnt4S7dmYGIOuLtd2lIPH8S0ptX5BifNE5PnBuFXwsxfj4FGEcoYgpMLbMNzHSeHEIvyCUAamtanXUO3FmPar7OoMj0eKxBRUDa496jZxHN3p5ODCaLiz2yqzf6iI2/xboGTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741305023; c=relaxed/simple;
	bh=hboA8iigm4vdCGGcs304LZIhnZrRN/SeYg9/2z3txMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a1ZixF555U8Y8rNFClc8LrVoXY//c8yHnq4dCbOaNrrn7cqIJ/EHsLWcvEhTQDfH0+eFNiRW2af434HFiiVbufywfclbX6a4LXpunNJfrxf3aCjFEfavU40B21mOXiuAYHuJ8vfj3vNr06oWMNTklnct7lIcoDQYOX9zvviHmKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=f+aw1RE4; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="f+aw1RE4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741305022; x=1772841022;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hboA8iigm4vdCGGcs304LZIhnZrRN/SeYg9/2z3txMk=;
  b=f+aw1RE4PkLWiQ5J9+KKbQ9PdxASnNoJvycRyo459akxirGFRUD+8P7U
   OAvW4Uef8CMyjQCeCckCvg7lR+wA1W7+2ZyW2kl0NSsusFrXMXuJ+t72L
   FnQkJP5lfu2tZX7q3ED9+u8sEfrtIRJCpFu29OrKHegQs21wHUAD573l2
   sXFFDUxhkBFoT0HhG4JJEfy+zW2M2gBxnvqvCMHLCXA+iuuPa+LKSm/Ye
   107wTTMyxBos3ydQQZHGKkspqT8xEeO/V1TzRu2owmhasaKkiMPvrfREb
   0+wjg5lI8qi1d7WCtXMeUpVO6YtW9ivqGcu+w2pn3fiUyIP438fOwNLBX
   A==;
X-CSE-ConnectionGUID: S4ZYmyT9SdGtlHLYHUrfuw==
X-CSE-MsgGUID: U0UcD/bhQ3qRdlRQN9+HHQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11365"; a="45150084"
X-IronPort-AV: E=Sophos;i="6.14,227,1736841600"; 
   d="scan'208";a="45150084"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2025 15:50:21 -0800
X-CSE-ConnectionGUID: tATp8ghmQ2m0A63SLvwyMg==
X-CSE-MsgGUID: 3y1MWMU3Qg2fytWEKqPbzQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="123358701"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.125.110.63])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2025 15:50:20 -0800
From: alison.schofield@intel.com
To: nvdimm@lists.linux.dev
Cc: Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>
Subject: [ndctl PATCH v2 2/5] ndctl/namespace: close file descriptor in do_xaction_namespace()
Date: Thu,  6 Mar 2025 15:50:11 -0800
Message-ID: <267483d9d16460ee4e5726c1675df4510d246ebc.1741304303.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <cover.1741304303.git.alison.schofield@intel.com>
References: <cover.1741304303.git.alison.schofield@intel.com>
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
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
---
 ndctl/namespace.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/ndctl/namespace.c b/ndctl/namespace.c
index 372fc3747c88..6c86eadcad69 100644
--- a/ndctl/namespace.c
+++ b/ndctl/namespace.c
@@ -2134,7 +2134,7 @@ static int do_xaction_namespace(const char *namespace,
 				util_display_json_array(ri_ctx.f_out, ri_ctx.jblocks, 0);
 			if (rc >= 0)
 				(*processed)++;
-			return rc;
+			goto out_close;
 		}
 	}
 
@@ -2145,11 +2145,11 @@ static int do_xaction_namespace(const char *namespace,
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
@@ -2208,7 +2208,7 @@ static int do_xaction_namespace(const char *namespace,
 						saved_rc = rc;
 						continue;
 				}
-				return rc;
+				goto out_close;
 			}
 			ndctl_namespace_foreach_safe(region, ndns, _n) {
 				ndns_name = ndctl_namespace_get_devname(ndns);
@@ -2287,9 +2287,6 @@ static int do_xaction_namespace(const char *namespace,
 	if (ri_ctx.jblocks)
 		util_display_json_array(ri_ctx.f_out, ri_ctx.jblocks, 0);
 
-	if (ri_ctx.f_out && ri_ctx.f_out != stdout)
-		fclose(ri_ctx.f_out);
-
 	if (action == ACTION_CREATE && rc == -EAGAIN) {
 		/*
 		 * Namespace creation searched through all candidate
@@ -2304,6 +2301,10 @@ static int do_xaction_namespace(const char *namespace,
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


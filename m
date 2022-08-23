Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A878FA54
	for <nvdimm@lists.linux.dev>; Tue, 23 Aug 2022 07:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661239273; x=1692775273;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5Jo0M7JLkpca4mmJEMDx0p2jux4rGpK3VNeWC/VQ7yw=;
  b=IAadiUcJS+QyCcCcYbLRQ3OQZiLmXjFOsbiOKBJjkBiJAnA1GGsAjiiD
   yDMWpolZQuaiBWQiInyrkPYotxnXFj8IpJQA/hntweMtUnHR2uFazP7U5
   wTc15sxAZis6QAp6tZCH4QyUZOm8mS9HFMTmhbwv+vJREpFWoEDA9dcuQ
   Rx0C/TKbNVwEeT5XTNhvIHY8VKt9HjX/4o4BU/idrGTjiedAbpdjzo7WA
   /CUH5tC3KwQc89a0oYalxelsjFx07nFDPDPaTWy46VATqapna+91FqfiX
   UXfiin/5KW5z6kZ+FPPXOV4BiXGTwZToPwgQowR0kcUJMzvcbykoyXNXS
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10447"; a="293612573"
X-IronPort-AV: E=Sophos;i="5.93,256,1654585200"; 
   d="scan'208";a="293612573"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2022 00:21:11 -0700
X-IronPort-AV: E=Sophos;i="5.93,256,1654585200"; 
   d="scan'208";a="735388584"
Received: from skummith-mobl1.amr.corp.intel.com (HELO vverma7-desk1.intel.com) ([10.212.54.206])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2022 00:21:10 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
To: <linux-cxl@vger.kernel.org>
Cc: <nvdimm@lists.linux.dev>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH 1/3] cxl/region: fix a dereferecnce after NULL check
Date: Tue, 23 Aug 2022 01:21:04 -0600
Message-Id: <20220823072106.398076-2-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823072106.398076-1-vishal.l.verma@intel.com>
References: <20220823072106.398076-1-vishal.l.verma@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=883; h=from:subject; bh=5Jo0M7JLkpca4mmJEMDx0p2jux4rGpK3VNeWC/VQ7yw=; b=owGbwMvMwCXGf25diOft7jLG02pJDMks9Q/vFNl6f34hmd2mvmcNY2JsUeXKykN/+idtltedUO/F e+haRykLgxgXg6yYIsvfPR8Zj8ltz+cJTHCEmcPKBDKEgYtTACYScJrhD9+ehh/CqvfVONjkfbT3st 1INxBqdxd6cHprX0v6a6HTqQz/PWtf5HlzJDyfJx/1Sr9IybKqQDe3uudrmNM0AYdtLvlMAA==
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

A NULL check in region_action() implies that 'decoder' might be NULL, but
later we dereference it during cxl_decoder_foreach().

Since cxl_decoder_foreach() won't ever enter the loop with a NULL decoder,
the check was superfluous. Remove it.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 cxl/region.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/cxl/region.c b/cxl/region.c
index a30313c..9372d6b 100644
--- a/cxl/region.c
+++ b/cxl/region.c
@@ -688,8 +688,6 @@ static int region_action(int argc, const char **argv, struct cxl_ctx *ctx,
 		cxl_decoder_foreach (port, decoder) {
 			decoder = util_cxl_decoder_filter(decoder,
 							  param.root_decoder);
-			if (!decoder)
-				continue;
 			rc = decoder_region_action(p, decoder, action, count);
 			if (rc)
 				err_rc = rc;
-- 
2.37.2


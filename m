Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CD9E79D2
	for <nvdimm@lists.linux.dev>; Wed,  8 Feb 2023 20:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675886449; x=1707422449;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=fAX98Edco08kfSF7rWrzM8w/+1K3xvv+FOGwue7EYAU=;
  b=S3HEihrMHEjLSpZ+cuhmffBS+EWTGsByWfc3ETemQHCZqyZL/CqLzF5m
   ydOlA/9tLlXnlAk0rY2IYbeTIjRRzRnNPp5Gous1WJhwSTpB9l3OoQOaG
   XQqkFu2WGrNdVEKe0kjO2nqFF+KcsjSa8IIsK0g5cKYYJM4tExigmx7X+
   mgOjAPdjTxrN9mgSXKW4EMmZDZQZgybE6Zosf+yU8FmHGpmI6gc7iOhPt
   DtrhB3WuszsmR2DVnlhQiDNwuNYIySJcnCxv2LgpeFdivKmjrjzJFrgjE
   UDVGejIb7emRxSs66iNuOxUVnzPGqKcKxFjy1nxPOQEOtK53kNY+ExgfD
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="329935489"
X-IronPort-AV: E=Sophos;i="5.97,281,1669104000"; 
   d="scan'208";a="329935489"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2023 12:00:46 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="776174686"
X-IronPort-AV: E=Sophos;i="5.97,281,1669104000"; 
   d="scan'208";a="776174686"
Received: from laarmstr-mobl.amr.corp.intel.com (HELO vverma7-desk1.local) ([10.251.6.109])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2023 12:00:45 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
Date: Wed, 08 Feb 2023 13:00:34 -0700
Subject: [PATCH ndctl v2 6/7] cxl/list: Include regions in the verbose
 listing
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230120-vv-volatile-regions-v2-6-4ea6253000e5@intel.com>
References: <20230120-vv-volatile-regions-v2-0-4ea6253000e5@intel.com>
In-Reply-To: <20230120-vv-volatile-regions-v2-0-4ea6253000e5@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Gregory Price <gregory.price@memverge.com>, 
 Jonathan Cameron <Jonathan.Cameron@Huawei.com>, 
 Davidlohr Bueso <dave@stgolabs.net>, 
 Dan Williams <dan.j.williams@intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>, nvdimm@lists.linux.dev, 
 Ira Weiny <ira.weiny@intel.com>
X-Mailer: b4 0.13-dev-ada30
X-Developer-Signature: v=1; a=openpgp-sha256; l=678;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=D7UqXnSXmnYe3Bfxk/zLNeSNw21I6tydyTN5ZJBJa10=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDMmP/2fKTJ/3QP3My1t17q6vXz245xbas+3BkqkbvOKaZ
 59yurPCs6OUhUGMi0FWTJHl756PjMfktufzBCY4wsxhZQIZwsDFKQAT0Tdg+GenyxWTuPNqTl+2
 ctDVyJnxgSaeZUeuGhrfTzBuzVXOW83IcC7kzA7x6FBXv1SnFL0CvgePKuvERE/Krv+oZPpePn0
 VFwA=
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp;
 fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF

From: Dan Williams <dan.j.williams@intel.com>

When verbose listing was added, region listing support was not available, so
it got missed. Add it now.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 cxl/list.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/cxl/list.c b/cxl/list.c
index e3ef1fb..4e77aeb 100644
--- a/cxl/list.c
+++ b/cxl/list.c
@@ -126,6 +126,7 @@ int cmd_list(int argc, const char **argv, struct cxl_ctx *ctx)
 		param.endpoints = true;
 		param.decoders = true;
 		param.targets = true;
+		param.regions = true;
 		/*fallthrough*/
 	case 0:
 		break;

-- 
2.39.1


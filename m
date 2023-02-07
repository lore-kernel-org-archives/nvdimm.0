Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43FA179C8
	for <nvdimm@lists.linux.dev>; Tue,  7 Feb 2023 19:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675797419; x=1707333419;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=iRdIDiH4UhTIWJ4OIMuQgZ3P0ZE88DyPelIpcwyE+I0=;
  b=KgZyxOB1wQRcmdJJG5xGhBpIA1fAsRd49fQstiUWFxUYATdXZ1AmMEHB
   QC4fMLqjwuayKprsJYFaRJLW8Bz8a7D6MsevRsR1Qa47vhA5LoeroUhRQ
   S6zCqLxP3on+Ye8ZeSo4i76Tam27j2vDLDGwgdYbPrHpGHuXFykk9R9RA
   UjhpNYL71grriUFx/8buLkJ8KxIXvYZPAmGt5J4aaKKlL0q/V+CediP16
   pXqXRs9YBQYUzWqKkce9kmvctSNA06kmVahaV+pJf5Ty2iJ9Qj4YfN2+T
   EXOIFYHHUh99Zh4+SBFCVHJTXVj7LBizGzUwLFolnHteaAr1SO0TyOM5t
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="331734012"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="331734012"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2023 11:16:56 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="735649821"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="735649821"
Received: from fvanegas-mobl.amr.corp.intel.com (HELO vverma7-desk1.local) ([10.209.109.6])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2023 11:16:56 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
Date: Tue, 07 Feb 2023 12:16:32 -0700
Subject: [PATCH ndctl 6/7] cxl/list: Include regions in the verbose listing
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230120-vv-volatile-regions-v1-6-b42b21ee8d0b@intel.com>
References: <20230120-vv-volatile-regions-v1-0-b42b21ee8d0b@intel.com>
In-Reply-To: <20230120-vv-volatile-regions-v1-0-b42b21ee8d0b@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Gregory Price <gregory.price@memverge.com>, 
 Jonathan Cameron <Jonathan.Cameron@Huawei.com>, 
 Davidlohr Bueso <dave@stgolabs.net>, 
 Dan Williams <dan.j.williams@intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>, nvdimm@lists.linux.dev
X-Mailer: b4 0.13-dev-ada30
X-Developer-Signature: v=1; a=openpgp-sha256; l=632;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=QfLIsB0jQFixz9GnkkwyrXBshIB2ZsjPNpz69CvK4mk=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDMmPFi8JW7yYgSvrqNDbsyKP2BsXRO+LmeQ2b3XxnRCB9
 8sbY09ldpSyMIhxMciKKbL83fOR8Zjc9nyewARHmDmsTCBDGLg4BWAiC7cyMqx+FxCcv2WmU61S
 km7c5Z4rc86dOPHyouzhHMnUid+zJeYy/DPYw93p5DRx6akZEQ41Kpc+CDyRXHVEwFXoq/N7Fd1
 lu5kA
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp;
 fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF

From: Dan Williams <dan.j.williams@intel.com>

When verbose listing was added, region listing support was not available, so
it got missed. Add it now.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
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


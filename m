Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAD571D90CB
	for <nvdimm@lists.linux.dev>; Fri, 15 Nov 2024 18:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731696051; cv=none; b=KBoD3X5Hd9hoi2HcDKhy9YFgevYO+zGRhFFT4gFOQE3uQxSKUS1+Qhd1uuUZJTVF+5pBnP//5Viae8IRAPgqUfyCkK8gFPnGVUBWx30f9NLARljYogq0rd9EwZcn0A9ZPbAbKWAnHsD75oKmJ0kEx0mTsWM88R6D5ijLLnWS3pQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731696051; c=relaxed/simple;
	bh=YMdKA2RGM+4rycwcwrUUs1tZXNNeH8g15UUiSnncD/0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=aLDXTfdnyxMEtOSGaw/TGEsCOBxNZycGeegJu8GmoInYqg2N3q4ncrzrXvlwsDaDUFKEFhKmsxagnIjyAjrAbmxZopPEif9X93pvx/Tm2rGqigKLJzr6RZ5SwGGqKHCQ696tAEo09nZmaGlkcmTYdMLtIsLj2KPpD1JcbPDX9Xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XmuwR1Fk; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XmuwR1Fk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731696050; x=1763232050;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=YMdKA2RGM+4rycwcwrUUs1tZXNNeH8g15UUiSnncD/0=;
  b=XmuwR1FkGlEyvwlVIPIgbf4eMJxGkmrcQP/F22jWWWFYutjXk3/H9xDv
   wzJM6zh3QPi3OiTY4Ye4UPQABUHfpW0FT4QA6qLNWqjrW5u0QGhU8MPnS
   xyCS0wi4A9mEdVkcuneKiW/MxlUxL3Mck79t7S3YhtPlCVuRTEmqHXGNy
   O70R82tEi9tk9DyCOkFcW3ugjrVTzJudKe453ZmAEg569IjZ/cb5FnF8w
   0FY2UjkK24p/iHZafu08/Gsbz7/QF6S4lg9pr5zvrdTHlWCFQNFyuyrZM
   SbsNBJWAgdFglsDYeQpN715RHEm8dqaWcIRn2l8F9THsUWfTj/0UQO9k7
   w==;
X-CSE-ConnectionGUID: b7gju3ScSvWSt2+/ANZmHw==
X-CSE-MsgGUID: UP4Qq+1ETdm0yRxuj6+jHw==
X-IronPort-AV: E=McAfee;i="6700,10204,11257"; a="31127889"
X-IronPort-AV: E=Sophos;i="6.12,157,1728975600"; 
   d="scan'208";a="31127889"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2024 10:40:40 -0800
X-CSE-ConnectionGUID: TNRTW0KMTiKfv+1DDegDmQ==
X-CSE-MsgGUID: MAN9WJQXSI+JWCM/wymBfQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,157,1728975600"; 
   d="scan'208";a="88522613"
Received: from ehanks-mobl1.amr.corp.intel.com (HELO localhost) ([10.125.108.112])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2024 10:40:40 -0800
From: Ira Weiny <ira.weiny@intel.com>
Date: Fri, 15 Nov 2024 12:40:35 -0600
Subject: [ndctl PATCH v3 2/9] ndctl/cxl/region: Report max size for region
 creation
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241115-dcd-region2-v3-2-326cd4e34dcd@intel.com>
References: <20241115-dcd-region2-v3-0-326cd4e34dcd@intel.com>
In-Reply-To: <20241115-dcd-region2-v3-0-326cd4e34dcd@intel.com>
To: Alison Schofield <alison.schofield@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>, 
 Jonathan Cameron <jonathan.cameron@Huawei.com>, Fan Ni <fan.ni@samsung.com>, 
 Navneet Singh <navneet.singh@intel.com>, 
 Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
 linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev, 
 Ira Weiny <ira.weiny@intel.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1731696034; l=1059;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=YMdKA2RGM+4rycwcwrUUs1tZXNNeH8g15UUiSnncD/0=;
 b=r8ekWtTXC9pC6cyWm5iaOpiAcxorlil3uwUUOqYRJAeYbxbUXLLyXZV3ngj0dxB8wgUBZ3era
 z5EIf7ieysuDzdg/6538/1O2/pnmmc0HJsAFTJooXib7ImSv+Qvhbza
X-Developer-Key: i=ira.weiny@intel.com; a=ed25519;
 pk=noldbkG+Wp1qXRrrkfY1QJpDf7QsOEthbOT7vm0PqsE=

When creating a region if the size exceeds the max an error is printed.
However, the max available space is not reported which makes it harder
to determine what is wrong.

Add the max size available to the output error.

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Fan Ni <fan.ni@samsung.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 cxl/region.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/cxl/region.c b/cxl/region.c
index 96aa5931d2281c7577679b7f6165218964fa0425..207cf2d003148992255c715f286bc0f38de2ca84 100644
--- a/cxl/region.c
+++ b/cxl/region.c
@@ -677,8 +677,8 @@ static int create_region(struct cxl_ctx *ctx, int *count,
 	}
 	if (!default_size && size > max_extent) {
 		log_err(&rl,
-			"%s: region size %#lx exceeds max available space\n",
-			cxl_decoder_get_devname(p->root_decoder), size);
+			"%s: region size %#lx exceeds max available space (%#lx)\n",
+			cxl_decoder_get_devname(p->root_decoder), size, max_extent);
 		return -ENOSPC;
 	}
 

-- 
2.47.0


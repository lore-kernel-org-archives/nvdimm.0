Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26B6E3C30
	for <nvdimm@lists.linux.dev>; Tue,  5 Nov 2024 02:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730772669; cv=none; b=lOeBM6IzMeg9FJSJsVi3dfoGsgZuN8tSDEZOhDpyxTYibqH+uDKoGLC9mOE6lFVkxE5Xl/YUfU3T3NVNiSGTPmUTwTBGXdlw4IFOU04ZVzY2lnZC2c+xO3T5twHQz2ukL0pfBM9zAn8098Pb+7Kn/EOUp+iEZBHDZ9zVyL55R6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730772669; c=relaxed/simple;
	bh=ie1bgarTdW2m0OhCx2ixlHunBdnNwnRrR7sxjGL0b9I=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=mYjlp2ZfJiuonrjJSbptdOhKrAOnaQYAoC2D/j1jlvC71JAUiJOAypmL17Ip4wgIGgIu00Z3Hl1ISIPCEreOHVVKPLCsxdaZio7RMVPbQIWxQrvvom5weplxZPuMwU0X2Aip53UA4YzH+pny8LJ76KmIQuoyXZ9lHVPE4Xsfu5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=H2V0vOI1; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="H2V0vOI1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730772668; x=1762308668;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=ie1bgarTdW2m0OhCx2ixlHunBdnNwnRrR7sxjGL0b9I=;
  b=H2V0vOI19B3lQOjU66pFsCF7p3QIW0MfI+R7JyShenVco5Z+ij6m//Rp
   IFgGceZF9Uenz/4E6SisizRppHhFwDWkYet6qAxfmvC3HBbpY3jp6+GqV
   arl63+A+F5+pCaEW2SJDMUI6zbP5eYrh6JBAGxDpwiVfHG3HyhZIuANiv
   NJf1qvg3V8eFcsCiEI0+/6YuU+iBl8AgarUsOzJSBzm67n6IblVgBu//6
   RVK8rIs8iOeu+Qzq1Cx0EHDGttzK/v8MjsWocABvRvQ73OkTJTQ6+xEZ6
   vI0k0EGPDLD2C5kF2/CzOwHCmf9FYsL6IWjon1AD+aJFmQRb3RI1BRNtV
   g==;
X-CSE-ConnectionGUID: zLjdh0G9QEmQKxc2WpkSZw==
X-CSE-MsgGUID: crcavZj+Rmecn+tkzUjqFw==
X-IronPort-AV: E=McAfee;i="6700,10204,11246"; a="30613077"
X-IronPort-AV: E=Sophos;i="6.11,258,1725346800"; 
   d="scan'208";a="30613077"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 18:11:08 -0800
X-CSE-ConnectionGUID: xwPtk9HkQOGeHD4fDF6Huw==
X-CSE-MsgGUID: eQ1Hri+wQ0e1E1kv9THmIQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,258,1725346800"; 
   d="scan'208";a="107176464"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.125.109.226])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 18:11:06 -0800
From: Ira Weiny <ira.weiny@intel.com>
Date: Mon, 04 Nov 2024 20:10:46 -0600
Subject: [ndctl PATCH v2 2/6] ndctl/cxl/region: Report max size for region
 creation
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241104-dcd-region2-v2-2-be057b479eeb@intel.com>
References: <20241104-dcd-region2-v2-0-be057b479eeb@intel.com>
In-Reply-To: <20241104-dcd-region2-v2-0-be057b479eeb@intel.com>
To: Alison Schofield <alison.schofield@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>, 
 Jonathan Cameron <jonathan.cameron@Huawei.com>, Fan Ni <fan.ni@samsung.com>, 
 Navneet Singh <navneet.singh@intel.com>, 
 Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
 linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev, 
 Ira Weiny <ira.weiny@intel.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1730772649; l=969;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=ie1bgarTdW2m0OhCx2ixlHunBdnNwnRrR7sxjGL0b9I=;
 b=AqjnRW+rxkvJ67LZdc3B3PEZ4KbklEjyrduy4IvPgnHKuI2bBbVlYy5W5d0oPrjfJDrPaFFUa
 TGb7FtBRGN0DCBopw3IHBErCqHH7p70MPVFzyFB2BwC72jkwb2+ZNwc
X-Developer-Key: i=ira.weiny@intel.com; a=ed25519;
 pk=noldbkG+Wp1qXRrrkfY1QJpDf7QsOEthbOT7vm0PqsE=

When creating a region if the size exceeds the max an error is printed.
However, the max available space is not reported which makes it harder
to determine what is wrong.

Add the max size available to the output error.

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


Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB4191DBB36
	for <nvdimm@lists.linux.dev>; Wed, 30 Oct 2024 21:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730325310; cv=none; b=CyrQy4urGbrYwqodxjT9+XsGNVnh3GZAEdsULS5z3iC13jfD8iNf86HcejSTY+62zUVs8cdYty0WiSMAjVaWTtz6qYrdRF2YCQmH2cwgiH9fHpCo8Bw/0ZWbt1/SO1j16gWmtpY9esN+RWnK9rM6Pu5zuEk6Esbzn4mDxfzQSMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730325310; c=relaxed/simple;
	bh=ie1bgarTdW2m0OhCx2ixlHunBdnNwnRrR7sxjGL0b9I=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=thZKYqGb/mgom0PA6++6EgYafAiIt3jNPffZW+6KqhPVuH4DPjXx5CRye//jXOCfYtL3bFgFhA7de1/O6ijrBXH2bPBLqBknnAXKHd+PWXBsKDHoU1fi8e22aAjZg38fSloxAe0y/JZrB9enHPMn1SbPsXOhmRxD2oS9G9S4OW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=K+hnXUc2; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="K+hnXUc2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730325309; x=1761861309;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=ie1bgarTdW2m0OhCx2ixlHunBdnNwnRrR7sxjGL0b9I=;
  b=K+hnXUc2AGbw9V0DmN9921+wauDwMacEgqcGBYbMMYfLycK0hXQDWN5c
   ZHRfTuNCIXEWOjTpy0R493+XubD0txtnI/MtBrtvxGvXkkZ6MSUFqC8uZ
   GfhSIZujluWlLhpcAKs/KSpTpomxk4pDRfZh9OxMH1eBT4rahy5CrVykx
   VZcRpTn6d15LFHFZddLGANwAmmmiyZHKO2yShN5tr7GF7SBZ/XOzLzCAn
   3QtAwoJhGaNj8jlH2avXZRdWkYA0YPLGyF9I2n0sFBlkZ2ZDEqSCpRcc6
   riesP2A0xG2m7W3VDoKC4YsHasNlRPVThwAwo1xPj0oiEdFWyHcMp7s+P
   Q==;
X-CSE-ConnectionGUID: QfpZoDpTSzC4leQUStDZXw==
X-CSE-MsgGUID: RtTtZZGaQW2yHja3b9Z4jQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11241"; a="40620521"
X-IronPort-AV: E=Sophos;i="6.11,246,1725346800"; 
   d="scan'208";a="40620521"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2024 14:55:09 -0700
X-CSE-ConnectionGUID: 6Te4gJDZRQeFrDkxPoWf6Q==
X-CSE-MsgGUID: SmOYxaVWTxG9n6q6h0tzcQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,246,1725346800"; 
   d="scan'208";a="119899962"
Received: from msatwood-mobl.amr.corp.intel.com (HELO localhost) ([10.125.108.161])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2024 14:55:08 -0700
From: Ira Weiny <ira.weiny@intel.com>
Date: Wed, 30 Oct 2024 16:54:45 -0500
Subject: [ndctl PATCH 2/6] ndctl/cxl/region: Report max size for region
 creation
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241030-dcd-region2-v1-2-04600ba2b48e@intel.com>
References: <20241030-dcd-region2-v1-0-04600ba2b48e@intel.com>
In-Reply-To: <20241030-dcd-region2-v1-0-04600ba2b48e@intel.com>
To: Alison Schofield <alison.schofield@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>, 
 Jonathan Cameron <jonathan.cameron@Huawei.com>, Fan Ni <fan.ni@samsung.com>, 
 Navneet Singh <navneet.singh@intel.com>, 
 Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
 linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev, 
 Ira Weiny <ira.weiny@intel.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1730325302; l=969;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=ie1bgarTdW2m0OhCx2ixlHunBdnNwnRrR7sxjGL0b9I=;
 b=SEow2WPOpIniAZ5Mgcv0yx6x5d70R6gsolbiHhmajL24qlEROwAP/dc+2s5PitJ/Hi1lVUA22
 e7/1/06C+OxCjoNAPY10VgoONwbnCaAm5OPZO1C24FGaz5JWuDyCSR8
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


Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 803131F666E
	for <nvdimm@lists.linux.dev>; Tue,  5 Nov 2024 18:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730831937; cv=none; b=Wt+Uf4S5s9p/AVPWGnul3DVubsP2noEJLHIneLWduiAAoIYn7sY+zy/2eyoDO5YbjzlgX9SiUL3Gf+Ml/3Fn72MjMYpacDKsE7dPWE4+y+T35b6R/0lZO3xbFvexEQNOOTzEob2DQIB1364hKU1XhYAuKputs38OvMFFHp2JYbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730831937; c=relaxed/simple;
	bh=pfzBxW1MRwdOp1Ja2Zhp+pNAkDAjjZV9tN0E/uC1Lkk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=U+y2rCpxrZH9YTaYcH/m3fBnuGwkrqR9Plxmivrr+h1hJP4knDhJoQf6yyw6KgqLHD+rNikUGRPqjJQuNedJxcQQmNhYPH263NLNNVXCJvfyDxyiDVsmn1mIgNinGb1iYEPiXQYovQc1yYwGM/s2kVajio9Ka9JMTkWkGH7ktFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Tgw1gQka; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Tgw1gQka"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730831936; x=1762367936;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=pfzBxW1MRwdOp1Ja2Zhp+pNAkDAjjZV9tN0E/uC1Lkk=;
  b=Tgw1gQka/pbaCIgT47KzcSWY+mbsbCIWk1Mt8XEMqC9Cc9JNkH8LdWw9
   0KJxtl2rmn8ZGTTKcqEDGMm/2DmeJER6Fue9pnYhLHaO/12e2DIDrzhKv
   ylx0ocxpg+cHH1NziunXXpFuHZ4forzgq6+h01TAVwHoqAfK3TMa2aJr8
   FEBMS96ZQAvcbdTcLDEo5420fyGghDO3xa8YRRYodZbeZ+sNPY1L/5VpL
   GZPr70vM8L0+RYUNKL6LGejuxuhEnutH0HmCN1H5W11WYW6YH6sG0Cotm
   FIpECrKkVcUfN/8zBMLCDXOYd1SQ8DiySMv3BWOWU/MrJxtXojOYRBo+h
   Q==;
X-CSE-ConnectionGUID: QhWeHdcsSEO5R3WKjjeH0A==
X-CSE-MsgGUID: dkLOv6XBQuGvsbOm7eHw6A==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="41153211"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="41153211"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 10:38:56 -0800
X-CSE-ConnectionGUID: yhzEHJD3TYaexMZYsirT4w==
X-CSE-MsgGUID: yjAQAG7ISmGITCJ2O63etQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,260,1725346800"; 
   d="scan'208";a="84235680"
Received: from spandruv-mobl4.amr.corp.intel.com (HELO localhost) ([10.125.109.247])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 10:38:53 -0800
From: ira.weiny@intel.com
Date: Tue, 05 Nov 2024 12:38:32 -0600
Subject: [PATCH v6 10/27] cxl/region: Add dynamic capacity decoder and
 region modes
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241105-dcd-type2-upstream-v6-10-85c7fa2140fe@intel.com>
References: <20241105-dcd-type2-upstream-v6-0-85c7fa2140fe@intel.com>
In-Reply-To: <20241105-dcd-type2-upstream-v6-0-85c7fa2140fe@intel.com>
To: Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>, 
 Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
 Navneet Singh <navneet.singh@intel.com>, Jonathan Corbet <corbet@lwn.net>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>, 
 Davidlohr Bueso <dave@stgolabs.net>, 
 Alison Schofield <alison.schofield@intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
 linux-cxl@vger.kernel.org, linux-doc@vger.kernel.org, 
 nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org, 
 Li Ming <ming4.li@intel.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1730831904; l=3381;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=FTiGwE2jQFLAzeLQHNUVR9Y1vD69ayI8FCayfic2Ot0=;
 b=X5fXbVYSmROk0iPH8hjo8i1QxEgmeviVpKKsAwEgmprPI4i49rrXrZfN04PccZMJGS5CSD1mF
 i4TpeYxF/QuDuT5DCYZ1lKNwmOEQazceo9rmFiHlAFXqLQ5QKcsKT7Y
X-Developer-Key: i=ira.weiny@intel.com; a=ed25519;
 pk=noldbkG+Wp1qXRrrkfY1QJpDf7QsOEthbOT7vm0PqsE=

From: Navneet Singh <navneet.singh@intel.com>

One or more decoders each pointing to a Dynamic Capacity (DC) partition
form a CXL software region.  The region mode reflects composition of
that entire software region.  Decoder mode reflects a specific DC
partition.  DC partitions are also known as DC regions per CXL
specification v3.1.

Define the new modes and helper functions required to make the
association between these new modes.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Fan Ni <fan.ni@samsung.com>
Signed-off-by: Navneet Singh <navneet.singh@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Li Ming <ming4.li@intel.com>
Co-developed-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 drivers/cxl/core/region.c |  4 ++++
 drivers/cxl/cxl.h         | 23 +++++++++++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index b3beab787faeb552850ac3839472319fcf8f2835..2ca6148d108cc020bebcb34b09028fa59bb62f02 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -1870,6 +1870,8 @@ static bool cxl_modes_compatible(enum cxl_region_mode rmode,
 		return true;
 	if (rmode == CXL_REGION_PMEM && dmode == CXL_DECODER_PMEM)
 		return true;
+	if (rmode == CXL_REGION_DC && cxl_decoder_mode_is_dc(dmode))
+		return true;
 
 	return false;
 }
@@ -3233,6 +3235,8 @@ cxl_decoder_to_region_mode(enum cxl_decoder_mode mode)
 		return CXL_REGION_RAM;
 	case CXL_DECODER_PMEM:
 		return CXL_REGION_PMEM;
+	case CXL_DECODER_DC0 ... CXL_DECODER_DC7:
+		return CXL_REGION_DC;
 	case CXL_DECODER_MIXED:
 	default:
 		return CXL_REGION_MIXED;
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 5d74eb4ffab3ea2656c8e3c0563b8d7b69d76232..f931ebdd36d05a8aa758627746f0fa425a5f14fd 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -370,6 +370,14 @@ enum cxl_decoder_mode {
 	CXL_DECODER_NONE,
 	CXL_DECODER_RAM,
 	CXL_DECODER_PMEM,
+	CXL_DECODER_DC0,
+	CXL_DECODER_DC1,
+	CXL_DECODER_DC2,
+	CXL_DECODER_DC3,
+	CXL_DECODER_DC4,
+	CXL_DECODER_DC5,
+	CXL_DECODER_DC6,
+	CXL_DECODER_DC7,
 	CXL_DECODER_MIXED,
 	CXL_DECODER_DEAD,
 };
@@ -380,6 +388,14 @@ static inline const char *cxl_decoder_mode_name(enum cxl_decoder_mode mode)
 		[CXL_DECODER_NONE] = "none",
 		[CXL_DECODER_RAM] = "ram",
 		[CXL_DECODER_PMEM] = "pmem",
+		[CXL_DECODER_DC0] = "dc0",
+		[CXL_DECODER_DC1] = "dc1",
+		[CXL_DECODER_DC2] = "dc2",
+		[CXL_DECODER_DC3] = "dc3",
+		[CXL_DECODER_DC4] = "dc4",
+		[CXL_DECODER_DC5] = "dc5",
+		[CXL_DECODER_DC6] = "dc6",
+		[CXL_DECODER_DC7] = "dc7",
 		[CXL_DECODER_MIXED] = "mixed",
 	};
 
@@ -388,10 +404,16 @@ static inline const char *cxl_decoder_mode_name(enum cxl_decoder_mode mode)
 	return "mixed";
 }
 
+static inline bool cxl_decoder_mode_is_dc(enum cxl_decoder_mode mode)
+{
+	return (mode >= CXL_DECODER_DC0 && mode <= CXL_DECODER_DC7);
+}
+
 enum cxl_region_mode {
 	CXL_REGION_NONE,
 	CXL_REGION_RAM,
 	CXL_REGION_PMEM,
+	CXL_REGION_DC,
 	CXL_REGION_MIXED,
 };
 
@@ -401,6 +423,7 @@ static inline const char *cxl_region_mode_name(enum cxl_region_mode mode)
 		[CXL_REGION_NONE] = "none",
 		[CXL_REGION_RAM] = "ram",
 		[CXL_REGION_PMEM] = "pmem",
+		[CXL_REGION_DC] = "dc",
 		[CXL_REGION_MIXED] = "mixed",
 	};
 

-- 
2.47.0


Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD3002010FD
	for <nvdimm@lists.linux.dev>; Thu,  6 Mar 2025 23:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741305023; cv=none; b=YzKNBba4nriE2uRy+wJY8XN/50VkmSSq08eGWshRJnRpYzDFpRkLMaN8PfxCBKEJF6fsY87CLBcyV43ydbQvnvWCbkrj+dTKu/TZkxs1ThWLo7rGlaXY/pIw54+VhguH2T9uPl9JlD1dqoaHwXXV9Gkj9EMUFi76W4iBqY2RZGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741305023; c=relaxed/simple;
	bh=Y3s2F1XQdVL7MDsFfqEU/66fxDUAW2ZZYeRkgCXYg6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eHQGsdYRXNRaj/KfFrqbobApsssFVWBv1B127OOph+Hu7DTLI+LFBc03auO3KDzRD74HcYt7T0OLO0EVCD6OqZSiZIWYpe6s2B7mV41caUE2KfVOyWcqRbIbTkRAy4JzzuiBqCuOQ/l1MdDqo1Zehr0Wp/QiId0WpTHHO4axfOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VN/UOxFa; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VN/UOxFa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741305022; x=1772841022;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Y3s2F1XQdVL7MDsFfqEU/66fxDUAW2ZZYeRkgCXYg6o=;
  b=VN/UOxFaRHdLJv8UBZmaqux+Hidg3QSNPmw3BGJ1A+o36j63gDX4Beft
   W58hAHLYb8pHZ7sBfEX+aKrM4BchXFVb2BogEp3JSUC/Z/ouH9NR7xyiq
   0lltUnfHLmm0q3WqKW3+vs6vrGk++4a5D6JAZHRw9EBIP3/WTPSEc4+4f
   +neohcOKXkVTB2Sb8cBPBXsCJEpiLbNioe/+M9VlJX6XwJc64IpXpYyVx
   H+K9gIuU90n0VdSe/kGxOdjUAAXLF/xRrMHOvC/fWzCdv+XKpDzOwhYo1
   ssHJmJaokawcBVFstux8ttNutv4CCHBoLILcswMJk1jKb+RzkklWrZXF3
   Q==;
X-CSE-ConnectionGUID: S5gwfTD0T8msgcOyAYkFVQ==
X-CSE-MsgGUID: HsvPeSuJSpKNAVKsiWJsdw==
X-IronPort-AV: E=McAfee;i="6700,10204,11365"; a="45150083"
X-IronPort-AV: E=Sophos;i="6.14,227,1736841600"; 
   d="scan'208";a="45150083"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2025 15:50:20 -0800
X-CSE-ConnectionGUID: 8CTcFMLCTOqAcDml2uFOQQ==
X-CSE-MsgGUID: +NvYxvVpRvuVYNb1YqL4+Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="123358694"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.125.110.63])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2025 15:50:19 -0800
From: alison.schofield@intel.com
To: nvdimm@lists.linux.dev
Cc: Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>
Subject: [ndctl PATCH v2 1/5] ndctl/namespace: avoid integer overflow in namespace validation
Date: Thu,  6 Mar 2025 15:50:10 -0800
Message-ID: <1b3cc602d61a1b0a5383a481452d216331e3477e.1741304303.git.alison.schofield@intel.com>
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

A coverity scan highlighted an integer overflow issue when testing
if the size and align parameters make sense together.

Before performing the multiplication, check that the result will not
exceed the maximum value that an unsigned long long can hold.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
---
 ndctl/namespace.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/ndctl/namespace.c b/ndctl/namespace.c
index aa8c23a50385..372fc3747c88 100644
--- a/ndctl/namespace.c
+++ b/ndctl/namespace.c
@@ -868,6 +868,13 @@ static int validate_namespace_options(struct ndctl_region *region,
 
 		p->size /= size_align;
 		p->size++;
+
+		if (p->size > ULLONG_MAX / size_align) {
+			err("size overflow: %llu * %llu exceeds ULLONG_MAX\n",
+			    p->size, size_align);
+			return -EINVAL;
+		}
+
 		p->size *= size_align;
 		p->size /= units;
 		err("'--size=' must align to interleave-width: %d and alignment: %ld\n"
-- 
2.37.3


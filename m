Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 072361A83EE
	for <nvdimm@lists.linux.dev>; Thu,  6 Mar 2025 23:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741305021; cv=none; b=KFVGixHVruNK8x209MBPB6++rnPa4mHvOPRFooMaGzIwBOIF6ysVkf9/DCC02GHZZMjQFic0cEfUMOaRqmUxtAZOcrwsxcDS2apS3ktID4X1+irsjsfFBCHtmX9x2w4yMffBZrpAJ7A4wx4mELtr5RbAW+l0hexQ+2uvaBYgHa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741305021; c=relaxed/simple;
	bh=VfX9sywZwhlVFIFnwIotyJ0c79bHjc2oI9K2sHwaZrI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Tp9OYId0qOE1ggdiwYxBli0jKZsHiP1PbXTKn6Fe6pcGdRMCSWiywVflXUHt2oKlemyJG4N/DrzEhAgRCTDNcosKCI7+VJkquVUV3ld15c210GpI/fJmuwJxD704QcV1e5/h0vQPGtRJF7lxWFqFTSBEWgS9ChHCIS92rwOPPXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aRvJzu2d; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aRvJzu2d"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741305020; x=1772841020;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=VfX9sywZwhlVFIFnwIotyJ0c79bHjc2oI9K2sHwaZrI=;
  b=aRvJzu2dVHf0Wm/eYNAGNvwOxi4vhS/gTREOmn0i8ryDTsjWiDWpAGZ3
   dwzKRwOIxc5TiglKlnR7RSEoFDWlnOiHEseHm6Gpwd5tc2Qa0fscg7NW1
   cYPGaD8gyUeCWEN902dQ/5zcefgbqWRu672cMUQL0d/X3hVloC5m43OIx
   5nqPE+73pNkH/OobSUFvplcnBuELz3JpMhBCMnNjS/znPB/MWmVDwCcf9
   y1a7Cn+HlPdNY9POLNwxjxNqTTnCmPEGhzPNPUdAIrkQUkmsGSVq+xnRb
   Ra997ZwERvIrzFvd1hNIMoDjvoEiA6ovDH7cNaYS1UlfGxB7e0z6OKWXZ
   w==;
X-CSE-ConnectionGUID: by2t2U7BQ/Wbpajiy3CBCQ==
X-CSE-MsgGUID: KgRm+aFERseKwJx5oteryg==
X-IronPort-AV: E=McAfee;i="6700,10204,11365"; a="45150082"
X-IronPort-AV: E=Sophos;i="6.14,227,1736841600"; 
   d="scan'208";a="45150082"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2025 15:50:19 -0800
X-CSE-ConnectionGUID: ENlL+op7Q9ug/TjEzrbWdA==
X-CSE-MsgGUID: VZ986xqXSZSwvTMB5eY9+Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="123358688"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.125.110.63])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2025 15:50:19 -0800
From: alison.schofield@intel.com
To: nvdimm@lists.linux.dev
Cc: Alison Schofield <alison.schofield@intel.com>
Subject: [ndctl PATCH v2 0/5] Address Coverity Scan Defects
Date: Thu,  6 Mar 2025 15:50:09 -0800
Message-ID: <cover.1741304303.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alison Schofield <alison.schofield@intel.com>

Changes in v2:
1/5: Put back deleted whitespace (DaveJ)
     s/maximimum/maximum
3/5: Move slot++ to for loop header (DaveJ)
     Update commit log to match

The NDCTL project routinely addresses any and all coverity defects
before each release. This new set of reports suggests enhancements
to the scan capabilities since none of this code has been touched
recently. Game on, we'll squash 'em!

Alison Schofield (5):
  ndctl/namespace: avoid integer overflow in namespace validation
  ndctl/namespace: close file descriptor in do_xaction_namespace()
  ndctl/dimm: do not increment a ULLONG_MAX slot value
  ndctl/namespace: protect against overflow handling param.offset
  ndctl/namespace: protect against under|over-flow w bad param.align

 ndctl/dimm.c      |  5 ++---
 ndctl/namespace.c | 36 ++++++++++++++++++++++++++++--------
 2 files changed, 30 insertions(+), 11 deletions(-)


base-commit: d2c55938a0c7308cba07cb23b598df1be93f1d38
-- 
2.37.3


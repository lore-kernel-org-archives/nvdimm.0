Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 394A01C683
	for <nvdimm@lists.linux.dev>; Tue,  4 Mar 2025 00:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741048642; cv=none; b=LrEWum2apQic2pc8Em7KOw5M38zsLU0zx+mEktKOpu06CHwrwKDYIi3++nTIq5kng5BC1iz8PFUClF0ut8n6WGVegeXQwBLjZ+9yzO+cY+/Sn/utZ9qC4x3sFDVX9KWKxpsToOcoOQe3gWwJihJwXuBm2b8FXvbt9PFnlNPYLA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741048642; c=relaxed/simple;
	bh=ffVA7YIcaC/nLPvxSR9cs6wqrpgiAsiKI4vKBsS5hEU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=u9CiRZVAv1JOJlN1O66ovoV52PEjsRT+1o14IHIk2dFFxfqbAVPx2wVp5k8+Wt0clA4al1+dbge7mSMYdIRBZt/Z3XsQWLvKTRfFbrPaEaY1Lk8eHOvj0kYWRfqB9EGvCY79CtiGMSEnh0AcHR5wxrktvcmjjewmnkClH1KdhJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=c9oHz4GH; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="c9oHz4GH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741048641; x=1772584641;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ffVA7YIcaC/nLPvxSR9cs6wqrpgiAsiKI4vKBsS5hEU=;
  b=c9oHz4GHMdXhJhCFsQK5TNvrzAIlGju2pdBQZdt26JO1d7NegDDQYa90
   cZokXhJfjVDJJ4iyHXay/yXfaVK2T7KJIOaCjPIdFMrd29lNJbZe0fQoZ
   MONaSCKbiuG3GmL+ZoYtU+aMVQoD8ehWYt6O4Es3e/Jpcpoh+BtaqgoL9
   HuQa54nGwsjS7fY6AOQLaF78NWTpAqE4XlcwZ5H/Hs2uLPibFdd8ql5jQ
   R67OcXR+iJ14UxZqvv4bUYH8aTrnt/EbbdXyURD8n+ysZ/BjLMvmZHSSx
   wCdvvyaWchCQLFQok8KUMG3be0fI/dGjc82OKM3Lvxb/RKgftisG06Nsd
   A==;
X-CSE-ConnectionGUID: O7Fdf9MDToSjeRP6XRdRSw==
X-CSE-MsgGUID: 20Xon7YhRhWNfk8liftpww==
X-IronPort-AV: E=McAfee;i="6700,10204,11362"; a="41975314"
X-IronPort-AV: E=Sophos;i="6.13,331,1732608000"; 
   d="scan'208";a="41975314"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2025 16:37:20 -0800
X-CSE-ConnectionGUID: /cdcL5TsQeCa2LzTjbRWpg==
X-CSE-MsgGUID: 6jVC/AbtSZeqX/GzD3HLtg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,331,1732608000"; 
   d="scan'208";a="141427134"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.125.109.46])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2025 16:37:19 -0800
From: alison.schofield@intel.com
To: nvdimm@lists.linux.dev
Cc: Alison Schofield <alison.schofield@intel.com>
Subject: [ndctl PATCH 0/5] Address Coverity Scan Defects
Date: Mon,  3 Mar 2025 16:37:06 -0800
Message-ID: <cover.1741047738.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alison Schofield <alison.schofield@intel.com>

The NDCTL project routinely addresses any and all coverity defects
before each release. This new set of reports suggests enhancements
to the scan capabilities since none of this code has been touched
recently. Game on, we we'll squash 'em!

Alison Schofield (5):
  ndctl/namespace: avoid integer overflow in namespace validation
  ndctl/namespace: close file descriptor in do_xaction_namespace()
  ndctl/dimm: do not increment a ULLONG_MAX slot value
  ndctl/namespace: protect against overflow handling param.offset
  ndctl/namespace: protect against under|over-flow w bad param.align

 ndctl/dimm.c      |  8 +++++---
 ndctl/namespace.c | 37 ++++++++++++++++++++++++++++---------
 2 files changed, 33 insertions(+), 12 deletions(-)


base-commit: d2c55938a0c7308cba07cb23b598df1be93f1d38
-- 
2.37.3


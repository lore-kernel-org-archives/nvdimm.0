Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42F6120F3
	for <nvdimm@lists.linux.dev>; Tue, 28 Nov 2023 04:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="llVsEDnA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701144706; x=1732680706;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=mEdUPtqZsLz6WH+SZt9rbw+Rc8U2tauR2YbKoTbZs/U=;
  b=llVsEDnAkDTDC16cou+iVDeUqeUqJ+UbIaCLrDbRw9VKANjeoIFF9uIO
   cWCEp20ZVT1A7a6BSIRPryGi6vl/7PwmmEt9UGOxH8/nXPGMowsnZFICD
   sQL8eaHmObMsnT4khon7H7fHuq6tOKaMQ18QhrGUaFrdYhm7tmsfpnSV7
   YwzB8ZhoB5d94+PwRjRlS1vExlT4jqpX13e2DPe7VFkidATPKnJpMNDuW
   ixeF0sTyKc0Luqg2eGsV7X1/QVWL4KfxuMx+sWRtx71Obwc2oMRvBDo7x
   yj1dxiFux86HDZD5VjPwEX2vNajx2Ywg+DXbcln3kkoJvdVMepRofxm1p
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10907"; a="390001063"
X-IronPort-AV: E=Sophos;i="6.04,232,1695711600"; 
   d="scan'208";a="390001063"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2023 20:11:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10907"; a="891948429"
X-IronPort-AV: E=Sophos;i="6.04,232,1695711600"; 
   d="scan'208";a="891948429"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.212.170.56])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2023 20:11:44 -0800
From: alison.schofield@intel.com
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: [ndctl PATCH 0/3] cxl/test: CXL unit test helpers
Date: Mon, 27 Nov 2023 20:11:39 -0800
Message-Id: <cover.1701143039.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alison Schofield <alison.schofield@intel.com>

This set started with the intent of expanding the check_dmesg()
to look for the 'calc interleave' failure message that is added
to kernel 6.7. It ended up being a bit more than that including a
small reorg of some commonly used setup and shutdown commands
plus a fixup to a timing issue with the dmesg log searches.

This does not depend upon 6.7 as it is only checking for the existence
of the failed message. In fact, it's value at the moment, is probably
in the hands of folks developing and testing on 6.7rc* and onward.

This is built upon ndctl origin/pending branch. (base commit below)


Alison Schofield (3):
  cxl/test: add and use cxl_common_[start|stop] helpers
  cxl/test: add a cxl_ derivative of check_dmesg()
  cxl/test: use an explicit --since time in journalctl

 test/common                 | 37 +++++++++++++++++++++++++++++++++++++
 test/cxl-create-region.sh   | 16 ++--------------
 test/cxl-events.sh          | 18 +++---------------
 test/cxl-labels.sh          | 16 ++--------------
 test/cxl-poison.sh          | 17 ++---------------
 test/cxl-region-sysfs.sh    | 16 ++--------------
 test/cxl-topology.sh        | 16 ++--------------
 test/cxl-update-firmware.sh | 17 ++---------------
 test/cxl-xor-region.sh      | 15 ++-------------
 9 files changed, 54 insertions(+), 114 deletions(-)


base-commit: cbf049039482a56c2b66ede3e10d5e9c652890b7
-- 
2.37.3


Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB433125BA
	for <nvdimm@lists.linux.dev>; Wed, 28 Aug 2024 03:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724814859; cv=none; b=d38NhGz48xnjrxws4y8KqMY4CpUJ3okvCgcDkR5kwIw+5wKQ+uxD+eM4aNPfosZbK299EQplKExt89cEaVwxCBA3XMDJAok0lvuxgSz8fh9y/9RnLfY4SOBt9/piuwr628ilT+9qmbTe7L4Mj4pJN2AIBoCMFQ5MrWVg+wKelEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724814859; c=relaxed/simple;
	bh=ek5RQgt6rKna2zHAa74hGGZBsuHtJcKDvJE+x1MpI3s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FV1RmJVLdG8drJXohvdk+RGaXFQl/u+tYi1aMv2++RjMpU5ZnX8smGykkTc38ykB698HFra0KxAWUc8Mk5kPbApBM6NsI2iA7vLTrf0/sIOFUaN7mPmnoLwWd92w5iFKboT/I60HzciXtSUJHm9wLYuinuOP6pRfwGv74lvo9ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UU8VxWYH; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UU8VxWYH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724814858; x=1756350858;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ek5RQgt6rKna2zHAa74hGGZBsuHtJcKDvJE+x1MpI3s=;
  b=UU8VxWYHdAXcmTBNm4eJotHURDNxoHRnCwaEZmBitUjdZ9odGkOWHscD
   7ssUGaZxSMIzA8hW2iXx+Uz4RqWZp1ZakfatfoA2sFQBeiuKB58xRl8uk
   UKtdRc1pY7D5odmP166IkXEEriDvth+R5djB8kUD+zt9f0iwwRUZ90F98
   MSglAZl7RVNt8O/DaPhpSdaHKpzgdSH6H9yHtG2wH+fM40qBcfpjf5Adp
   D2JfcZsuFRJvLFPQW2cbd/yN8cwK35GopHxY47ApL4x0YM9S2D/CU9X9I
   RntQwflomm/t5YgChhBgdPZC5FvWIYThbwEDzanAzF6NDxLwm9777fUDM
   g==;
X-CSE-ConnectionGUID: +/wu/ThrQdqOq1hNKd8AYg==
X-CSE-MsgGUID: XGaqlbs2RYeXwVUJu/vEXw==
X-IronPort-AV: E=McAfee;i="6700,10204,11177"; a="23285724"
X-IronPort-AV: E=Sophos;i="6.10,181,1719903600"; 
   d="scan'208";a="23285724"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2024 20:14:18 -0700
X-CSE-ConnectionGUID: DKwL4M/0SeSmPMS6q4OY+w==
X-CSE-MsgGUID: WOxwBpkTRra/d8+i8VSYNQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,181,1719903600"; 
   d="scan'208";a="63039276"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.125.111.50])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2024 20:14:17 -0700
From: alison.schofield@intel.com
To: nvdimm@lists.linux.dev
Cc: Alison Schofield <alison.schofield@intel.com>,
	linux-cxl@vger.kernel.org
Subject: [ndctl PATCH 0/2] Use CXL regions in daxctl-create unit test
Date: Tue, 27 Aug 2024 20:14:03 -0700
Message-ID: <cover.1724813664.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alison Schofield <alison.schofield@intel.com>

efi_fake_mem support was removed from the kernel in v6.11 making
this unit test SKIP, unable to find the hmem regions that relied
upon the fake devices.

Pivoting to use the already available CXL regions seems like a
good fit. The setup changes but the same DAX test functionality
remains unchanged.

Please take a look.


Alison Schofield (2):
  test/daxctl-create.sh: use bash math syntax to find available size
  test/daxctl-create.sh: use CXL DAX regions instead of efi_fake_mem

 test/daxctl-create.sh | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

-- 
2.37.3


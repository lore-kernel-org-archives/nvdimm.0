Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39FA3392825
	for <nvdimm@lists.linux.dev>; Tue, 29 Sep 2026 05:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790660227; cv=none; b=j2JmX2UviEG9Pb+NwwikSdCFodmjK0vrHfW3M89mnXY0/WF1nOWd/pumTEEeZuZW3jJmLHIfcPGin7NzgkDYXfGr76OeH9l0fXt8T8wFDaavDc9LTAZQIZ8k1cFnocCNPFOecbB/px7gj2QljaSaPE4VE/kTsZVqe42IO9ShstQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790660227; c=relaxed/simple;
	bh=Nl+OxwldP7jnl/vMUXiO5IY5NcX4Y9vzO5/ssMixdBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ClIJVUe4VExogEsgVcrQmBOoLFjMGUMJivQ9pWDg6vRDSv0kHsc7oDGnNmt96DpnnaF30HrwA8Nir9oq6K9+K2gkKR8WPkm9WWv3s1THSHi3VyZNFYdAkZ4bQ9zsG6nT68fO7v+yQs+wMRYXXyftN7IZuNiAH2ca6dzhv0MZlaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=U8aRW8Kz; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="U8aRW8Kz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790660224; x=1822196224;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Nl+OxwldP7jnl/vMUXiO5IY5NcX4Y9vzO5/ssMixdBQ=;
  b=U8aRW8Kzq3eygplqoPyZJ3HZFp0v7XremtBKcUcA20JeysGZMmUEk8ai
   nEiImE5gAB89ODXinoCgvnD/M9f+lU8GDEbVzRnXX1QfYLzAGs3I67KmP
   TrYtwmGVaEzJilKVEGG2b2hDs5VS68aD9b/sUctQSH4GbL3GdUQ0nmY0n
   9ZDWEKojGZEHYKPyl5vHciSxebMTTGq4ei+zvhJjmmL3fHCRIVHRnv7bJ
   K/zzAuYaFdmJE64NjSv79ozELb4apkBcMQhJhhUxzh+bac2f3HTpGk80/
   +N9Ps7H9erBas26PSPH6jqTncBK8vdTTh2up9ZKAsbPZRDgnMEeuhusFB
   w==;
X-CSE-ConnectionGUID: FGX6b+hLSuuu89gHLBX1jQ==
X-CSE-MsgGUID: 5nEe2xCPQXa6NfgnybwyDg==
X-IronPort-AV: E=McAfee;i="6800,10657,11919"; a="100700061"
X-IronPort-AV: E=Sophos;i="6.27,129,1787036400"; 
   d="scan'208";a="100700061"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2026 22:37:03 -0700
X-CSE-ConnectionGUID: 4ajude3bSjKT+17cg2giCA==
X-CSE-MsgGUID: XTGfyPkhQjWrDEP0jXAFiQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,129,1787036400"; 
   d="scan'208";a="304767456"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.222.149])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2026 22:37:03 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Cc: Alison Schofield <alison.schofield@intel.com>
Subject: [ndctl PATCH 0/7] cxl/region: create-region command and unit
Date: Mon, 28 Sep 2026 22:36:52 -0700
Message-ID: <cover.1790658549.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

While working to enhance the cxl-cli cxl-create-region command to handle
out-of-order target lists or no user-supplied target list, I ran into some
basic issues in the existing command that need to be addressed first.

Patches 1-2 consolidate and clean up the existing create-region tests.

Patches 3-6 fix target-list parsing and validation, release DPA after a
failed create, and move granularity validation ahead of region creation.
Each fix adds a test case for the problem it addresses.

Patch 7 corrects the documentation to reflect that --decoder is currently
required. Automatic root decoder selection will be considered separately
with the upcoming create-region usability work.

Developing tests for these fixes exposed two bugs and a topology gap in
the cxl_test mock module. A companion cxl_test series is here [1].


[1] https://lore.kernel.org/linux-cxl/cover.1790641236.git.alison.schofield@intel.com/

Alison Schofield (7):
  test/cxl-create-region.sh: fold in XOR coverage
  test/cxl-create-region.sh: deduplicate topology lookups
  cxl/region: parse comma-separated target lists
  cxl/region: reject duplicate or unknown target memdevs
  cxl/region: release reserved DPA when region creation fails
  cxl/region: validate granularity before region creation
  cxl/region: document --decoder as required

 Documentation/cxl/cxl-create-region.txt |   7 +-
 cxl/region.c                            | 139 ++++++++--
 test/cxl-create-region.sh               | 338 ++++++++++++++++++++++--
 test/cxl-xor-region.sh                  | 129 ---------
 test/meson.build                        |   2 -
 5 files changed, 442 insertions(+), 173 deletions(-)
 delete mode 100644 test/cxl-xor-region.sh

-- 
2.37.3


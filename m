Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C464AD48
	for <nvdimm@lists.linux.dev>; Fri, 23 Feb 2024 01:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708652410; cv=none; b=TG2sQXlnAMsZ03rWYoD7iUWSSNKWWQe5D2gjiGYqEH8SXbhR1krWsFMWWjBj/HWlr0RaPD8jGxmcDGUHDVhU12xops4bwREjHWZAB+hy6iWxjAfk9b5SHb6Uud+A32LWLvuieBDY81H8OCOaPaAClscX8yiKULgrBuOQ5QFDan0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708652410; c=relaxed/simple;
	bh=NmlkkzSU6Vbja+FJwQbGWj3GoFPPd1QYAinAczW1i28=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=SkvN2kdhdboDDgNlGGq4OFxBB97QVGKNNUFMwgzOWarQjn1l2OBRD0ckUByiD0qppyeuwzZQigMR3fGn2RIJY1N9ybavvQoUOOfCgEw7UqqFuuau3EfZVmDFd+jqaFn1Z5msxGzERvAaRHDOuUR5r+yIf/aMKbi0cz6A3TvI6/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=j1rU5dak; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="j1rU5dak"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708652409; x=1740188409;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=NmlkkzSU6Vbja+FJwQbGWj3GoFPPd1QYAinAczW1i28=;
  b=j1rU5dakjtdoVb7KuDYq/Hg25MUKWlZGvuZ/iwQWkkoLY2sC6nN1UkLy
   Yup7PubAhtQAn+VUwxY3jebDrG+WJf3fiKVOanG6603d2SVawqH5YXt0h
   o5TD8jl+8wKu0nAtfDpcVor8AymEqeunq4FZU6P4VKKlWmLPjsczEbT2K
   qVCv04CYvNH9R2kpxtm2b7PBQvf54AlAZ5cF+hl87tOQHHcqIQOozhc3V
   Y51+lEBzK3U/MinccmS9JyVpZTVA1MPcZGJ71Q4x5/pNSLmDv2AHcQO7j
   xoUDRW31jUvVGHlZW6QAhEvcPrcVaWXiHpdO7shOgaQQeFs87L2EvqpzA
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10992"; a="3097984"
X-IronPort-AV: E=Sophos;i="6.06,179,1705392000"; 
   d="scan'208";a="3097984"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2024 17:40:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,179,1705392000"; 
   d="scan'208";a="10482389"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.209.29.102])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2024 17:40:08 -0800
From: alison.schofield@intel.com
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: [ndctl PATCH v2 0/3] Tidy-up, then expand, cxl-xor-region.sh
Date: Thu, 22 Feb 2024 17:40:02 -0800
Message-Id: <cover.1708650921.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alison Schofield <alison.schofield@intel.com>

This is labeled v2 because v1 of the 3rd patch in the set previuosly
appeared here:
https://lore.kernel.org/nvdimm/20240214071447.1918988-1-alison.schofield@intel.com/

Two cleanup patches are prepended to the original patch. There is no
functional change since v1, only cleanup and a rebase on the latest
ndctl pending branch.


Alison Schofield (3):
  cxl/test: replace spaces with tabs in cxl-xor-region.sh
  cxl/test: add double quotes in cxl-xor-region.sh
  cxl/test: add 3-way HB interleave testcase to cxl-xor-region.sh

 test/cxl-xor-region.sh | 112 +++++++++++++++++++++++++++--------------
 1 file changed, 73 insertions(+), 39 deletions(-)


base-commit: 4d767c0c9b91d254e8ff0d7f0d3be04a498ad9f0
-- 
2.37.3


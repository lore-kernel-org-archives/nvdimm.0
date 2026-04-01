Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C0A8171CD
	for <nvdimm@lists.linux.dev>; Wed,  1 Apr 2026 04:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775018995; cv=none; b=uksZTkZM0WyOevOGJiBWYwpTB2DLhvZB/pBQJPyyb45VKHUfjBX+P99H93+0+Av1oKDImGWNm4adudfvY6nS8hfUPPzYr1Wa5JC/D7FxdPeb67CfwUwAu8fvpanUEBf92So4afcaSIL8JLw5XSFt6vyRgu1pigsWSCclzFd3so0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775018995; c=relaxed/simple;
	bh=6gD8o+5Dd5GLbcm85eYF+Y3Ws/vtjgHEsDS3HUH2VdY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cuFHN9mLAwF7ncxzGO2Nw67PH34o72yZV3PVcO5Q4EHfPSQbkel33qqY7UIToUfJyNye3AYdikt4o+2tcGvZWUW8SC1j7pIWSF/2mz8Nt6+6u2pgY4Vb7dW4CjGRuOLvUNibHwpLnnhBT6usSnrD4ZmLJTXbGfuXWj+WsWnp7xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=C/NSSOCl; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="C/NSSOCl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775018994; x=1806554994;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=6gD8o+5Dd5GLbcm85eYF+Y3Ws/vtjgHEsDS3HUH2VdY=;
  b=C/NSSOClhoPEKkm3oJVf1tYBlIWb9LCySw4PpmJCbiDHmKtCXPvgMcnB
   ZIF73jP9Jxqwh1lEKIrnw+XKRjQ8S8oVlwLM/V2jtkZE5t4hxgIQLItMP
   5iF6JnG5E1lgcTReSY5LoLwNYpzNuCj1WIewNQVi73GolzPZS04Ueghtq
   CvqY0PROepE685DJRxeLCwTvyns+BMIg+WhtY37zas743r5Ng8op3UVGx
   i8RUWjdSdKyuII9a/FVzHsYUJpgAnjlTSEAFQJfYYcpabxLlUnIkILyqM
   BE0y7KLYfJt2FownamvsrJlbyCCS7+Mv3RKzGoKLhCNDTRm5UvtNhYibt
   g==;
X-CSE-ConnectionGUID: n4NLRWleQ1GIM96PLRPrZw==
X-CSE-MsgGUID: uIoUExY6SdOp9Ndr4nbA0Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11745"; a="75218252"
X-IronPort-AV: E=Sophos;i="6.23,153,1770624000"; 
   d="scan'208";a="75218252"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2026 21:49:54 -0700
X-CSE-ConnectionGUID: qEOJojgOTAKzz1rHrJx5RQ==
X-CSE-MsgGUID: USvSXflNTpKSHga9ggcsYg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,153,1770624000"; 
   d="scan'208";a="249781859"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.223.4])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2026 21:49:54 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: nvdimm@lists.linux.dev
Cc: Alison Schofield <alison.schofield@intel.com>
Subject: [ndctl PATCH 1/3] test/mmap.c: check mmap() result against MAP_FAILED
Date: Tue, 31 Mar 2026 21:49:45 -0700
Message-ID: <09ef1cacb6dcb0accae1756561b0f761a764aaba.1775018517.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The mmap test currently checks for failure by comparing the return
value of mmap() against NULL. However, mmap() indicates failure by
returning MAP_FAILED, not NULL. This means a failure would go
undetected and the test would proceed with an invalid pointer.

Update the check to compare against MAP_FAILED.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 test/mmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/test/mmap.c b/test/mmap.c
index 0a66967a25f6..98b85fe8453e 100644
--- a/test/mmap.c
+++ b/test/mmap.c
@@ -155,7 +155,7 @@ int main(int argc, char **argv)
 
 	printf("> mmap mprot 0x%x flags 0x%x\n", mprot, mflags);
 	p = mmap(mptr, size, mprot, mflags, fd, 0x0);
-	if (!p) {
+	if (p == MAP_FAILED) {
 		perror("mmap failed");
 		return EXIT_FAILURE;
 	}

base-commit: 8ad90e54f0ff4f7291e7f21d44d769d10f24e2b6
-- 
2.37.3


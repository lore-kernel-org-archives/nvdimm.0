Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27256185B58
	for <nvdimm@lists.linux.dev>; Fri, 15 Nov 2024 18:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731696049; cv=none; b=IKiIuzLLthxLscoOMTw1Smje15oS6S5LoXH6ut05QIRfzclQ/NPmbVn3yL5LkEHYMHxbOeBRn+ZHnIAs08U2nmyXQnUiQsSCUBJn/m41a/d0o0YgTESpqVv9GA7BKjGN14Wjmwvz1fgyIsCzRsaFgOvpLAQ2rtXfPSoaEJVPfgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731696049; c=relaxed/simple;
	bh=wD+XIhKFNUIAbTLMKPo9wsnzKTJTpx4Wre2NG4iL7dw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=gcUPUnL/uyXj2FURmrLyGFAHCKe3VkCM7CvNzP2ZIbbz3clChf1kKXsyLwUAsPgCk0hO8PCT58syLdNa+h9OrIMmzmhGOxPA+NTfkHfWYrFHHTeKuZVhgva0Kqd8uL02RxoTvkBBsatqUkyt2E9Q0et81BB9t494g3JnqVdI6b4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=as06cAup; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="as06cAup"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731696048; x=1763232048;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=wD+XIhKFNUIAbTLMKPo9wsnzKTJTpx4Wre2NG4iL7dw=;
  b=as06cAupiJhBLSh/eO163zQn9T+i8zp398obTFb4Bai3Jadtv2qMi3sp
   KW1tj/lTvx6/cVBh5u+7lPMe8G/ei81gIU37Hlx+mpI+gEdzi4HXBXsRW
   ndoJSvX7jyi4IVXp96gLM4bvjJKL2tsPpM6Due3tmFLYrNShZBPMvomaD
   mh5EL7VFe19AcGQvMJD4QYnsUm855kgjBlTNinHEXee3ajsjT22p75xzy
   VO3XhGEx0xBUSSM8OD3KTqty6Cby2yC7ffSrX7YmJCbGHlThm+jzQZHDP
   6GquSRCdkYhtXfdLW3hTvUHZU8ZcHkCWWeedhflGPW4Mcd2qwr/1L7j0O
   w==;
X-CSE-ConnectionGUID: Om9DwML5TvaJ5XwV1FPbqQ==
X-CSE-MsgGUID: 6ianb0tzSVW0bFnyCZtGMQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11257"; a="31127884"
X-IronPort-AV: E=Sophos;i="6.12,157,1728975600"; 
   d="scan'208";a="31127884"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2024 10:40:38 -0800
X-CSE-ConnectionGUID: NGhgHLS8SbeQGBg5NjRW2A==
X-CSE-MsgGUID: UiAMGmC3ScCQOdmnacoc3Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,157,1728975600"; 
   d="scan'208";a="88522607"
Received: from ehanks-mobl1.amr.corp.intel.com (HELO localhost) ([10.125.108.112])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2024 10:40:38 -0800
From: Ira Weiny <ira.weiny@intel.com>
Date: Fri, 15 Nov 2024 12:40:34 -0600
Subject: [ndctl PATCH v3 1/9] ndctl/cxl-events: Don't fail test until event
 counts are reported
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241115-dcd-region2-v3-1-326cd4e34dcd@intel.com>
References: <20241115-dcd-region2-v3-0-326cd4e34dcd@intel.com>
In-Reply-To: <20241115-dcd-region2-v3-0-326cd4e34dcd@intel.com>
To: Alison Schofield <alison.schofield@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>, 
 Jonathan Cameron <jonathan.cameron@Huawei.com>, Fan Ni <fan.ni@samsung.com>, 
 Navneet Singh <navneet.singh@intel.com>, 
 Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
 linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev, 
 Ira Weiny <ira.weiny@intel.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1731696034; l=1494;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=wD+XIhKFNUIAbTLMKPo9wsnzKTJTpx4Wre2NG4iL7dw=;
 b=pZbc8695CQScCgXAju+hnBt8dbNXI8x56/nXhIcoXDTbU5r/I6uqlvyHyrLGuul/znuSUh0hM
 gsgOaam6IJQBCReA/QBioTZ96GR8cfjoHwYz3GQRu3Jgs/IbNLwCqar
X-Developer-Key: i=ira.weiny@intel.com; a=ed25519;
 pk=noldbkG+Wp1qXRrrkfY1QJpDf7QsOEthbOT7vm0PqsE=

In testing DCD event modifications a failed cxl-event test lacked
details on the event counts.  This was because the greps were failing
the test rather than the check against the counts.

Suppress the grep failure and rely on event count checks for pass/fail
of the test.

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 test/cxl-events.sh | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/test/cxl-events.sh b/test/cxl-events.sh
index ff4f3fdff1d8f6fd80f093126a27bf14b52d167f..c216d6aa9148c938a649cb22656127b3df440039 100644
--- a/test/cxl-events.sh
+++ b/test/cxl-events.sh
@@ -71,10 +71,10 @@ echo 0 > /sys/kernel/tracing/tracing_on
 echo "TEST: Events seen"
 trace_out=$(cat /sys/kernel/tracing/trace)
 
-num_overflow=$(grep -c "cxl_overflow" <<< "${trace_out}")
-num_fatal=$(grep -c "log=Fatal" <<< "${trace_out}")
-num_failure=$(grep -c "log=Failure" <<< "${trace_out}")
-num_info=$(grep -c "log=Informational" <<< "${trace_out}")
+num_overflow=$(grep -c "cxl_overflow" <<< "${trace_out}" || true)
+num_fatal=$(grep -c "log=Fatal" <<< "${trace_out}" || true)
+num_failure=$(grep -c "log=Failure" <<< "${trace_out}" || true)
+num_info=$(grep -c "log=Informational" <<< "${trace_out}" || true)
 echo "     LOG     (Expected) : (Found)"
 echo "     overflow      ($num_overflow_expected) : $num_overflow"
 echo "     Fatal         ($num_fatal_expected) : $num_fatal"

-- 
2.47.0


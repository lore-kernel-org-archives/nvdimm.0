Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BAF11D63E8
	for <nvdimm@lists.linux.dev>; Fri, 15 Nov 2024 18:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731696388; cv=none; b=mXLA6I46OX8jMYBYtAEEUPI4TLBEKk7ByxYLWntRUJ3gEYdjiPToCdCOjBmWVc5HLjTHcEDzP1qdP7jzmgn/dMm5tjQEgKOFCuZQFEJIIOsG5APCAAQlasXCjLz439tTLOEfLbDfpoTBtM4sMCGTuvb9FZeCYFQJwuXL6U4uuiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731696388; c=relaxed/simple;
	bh=wD+XIhKFNUIAbTLMKPo9wsnzKTJTpx4Wre2NG4iL7dw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=MdUR5uWuu5rTqpYhnTze5pU6hUE0IXe52mYdEVFIG6VKawCwafDUL6bV7Qec6GsF/ruW1edaVg2ekN78AHx/jn0TbHfs0vJMq8VAzuQ067DSQpEJuO0vI4VAXrrRo5g+Y5ns+P1af9IALidE6uN8fd4HKWq9oa5Ivr2EvFxtRRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=K0lD1Kgz; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="K0lD1Kgz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731696388; x=1763232388;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=wD+XIhKFNUIAbTLMKPo9wsnzKTJTpx4Wre2NG4iL7dw=;
  b=K0lD1KgzDerkQSpWQgjoQTmqiNgLDqivdUOF+V+DJG6um2mHK9jMtrE5
   pzJmdnchnia6BiT+vgdLdMej0ah/gyV4b3wTPDf34QCawtkhc/YUA/F0B
   hsBu2QHQ1XgYn0PjONnLD71kgovE/GmCcpdzvINrJrnX7VktstD2FJRk2
   feQ2mwTpZNjVwFTyA1oQ6B9rmEWmmxyb9DRYLoOOeENV+x8mSQ9+8ignw
   sDnV//lQ6toz4Q7phlnjqXy36YqapMn70+iBhfT+5RuZXP//eQuKhiGEE
   OPVV1jRB4+Nwo0sXVXbcTqY8xy683LWoLbECPb9yO/MLE0ek5POOg43sn
   Q==;
X-CSE-ConnectionGUID: kkTDoBKCSAyfSCCPNrCxDQ==
X-CSE-MsgGUID: 03aprq8SS9apmffzvwhwBg==
X-IronPort-AV: E=McAfee;i="6700,10204,11257"; a="42794867"
X-IronPort-AV: E=Sophos;i="6.12,157,1728975600"; 
   d="scan'208";a="42794867"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2024 10:46:28 -0800
X-CSE-ConnectionGUID: jn1jpH9IQ0CC47raUqiM+Q==
X-CSE-MsgGUID: FqH+eF6pQieQOMjCb9HOGA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,157,1728975600"; 
   d="scan'208";a="92715690"
Received: from ehanks-mobl1.amr.corp.intel.com (HELO localhost) ([10.125.108.112])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2024 10:46:25 -0800
From: Ira Weiny <ira.weiny@intel.com>
Date: Fri, 15 Nov 2024 12:46:19 -0600
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
Message-Id: <20241115-dcd-region2-v3-1-585d480ccdab@intel.com>
References: <20241115-dcd-region2-v3-0-585d480ccdab@intel.com>
In-Reply-To: <20241115-dcd-region2-v3-0-585d480ccdab@intel.com>
To: Alison Schofield <alison.schofield@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>, 
 Jonathan Cameron <jonathan.cameron@Huawei.com>, Fan Ni <fan.ni@samsung.com>, 
 Navneet Singh <navneet.singh@intel.com>, 
 Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
 linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev, 
 Ira Weiny <ira.weiny@intel.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1731696382; l=1494;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=wD+XIhKFNUIAbTLMKPo9wsnzKTJTpx4Wre2NG4iL7dw=;
 b=h5rXdxx2f6NLIG13P8WgFf76OcfOZw8o6MvAoLFyhPcOvI60Texz+qsoJ0ZjEEvsBuB/+3Qp9
 5jR/Q04Ki2pDYn+2F6+ZCrjvcTnkaHDoWHrPEH1CZs/w3fH6rkWkw/S
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


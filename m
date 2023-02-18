Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1C5236F
	for <nvdimm@lists.linux.dev>; Sat, 18 Feb 2023 00:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676680832; x=1708216832;
  h=from:subject:date:message-id:mime-version:
   content-transfer-encoding:to:cc;
  bh=px4xhLIWrOdfy8hwdxneIDO3Q0UT2tBgjgQb004DE4w=;
  b=QCFrUcHJ7TUzEVje5ciHanZsguYuYOPe6Zl/Z4heD61Vj8PCZDpEXkRL
   uN87oZu0hC6FamVCYhsVaqFipFIRZihUh2dgjBYOXsniTaWLJA04g5KiK
   /IZohz3gWqG4fTQeD3e/Psg8LxhJRevhH6/csNFQkutDwFYoQbmylmaWz
   u8IOMn1VnLGdJf1LE94SUS3M55KL9DN2z9pIrpvN970f0p01llcusDqPS
   5qYe9t9WKazX996h8+hav6PwF5DSmcNPf4AtPps+0/skotXkncE/GvRas
   2InnxSk52EwkAeHFp0gGFrmLdB+c3hnKW6bovsTEFgHbim6lloHcdMgXL
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10624"; a="311754221"
X-IronPort-AV: E=Sophos;i="5.97,306,1669104000"; 
   d="scan'208";a="311754221"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2023 16:40:32 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10624"; a="844748999"
X-IronPort-AV: E=Sophos;i="5.97,306,1669104000"; 
   d="scan'208";a="844748999"
Received: from basavana-mobl.amr.corp.intel.com (HELO vverma7-desk1.local) ([10.209.2.127])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2023 16:40:31 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH ndctl 0/3] cxl/monitor: coverity and misc other fixes
Date: Fri, 17 Feb 2023 17:40:21 -0700
Message-Id: <20230217-coverity-fixes-v1-0-043fac896a40@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAHUe8GMC/x3LMQ6DMAyF4asgz7VEwlDEVaoOieOAF4PiCrVC3
 B3T8X9P3wHGTdhg6g5ovIvJqh7h0QEtSWdGKd4Q+zj0MTyR1t3F54dVvmzIoQx1zBSpZnCUkzH
 mlpSWm22sRXS+n63xn/j8ep/nBSCuzzF6AAAA
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev, Dave Jiang <dave.jiang@intel.com>, 
 Dan Williams <dan.j.williams@intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>
X-Mailer: b4 0.13-dev-ada30
X-Developer-Signature: v=1; a=openpgp-sha256; l=714;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=px4xhLIWrOdfy8hwdxneIDO3Q0UT2tBgjgQb004DE4w=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDMkf5OpNJDrmLD8npJnwUbzg16J4zcAHTbqT7dOqdyWcf
 bz85cTcjlIWBjEuBlkxRZa/ez4yHpPbns8TmOAIM4eVCWQIAxenAEwkdQMjwwSJGqcAAZnFYpWb
 FjMXv9Z4bPdsRbVf4PZte/LOa24/sISRYdITTykV++bYl5w8T+9FNpeoHZss0DH7tMzNE2a3rr7
 vYgEA
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp;
 fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF

Fix a couple of issues reported by Coverity in the cxl-monitor code, and
an async probe wait in the cxl=security.sh test.

Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
Vishal Verma (3):
      cxl/event_trace: fix a resource leak in cxl_event_to_json()
      cxl/monitor: retain error code in monitor_event()
      test/cxl-security.sh: avoid intermittent failures due to sasync probe

 cxl/event_trace.c | 3 ++-
 cxl/monitor.c     | 3 ++-
 test/security.sh  | 1 +
 3 files changed, 5 insertions(+), 2 deletions(-)
---
base-commit: a88bdcfb4202c73aadfee6f83c5502eb5121cbd9
change-id: 20230217-coverity-fixes-e1d3f8bc2cfb

Best regards,
-- 
Vishal Verma <vishal.l.verma@intel.com>


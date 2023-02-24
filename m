Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75A85D2FB
	for <nvdimm@lists.linux.dev>; Fri, 24 Feb 2023 05:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677217560; x=1708753560;
  h=from:subject:date:message-id:mime-version:
   content-transfer-encoding:to:cc;
  bh=y0crmw7TfVMELQMzTcXRd2RFZ97sUGV9wJ5294+zv+E=;
  b=EJxS1o7tFvRpZHP5O78lLJoF7ewvcrvxbIutPxdCCdKeTzkruwtDp3LV
   wxXAIY193g5N/OXqNiBMqUP2e19K4jBdJ1If8vn4CUei/8ZD5tWBFy+dc
   kYtYPAIluhu8FMVe/C6NzYb4Ebfv0CwPj0WLmtHv3o5Afoxxy1nRSiJst
   DpfeYokCQ27TxqaeNoZlJa5iB2ZjLzFn6hT3GrhlaQMh67FngauDIHkDi
   1KJAp8bRk29ueKlXnDpM4XX5q0bbDSnWWIUBraajv5MLIuD4iBJk/O2RD
   5cBOvemQkoHqprfdG9H0Rm2PkZWfrSnB2+VZmaGHNvBMzlJk0Lw9X3TLa
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10630"; a="398137016"
X-IronPort-AV: E=Sophos;i="5.97,322,1669104000"; 
   d="scan'208";a="398137016"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2023 21:45:59 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10630"; a="1001701692"
X-IronPort-AV: E=Sophos;i="5.97,322,1669104000"; 
   d="scan'208";a="1001701692"
Received: from kwameopo-mobl1.amr.corp.intel.com (HELO vverma7-desk1.local) ([10.209.85.102])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2023 21:45:59 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH ndctl 0/2] fix a couple of meson issues with v76
Date: Thu, 23 Feb 2023 22:45:37 -0700
Message-Id: <20230223-meson-build-fixes-v1-0-5fae3b606395@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAFP+GMC/x2LQQqDQAwAvyI5N7DNopR+pfSQ1aiBbSwbLAXx7
 w09zjBzgEtTcbh3BzT5qOtmAddLB+PKtgjqFAyUKCeijC/xzbDsWiec9SuOeaD+NnDimQXiK+y
 CpbGNa5y21xry3eRfh3k8z/MHKpx8D3gAAAA=
To: linux-cxl@vger.kernel.org
Cc: =?utf-8?q?Michal_Such=C3=A1nek?= <msuchanek@suse.de>, 
 Dave Jiang <dave.jiang@intel.com>, Dan Williams <dan.j.williams@intel.com>, 
 Dan Williams <dan.j.williams@intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>, nvdimm@lists.linux.dev
X-Mailer: b4 0.13-dev-ada30
X-Developer-Signature: v=1; a=openpgp-sha256; l=734;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=y0crmw7TfVMELQMzTcXRd2RFZ97sUGV9wJ5294+zv+E=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDMk//MVVkp5fPjNPUe3W/kK/NW801KzYJYuu+JnqHQ2xX
 lP8JG92RykLgxgXg6yYIsvfPR8Zj8ltz+cJTHCEmcPKBDKEgYtTACYSGsvwP41z8qJ/a3ewxs9N
 nFLIu26TtnLUr8OP0rbZdOz/p/ydeRnDH74Z3DzZO9Uf9s0+nrP907lETZOF89ZMd7ToU7pwyks
 iiQEA
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp;
 fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF

Fix the include paths for libtraceevent and libtracefs headers to not
explicitly state the {lib}trace{fs,event}/ prefix since that is
determined via pkg-config.

Require a minimum version of json-c for new APIs used by cxl-monitor.

Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
Vishal Verma (2):
      cxl/monitor: fix include paths for tracefs and traceevent
      cxl/event-trace: use the wrapped util_json_new_u64()

 cxl/event_trace.c | 8 ++++----
 cxl/monitor.c     | 4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)
---
base-commit: 4e1d3fd6343abf60a1d51eec6657be8fe1156789
change-id: 20230223-meson-build-fixes-362586a0afae

Best regards,
-- 
Vishal Verma <vishal.l.verma@intel.com>


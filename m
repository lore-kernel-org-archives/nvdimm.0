Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0F5063AD
	for <nvdimm@lists.linux.dev>; Mon, 24 Apr 2023 19:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682366394; x=1713902394;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=N+pnJfgGcGHjw+ULGWkSTJiaCsI/Hrj1Roxt/t3wLLU=;
  b=iGznIUlYn7FYzoqaBFPhuBvzZouBRUas/q3EOdcehuFtcvaM0zmCcCj0
   pq4l0sZwDHCkD/45QHbkFmvxcaajTOwksMBPkzqF17s9mQEDhNuT57ZHX
   y811zrIo8zlu/unBWNlryInPsOZpn/S7z2xoaWBAWgi0rP7i5s87MZHNU
   JdUdCiMVLeQgME7FPCALPv9QJ7BoTc8Pbp2y3r3OHYOjxMLbz15fQBNbN
   Uetn9COY9JFSgLhwqY7XijbonD3Inzvit9KdOtCPtgFp5AS6Qv8bgvRJv
   NbvVeApwr6t0+BirkCBBpIhXLhmM5bI3p0uuI0mW2lecz9voXDBEHxUe6
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10690"; a="326157396"
X-IronPort-AV: E=Sophos;i="5.99,223,1677571200"; 
   d="scan'208";a="326157396"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2023 12:59:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10690"; a="670622089"
X-IronPort-AV: E=Sophos;i="5.99,223,1677571200"; 
   d="scan'208";a="670622089"
Received: from fbirang-mobl.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.209.88.12])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2023 12:59:54 -0700
Subject: [PATCH 4/4] test: Fix dangling pointer warning
From: Dan Williams <dan.j.williams@intel.com>
To: vishal.l.verma@intel.com
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Date: Mon, 24 Apr 2023 12:59:54 -0700
Message-ID: <168236639399.1027628.5866455518934998684.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <168236637159.1027628.7560967008080605819.stgit@dwillia2-xfh.jf.intel.com>
References: <168236637159.1027628.7560967008080605819.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

gcc (13.0.1 20230421 (Red Hat 13.0.1-0)) complains:

../test/libndctl.c: In function ‘check_commands’:
../test/libndctl.c:2313:20: warning: storing the address of local variable
‘__check_dimm_cmds’ in ‘check_cmds’ [-Wdangling-poiter=]

...fix it by showing the compiler that the local setting does not escape
the function.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/libndctl.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/test/libndctl.c b/test/libndctl.c
index 51245cf4ea98..858110c4dbc1 100644
--- a/test/libndctl.c
+++ b/test/libndctl.c
@@ -2322,7 +2322,8 @@ static int check_commands(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
 					ndctl_bus_get_provider(bus),
 					ndctl_dimm_get_id(dimm),
 					ndctl_dimm_get_cmd_name(dimm, i));
-			return -ENXIO;
+			rc = -ENXIO;
+			break;
 		}
 
 		if (!check->check_fn)
@@ -2331,6 +2332,7 @@ static int check_commands(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
 		if (rc)
 			break;
 	}
+	check_cmds = NULL;
 
 	for (i = 0; i < ARRAY_SIZE(__check_dimm_cmds); i++) {
 		if (__check_dimm_cmds[i].cmd)


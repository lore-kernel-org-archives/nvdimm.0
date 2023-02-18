Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E48036F
	for <nvdimm@lists.linux.dev>; Sat, 18 Feb 2023 00:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676680835; x=1708216835;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=9UeQUR+hYc76x7YfmfwMiEJR1+Ro6FeZ9RipZ0udPiY=;
  b=fS1TIF0A/PlBP+FHEewEV09gmQSM0qbREFQa/NJ6afCIvnweFfTtrVHb
   NWVZUONrp9iyld4I6v6JYB9MsA1jhes2cKPNNvi8TLGELGwE5CdlyWbNp
   e6j0V1OlC6EPnv1fPYTn0jpFI+W4b3F3EIME1icudlGhQCZLrot8guTs0
   Gw3dSjdJ19NekdRI9aCGBF9K8/UTzgKiX+k3ejYdgBq6/Y3WSGDAXYnFs
   wapKSEgPyoficG3KZMGhNd6U6dGwZWX6JzJEfknm162gTyPos/X9VafZL
   20uLoT+znAW51lQBIADVqBFo9c/JYQCozk3+RNpbewgyryQejsBoBGnxV
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10624"; a="311754225"
X-IronPort-AV: E=Sophos;i="5.97,306,1669104000"; 
   d="scan'208";a="311754225"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2023 16:40:32 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10624"; a="844749005"
X-IronPort-AV: E=Sophos;i="5.97,306,1669104000"; 
   d="scan'208";a="844749005"
Received: from basavana-mobl.amr.corp.intel.com (HELO vverma7-desk1.local) ([10.209.2.127])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2023 16:40:32 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
Date: Fri, 17 Feb 2023 17:40:23 -0700
Subject: [PATCH ndctl 2/3] cxl/monitor: retain error code in
 monitor_event()
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230217-coverity-fixes-v1-2-043fac896a40@intel.com>
References: <20230217-coverity-fixes-v1-0-043fac896a40@intel.com>
In-Reply-To: <20230217-coverity-fixes-v1-0-043fac896a40@intel.com>
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev, Dave Jiang <dave.jiang@intel.com>, 
 Dan Williams <dan.j.williams@intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>
X-Mailer: b4 0.13-dev-ada30
X-Developer-Signature: v=1; a=openpgp-sha256; l=1113;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=9UeQUR+hYc76x7YfmfwMiEJR1+Ro6FeZ9RipZ0udPiY=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDMkf5Oq7Dz7oPdK202man3ff7srrsX2e1t6rzix8utVA3
 9vz82r9jlIWBjEuBlkxRZa/ez4yHpPbns8TmOAIM4eVCWQIAxenAEzk5U6Gf6o3Ox4vXb1mb3bk
 bcl1SXfSZE2vme8+HnE4SuMZb/+CjXcY/lfYH5H58mD1Nb0LU9ze3eKatvb1V8tFhz1ObRK4WXX
 Dt58BAA==
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp;
 fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF

Static analysis reports that the error unwinding path in monitor_event()
overwrites 'rc' with the return from cxl_event_tracing_disable(). This
masks the actual error code from either epoll_wait() or
cxl_parse_events() which is the one that should be propagated.

Print a spot error in case there's an error while disabling tracing, but
otherwise retain the rc from the main body of the function.

Fixes: 299f69f974a6 ("cxl/monitor: add a new monitor command for CXL trace events")
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 cxl/monitor.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/cxl/monitor.c b/cxl/monitor.c
index 31e6f98..749f472 100644
--- a/cxl/monitor.c
+++ b/cxl/monitor.c
@@ -130,7 +130,8 @@ static int monitor_event(struct cxl_ctx *ctx)
 	}
 
 parse_err:
-	rc = cxl_event_tracing_disable(inst);
+	if (cxl_event_tracing_disable(inst) < 0)
+		err(&monitor, "failed to disable tracing\n");
 event_en_err:
 epoll_ctl_err:
 	close(fd);

-- 
2.39.1


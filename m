Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F20738AC8A
	for <nvdimm@lists.linux.dev>; Thu, 18 Jun 2026 09:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781773628; cv=none; b=RRqeRKzo4f4TLmUhOASOtt6vKwGuVl1XbhQaBB6/c6GqAwnoa8w3gXCmw3APMsXyM+k1G7zpN+1Nd3Hc71BgJKEZiIx0aWYhEUlVWo0XLYZN/mgb+/Nch+AbKZ913wH7m8U8dHzH+tNEUqVZUqiP+agxNRFKmVR2N2qM1KDCu5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781773628; c=relaxed/simple;
	bh=401A1wOXkOrpaj8l17F2wrcV6vWjHRZK45lFSsCo6bI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T6++p8F6qq8kXh+EKVCjAvbv60PXPz5A6zQSFGf2VY2XZCVEOuCE6+9rbI4uDvSkMrSumRp92eJzfKyOKc8ReFJt9AmINPco8AMOyG0w+kb0WAbKeW+GQXDCQuTDajy85IkUAprzRD97MBYyyTdq7MBOarBt7bP7Tu5bM4oem9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=muCEfNnF; arc=none smtp.client-ip=115.124.30.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="muCEfNnF"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1781773623; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=ummSZw3UDyGl3S5iMZCHW/7Zf+cR2bKmvjP5CqxFkYI=;
	b=muCEfNnFcWDaNRUvdsFv6EfMGd8cGMEvzf23YlpEVSojpOzubxMGVCGC0tSmOzbzIQnwR1VT9MCVfqmuDjGunxZA2Ieoo3NqtDxMzROwQaZnFtDpMjmMPlVjLXT8eDWeG+QHnIuL1Q4dghzhQ8SHwxgXA2jTGo4hZbmrhpNytvk=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R331e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=cp0613@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0X56Rkm2_1781773622;
Received: from DESKTOP-S9E58SO.localdomain(mailfrom:cp0613@linux.alibaba.com fp:SMTPD_---0X56Rkm2_1781773622 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 18 Jun 2026 17:07:02 +0800
From: Chen Pei <cp0613@linux.alibaba.com>
To: alison.schofield@intel.com,
	dave.jiang@intel.com,
	jic23@kernel.org,
	nvdimm@lists.linux.dev
Cc: guoren@kernel.org,
	linux-cxl@vger.kernel.org
Subject: [ndctl PATCH v3 1/2] daxctl: fix kmod reference leak on probe-insert failure
Date: Thu, 18 Jun 2026 17:06:52 +0800
Message-ID: <20260618090653.8983-2-cp0613@linux.alibaba.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260618090653.8983-1-cp0613@linux.alibaba.com>
References: <20260618090653.8983-1-cp0613@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

daxctl_insert_kmod_for_mode() obtains a kmod reference via
kmod_module_new_from_name() and only stores it in dev->module after a
successful kmod_module_probe_insert_module() call. On the failure path
the local reference was returned without being released, leaking one
reference per failed enable attempt.

Drop the reference before returning the error code.

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Chen Pei <cp0613@linux.alibaba.com>
---
 daxctl/lib/libdaxctl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/daxctl/lib/libdaxctl.c b/daxctl/lib/libdaxctl.c
index 01b1915..8c3ac47 100644
--- a/daxctl/lib/libdaxctl.c
+++ b/daxctl/lib/libdaxctl.c
@@ -975,6 +975,7 @@ static int daxctl_insert_kmod_for_mode(struct daxctl_dev *dev,
 			NULL, NULL, NULL, NULL);
 	if (rc < 0) {
 		err(ctx, "%s: insert failure: %d\n", devname, rc);
+		kmod_module_unref(kmod);
 		return rc;
 	}
 	dev->module = kmod;
-- 
2.43.0


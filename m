Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 654C5181B9D
	for <nvdimm@lists.linux.dev>; Tue, 30 Apr 2024 17:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714499086; cv=none; b=ajvF886sLy/sfdd8XhoghhJV9N8xY5Rku31K0iQP8kTkqoASoEGcMfYKrZoli/YxfxcZNNmkaOX5Ju9n1DcHMnXPz/ZgKJrnwGNz+WiE0rw1bQAEjt/LALO2YK1H+ZjEJGszUxbBXeQuMsW66KLL+tM3iHAqOzjQ/vj59BDV630=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714499086; c=relaxed/simple;
	bh=IuUcxmSQ8rmcL+XwprIf4jy7ccGbldFrluNcXl4Pl6A=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=uKu9Y5auj5y3QEGmHn0LsG6dP1w8F0jTSaccl4/Ntpr7T0MRALUrIiYuQ3ZUlTFBBeZYez7qLHoGrgCAslbWupbYgBEblv4/wqkJptJx3dPZqD1k+ZhTakC+KY9f9ieomg4ovfjmzJRArnxXW2Xhc3QRytEtYsnx41GdjNef6mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mxqGRdLZ; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mxqGRdLZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714499085; x=1746035085;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=IuUcxmSQ8rmcL+XwprIf4jy7ccGbldFrluNcXl4Pl6A=;
  b=mxqGRdLZQOyonNVH+IjktykX9mADPgddBnmJOj0AMN9wq4DjskcKa/UO
   3u/W1RF4x3dZgHO+VaULxL/0WobYyY8XlROcQRe39aMaAovubU/zD4hBW
   g7mgenevkcWH94LgxjYYE5VzCr6XqXdugMRi7tpYX0vzv6iNI4rFMg91Y
   cJRTCG1rObxIgB7LmW0ZQ+yyRr0602yszx+/bACbP2KmjE1DITqBpRp9n
   7Fo3as4/TbUgKqhgaZoIbsaOjKEwjN0lHjbGlF86ricp+hIQ+SKW17pga
   YreSNV7kBlz4Ccnix13KenY99LDXNePP1WJKKEGIb8RiqZyNm51uZijUI
   w==;
X-CSE-ConnectionGUID: k2L6T1OpSVuP8nXyeTSbag==
X-CSE-MsgGUID: N2q1EfMdQU+L4dLA6OaWvQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11060"; a="27669843"
X-IronPort-AV: E=Sophos;i="6.07,242,1708416000"; 
   d="scan'208";a="27669843"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2024 10:44:42 -0700
X-CSE-ConnectionGUID: e1jOA7NYSFqVX4GdYq4k9g==
X-CSE-MsgGUID: HKBzb4dvRh+9ecG232yJLw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,242,1708416000"; 
   d="scan'208";a="26534783"
Received: from vverma7-desk1.amr.corp.intel.com (HELO [192.168.1.200]) ([10.212.82.45])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2024 10:44:42 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
Date: Tue, 30 Apr 2024 11:44:26 -0600
Subject: [PATCH v3 4/4] dax/bus.c: Use the right locking mode (read vs
 write) in size_show
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240430-vv-dax_abi_fixes-v3-4-e3dcd755774c@intel.com>
References: <20240430-vv-dax_abi_fixes-v3-0-e3dcd755774c@intel.com>
In-Reply-To: <20240430-vv-dax_abi_fixes-v3-0-e3dcd755774c@intel.com>
To: Dan Williams <dan.j.williams@intel.com>, 
 Dave Jiang <dave.jiang@intel.com>, 
 Alison Schofield <alison.schofield@intel.com>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Vishal Verma <vishal.l.verma@intel.com>
X-Mailer: b4 0.14-dev-5ce50
X-Developer-Signature: v=1; a=openpgp-sha256; l=1034;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=IuUcxmSQ8rmcL+XwprIf4jy7ccGbldFrluNcXl4Pl6A=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDGmGehzPLNirDG5tiC/7LZaetnFTELtN95cHBgw7/ryc9
 GKpxIVfHaUsDGJcDLJiiix/93xkPCa3PZ8nMMERZg4rE8gQBi5OAZhI6GVGhmnLw5Inqtjdb654
 fGP3vZdb37fY1maErJRK39AY7XEkwZDhN/vmEtsfceebpW6dcHSsXrDYbv+EV9fymARvlE+rM5b
 9zAUA
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp;
 fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF

In size_show(), the dax_dev_rwsem only needs a read lock, but was
acquiring a write lock. Change it to down_read_interruptible() so it
doesn't unnecessarily hold a write lock.

Fixes: c05ae9d85b47 ("dax/bus.c: replace driver-core lock usage by a local rwsem")
Cc: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 drivers/dax/bus.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index 0011a6e6a8f2..f24b67c64d5e 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -937,11 +937,11 @@ static ssize_t size_show(struct device *dev,
 	unsigned long long size;
 	int rc;
 
-	rc = down_write_killable(&dax_dev_rwsem);
+	rc = down_read_interruptible(&dax_dev_rwsem);
 	if (rc)
 		return rc;
 	size = dev_dax_size(dev_dax);
-	up_write(&dax_dev_rwsem);
+	up_read(&dax_dev_rwsem);
 
 	return sysfs_emit(buf, "%llu\n", size);
 }

-- 
2.44.0


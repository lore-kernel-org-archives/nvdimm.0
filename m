Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A79534887E;
	Thu, 23 Apr 2026 17:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776963750; cv=none; b=QeQPS8vQsS/HBDMtcUsgXELShNNBqyERNkTWqJQzbCHiDz6TU3EdGGZSPV5Cxhfwb7dwhIQlknIjIeFVnvqsSAH93ai//7qIgPGUweiVLQtrrWVS6JQ4iJc1+6ABIsS3+8eNn7mic/w8tNtfImIM9XASnbVOwlCkl5WRLkk2Ly8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776963750; c=relaxed/simple;
	bh=GWmOwp8QYp1AcydTYqNbCRTEjcWKB6GeAsZZVnHI8ws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jnENy3B5Hc3BeBdhtLUCKcIVKi+F3CFt+lVFuXbfphKhTXMSVRg5Gk6zWqolShstNT1VjDcG468Gd7lP9vn81HtlCVJckHIkpT1ztB7SaqAolLYAsJ+XLkq5pfSoA4tmVyoIAVXjLzodKXI1c4XHSYJGg68TwlRTYUnp01/Onis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D02B9C2BCB3;
	Thu, 23 Apr 2026 17:02:29 +0000 (UTC)
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: djbw@kernel.org,
	iweiny@kernel.org,
	pasha.tatashin@soleen.com,
	mclapinski@google.com,
	rppt@kernel.org,
	joao.m.martins@oracle.com,
	jic23@kernel.org,
	gourry@gourry.net,
	john@groves.net,
	rick.p.edgecombe@intel.com
Subject: [RFC PATCH 06/12] dax: Add helper to determine if a 'struct file' supports dax
Date: Thu, 23 Apr 2026 10:02:13 -0700
Message-ID: <20260423170219.281618-7-dave.jiang@intel.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260423170219.281618-1-dave.jiang@intel.com>
References: <20260423170219.281618-1-dave.jiang@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a helper function that checks of the file_operations is dax.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 include/linux/dax.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/linux/dax.h b/include/linux/dax.h
index 9d624f4d9df6..a5e1a3ca1a0d 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -311,4 +311,11 @@ static inline void hmem_register_resource(int target_nid, struct resource *r)
 typedef int (*walk_hmem_fn)(struct device *dev, int target_nid,
 			    const struct resource *res);
 int walk_hmem_resources(struct device *dev, walk_hmem_fn fn);
+
+extern const struct file_operations dax_fops;
+static inline bool is_file_dax(struct file *file)
+{
+	return file->f_op == &dax_fops;
+}
+
 #endif
-- 
2.53.0


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2025345CA1;
	Fri,  6 Mar 2026 23:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772838309; cv=none; b=Pm1WYrkWbX4bA+hboVMxJ6vVr9Hk30FLMLcy9oC6D6tabnjgxP2ic7JJVe99c7WJknQWGt87Rr+w5YNDZdxMsyDT7i+IMFSUDsfC8gr79Z7K6ATEvy8kGfQHM/rD1bIIEgLA72XuxGpoTetrs98BCX9OJXU9GITSJ0831AtSTVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772838309; c=relaxed/simple;
	bh=1T19RrjSbynvoB0taZha6rszp7DUVkE7wsJUoX9iLT4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GMJ98HD7xqmTajv6pkBYh4bRU/GtJBBuz42OIJ+Ef6lSJhWdy61p3Kr+CEGwhgAkFwjMwQ80WsHLmQPphdSh41NTdFqv3CLb8DH8upeBNXzRIKxQyhXS4jKXYVvgbod/e7NhhEtQbdWSLEv2/JlLzqp32Q6or1CP3yzJcRJfMgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33EF0C4CEF7;
	Fri,  6 Mar 2026 23:05:09 +0000 (UTC)
From: Dave Jiang <dave.jiang@intel.com>
To: nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Cc: dan.j.williams@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com
Subject: [PATCH] dax: Add direct_access() callback check for dax_direct_access()
Date: Fri,  6 Mar 2026 16:05:07 -0700
Message-ID: <20260306230507.2149965-1-dave.jiang@intel.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

__devm_create_dev_dax() calls alloc_dax() with the ops parameter passed
in as NULL. Therefore the ops pointer in dev_dax can be NULL. Add a
check in dax_direct_access() for ops and ops->direct_access() before
calling ops->direct_access().

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/dax/super.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index c00b9dff4a06..5cebaf11a58e 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -160,6 +160,9 @@ long dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff, long nr_pages,
 	if (nr_pages < 0)
 		return -EINVAL;
 
+	if (!dax_dev->ops || !dax_dev->ops->direct_access)
+		return -EOPNOTSUPP;
+
 	avail = dax_dev->ops->direct_access(dax_dev, pgoff, nr_pages,
 			mode, kaddr, pfn);
 	if (!avail)

base-commit: 11439c4635edd669ae435eec308f4ab8a0804808
-- 
2.53.0


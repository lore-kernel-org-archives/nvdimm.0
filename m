Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9E7438735A;
	Thu, 23 Apr 2026 17:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776963742; cv=none; b=I2YYul7WUN0Xs3MIbGpoqa2359NJo55iuxM00q8UeKD1cBulBWvyeNzagUDumEpe3wJMbx6jkPxRZ3U5NWksVC13YfkWxSYeyRuE08D7gfBY7GzSTOnuYOW0GdhW7Jb5iR86wgI/d4nfNK2qNUigyldtwuXfDxoa+xeFMiR4EuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776963742; c=relaxed/simple;
	bh=ypyApHnZEKpoHVLOvakqXzDqjboOFWYPgK/w4Tdo4Nw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PDFFJ8H6C/Tc9hwr5vfjZhxj6Y89fBfhrR6aE4TU8HaeLOPjt+8LKG7R+RGeJcDfMBxCF8D6F7vn3IrHqHcT7W0InHe4Sd93SxHVFOMlFY6947kZfpQpPOWJpgIIAg2u+AU7pRQIVj0f4mLTun7kzx8x12kBZ64VRLBMrTJUgOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 356E9C2BCAF;
	Thu, 23 Apr 2026 17:02:22 +0000 (UTC)
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
Subject: [RFC PATCH 01/12] dax: rate limit dev_dax_huge_fault() output
Date: Thu, 23 Apr 2026 10:02:08 -0700
Message-ID: <20260423170219.281618-2-dave.jiang@intel.com>
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

Use dev_dbg_ratelimited() to rate limit the output of
dev_dax_huge_fault() in order to not flood the dmesg output.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/dax/device.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/dax/device.c b/drivers/dax/device.c
index 22999a402e02..62206bcb63a6 100644
--- a/drivers/dax/device.c
+++ b/drivers/dax/device.c
@@ -244,9 +244,11 @@ static vm_fault_t dev_dax_huge_fault(struct vm_fault *vmf, unsigned int order)
 	int id;
 	struct dev_dax *dev_dax = filp->private_data;
 
-	dev_dbg(&dev_dax->dev, "%s: op=%s addr=%#lx order=%d\n", current->comm,
-		(vmf->flags & FAULT_FLAG_WRITE) ? "write" : "read",
-		vmf->address & ~((1UL << (order + PAGE_SHIFT)) - 1), order);
+	dev_dbg_ratelimited(&dev_dax->dev, "%s: op=%s addr=%#lx order=%d\n",
+			    current->comm,
+			    (vmf->flags & FAULT_FLAG_WRITE) ? "write" : "read",
+			    vmf->address & ~((1UL << (order + PAGE_SHIFT)) - 1),
+			    order);
 
 	id = dax_read_lock();
 	if (order == 0)
-- 
2.53.0


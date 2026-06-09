Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B16C40F8C6;
	Tue,  9 Jun 2026 12:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781006885; cv=pass; b=kwUTiqRgL9HoBJjbGk5oY4ntqXKSjVNMqVcZ6GOEDrk9uAHcAboTqw84Jm1wSuwEh0tT4yFpj2WL6+lyxmIdr18yIHZryra7olKDs9TVhHrCL2lrIAfVfti3lsjwgb0aGnaOyzHAPhMbm/ZyqblzLjZw3WQTezRDeuSfr1gPsys=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781006885; c=relaxed/simple;
	bh=BObJGRZzmtRxVfVzdFlLpRgDXZJViibwtMW5khQwtNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XGZ8Lvdw6PN0fhxAShAaErIPHsRd/laQhsRSAfkp2tpZHtggSn7UY1j1LMTIbKMav2Yvktt4BaUf4nUtglzNJnw9BiiC8z04mVREFFg4sFcehCfwm2HHKG7IrPmCe44WZR9eqwF9cyjzl0bKc8IgMixEatVy22/Ro6ykg16SE4A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=FYCh9wV+; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="FYCh9wV+"
ARC-Seal: i=1; a=rsa-sha256; t=1781006873; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=Z7f4D1DCsyyH7K2l1pkEwzPZIeqLYBgbssLY/1dI4Z2BGfucdNeW/G7iEe76tQXQLkUPK8xEXnVSNtFE7/UPg7JdrAu/CXh5xhffBQNJJwv2h5AojUVxVgqbrnpantGToJFu0TyBzHuONAtNMa7mxsSNI3nWrL3etZfZD3tXK2Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1781006873; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=Kkm6b8v9HrmRxgveYsXGJWG4c5oEBQ3malO2AScRBME=; 
	b=d4aRUbnXSEtAVyWFooyhcRTOr5POKr4xrWhdXZTk65+nrsR/kc2K0Q6Fn11PlO0UiUqNyDESN8DT3zUxwL8pk5oF6Fsys7DwOH6B84EGg/3DjgtJK4zmcVUXHYfn+K15S/pAQPFNMp2nL05zLwr9/zSnSdsu7IptHd+QmJbNZNk=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1781006873;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=Kkm6b8v9HrmRxgveYsXGJWG4c5oEBQ3malO2AScRBME=;
	b=FYCh9wV+yIf7hSrcaOeZJqCInwUkbN3Cg3WkA87V23chxsMSertwLV/s/BgKC1ID
	xoGmVYs62pIoLP05wos36falIETFHB4pj2AcIBwPlNxIl0aOLefU6OCVfxrBaPBfycp
	mWH9eaW9II4rMcvoHBK8sxWPNxbhZDo+UoKhBzi8=
Received: by mx.zohomail.com with SMTPS id 1781006870001907.9313856047778;
	Tue, 9 Jun 2026 05:07:50 -0700 (PDT)
From: Li Chen <me@linux.beauty>
To: Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	virtualization@lists.linux.dev,
	nvdimm@lists.linux.dev
Cc: linux-kernel@vger.kernel.org,
	Li Chen <me@linux.beauty>
Subject: [PATCH v4 1/7] nvdimm: preserve flush callback errors
Date: Tue,  9 Jun 2026 20:07:15 +0800
Message-ID: <20260609120726.1714780-2-me@linux.beauty>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260609120726.1714780-1-me@linux.beauty>
References: <20260609120726.1714780-1-me@linux.beauty>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

nvdimm_flush() currently converts any non-zero provider flush error to
-EIO. That loses useful errno values from provider callbacks.

A local virtio-pmem mkfs sanity test showed the masking clearly:

  wipefs: /dev/pmem0: cannot flush modified buffers: Input/output error
  mkfs.ext4: Input/output error while writing out and closing file system
  nd_region region0: dbg: nvdimm_flush rc=-5

The virtio-pmem callback can return -ENOMEM when async_pmem_flush() fails
to allocate a child flush bio, but nvdimm_flush() hides that as -EIO before
pmem_submit_bio() converts it to a block status.

Return the provider callback error directly. The generic flush path still
returns 0, and pmem_submit_bio() already handles errno-to-blk_status
conversion for bio completion.

Signed-off-by: Li Chen <me@linux.beauty>
---
v3->v4:
- New patch.

 drivers/nvdimm/region_devs.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index e35c2e18518f0..0cd96503c0596 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -1114,10 +1114,8 @@ int nvdimm_flush(struct nd_region *nd_region, struct bio *bio)
 
 	if (!nd_region->flush)
 		rc = generic_nvdimm_flush(nd_region);
-	else {
-		if (nd_region->flush(nd_region, bio))
-			rc = -EIO;
-	}
+	else
+		rc = nd_region->flush(nd_region, bio);
 
 	return rc;
 }
-- 
2.52.0


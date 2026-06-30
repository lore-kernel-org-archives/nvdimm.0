Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1C563E2754;
	Tue, 30 Jun 2026 09:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782811484; cv=pass; b=GO0jkM8OiXDsjGVEe8O8Smp8ceLFYASEp+xU/zHCDYsVf+AQKSAqDngsErojAydKGx5IYVNvvNmID4VjpFS1+80ujQEtKuzC9RcyrKy1tTXfOq1NLJyrklBJp8oWkP+6/UkyzYfOjkPJfUb+hKqLVNn6EKVTawY7/A+JoTmSjkU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782811484; c=relaxed/simple;
	bh=HOkboN4hDdShgcwZeRsLk2Buy2Re5704yodFz9T9gCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PblxZC4okGOnSbUnBg1ZRmZCgqHnCt3U0b5cpWp8CiLV9CbvwEFD2o1NB5pJ2CyGtV3lfbOs2jxhgLwg2GumBctoAcfjgukUit7OYQnXYn1SZ8WW6kRpjfWNX6AMHaZAChBM/LWfyBo9MROPeK8LkWnDCek+/r3h8NfMITRnmO0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=SSpYC49F; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="SSpYC49F"
ARC-Seal: i=1; a=rsa-sha256; t=1782811453; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=T/3nxGkQkR2lEGjewomW2ASSSqvcBIbWy12oP6WV0COlh2tXcY5GSNK25B81fl8CynQQTz1G677oO1AQSw5AIsWJG3UYOcL2JlTkRKxiAehD3i9dkhBq135hPift+uZah5kJMze8sQnby/aGMCKolXb+lDR1x3FmCIWSsPjknME=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1782811453; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=v+XVFe2bm4JGeaAkEpcvHOdpOCS/g1TcjllGxU9z6Hk=; 
	b=ZHrky8XFlX2GPpUSu8S/g78ut1EBMfr1TtXLwCGBaQVEDs3d0AcMfZHac7hxkzK2RhNKkTNsYGmqn4AZZzZp1uXUH6bN6K8Lxqpmx2lYpnE3VgyVqHi2sVsn4dFRKQs9QttuyfkDu/Jgs4nFL13rgRPALGFaEx8877y4PXarQbI=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1782811453;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=v+XVFe2bm4JGeaAkEpcvHOdpOCS/g1TcjllGxU9z6Hk=;
	b=SSpYC49F711ZpC6yqb1INvu/Z9z/ZH/l4cTX6a2M+P9IuvaqlUspuV5oIzG0uung
	FYod9E4ytXKK0ECi6rECyhnrHNtkYwsAH/wFyaacfx/9bpkQBzQ3x7sDzxU4d3nYW6P
	v3CVkR4Ba7OumzGI1Jzm2FLZ8EqPF9sL5J2RJNDs=
Received: by mx.zohomail.com with SMTPS id 1782811452036829.5784203426026;
	Tue, 30 Jun 2026 02:24:12 -0700 (PDT)
From: Li Chen <me@linux.beauty>
To: Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	virtualization@lists.linux.dev,
	nvdimm@lists.linux.dev
Cc: linux-kernel@vger.kernel.org,
	Li Chen <me@linux.beauty>
Subject: [PATCH v7 05/12] nvdimm: virtio_pmem: use GFP_NOIO for flush requests
Date: Tue, 30 Jun 2026 17:23:30 +0800
Message-ID: <20260630092338.2094628-6-me@linux.beauty>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260630092338.2094628-1-me@linux.beauty>
References: <20260630092338.2094628-1-me@linux.beauty>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

virtio_pmem_flush() can run from pmem_submit_bio() while filesystem IO
is waiting on the flush completion. The request object allocation can
sleep, but it should not enter filesystem or block IO reclaim from this
flush path.

Use GFP_NOIO for the request allocation. The virtqueue descriptor
allocation still uses GFP_ATOMIC because it runs under pmem_lock.

Signed-off-by: Li Chen <me@linux.beauty>
---
Changes in v7:
- Keep GFP_NOIO for the virtio-pmem request allocation after removing the
  child flush bio path.
Changes in v6:
- New patch; keep GFP_NOIO only for the virtio-pmem request allocation.

 drivers/nvdimm/nd_virtio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvdimm/nd_virtio.c b/drivers/nvdimm/nd_virtio.c
index 8e16b7780be1a..a35044afddf34 100644
--- a/drivers/nvdimm/nd_virtio.c
+++ b/drivers/nvdimm/nd_virtio.c
@@ -61,7 +61,7 @@ static int virtio_pmem_flush(struct nd_region *nd_region)
 		return -EIO;
 	}
 
-	req_data = kmalloc_obj(*req_data);
+	req_data = kmalloc_obj(*req_data, GFP_NOIO);
 	if (!req_data)
 		return -ENOMEM;
 
-- 
2.52.0

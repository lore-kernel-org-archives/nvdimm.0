Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D9F3366DA3;
	Sun, 21 Jun 2026 13:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782047015; cv=pass; b=ZtruFhwrgb8CYdvTcbseyuOqsgFpcBetGbcG2UaYIKmRcEAzQ+6mX6Uslp8LVjz9ctzTqCpc/sOyXrnBByfGfK1/RlMRPXXNXLrKYSmL8DnW/HMefOAcnQ5uRvU1Byi/ZzSeAl8YRK23Ui78u+fXZCYnq/qSeDHyfOEI84zTBlE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782047015; c=relaxed/simple;
	bh=ewbtKz2hdslCFWnjQTPY4AnRMcpsvvM+zeJ55wqDaQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TOBbW2BOGkcrIa24iO22zAohHAMljz4L6XvP5cZ8nHjOKsaFInRLDM55CG8ZAZcJFU9g1xjWFFK6Snha+xSyFY5CzqbDMdO/9UarVw6qktCq+//UpjZwucbN/YAO5KmKY07IOg4+DXTOtNOWfWAJwkIqt/i1+7vKelQOpaoO3m4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=UyY9byqd; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="UyY9byqd"
ARC-Seal: i=1; a=rsa-sha256; t=1782047002; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=MxAYZL6+AXhvOvX5N5/u3vCCr9I9aX6oFOAWrO5i3jHw51QJFhebcx1iW1p0mqGQV3XeI6X2CkVTcsSrhlvKNoOvn8JjI4VCzgTa0pobvA9SUvdNbKoiI2vSZq8CDZzIFOnVTqEzHJ4b3rxfDTc8jqGKJam89YzCwDUypTMh1+w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1782047002; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=W+o+IKys+lU/ZxFNZxi3pNHAmf/FkNcd7IUh/VLtXLU=; 
	b=JbSZg7FTX4uyoANvOZApavJ49Jeqe+gH4umI9MTO4ybfNxyCJmYr4Lzksm6JJQy9s61yr/jxupLB4aZRWops+lEKN3DCOvUAiX9wKmaV3jpJSnRTW+zA9D61ZsApKHTzMKqJf09TbFxEnLYQ68lGuZeGzZcjA2g4zApXcDMjBk4=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1782047002;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=W+o+IKys+lU/ZxFNZxi3pNHAmf/FkNcd7IUh/VLtXLU=;
	b=UyY9byqdcuyB30IuQ4ltnwxAEZmGtNo3xN9LDYF0vaqgG/xVdbAWihEG0j+ai5jh
	Fg5spON+uD1FgC7I0uAcTkVHD+ad9XIf1LTJBZJfsX/rhD16n6MW0f5iUg63wVrhjxd
	Fz5BEwj4fEBVFJQZfJO/D+Cpel9NHnbYw0x48oyQ=
Received: by mx.zohomail.com with SMTPS id 1782046999373828.3231573844629;
	Sun, 21 Jun 2026 06:03:19 -0700 (PDT)
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
Subject: [PATCH v6 05/12] nvdimm: virtio_pmem: use GFP_NOIO for flush requests
Date: Sun, 21 Jun 2026 21:02:36 +0800
Message-ID: <20260621130246.2973254-6-me@linux.beauty>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260621130246.2973254-1-me@linux.beauty>
References: <20260621130246.2973254-1-me@linux.beauty>
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
Changes in v6:
- New patch; keep GFP_NOIO only for the virtio-pmem request allocation.

 drivers/nvdimm/nd_virtio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvdimm/nd_virtio.c b/drivers/nvdimm/nd_virtio.c
index 4b2e9c47af0f5..91ca144607531 100644
--- a/drivers/nvdimm/nd_virtio.c
+++ b/drivers/nvdimm/nd_virtio.c
@@ -55,7 +55,7 @@ static int virtio_pmem_flush(struct nd_region *nd_region)
 		return -EIO;
 	}
 
-	req_data = kmalloc_obj(*req_data);
+	req_data = kmalloc_obj(*req_data, GFP_NOIO);
 	if (!req_data)
 		return -ENOMEM;
 
-- 
2.52.0

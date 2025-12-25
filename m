Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10C2E2D8365;
	Thu, 25 Dec 2025 04:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766637015; cv=pass; b=a/p2FlPEIORU1aZ+0ymawZUAv0IGDSYOlwsgu2n4GIQ/9wdjjRmHIYZFSvDbGtpokKPLKVkKF5h4C7wOVayB/OYKuAqJIyEqelvJPBap8ShFbKNPGJTP6oJHPUpaJUFaqZbcumV3fmacWfUnnG5HhiQW3GBLf6lk7OgBQbCzEV0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766637015; c=relaxed/simple;
	bh=nSSPLk/HLWPCSAdSLT+cbXEk6rQcq5rhPUFFC3udauk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fHnSmvsyjYA6MmF0M1rdMUi/2QykvozfSN6lupYMGA0Lfc6OZmDZZA0nfbA+eEIU3Kb+LsuC5DurZ7AT7WXK0Z0svnwBYkNxYi8GFVvZZ4x0Tn91MoSP3yB5aIB+HoYfJC9fK12zJpNw2YPXbIf+kjTLM3lhrX6JFqOgNd/BocE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=dv6mI2im; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="dv6mI2im"
ARC-Seal: i=1; a=rsa-sha256; t=1766636982; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=Zvy/99QaETtzSepEP+M82+j7V7ChGzboKZBSeBcBIH2FSP8cZgZYEb1SS8j+MZ1KgoUnc+I1l8uro1wtKyTzZ1iPG538kEBtfwUQaJtDAl4zIAyLwUqJPwNysUKS1NU8wgnR/R4PRpoHTvjzUF3TZ4yQgVfXsPpihsE2jQFaG7c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1766636982; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=wLNb/jl0vEDtdEht8xoD9UZAoUmf2MpLAWXKbrRynh4=; 
	b=IhRFqK8tL+aFpohcfgBNkIUtfBlbGIVlNN6o8PS1rpecW80l+6W+r2JRlPeRqfmamCsqp+SJv4dCLw1+e2FmQUNGlaCmYu83fskBWsLq33VFZ7e+34tJHcQuI50AwTfDD+mH+ulhE3z9EY7Uq9MhDpryyb5k91FJWaykbqwshwA=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1766636982;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=wLNb/jl0vEDtdEht8xoD9UZAoUmf2MpLAWXKbrRynh4=;
	b=dv6mI2imyedVSGNeaOrU0uZ+409GjvsVO2wEFKGkyRq1ULltjNuT3hNyi9AaiEJI
	V2ewKOULH9e3EWYa9o70Im23mZ0W1ui1ptf5yLv0NGjp9fpbusBXpxIAV3Nt95zEn+q
	gX/c1SKB2/FmOkuULFpORj3RG673aiMyvn+YhXK4=
Received: by mx.zohomail.com with SMTPS id 1766636980390385.79513683952234;
	Wed, 24 Dec 2025 20:29:40 -0800 (PST)
From: Li Chen <me@linux.beauty>
To: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
	nvdimm@lists.linux.dev,
	virtualization@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Li Chen <me@linux.beauty>
Subject: [PATCH V2 4/5] nvdimm: virtio_pmem: drain requests in freeze
Date: Thu, 25 Dec 2025 12:29:12 +0800
Message-ID: <20251225042915.334117-5-me@linux.beauty>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251225042915.334117-1-me@linux.beauty>
References: <20251225042915.334117-1-me@linux.beauty>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

virtio_pmem_freeze() deletes virtqueues and resets the device without
waking threads waiting for a virtqueue descriptor or a host completion.

Mark the request virtqueue broken and drain outstanding requests under
pmem_lock before teardown so waiters can make progress and return -EIO.

Signed-off-by: Li Chen <me@linux.beauty>
---
 drivers/nvdimm/virtio_pmem.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/nvdimm/virtio_pmem.c b/drivers/nvdimm/virtio_pmem.c
index aa07328e3ff9..5c60a7b459d4 100644
--- a/drivers/nvdimm/virtio_pmem.c
+++ b/drivers/nvdimm/virtio_pmem.c
@@ -152,6 +152,13 @@ static void virtio_pmem_remove(struct virtio_device *vdev)
 
 static int virtio_pmem_freeze(struct virtio_device *vdev)
 {
+	struct virtio_pmem *vpmem = vdev->priv;
+	unsigned long flags;
+
+	spin_lock_irqsave(&vpmem->pmem_lock, flags);
+	virtio_pmem_mark_broken_and_drain(vpmem);
+	spin_unlock_irqrestore(&vpmem->pmem_lock, flags);
+
 	vdev->config->del_vqs(vdev);
 	virtio_reset_device(vdev);
 
-- 
2.52.0


Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FEC62F745D;
	Sat, 20 Dec 2025 08:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766219719; cv=pass; b=F7DPc2kdVRm1c3VZgsbC4WhV2pLAuaOlULeut8v0zKD/L/ilR2ljYT9R9obqVAJxbSzvxVbCYHIa8wXhxaLnQ+xKJ6p1FsR9nTibqOLHgLvnfEYp6z/Uelj7W55j3kIWbJkoU0cYFgERZWIPmFMEHn3+XwpZp07XIEvkG4cRF1w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766219719; c=relaxed/simple;
	bh=xgICL+AROYOEauYrDUTbYngxQO2C4HrLy6Y3+XbcN0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pxEtpHW576SwGfolN72nnqfoUEUYAgmn/5IAEIx7T9bx2ztlfgxD1VMU9Ejszo81GD5jgTFslSEa8iev2O7+RECZGKxO9eFJwrxcNQW4K9uU86bDdBcfhc2k5pzLubJ/nj7dytD1qd6NzRBPbD7DkAJTWa9c6Rb46HkSDWXVkgU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=MYUmmMhE; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="MYUmmMhE"
ARC-Seal: i=1; a=rsa-sha256; t=1766219704; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=buA3kA8hIoTqkpgvAurMNsLpy6SFVAD+/z/qjmDAlEQ8MQuDPC8DZtkZnmCKxGtwcJnL7rGnfK2Vi77L9F7i8Zxt14Et6bbIesqVV5Bx8mxzH573D7Jl5NZ3ccnmntx6TYaaf5XiizpRW56zyDU0WFC6w1wnNJglb6GtNBr1cJM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1766219704; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=eYfBRITWUnnz0wYgbPwxrDTSwaVRo1CFJZSXwe3HQ70=; 
	b=nKCt6ePpmhRKO3i4kLl0/POcdQjTVaEbg6oA4aSUhvCAw28LYl3zHZoxmu82LrcHy6786mEJENnzxr+tNHjXUCIPxMokRWKeYrHarxnM5dVESo7VZSoPD4MJx3Gh4aHZwQtu26oElhnodKnpLoGMYnFTcCii2zZBqkL1s8lVMyE=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1766219704;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=eYfBRITWUnnz0wYgbPwxrDTSwaVRo1CFJZSXwe3HQ70=;
	b=MYUmmMhEk1Zp+nVRueRvpy7XjgtHT0aJQSG06UG8iKv3P/YvyIRJIdXfeeH4J7iv
	BWPwjvJANpdr8CH3XI8ADW4rFr1Z2vKgZyb4I2WsDAyfyO66yVqR/JJeV3zz6gstPsg
	UMCoa11zL6y27vSuJhJpCE2ihyiLmRjaSqQs4TvA=
Received: by mx.zohomail.com with SMTPS id 17662197034231022.1025851067282;
	Sat, 20 Dec 2025 00:35:03 -0800 (PST)
From: Li Chen <me@linux.beauty>
To: Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	virtualization@lists.linux.dev,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Li Chen <me@linux.beauty>
Subject: [PATCH 4/4] nvdimm: virtio_pmem: drain requests in freeze
Date: Sat, 20 Dec 2025 16:34:40 +0800
Message-ID: <20251220083441.313737-5-me@linux.beauty>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251220083441.313737-1-me@linux.beauty>
References: <20251220083441.313737-1-me@linux.beauty>
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
2.51.0


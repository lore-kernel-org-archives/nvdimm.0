Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF8574071F8;
	Wed, 17 Jun 2026 12:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781699188; cv=pass; b=PcEREaLlP1/8p6VcFZRMK8snEf0g0LJnjRt9miHpusT9s1CRu8iB8EjOqMnAajhCYli/tWqjXhO+/T8LSYV6kyLZ6upo3qOUKa8LdSrxNM/j3kEEbYjUAP6bnK1ctHx6oSOCICSHEP+TBLC/BgYCQCQ+4jD8yJLEBW1q9dD8BWc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781699188; c=relaxed/simple;
	bh=s/t/3obYASgpKnZE5QF0BBSwV2OFBGibq8mYG+xMHGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BORPITVVR/fmElEY9ojMPRMsQS1MjGLDvjR2u2PAj5C6BqUaAdJLUSTZ0vnaPMlBJQvnj4KJSAPTCL/FOViNUbEpQEo5jB74iEon2e+v4YhL77xhE2dCtEUQ5NlCIYUREnxw7Nb8iXsLs9g6vVL5kPA7DEWcEPwjuP0jhKISSgA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=C2SLnXPB; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="C2SLnXPB"
ARC-Seal: i=1; a=rsa-sha256; t=1781699134; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=VDjUf+q3GdSKuA3Yb7KIeg+K2VSo1GXRWf1an4G14LGogbavI0TGTOsD9j0QgMQtE4XK238amuL8tT1FzJT3g3sUeb0Q0bEwYgZLK9GcjKp/nO3R7/0r1S8g1m/f6HVk4vnzqq7H5ZWap4DTm/nqgWyvdF+PTzgU+0pNecd8miU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1781699134; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=kZE5a6xt/jRyIux8T+qErS1o83ikwPQoZPybeq7hjwo=; 
	b=U63eYboNctKz/QKsSA2HqWHzBEjwP+XbRl5FqZ3cb0w3JJumehdEEhjWtbZ8ixotbnOALH7G95lFqHzXxwxEKO0vjloEwG9JtXf/r/OH5kimZPuxGmed3qSbR/wWjiulzIHDdczKA9aJmgm0Ls3+OL2jvJHYKXgPEk9jB9HRJQ4=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1781699134;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=kZE5a6xt/jRyIux8T+qErS1o83ikwPQoZPybeq7hjwo=;
	b=C2SLnXPBJVxE6Fh4G7s5dGwW49e85ttk7yuxe73CsqzXiwbzWOndaNONFHd0kMGO
	dw0tVyOClawRR8TFc9s9FQertfTIchzm03Oa4WlQKDcBCzBmEtjiPIx0xeLNfEfpsBe
	izKH+uAOQn97R+v1r0NOVilVLFTzuoSdtpD7MneM=
Received: by mx.zohomail.com with SMTPS id 1781699131600843.5815514663028;
	Wed, 17 Jun 2026 05:25:31 -0700 (PDT)
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
Subject: [PATCH v5 8/8] nvdimm: virtio_pmem: drain requests in freeze
Date: Wed, 17 Jun 2026 20:24:40 +0800
Message-ID: <20260617122442.2118957-9-me@linux.beauty>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260617122442.2118957-1-me@linux.beauty>
References: <20260617122442.2118957-1-me@linux.beauty>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

virtio_pmem_freeze() currently deletes virtqueues and resets the device
without waking threads waiting for a virtqueue descriptor or a host
completion.

Mark the request virtqueue broken before reset. This makes new submissions
fail fast and lets -ENOSPC waiters leave the wait list. Reset the device
before draining used and unused request tokens, then delete the virtqueues.
This wakes waiters with -EIO. It also keeps the detach call on a quiesced
device.

Signed-off-by: Li Chen <me@linux.beauty>
---
Changes in v5:
- Reset the device before draining used and unused request tokens.
- Use the split broken-marking and post-reset drain helpers.
v2->v3:
- No change.
v3->v4:
- Rebased onto v7.1-rc7 and renumbered after the flush error patches.

 drivers/nvdimm/virtio_pmem.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/nvdimm/virtio_pmem.c b/drivers/nvdimm/virtio_pmem.c
index 3bcc7b3671d21..9961bc2678d0f 100644
--- a/drivers/nvdimm/virtio_pmem.c
+++ b/drivers/nvdimm/virtio_pmem.c
@@ -158,9 +158,21 @@ static void virtio_pmem_remove(struct virtio_device *vdev)
 
 static int virtio_pmem_freeze(struct virtio_device *vdev)
 {
-	vdev->config->del_vqs(vdev);
+	struct virtio_pmem *vpmem = vdev->priv;
+	unsigned long flags;
+
+	spin_lock_irqsave(&vpmem->pmem_lock, flags);
+	virtio_pmem_mark_broken(vpmem);
+	spin_unlock_irqrestore(&vpmem->pmem_lock, flags);
+
 	virtio_reset_device(vdev);
 
+	spin_lock_irqsave(&vpmem->pmem_lock, flags);
+	virtio_pmem_drain(vpmem);
+	spin_unlock_irqrestore(&vpmem->pmem_lock, flags);
+
+	vdev->config->del_vqs(vdev);
+
 	return 0;
 }
 
-- 
2.52.0

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FEDF1E285A;
	Fri,  4 Oct 2024 18:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728066646; cv=none; b=s9qMi9VG/vCOxHhZCaHoog9QPGKMtIK7Rljpix8juvZGv0tOvCaf+l/K9DBN9FxteeYD+DGlV0Y6onFKIevmDq3iJA6g4qzj+5pQ5HyLPUcNGno2flMuhumgI6iGuLzuBpSwKhxutjV5toHclhmtIURCIP77/xOoUyVH/G8u0ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728066646; c=relaxed/simple;
	bh=23AYrvH6m7KzyPtR5dF5yMTUmucHtURniMfelumR7nQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SGdzjIjvRtoZf1yX/vhW9ceEFy86Cl9ua+/+WwSsj0gsSszf0wEScyzeZQ51PqG0ps4EpthEFDrHcqAZ7/iNjnzxtefhefeSFN4HTdgLtO67JDT9wRcjOsm+Scl0Edu/Dio0M2XfBavcvIdbLT6QHnbXhfWQWweo0nLCQdLrUpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bS28GPgl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bS28GPgl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF55DC4CECC;
	Fri,  4 Oct 2024 18:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728066646;
	bh=23AYrvH6m7KzyPtR5dF5yMTUmucHtURniMfelumR7nQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bS28GPglVciQ5fRM9Qo6WP6JJ1rLikecgxZRNlLZnyD+IiSlOuC/pJoVGnxtjILSH
	 NEPS/zoCZGZFhGh6KzDdwvBbh8kvuVPAHENq6o9Yqvx/F+jAvxUp2rCOFolRpiiopt
	 /tpNqn+VU2LbuEguqqH+fwIz6yajzci0SH7DiWsi0/1KFHfqvQyG5j0bLc8/77hJE1
	 6YRfwrUuFW+JwkfCNekuzW4VjeOEH7LfBBq8o5bADNtWUdLST8Fit/l/zmDYBVLwMY
	 oemMfzWgRynflVFZa7Ui07w5CRyKL/kzeHIt/4ol2y5P9ZZnqk5bqT/LBofVxr9NcN
	 bPAg/RWMZ5+CQ==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Philip Chen <philipchen@chromium.org>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	pankaj.gupta.linux@gmail.com,
	dan.j.williams@intel.com,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	ira.weiny@intel.com,
	virtualization@lists.linux.dev,
	nvdimm@lists.linux.dev
Subject: [PATCH AUTOSEL 5.10 22/26] virtio_pmem: Check device status before requesting flush
Date: Fri,  4 Oct 2024 14:29:48 -0400
Message-ID: <20241004183005.3675332-22-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241004183005.3675332-1-sashal@kernel.org>
References: <20241004183005.3675332-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.10.226
Content-Transfer-Encoding: 8bit

From: Philip Chen <philipchen@chromium.org>

[ Upstream commit e25fbcd97cf52c3c9824d44b5c56c19673c3dd50 ]

If a pmem device is in a bad status, the driver side could wait for
host ack forever in virtio_pmem_flush(), causing the system to hang.

So add a status check in the beginning of virtio_pmem_flush() to return
early if the device is not activated.

Signed-off-by: Philip Chen <philipchen@chromium.org>
Message-Id: <20240826215313.2673566-1-philipchen@chromium.org>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvdimm/nd_virtio.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/nvdimm/nd_virtio.c b/drivers/nvdimm/nd_virtio.c
index 10351d5b49fac..41e97c6567cf9 100644
--- a/drivers/nvdimm/nd_virtio.c
+++ b/drivers/nvdimm/nd_virtio.c
@@ -44,6 +44,15 @@ static int virtio_pmem_flush(struct nd_region *nd_region)
 	unsigned long flags;
 	int err, err1;
 
+	/*
+	 * Don't bother to submit the request to the device if the device is
+	 * not activated.
+	 */
+	if (vdev->config->get_status(vdev) & VIRTIO_CONFIG_S_NEEDS_RESET) {
+		dev_info(&vdev->dev, "virtio pmem device needs a reset\n");
+		return -EIO;
+	}
+
 	might_sleep();
 	req_data = kmalloc(sizeof(*req_data), GFP_KERNEL);
 	if (!req_data)
-- 
2.43.0


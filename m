Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70AE41E8845;
	Fri,  4 Oct 2024 18:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728066025; cv=none; b=NVlh+Z319cQYwUI100QBK4oLrRqq2heAAVbPCYRebPpjFI7Qz6WFI4Ue9BsNN6eUwqqVDBggRFnQvoNb1dFqfUJsP8kZJv0Tfzk0za9nvkr6RGRfN80NMDJ3kbPo/mrp3coshlkLxL4DE751yzNAAPUvBgMldjDB40XXuFBnpmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728066025; c=relaxed/simple;
	bh=31Eu63po/GTps1UbVQw+dXkrvrYK47lQDftGwjhtYQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BAeLV1MM+5jW5H2neztOXjwQ7srT8QUGxbcmyn+0VygT6npy3MB9qSh2J6kp0AsTEMGI3oQ6D63t+E5Dz4g6Ywyxq/znEZTtiTvXQAFm6La0zOb3N0THHrBZvIZJqk78aLV7NvAZFkE90ZaBDBXbjG1P9GMcDwE9a1LSw4YpA/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VN6WageN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VN6WageN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ECCCC4CECE;
	Fri,  4 Oct 2024 18:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728066025;
	bh=31Eu63po/GTps1UbVQw+dXkrvrYK47lQDftGwjhtYQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VN6WageNOMCQ2jKiSrqFm5wL33VkHsdw66u6PWkmw1xrbquxid+UBGLlyZhOPHjhX
	 hcmxzKo40PxCK0uhaVK0MGWu10q4Qh1CheXCsaa3KIxpbhsv5eMNC+KDkKaiRVj0jU
	 Xl93vQnssdWeGgIjXsu5xXDy2vI0YfjaBt0wlB9UEq+/JLk28S7yd0MbCE3m1B9zoW
	 IBHQk2Ono6CmQcBkM1X9tMKE7RuWKBmuvj3GaM91F/c0vujosZx8CJJL3j+3Dj+kdn
	 80+u0eLaW6EU7tkdBYyyJjH4/AjYImnZ/UAGumRtL2ja9QdWtZWR1Cuhe7/6TFlWji
	 362kl4Udk5/fg==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Philip Chen <philipchen@chromium.org>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	dan.j.williams@intel.com,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	ira.weiny@intel.com,
	pankaj.gupta.linux@gmail.com,
	nvdimm@lists.linux.dev,
	virtualization@lists.linux.dev
Subject: [PATCH AUTOSEL 6.11 61/76] virtio_pmem: Check device status before requesting flush
Date: Fri,  4 Oct 2024 14:17:18 -0400
Message-ID: <20241004181828.3669209-61-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241004181828.3669209-1-sashal@kernel.org>
References: <20241004181828.3669209-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.11.2
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
index 35c8fbbba10ed..f55d60922b87d 100644
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


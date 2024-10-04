Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAFA71DBB23;
	Fri,  4 Oct 2024 18:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728066500; cv=none; b=kKNScqrKPb+rjA+IteniWoDSTKp2mI2Z5rzwTW8+E0x6FbKnYCN4NxIqlYTJdwc9YW9kqyaAq6RmWMe30zPLZ4mjuFoFMCt5gUupHDo5Mvo38pspzGl2ZkrXwBIHNHrLo3khhx2KccuF0ha8izf0vPTh1exTK76f4DmC7OOgFTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728066500; c=relaxed/simple;
	bh=RD5DMe3PiYRlg0KCxEYMrN86pwv+rEBf2N8pMKQpjGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xi+A/Zkq1zkAEO8vWzcpha7nkhaGFoNiMQw7rvdWW8xDs7dQL+iDw1bMr0LGGZqirjONohxf9vF6/jHVZzjdqnTD5sCTVOal+dlULw88ps17tSYPkA+/RgRfnfXFLFlfknHYO8skamH6MwmoFOo5jPGzn4v98c+WMzVdEgQCgL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BB/3nuPx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BB/3nuPx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76600C4CED2;
	Fri,  4 Oct 2024 18:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728066499;
	bh=RD5DMe3PiYRlg0KCxEYMrN86pwv+rEBf2N8pMKQpjGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BB/3nuPxEu6wAeWGkifzy+5DD6cOyqsdGK4S26l+q7wJRmfqs1l4ny1OseJVaGTXw
	 xGor14bp0YR/i/pP56SGHdu6ESP0/+tRv1UWdYXN1vQHW9BphepPplqUBFu4zLM7F3
	 vgLapNTjqDwj0oqnOv+E9ZjrEEV8i4tRn5H9P1s6WT6hhEYWHJ1m4lSDWjULefyq6C
	 /gfFY8W+6iaZoYuM7niHlJkqthVygXazzF19vKF9hgOBLQ7QwqpGJPEA/cDXhDBWMJ
	 RwwBu60dW61NfP/jqMOz+uY8G+y57kgCf+9QKfXhW3gdL2Mf8M8WBSqqeANQRqLD3U
	 On+2VMpQkX4Sg==
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
Subject: [PATCH AUTOSEL 6.1 34/42] virtio_pmem: Check device status before requesting flush
Date: Fri,  4 Oct 2024 14:26:45 -0400
Message-ID: <20241004182718.3673735-34-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241004182718.3673735-1-sashal@kernel.org>
References: <20241004182718.3673735-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.112
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
index c6a648fd8744a..a78e17a43a9d2 100644
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


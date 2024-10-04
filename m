Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EB7120A5CF;
	Fri,  4 Oct 2024 18:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728066391; cv=none; b=tQrqeB6M5aAclkvs9SpKEaLVOpzZsfXoH67uhIRLyb8TfFdd9ipj2vVgEjW/Crc4eb0X9rHHn3GVdzoqoiPrTwVrOjTKEVuoTKa5cYeFVOe/5N8Ewodu9o2BkL9Lu3wx/LFvC1qqlCgRLhE9yqEnDrZdKg+w48Uw5X/N2d1lNmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728066391; c=relaxed/simple;
	bh=vcj691Jmoh6A2g6nBW3VlGUIxl9YffykrLG0H3LroeY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xt/YLBCnuSVm6ICWTgvYjo2xHIYFYxdD3hIirJ/dxqUHgfWv7x4jHizoPf1fqkCZDEGhUGLeBJ+4UFT7AXbTwc9EU5tbYjQ/dJANyFVIrT8q2e6qREHgZx67WVOkkEDVv1jKHN1PPSindVTyIliNsY2lYTcnHdDPSI288RaMGEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iXlEsI5+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iXlEsI5+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19E28C4CEC6;
	Fri,  4 Oct 2024 18:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728066391;
	bh=vcj691Jmoh6A2g6nBW3VlGUIxl9YffykrLG0H3LroeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iXlEsI5+trNRWWYtKGv9d0dk8PPk0u0S/CxUSeKzA+w87UZkKWmBdG7AhreyVloKu
	 mKmGTHkabLLfxy3kbYIB7Dm433PEaATd30/Sbd+Vus7sv+FuoeuD+GocVoZGp59TgF
	 PWxGNqgJZWlFYYd0IJ0DFDgXtZBbCgItb9peEEyn0HbzDFPGr2uUShSZrqL0MDRVU7
	 4rLKfO+PNCIOB+Je1Z4Y2OCc/BX7Jxw43kswQHDQeyeddzOrSlFIE2n9sIYt25q7j+
	 UTp2MZTbxI0DtwqxIQnHkvNRUDQCvWSQmz4Afd0ldJUw1Z6J3jUFV1hJt2+oxhr6qo
	 AgIQewxp79VVQ==
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
Subject: [PATCH AUTOSEL 6.6 48/58] virtio_pmem: Check device status before requesting flush
Date: Fri,  4 Oct 2024 14:24:21 -0400
Message-ID: <20241004182503.3672477-48-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241004182503.3672477-1-sashal@kernel.org>
References: <20241004182503.3672477-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.54
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
index 1f8c667c6f1ee..839f10ca56eac 100644
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


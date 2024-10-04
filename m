Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C140722DBC3;
	Fri,  4 Oct 2024 18:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728066697; cv=none; b=uzfeVewwMA7OepvHgH42ZIN2K6RXE/04klYM0BdoPEnViLyZZPdat9jhFjfYtpB6QIRYRo8D8byVLhZ/aHiod9m7B5FYsXz+21u91zNXdqJ1rMxrpOy8nSIZzbRqo5b0077uAw5//IGmSu5WthJ8Z8peH62B+x+PCjLzKNAt9Z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728066697; c=relaxed/simple;
	bh=23AYrvH6m7KzyPtR5dF5yMTUmucHtURniMfelumR7nQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mSc5obpewmEMVqkf2b7H0vunrEpwAA8z7dJ83/NdYW015hVpeitwyuIsZv9uVGDDi7hwMCcaeHE1OaKWDwmuiEgSd6VcvpZSt/KsXX5STb3XWZyIVNvZl8Qk4oISqPJqnTgBP/3mtVl/FSzl6Clx4FxB3ypHZr5Iq6zzLd7lcuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SpTuFQ+Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SpTuFQ+Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55834C4CECC;
	Fri,  4 Oct 2024 18:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728066697;
	bh=23AYrvH6m7KzyPtR5dF5yMTUmucHtURniMfelumR7nQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SpTuFQ+QRX2zS8r4h/9mqeyPytl04Ti1ikMRoz2Dgpal1W2Jwho6Lc5A9jYn8yuiK
	 ogD1Ts5hRsNy2C2fxLgvTK9CwNTTfiyA34MFI2rocbnHz7bPvVNXymzCNGNav7L9VE
	 Ssx5qELE2FO6yHZlihpTWDxbNSeftqN3+7BpAyobs4c9CUYdTL5Nha2pTTOqsh+OiC
	 1+GU1HqVIF6QuCIQVTVt8A4pz2a9aiAHlJhtC0U1DjMMQc/CVnHPtV4mPkhew2+iu7
	 mOTa/1bK6tFSp+F3BYFXq/xY5oag6PRlDkUGqsbPGoK9X+RlogE2SacoHs4KHNbdH6
	 PLh55yknAyJ0g==
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
Subject: [PATCH AUTOSEL 5.4 18/21] virtio_pmem: Check device status before requesting flush
Date: Fri,  4 Oct 2024 14:30:53 -0400
Message-ID: <20241004183105.3675901-18-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241004183105.3675901-1-sashal@kernel.org>
References: <20241004183105.3675901-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.4.284
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


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BAC51FAC33;
	Fri,  4 Oct 2024 18:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728066227; cv=none; b=IGb1uXmfsyFRQliiNbtBiNemOk7w5JY+f98dTPvTS30rQk5h9OV3kidv1w+vehVH5TzxZsfjBFqET2mKyo40tyn6Mw+6RYcJCYsmJig4HLHq/jctz2WnSw4kIU47yxMEvi3ePybIwc6Pa5KI+kFdYd2SsnxQIx/y6Sn4itqIySk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728066227; c=relaxed/simple;
	bh=vcj691Jmoh6A2g6nBW3VlGUIxl9YffykrLG0H3LroeY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TXv3m3QzbUc1cwSKF1uPBU7Ur82mKEsB6BRTYpTA2OAiXNlqevHLZhcv02Pqwp8zeCSPQDoXCiBcChnfEh8Lp+E7og25X/9OZX/rbmw2r3Mcl2a+a2POf/5UZgkOyJKiKGa+xqMzFjA5CC9lupm2kruMoaCoIAk6877fkmG1778=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k7nFPMGV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k7nFPMGV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FEFDC4CED5;
	Fri,  4 Oct 2024 18:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728066227;
	bh=vcj691Jmoh6A2g6nBW3VlGUIxl9YffykrLG0H3LroeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k7nFPMGVElvU+TsqOFB4idk5h99wTrfwVpdq3zK2SS3e8jQz6oxxWm9YWO9SlYyl9
	 iQWluQaM1xXo3FNICrW96N8Xxu4apGkzz1qWIhhPZ2Z/pBdxBAHoN8WV6MAGCUvNMu
	 uJ92EvTZW5tbPM4rANuY8VEKKyOoEyCv/dwwgtLFX3i5niPJO31CNSH2qt1IDUUetU
	 wC0cVByKagYn0ThAfBUwDQGgJRdpuzfmKxzK9gIYp8BnDQ/69c/UhKl9h+u73a3/rc
	 A4ppc1Kd8TJPBhYUN8h1I81kNEbTVqUTUQ+E4OSk3QqVaYeH1cd+aWMm8relYQrb1q
	 h/rS4QBfxkXnw==
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
Subject: [PATCH AUTOSEL 6.10 55/70] virtio_pmem: Check device status before requesting flush
Date: Fri,  4 Oct 2024 14:20:53 -0400
Message-ID: <20241004182200.3670903-55-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241004182200.3670903-1-sashal@kernel.org>
References: <20241004182200.3670903-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.10.13
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


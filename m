Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27AE22777E3;
	Mon,  5 May 2025 22:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746484864; cv=none; b=JCujk+YJ1TnpVuHSxhNGEEay13d8xLH2laPXrGDcBZ0q+xs+v32vCHblXyG1KSPLQIobXh12dvFbEHbMaPiF8JbMr02H8CtHStzxfh63l7Q8H43TUMjk6Frr6idks3BPMsBdTFXlKXvsNTlgr9gl7vKJfkSdmo3ET5W+AK70ILY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746484864; c=relaxed/simple;
	bh=rRPQrr8rQ2U57aU/QceYFLpT/KG7abauUVPWd1WRWmc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iRHgoVcOD8HCbeClIF9cpMDNMyEHKk5dZjsmg/x/PqOM0akFsMWD1klVO9cC+HFg3H5pQ/iBzPgyng0rajz864D/5BoVVTlVnGRR80y8C2SH6AJDh7ZrjixraHkEqFz6Z0fEnZnHT73SOeOQn6ywyQjKmcHPf02HGDQ9f2P8it4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d4OwzBgj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d4OwzBgj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C55AC4CEEE;
	Mon,  5 May 2025 22:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746484863;
	bh=rRPQrr8rQ2U57aU/QceYFLpT/KG7abauUVPWd1WRWmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d4OwzBgjJVLD7d4Rw4yaVDN1w5um9U8fKpunl/y1g4vcI1uOAvg0v3/zUEC+9Dcoz
	 OVuqqm67vg5Fu++PnGT28uAZMRp81I3Uj8RoKo2rdpZlsSUnYX871myrorY7uwDU9W
	 U4absj31b35Pw4VI5dMu6PJaBk7qZIovwP9Z1BwxnZIbzWMwffabY5Z8icfyDmi2sr
	 qAcXsgv05wL++HZctMO1cgNuVdCG68gDv03sWeQ1xuD7OwtKjUtcKYf2kD6DEWW5Tc
	 3oSOe8mxn+okeeM87x3ITG2uFXgtBKkHxsfmqXRNc1V/q/1WhECbQqUhmnC1v8FD/o
	 sa5yEUsJwE/uw==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Robert Richter <rrichter@amd.com>,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	dan.j.williams@intel.com,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	nvdimm@lists.linux.dev
Subject: [PATCH AUTOSEL 6.12 054/486] libnvdimm/labels: Fix divide error in nd_label_data_init()
Date: Mon,  5 May 2025 18:32:10 -0400
Message-Id: <20250505223922.2682012-54-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250505223922.2682012-1-sashal@kernel.org>
References: <20250505223922.2682012-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.26
Content-Transfer-Encoding: 8bit

From: Robert Richter <rrichter@amd.com>

[ Upstream commit ef1d3455bbc1922f94a91ed58d3d7db440652959 ]

If a faulty CXL memory device returns a broken zero LSA size in its
memory device information (Identify Memory Device (Opcode 4000h), CXL
spec. 3.1, 8.2.9.9.1.1), a divide error occurs in the libnvdimm
driver:

 Oops: divide error: 0000 [#1] PREEMPT SMP NOPTI
 RIP: 0010:nd_label_data_init+0x10e/0x800 [libnvdimm]

Code and flow:

1) CXL Command 4000h returns LSA size = 0
2) config_size is assigned to zero LSA size (CXL pmem driver):

drivers/cxl/pmem.c:             .config_size = mds->lsa_size,

3) max_xfer is set to zero (nvdimm driver):

drivers/nvdimm/label.c: max_xfer = min_t(size_t, ndd->nsarea.max_xfer, config_size);

4) A subsequent DIV_ROUND_UP() causes a division by zero:

drivers/nvdimm/label.c: /* Make our initial read size a multiple of max_xfer size */
drivers/nvdimm/label.c: read_size = min(DIV_ROUND_UP(read_size, max_xfer) * max_xfer,
drivers/nvdimm/label.c-                 config_size);

Fix this by checking the config size parameter by extending an
existing check.

Signed-off-by: Robert Richter <rrichter@amd.com>
Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Link: https://patch.msgid.link/20250320112223.608320-1-rrichter@amd.com
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvdimm/label.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
index 082253a3a9560..04f4a049599a1 100644
--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -442,7 +442,8 @@ int nd_label_data_init(struct nvdimm_drvdata *ndd)
 	if (ndd->data)
 		return 0;
 
-	if (ndd->nsarea.status || ndd->nsarea.max_xfer == 0) {
+	if (ndd->nsarea.status || ndd->nsarea.max_xfer == 0 ||
+	    ndd->nsarea.config_size == 0) {
 		dev_dbg(ndd->dev, "failed to init config data area: (%u:%u)\n",
 			ndd->nsarea.max_xfer, ndd->nsarea.config_size);
 		return -ENXIO;
-- 
2.39.5


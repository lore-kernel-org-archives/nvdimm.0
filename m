Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3BE8376893;
	Mon,  5 May 2025 23:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746486442; cv=none; b=KUGujpun8MyJFH9m/TiUGDW2euDj76IGMr1fqzI2C20mTsT+lRVbzFBxIDoZq1bb1HEyU39yH5f41VezfmUFsBtOhUKamDrYnM3Hx3UMgkjp2nGJIR2WZJmRGTXIRRomCatZ5Rc/keSrM65k5VvI3YwCAoNVjWCK7cmDXUi+bb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746486442; c=relaxed/simple;
	bh=rRPQrr8rQ2U57aU/QceYFLpT/KG7abauUVPWd1WRWmc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kBBNjCe5oSZjZV+h+28TYaBigKi/mNjJNmr604LryH2DT2x+C1fX7EYysb3ZqxdYJSt2cPT7TXezH2xFhyYJOiHA2qJ+o7Dycbzt7cQgb2NBRJdZDOhZXU5tpU9VqDf6pujhzqtReLY2hiAxHQpVj3AxAx50FWSvCYT/Iw8SIP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CS7tPBY/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CS7tPBY/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2413FC4CEF1;
	Mon,  5 May 2025 23:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746486441;
	bh=rRPQrr8rQ2U57aU/QceYFLpT/KG7abauUVPWd1WRWmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CS7tPBY/A3cQ47nhxPtoPrsPyOw30LhIBKn3/DY//3m5/nkmDqWij86ZFOE8I9+U3
	 xmra9uzRPsW2adwaHKBUbwcTLV3jjr7BkxW+3inmtP2a42qDQqQ1tpsWzcTKZzNRE3
	 gbH0hLjBIgU2x1fV5evlxbGoBGEkVRFhIC0r777jx5w0u8ncg9tVB31w6s0Q9GvnnE
	 xHWgoDEkjlCIn/5eT5rqTpD093PKNO4Xmb/iuxxnaTFSYGwQGvdMOozf3ykIumczHl
	 c58XMRtp/+0fO7eGAjW3+FfW+nhC6ZiiV8rUUL4En5pb6/aXLXMrSF7cS8d+D46SrW
	 U36Sfx2MZvitQ==
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
Subject: [PATCH AUTOSEL 6.1 029/212] libnvdimm/labels: Fix divide error in nd_label_data_init()
Date: Mon,  5 May 2025 19:03:21 -0400
Message-Id: <20250505230624.2692522-29-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250505230624.2692522-1-sashal@kernel.org>
References: <20250505230624.2692522-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.136
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


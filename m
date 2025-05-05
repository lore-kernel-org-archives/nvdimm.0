Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82E5E37F952;
	Mon,  5 May 2025 23:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746487334; cv=none; b=kVi77aXvN3F5L26FaF/2kGwi3cnVowptGx2fBjRbX5gYUbfVhjwa8AMgL1LADKAss55bLl90RaK74cxyqsHRqe5eP0SGpCfcn87ds2It+hdreL0dFhdumelyXB0lUUfS0JCOyT91ABpQ8q0xRQ3AtXIM6le52okNwuGWw7ex4cQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746487334; c=relaxed/simple;
	bh=qyEFOo3dGJ8zBBN3Gmf+P6PpGQtWOSG8F0FiNzvT9Ig=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bOLWzqkAla4ZVbsA1P5H1kEZV/lyBxfWiOnIEzlxGID5XBRibtfSiXrhD44HEvsj5kP4hO2aWu2mN2wR1uSt2mlNCnWWvV8mM8fEVAN7vytdQiM6rpxqJkpkPjLRKvAQHJA1aS9SmT1j9VbVLO0DW0auXkECc2/ZXK20Uu8gNRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vRlJ3vRN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vRlJ3vRN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1E53C4CEF1;
	Mon,  5 May 2025 23:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746487333;
	bh=qyEFOo3dGJ8zBBN3Gmf+P6PpGQtWOSG8F0FiNzvT9Ig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vRlJ3vRN8TAJI0RGipAkfbj2zottvcsSOM3O6SHW6J9TRaIw07Lk4byPg69BQ81OB
	 utAreMIaKVLLlAIRswn0IAyNajyGQ0Psz68KEZkUtNKD+RClQJMQipjq245tuhnEf9
	 96Rm1oo3WBsUOJdGAmg0907qXVGF1HR88o6XnAXbZz/3neD8qyetPXtIWdjcea5/Nj
	 J/U/7Xm/DSCVStsIBvTQiKPKQOJX2oCBWu7FNOuS/MSLl1Rzzw5d6FYr1fj9OGFbd/
	 7BBjWua3szPS6vMp9OmnVcbBmz9/2IPm5PesJQ8JD5uqd0curHrt2swgjv7uXH+DFT
	 /LCB4FXrsJ+jQ==
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
Subject: [PATCH AUTOSEL 5.4 11/79] libnvdimm/labels: Fix divide error in nd_label_data_init()
Date: Mon,  5 May 2025 19:20:43 -0400
Message-Id: <20250505232151.2698893-11-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250505232151.2698893-1-sashal@kernel.org>
References: <20250505232151.2698893-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.4.293
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
index 9251441fd8a35..5251058adc4d1 100644
--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -421,7 +421,8 @@ int nd_label_data_init(struct nvdimm_drvdata *ndd)
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


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA337183CB8;
	Wed, 31 Jul 2024 19:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722453267; cv=none; b=vGWWI3xg9VArWs1/m3o3YTqiAkHiQ0t1dr8eyjfA7TnAr5S2sQBS63lahtgJCs/L4uUf682eqHewP8zIgTppCu6Ug8ECjM9oIGCOPtH474RociMeHiZf16190CDB0JRW+ix0gG5s2/5YKzPn8V5uDTAMDeZSfpxRj2R4N6WP2c8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722453267; c=relaxed/simple;
	bh=MULSNYeZeSPrl1VTRH84C1j8hdrGU7G7dLkCXe5sadw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HOL/8MLXgJGhoOV5kUJrad1Nuxp4u8BrSQMPUpijKYzxdhyjJfWFO2FVEsAwanSkT9Sjxpcm5ICYaJ78rRkpjLN9jalYd7J8QaruEM43XrFZkCJd6K5SC9BBznqMzDbzN3YCA4C4UnhBhqTP34wmPF3c3J/G6cscec74I0O4e5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L4DglsAp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L4DglsAp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F91CC116B1;
	Wed, 31 Jul 2024 19:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722453266;
	bh=MULSNYeZeSPrl1VTRH84C1j8hdrGU7G7dLkCXe5sadw=;
	h=From:To:Cc:Subject:Date:From;
	b=L4DglsApNHqnJbYdmle/VboL3eAuc/cGZtznSEUUR4PXU/31dn9uf/Las/Es0fzdt
	 FwjIlabd7BoF1VbE/M87/fDpFmiUXjrfUwG2onm3oeV0fHSUL7TyBvkW7FMYgIoBVO
	 X4P69LDvfguzIxrDlAtbPvjv4rE0A6cz0aDtWxUVWkGK2gqwxq8aqjGRWIoN+W40tq
	 d7JT/ZgHCe9PN/ccdIretDFgmf+ieNt6QpkzEv9DVhDENkYB432XzjCKZchXXNLcDl
	 Y86cYW0FKiXuJ4ehXoCiSLCRgDNYR41SoiibVHl+HosNAl+9/7KhW3ABbRNcFtZv7q
	 aGNj/91wIcjVQ==
From: "Rob Herring (Arm)" <robh@kernel.org>
To: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	"Oliver O'Halloran" <oohall@gmail.com>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH] nvdimm: Use of_property_present() and of_property_read_bool()
Date: Wed, 31 Jul 2024 13:13:04 -0600
Message-ID: <20240731191312.1710417-26-robh@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use of_property_present() and of_property_read_bool() to test
property presence and read boolean properties rather than
of_(find|get)_property(). This is part of a larger effort to remove
callers of of_find_property() and similar functions.
of_(find|get)_property() leak the DT struct property and data pointers
which is a problem for dynamically allocated nodes which may be freed.

Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
---
 drivers/nvdimm/of_pmem.c | 2 +-
 drivers/nvmem/layouts.c  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nvdimm/of_pmem.c b/drivers/nvdimm/of_pmem.c
index 403384f25ce3..b4a1cf70e8b7 100644
--- a/drivers/nvdimm/of_pmem.c
+++ b/drivers/nvdimm/of_pmem.c
@@ -47,7 +47,7 @@ static int of_pmem_region_probe(struct platform_device *pdev)
 	}
 	platform_set_drvdata(pdev, priv);
 
-	is_volatile = !!of_find_property(np, "volatile", NULL);
+	is_volatile = of_property_read_bool(np, "volatile");
 	dev_dbg(&pdev->dev, "Registering %s regions from %pOF\n",
 			is_volatile ? "volatile" : "non-volatile",  np);
 
diff --git a/drivers/nvmem/layouts.c b/drivers/nvmem/layouts.c
index 77a4119efea8..65d39e19f6ec 100644
--- a/drivers/nvmem/layouts.c
+++ b/drivers/nvmem/layouts.c
@@ -123,7 +123,7 @@ static int nvmem_layout_bus_populate(struct nvmem_device *nvmem,
 	int ret;
 
 	/* Make sure it has a compatible property */
-	if (!of_get_property(layout_dn, "compatible", NULL)) {
+	if (!of_property_present(layout_dn, "compatible")) {
 		pr_debug("%s() - skipping %pOF, no compatible prop\n",
 			 __func__, layout_dn);
 		return 0;
-- 
2.43.0


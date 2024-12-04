Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF57E226EF8;
	Wed,  4 Dec 2024 17:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733331793; cv=none; b=mUrr0hU7Iuu8g9rfP6KbHEkFaXTmG1LjFVHi4PYRy4s8qEO4ZKKhn+1CiqAqxPtXakxocmJgahte2IV0jAKVjP6i+ZVmFSkA/k3wwm2BpM6m9jH4roxv6Y3K+YWRQfvN+PPOZlwmjmZRoXHGzDipd/QJZmKjS2VtP8T0rvYDy9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733331793; c=relaxed/simple;
	bh=NXYdDcp1FvVvZENdn/zaug2HlbdJ/XeYcO2X48v8+5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uMSEzUlmPrFcpoucRvC+LAr3bCayORwtbZUsAoiM0bpKCZDUnUaajDGwVulhWxoYgPlEMOcwjgxTFPqP+aNwuULP++U5wkI5EqeCZnd3vBAzmdK7Uz0bjqahnJi2CkIjPzlq+zsmfFbqSEqXafm2h3mMQ49/LhjldhXuCrktAbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Blc7xnHI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Blc7xnHI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5794C4CED1;
	Wed,  4 Dec 2024 17:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733331792;
	bh=NXYdDcp1FvVvZENdn/zaug2HlbdJ/XeYcO2X48v8+5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Blc7xnHIJ8rzxRvkHg4EC2Q3uEBw/gVgXwr9NRiUfxB9OIS3d28sN2zSLTFJ8+6oy
	 FUpTYMGxOQ3ryvO3BRZqfea8x5K3Ke51J0b4HjBDuPlrs8W1ksAf0PQvmYvY1Zczm/
	 nmRGA44owAn7cL6RSSbyKiJfgTBv1nXd5glidXxnU1J9jz7NnbyM9cGjZ/+e7/Cj1i
	 tQ7r3EqQvay4WG49/xV3WNI26QJmBOSuwF4OCfn6uhEBE6rx3DjMjDSmWSvuhHGO2a
	 aFIbNhEeD8Ngxz/J/xrLvsdtSCRV78czY4nyIXeV5IE+PE1vSozYV0or3bqkaHW27a
	 0EoAQVkl01ThQ==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Yi Yang <yiyang13@huawei.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	dan.j.williams@intel.com,
	vishal.l.verma@intel.com,
	nvdimm@lists.linux.dev
Subject: [PATCH AUTOSEL 5.15 9/9] nvdimm: rectify the illogical code within nd_dax_probe()
Date: Wed,  4 Dec 2024 10:51:39 -0500
Message-ID: <20241204155141.2214748-9-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241204155141.2214748-1-sashal@kernel.org>
References: <20241204155141.2214748-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.15.173
Content-Transfer-Encoding: 8bit

From: Yi Yang <yiyang13@huawei.com>

[ Upstream commit b61352101470f8b68c98af674e187cfaa7c43504 ]

When nd_dax is NULL, nd_pfn is consequently NULL as well. Nevertheless,
it is inadvisable to perform pointer arithmetic or address-taking on a
NULL pointer.
Introduce the nd_dax_devinit() function to enhance the code's logic and
improve its readability.

Signed-off-by: Yi Yang <yiyang13@huawei.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Link: https://patch.msgid.link/20241108085526.527957-1-yiyang13@huawei.com
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvdimm/dax_devs.c | 4 ++--
 drivers/nvdimm/nd.h       | 7 +++++++
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/nvdimm/dax_devs.c b/drivers/nvdimm/dax_devs.c
index 99965077bac4f..e7b8211c19cc6 100644
--- a/drivers/nvdimm/dax_devs.c
+++ b/drivers/nvdimm/dax_devs.c
@@ -106,12 +106,12 @@ int nd_dax_probe(struct device *dev, struct nd_namespace_common *ndns)
 
 	nvdimm_bus_lock(&ndns->dev);
 	nd_dax = nd_dax_alloc(nd_region);
-	nd_pfn = &nd_dax->nd_pfn;
-	dax_dev = nd_pfn_devinit(nd_pfn, ndns);
+	dax_dev = nd_dax_devinit(nd_dax, ndns);
 	nvdimm_bus_unlock(&ndns->dev);
 	if (!dax_dev)
 		return -ENOMEM;
 	pfn_sb = devm_kmalloc(dev, sizeof(*pfn_sb), GFP_KERNEL);
+	nd_pfn = &nd_dax->nd_pfn;
 	nd_pfn->pfn_sb = pfn_sb;
 	rc = nd_pfn_validate(nd_pfn, DAX_SIG);
 	dev_dbg(dev, "dax: %s\n", rc == 0 ? dev_name(dax_dev) : "<none>");
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index 5467ebbb4a6b0..55ae9fa9db5bf 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -485,6 +485,13 @@ struct nd_dax *to_nd_dax(struct device *dev);
 int nd_dax_probe(struct device *dev, struct nd_namespace_common *ndns);
 bool is_nd_dax(struct device *dev);
 struct device *nd_dax_create(struct nd_region *nd_region);
+static inline struct device *nd_dax_devinit(struct nd_dax *nd_dax,
+					    struct nd_namespace_common *ndns)
+{
+	if (!nd_dax)
+		return NULL;
+	return nd_pfn_devinit(&nd_dax->nd_pfn, ndns);
+}
 #else
 static inline int nd_dax_probe(struct device *dev,
 		struct nd_namespace_common *ndns)
-- 
2.43.0


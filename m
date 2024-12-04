Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8FC32251A5;
	Wed,  4 Dec 2024 17:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733331772; cv=none; b=LG4U9hWMqj3OkAxK+GGrUOwal8TSWlDfAEcpzachVTdjUuKI7biC4ROfJcGbzowhqa0vTZf3tQ6UI2FuvSWoMvHXF657ot5zcOY/LzNfTiD3GRbfnz7TNTcYDsmInikF/PRwLs3VNzzqrek9mE4dWDGIGMuprG25uAk7FLC4M50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733331772; c=relaxed/simple;
	bh=hoC2IAlLqigAA95Cs3g+AHNIiXkD9e7oBgoQhGSXLSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M/qCsRzGRSRFUwd1yD1/2NUgdozyVgckZYeIKTV0Y8S/ld5odGxVCRmlyuG0VEIFEtnjm3C5WvWI/fySv5vq7d40uu1m3k+lbM5UUnHfH+t3DAcPiEDAJOL2XP9mVzXivcxgnXRkGGSSoI7rTCBDn0TaC3W3ZYLJV/NY3MvVfR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iEv0NWwn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iEv0NWwn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4795DC4CED1;
	Wed,  4 Dec 2024 17:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733331772;
	bh=hoC2IAlLqigAA95Cs3g+AHNIiXkD9e7oBgoQhGSXLSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iEv0NWwnSyfA8z0cklxvP82r2Uu7N6O4er5WVy9DJc5AeThlhmDG3rqZqYEyx8vUb
	 R0fqyeB17/CJDbDa20XnRa44FZqg/pGiGR+/7dGVtRWT/zTVKi9oa2aZAjGbM3ajAK
	 lkqSouNY7z+MDdgAiSzHGRuo8nV7K5RGVq8EHPKOK4Q197imOYouUOlDjMyIzrnj4h
	 qOA5POTmNuhDkkE+P8XJiFktRjH6dj5L8KcSTWLreFkixK4E1OxtzaR7CHCFBSqM2h
	 Lwu903fgsUgu0p8rXEsbtMm+O9fKAKfUffIGI0kCGXKrVwtH+Ni80lI4KQtz0fiTX+
	 g85/5sfANO0YQ==
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
Subject: [PATCH AUTOSEL 6.1 13/15] nvdimm: rectify the illogical code within nd_dax_probe()
Date: Wed,  4 Dec 2024 10:50:52 -0500
Message-ID: <20241204155105.2214350-13-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241204155105.2214350-1-sashal@kernel.org>
References: <20241204155105.2214350-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.119
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
index 7f4a9d28b6702..5cafca6ba1da3 100644
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
index ec5219680092d..cce728f5409d6 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -601,6 +601,13 @@ struct nd_dax *to_nd_dax(struct device *dev);
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


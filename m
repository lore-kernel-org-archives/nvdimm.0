Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CA33231CA8;
	Wed,  4 Dec 2024 16:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733331530; cv=none; b=ju7jEl2WG2bauxX4IrNYms6WxSUL9OJOF0f82s/XwebRHe1LGx4aI/wa8QAk1X0u9ik166va7ntC4tjaDSuMD8ISO+n0HML/AxxNY9evuuxyWeq01hw7LjYGytkL4AI3bZA+rMqdKXWyRGm79sO3GG3n8lOjjLquqOJrog7aoqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733331530; c=relaxed/simple;
	bh=Z7dcg172ZmLMndDiaZ86nq9I4fvX84bySeNXPXbXVGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IouSsMg8At8xt9QXIdA71KDLIKED8e6LT52uSV2P3y+P29FtkAHrQJOEs+x9736RdXulEOesWNpSnzlHhodeWl+ZCaeRpzeZC8Of/EKk7pHTfTumWbFgIpIx8H4+C06m59urVZj6iH2m8O1LEcz5NLeB3LIYlzYWcPh3m961BKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r6m7CSas; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r6m7CSas"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D97CC4CECD;
	Wed,  4 Dec 2024 16:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733331530;
	bh=Z7dcg172ZmLMndDiaZ86nq9I4fvX84bySeNXPXbXVGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r6m7CSasM4Cn09IhpoJB2RGhHS/dk+qpBr+hf78P50jquSOGJW0rrLx9t/0MpLQCI
	 keXJYSxIZrnOFif4AEuDjg1wN8Al32Jm6jT0QvhIShyQ2gY8e0EFWM2nzsJAo/iZOQ
	 SnMSFeBBFk/QCfsMcAeE9HtH52Bp+oWu2TBUQN8QH9W9L70ToHENIlpZxHUcgoFcyW
	 fGgcR3lNBd11rtOYPn4rbd0dzdFow+rQEuXAK4pgaOgx0ZR+NgjgdsZP/VplZbmpwd
	 hXVOmLqW1jYVNiyQ5xixYrN7HoHcZER9Ws3tFQ3VvQhaX4FT7uV2sPqLUtw81sw+5g
	 9Rps7Z0AbOUKg==
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
Subject: [PATCH AUTOSEL 6.12 31/36] nvdimm: rectify the illogical code within nd_dax_probe()
Date: Wed,  4 Dec 2024 10:45:47 -0500
Message-ID: <20241204154626.2211476-31-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241204154626.2211476-1-sashal@kernel.org>
References: <20241204154626.2211476-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.1
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
index 6b4922de30477..37b743acbb7ba 100644
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
index 2dbb1dca17b53..5ca06e9a2d292 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -600,6 +600,13 @@ struct nd_dax *to_nd_dax(struct device *dev);
 int nd_dax_probe(struct device *dev, struct nd_namespace_common *ndns);
 bool is_nd_dax(const struct device *dev);
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


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0916D218DC6;
	Wed,  4 Dec 2024 17:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733331823; cv=none; b=RvAuLPZXd/1JwYXuz09LkASzbG3kY18tsp22ncAOlR0tqcM5Ul0+42vzHY+aL8pUZuvg+jao4fcsPnUbGVqV4FHk4XP7Y1xrM3NkleiYaifrjGt9gqOzIP/sYQjutCcy8K53LQHm0iDlDzLd6Zjo8Po1TH1+U64aDNsQziNlJR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733331823; c=relaxed/simple;
	bh=yuHaRE1iv1c9h/Pp45HxXM5iJTa3nhKlWYuQeRowhbg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ufHQuEkOVPR5+G/UwHizKorciv20EBYscTp+299WUG3wZhghf6w3siGYwQ/VhzlLeIjG6WR/5NhwcJaQ7SSmKISthjxxhfOKeRNtCq/j9Y5Co4bITVuIYqHoQEs6Z5/3hyhfTo46tF3CXbQv0GmZrK8cUiR3hFnqu7BzFAKEagM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zd7ZiwgC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zd7ZiwgC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 658E0C4CED1;
	Wed,  4 Dec 2024 17:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733331822;
	bh=yuHaRE1iv1c9h/Pp45HxXM5iJTa3nhKlWYuQeRowhbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zd7ZiwgCyS53dMy10iRYLq7QZeg1v/l8go2/Bdjyq6Umqcy4VqnjVARNHnRDsdJIn
	 tuVKsKlYXRrTkxzT3jwiy9Eu4SMXlka72V3TZi8AqdzpiaASujkSDOGpleqfkgbK1O
	 1aZ/3Dz/wMkhZhUc/8qJCWiT0B8kWK+C75Aaw07cMn4ViKrUeRntVk6GG4Qtj3V9He
	 QJAO8KUrbH4F5B/eVSXashe+bO7TBMrhin6yChzEWYdUBwO3ZYooK8JAyB0c4Ha89Z
	 I5VnS6Xs0xMeLKeSdm+b/jhj5BVOXJXfhdJzZ4+DE+dEbFQq2bPOEoTjZdXfgkRY05
	 rDm4UltEexjog==
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
Subject: [PATCH AUTOSEL 5.4 7/7] nvdimm: rectify the illogical code within nd_dax_probe()
Date: Wed,  4 Dec 2024 10:52:12 -0500
Message-ID: <20241204155213.2215170-7-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241204155213.2215170-1-sashal@kernel.org>
References: <20241204155213.2215170-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.4.286
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
index 6d22b0f83b3b0..c882534dbe84c 100644
--- a/drivers/nvdimm/dax_devs.c
+++ b/drivers/nvdimm/dax_devs.c
@@ -113,12 +113,12 @@ int nd_dax_probe(struct device *dev, struct nd_namespace_common *ndns)
 
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
index ee5c04070ef91..23d011b01fa61 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -326,6 +326,13 @@ struct nd_dax *to_nd_dax(struct device *dev);
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


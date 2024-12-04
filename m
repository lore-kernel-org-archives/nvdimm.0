Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FC6A22144B;
	Wed,  4 Dec 2024 17:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733331728; cv=none; b=If6cHAdCnZ6A7rqcU6TLWI7sg3pZHTq8FpUdU4/h+2ynpPXkVf9MhKthOghRtclHkAxHaXt7i6iaRGgRBGphCHOx6hK/fksBmKhUijrFzdqmpfKDGw0qh78rAwQQZj1HRKKcCbHTl3fl7gX6P4MZKDlVPvJ2gm9YRiNdgl6lRLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733331728; c=relaxed/simple;
	bh=F8g1ZzkAE7Z4xwtf1thmKFemuZCBnownLe2zR6PC4iU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gA+yTUXnjJmxmHVE9IJ6Hk5BSxB4Km18p/byd44n2KbnsME+4ThoJXeGSxp5/9qq4v2RsswthGl79DUIuGXS0vzqQQZNkgj1ZBBCVmA0PuRRQcvdMtLIieqUxgCvb0qP/u2di70rRDeSfXYBF0Pwuy7BdpW9jJfU592Z0urDA+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZX1O2Eib; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZX1O2Eib"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3599AC4CECD;
	Wed,  4 Dec 2024 17:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733331728;
	bh=F8g1ZzkAE7Z4xwtf1thmKFemuZCBnownLe2zR6PC4iU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZX1O2EibLGjzR4ZL34tEtZcZzaVJxuZ6lGd1GwtQQY23NkByKpYPraD5F3cptqJE5
	 r7IPbGHS7T/GzGyhcsgtE9/JK3/PjtA+i96ah++i3fk2kCAjJ8qPV8AJ+4pyssyzOE
	 l5N4MgPCbxm1lsaRMoXZClJfIgHyJ7s5nih4Lpn+aPRgkUzeVBsOVQyMl02jFYN/8Z
	 RfDKct2Sp45oYWRStkRH/7wckcgvJRivcyFxIrLNZLz8qZw0OSC9dVMW9GxNxhm1C4
	 YGmgzAN3wBba3FIDJVD7WIzhNaZdkBZv0ruRP0cVz78666M1EzoF1F4TWyznd5yuFy
	 j7X+4JfORV/8A==
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
Subject: [PATCH AUTOSEL 6.6 22/24] nvdimm: rectify the illogical code within nd_dax_probe()
Date: Wed,  4 Dec 2024 10:49:42 -0500
Message-ID: <20241204155003.2213733-22-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241204155003.2213733-1-sashal@kernel.org>
References: <20241204155003.2213733-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.63
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
index 3bd61f2457885..cfafe1fa77bab 100644
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
index e8b9d27dbb3c3..12774334273c1 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -601,6 +601,13 @@ struct nd_dax *to_nd_dax(struct device *dev);
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


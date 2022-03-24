Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FA3E1B60
	for <nvdimm@lists.linux.dev>; Thu, 24 Mar 2022 07:30:03 +0000 (UTC)
Received: by mail-ej1-f42.google.com with SMTP id j15so7315299eje.9
        for <nvdimm@lists.linux.dev>; Thu, 24 Mar 2022 00:30:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=41pszt+PybnYgUfx9vODac1IhLaztrq7kY7kXvf9mWE=;
        b=W75d1bj3/HxEocX67AESJvny7BilgO6/7lbivPiE3r4fOBeapIiA75UE/w4WB2mj5S
         rV4FrD2YP1BuVYTq5QIsCmFhcdwSQJpFIjv7aV1akR0ZF/U1krZMcKAr5LIQ6XAMPM1w
         35SUvw17LHJvsy4eJtBTsKu2nqf3HlTN+lIePzCOovyk2sTlcFSQ4TY3BVPV+vbZT8Dq
         EKTP4dcw/q1zUg6OhJaA4WAZ3K8dd4zGKcxf/slB0oiPhPx9qmRKkDNufV1LEJbMf0Vk
         moAnOYySm5bSqtv0NQQ39Yb5TqBR0rGOodNmG+U99BXGHOv8oie3O5rvCKYGcYLjSByn
         O/Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=41pszt+PybnYgUfx9vODac1IhLaztrq7kY7kXvf9mWE=;
        b=0eUZRMM/Kn+8YXBZxPxn0WxXFVUj47NCuXJxlDKNT7qClOr7qJjsUvYUuipvYkvjBU
         GGXSwJRmiepWtCeRe+OOH0ISMTZttF0dF29dxbw+7YhP3Xa1knBdOifwVj0yPeSX4q9q
         3i8IvMGvAd/po48hczAl4ORC/l6QVOxJ8iO5DXfA92I3mmcOqHfGZx7lCjn+d3jtlXj8
         hqAwmJ7vyLxG9k4A0ZrdbsORaBO4+4jfQ81yte7VFWRNk/XcGC25QlrNjful1nQJKqAD
         BKhALYO3LrSvQE5hgC/6w5M6nIyiBDqrn+gd//UyTctgctQyk0eBgZwEGzyV581H9c5r
         PTSw==
X-Gm-Message-State: AOAM532Xa1ZLLiCYTZk9rn9rVnhnvFYy1aWWDJzA3fUy0cpBcC9UDAzq
	GqmACWIlrNFfs/UtL2v1IXs=
X-Google-Smtp-Source: ABdhPJypvh4h6q3BYO/WNfs15tnV/nCxMBcLKYfEtbu2nrSmu2Bj2OEgrzj3UAcqRGrX+RJ6G4I3+A==
X-Received: by 2002:a17:906:2a50:b0:6da:ed06:b029 with SMTP id k16-20020a1709062a5000b006daed06b029mr4301820eje.506.1648107002288;
        Thu, 24 Mar 2022 00:30:02 -0700 (PDT)
Received: from localhost.localdomain (i130160.upc-i.chello.nl. [62.195.130.160])
        by smtp.googlemail.com with ESMTPSA id q9-20020a17090609a900b006cd30a3c4f0sm787085eje.147.2022.03.24.00.30.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Mar 2022 00:30:01 -0700 (PDT)
From: Jakob Koschel <jakobkoschel@gmail.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Len Brown <lenb@kernel.org>,
	Zou Wei <zou_wei@huawei.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	nvdimm@lists.linux.dev,
	linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mike Rapoport <rppt@kernel.org>,
	"Brian Johannesmeyer" <bjohannesmeyer@gmail.com>,
	Cristiano Giuffrida <c.giuffrida@vu.nl>,
	"Bos, H.J." <h.j.bos@vu.nl>,
	Jakob Koschel <jakobkoschel@gmail.com>
Subject: [PATCH] tools/testing/nvdimm: replace usage of found with dedicated list iterator variable
Date: Thu, 24 Mar 2022 08:29:52 +0100
Message-Id: <20220324072952.65489-1-jakobkoschel@gmail.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

To move the list iterator variable into the list_for_each_entry_*()
macro in the future it should be avoided to use the list iterator
variable after the loop body.

To *never* use the list iterator variable after the loop it was
concluded to use a separate iterator variable instead of a
found boolean [1].

This removes the need to use a found variable and simply checking if
the variable was set, can determine if the break/goto was hit.

Link: https://lore.kernel.org/all/CAHk-=wgRr_D8CB-D9Kg-c=EHreAsk5SqXPwr9Y7k9sA6cWXJ6w@mail.gmail.com/
Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>
---
 drivers/acpi/nfit/mce.c           | 11 +++++------
 tools/testing/nvdimm/test/iomap.c | 18 +++++++++---------
 2 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/acpi/nfit/mce.c b/drivers/acpi/nfit/mce.c
index ee8d9973f60b..6d11506e871e 100644
--- a/drivers/acpi/nfit/mce.c
+++ b/drivers/acpi/nfit/mce.c
@@ -15,7 +15,7 @@ static int nfit_handle_mce(struct notifier_block *nb, unsigned long val,
 {
 	struct mce *mce = (struct mce *)data;
 	struct acpi_nfit_desc *acpi_desc;
-	struct nfit_spa *nfit_spa;
+	struct nfit_spa *nfit_spa = NULL, *iter;
 
 	/* We only care about uncorrectable memory errors */
 	if (!mce_is_memory_error(mce) || mce_is_correctable(mce))
@@ -33,11 +33,10 @@ static int nfit_handle_mce(struct notifier_block *nb, unsigned long val,
 	mutex_lock(&acpi_desc_lock);
 	list_for_each_entry(acpi_desc, &acpi_descs, list) {
 		struct device *dev = acpi_desc->dev;
-		int found_match = 0;
 
 		mutex_lock(&acpi_desc->init_mutex);
-		list_for_each_entry(nfit_spa, &acpi_desc->spas, list) {
-			struct acpi_nfit_system_address *spa = nfit_spa->spa;
+		list_for_each_entry(iter, &acpi_desc->spas, list) {
+			struct acpi_nfit_system_address *spa = iter->spa;
 
 			if (nfit_spa_type(spa) != NFIT_SPA_PM)
 				continue;
@@ -46,7 +45,7 @@ static int nfit_handle_mce(struct notifier_block *nb, unsigned long val,
 				continue;
 			if ((spa->address + spa->length - 1) < mce->addr)
 				continue;
-			found_match = 1;
+			nfit_spa = iter;
 			dev_dbg(dev, "addr in SPA %d (0x%llx, 0x%llx)\n",
 				spa->range_index, spa->address, spa->length);
 			/*
@@ -58,7 +57,7 @@ static int nfit_handle_mce(struct notifier_block *nb, unsigned long val,
 		}
 		mutex_unlock(&acpi_desc->init_mutex);
 
-		if (!found_match)
+		if (!nfit_spa)
 			continue;
 
 		/* If this fails due to an -ENOMEM, there is little we can do */
diff --git a/tools/testing/nvdimm/test/iomap.c b/tools/testing/nvdimm/test/iomap.c
index b752ce47ead3..5d3d6b0fce2e 100644
--- a/tools/testing/nvdimm/test/iomap.c
+++ b/tools/testing/nvdimm/test/iomap.c
@@ -227,8 +227,8 @@ static bool nfit_test_release_region(struct device *dev,
 		struct nfit_test_resource *nfit_res = get_nfit_res(start);
 
 		if (nfit_res) {
-			struct nfit_test_request *req;
-			struct resource *res = NULL;
+			struct nfit_test_request *req = NULL;
+			struct nfit_test_request *iter;
 
 			if (dev) {
 				devres_release(dev, nfit_devres_release, match,
@@ -237,18 +237,18 @@ static bool nfit_test_release_region(struct device *dev,
 			}
 
 			spin_lock(&nfit_res->lock);
-			list_for_each_entry(req, &nfit_res->requests, list)
-				if (req->res.start == start) {
-					res = &req->res;
-					list_del(&req->list);
+			list_for_each_entry(iter, &nfit_res->requests, list)
+				if (iter->res.start == start) {
+					list_del(&iter->list);
+					req = iter;
 					break;
 				}
 			spin_unlock(&nfit_res->lock);
 
-			WARN(!res || resource_size(res) != n,
+			WARN(!req || resource_size(&req->res) != n,
 					"%s: start: %llx n: %llx mismatch: %pr\n",
-						__func__, start, n, res);
-			if (res)
+						__func__, start, n, &req->res);
+			if (req)
 				kfree(req);
 			return true;
 		}

base-commit: f443e374ae131c168a065ea1748feac6b2e76613
-- 
2.25.1


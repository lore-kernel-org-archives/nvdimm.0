Received: from out162-62-57-137.mail.qq.com (out162-62-57-137.mail.qq.com [162.62.57.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C7A8329E5E
	for <nvdimm@lists.linux.dev>; Mon, 26 Jan 2026 13:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.137
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769432660; cv=none; b=W8LOFT+pOndgyeExVqYSW8b/MRCAwULQIfkRXmJs9NmBvEDAQDGBugJ1qeL2s/gVjYuQcNZEb6238VTlgRoT+QlXGMDN/Rt1pv8nrXS9kFbZRSd9BPJ5iFhWYoBVaNfNmH3+mmGyY3LSF8UWWG9z1pGg2GOUtlkQcTrC+XZ/rgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769432660; c=relaxed/simple;
	bh=o2MB7v6l9rfSNwvfTE3kUnv7hICHPMOZmrum536s3qw=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version; b=iYIowOldDMuS6g2bmR0HoHUseg6g7FDTA00pUMqtu82VnhdD9eaxrI6l15LxNC1ynyy1UR+87Y1D3SaTYaXMmYQ8yQxNICt04bwf6KeYIeXCTMY/TDvUo3Lu46Es1ZkGTi67nfFdigc+p7INtuxLmdTSDtgDMjj29iEFxyd4Rz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=L7x05D/e; arc=none smtp.client-ip=162.62.57.137
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="L7x05D/e"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1769432653; bh=wzoS6x3skSzIWFWYu1SImMnrrxwH6IbxW33niI/npcA=;
	h=From:To:Cc:Subject:Date;
	b=L7x05D/e06EquxMtktPwD7GRhmlEGYDOQyEe59Ej7LMzo5jUwZwsY5fIaLvjbzgQX
	 DJfqlBz88OPKtOUmSyMho7OUVlLgX9N9spoLGQyMXRRlQYpQMHohmviexx7DaFw428
	 QUMhsMktsokmoiDmoWWPdciyssAiKLXJWt8pGaWk=
Received: from admin.. ([2001:da8:205:20a0:6eeb:b6ff:fe15:94a7])
	by newxmesmtplogicsvrszc50-0.qq.com (NewEsmtp) with SMTP
	id 10A0E01D; Mon, 26 Jan 2026 21:04:10 +0800
X-QQ-mid: xmsmtpt1769432650tlsm82j93
Message-ID: <tencent_A06C2B14D0B5B3FEF2379914F5EF8AD61D07@qq.com>
X-QQ-XMAILINFO: Nd/Exl7W9DK5jhL7PQONnAORdWVI1r1nje2xg8o6oW8oFfwlcF4g3GHSDNJ71K
	 zxz/V6qheID2puenqKtV1U3AK6l3T1/Kr2zpjXOsselt9vjePCy2M7S1mXOipsTifF/iRzpksC8b
	 fHk6J9wPf9M+Kj7BMtVBq1mXilfIdnluLNvOiCLC1r69GSASOa5Yh/LwUIelBMRX/QwyXTrCaLjo
	 cEjthCkXMInPvzwwiK2DGFiPhE0mGTS5Yx95/4nKs3VvHIGaC7Lmw1XSBMI+ci71cClfD1kEADuE
	 iQkTKBLCBREs/Gsk2DfNVhRARfgl/wdYmRkawXRNXgZBQdUmgTnKaj1rT5E4lQauUR1+Jp3hOCMj
	 odTFd41u8x9ExNjzcnSsQewbZp0fmwgQLsSjlrquZYd7ru7kAScdeqCJLN8e79nW5INJi5tTzUul
	 7CQcXXYmCSdh9D1k2WPmq4w+vT+tSdYQj/kY8YeG16CCYUu+gHms6ICB2Vzb8p2Q/LlBVJkMP33s
	 kUFzSxrKBoJIX6R03/wdzUsD7d7bZjiRtYvDZGj3oF8jm2RvZn9Sp00dukyhDha9JJ4URIyhv53w
	 IdW2TjfJpG5FGYu3VLxqKQAKWJBymfQunVkgKFQSO6e3Lv83yN/DPFTpMGVrW/IPHxiVjvxTe6Sk
	 Gx4eMljVhQOhr37JmH+rcRr0ib5nUgzgkOCQQxYs9JD74OxL1ALUCY2RbBEwD/lLwzdFB0nAtwMZ
	 TN3pCX9piCr1zlc2kDZPY0o09sWaMh0t9F5Uszg6IaSkEIaAJgmBH1S+NyIdftlY8HSY16IwyKXX
	 s9yMOL6f4fQUyDIqJtefWAVYTGlwvRfOwSb0Ksl+XVHi7x+vgrzOsmJgzbtHO66rEK36B4YLdKw0
	 plCI8G5rAquKLPEM/7PDXDjrTELvpIG516Ed0LvmPDYO6gVZmXhTsB40zOkllAxYpZ/CIgNOLofp
	 0+EPesiPM1TA4kXHyOv7i9TOSL/b0xoRKOHErL4j3zn87VArcNeY+QknkxnhgFhoURwRdFqi6v/h
	 nfRNFukpvEqpe95XEI6+cHovs72f+OyKa/lHPwLxjUXmHa++IcIz5dMmDJclbiXmQJX9Vw3r+ebw
	 rW/L1lB5Rpx1nMoERfkQCirrADPrYhHeSsmFtE
X-QQ-XMRINFO: M/715EihBoGS47X28/vv4NpnfpeBLnr4Qg==
From: Zhaoyang Yu <2426767509@qq.com>
To: dan.j.williams@intel.com
Cc: vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	ira.weiny@intel.com,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	gszhai@bjtu.edu.cn,
	Zhaoyang Yu <2426767509@qq.com>
Subject: [PATCH] nvdimm: Add check for devm_kmalloc() and fix NULL pointer dereference in nd_pfn_probe() and nd_dax_probe()
Date: Mon, 26 Jan 2026 13:04:08 +0000
X-OQ-MSGID: <20260126130408.37599-1-2426767509@qq.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The devm_kmalloc() function may return NULL when memory allocation fails.
In nd_pfn_probe() and nd_dax_probe(), the return values of devm_kmalloc()
are not checked. If pfn_sb is NULL, it will cause a NULL pointer
dereference in the subsequent calls to nd_pfn_validate().

Additionally, if the allocation fails, the devices initialized by
nd_pfn_devinit() or nd_dax_devinit() are not properly released, leading
to memory leaks.

Fix this by checking the return value of devm_kmalloc() in both functions.
If the allocation fails, use put_device() to release the initialized device
and return -ENOMEM.

Signed-off-by: Zhaoyang Yu <2426767509@qq.com>
---
 drivers/nvdimm/dax_devs.c | 4 ++++
 drivers/nvdimm/pfn_devs.c | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/nvdimm/dax_devs.c b/drivers/nvdimm/dax_devs.c
index ba4c409ede65..aa51a9022d12 100644
--- a/drivers/nvdimm/dax_devs.c
+++ b/drivers/nvdimm/dax_devs.c
@@ -111,6 +111,10 @@ int nd_dax_probe(struct device *dev, struct nd_namespace_common *ndns)
 			return -ENOMEM;
 	}
 	pfn_sb = devm_kmalloc(dev, sizeof(*pfn_sb), GFP_KERNEL);
+	if (!pfn_sb) {
+		put_device(dax_dev);
+		return -ENOMEM;
+	}
 	nd_pfn = &nd_dax->nd_pfn;
 	nd_pfn->pfn_sb = pfn_sb;
 	rc = nd_pfn_validate(nd_pfn, DAX_SIG);
diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
index 42b172fc5576..6a69d8bfeb7c 100644
--- a/drivers/nvdimm/pfn_devs.c
+++ b/drivers/nvdimm/pfn_devs.c
@@ -635,6 +635,10 @@ int nd_pfn_probe(struct device *dev, struct nd_namespace_common *ndns)
 	if (!pfn_dev)
 		return -ENOMEM;
 	pfn_sb = devm_kmalloc(dev, sizeof(*pfn_sb), GFP_KERNEL);
+	if (!pfn_sb) {
+		put_device(pfn_dev);
+		return -ENOMEM;
+	}
 	nd_pfn = to_nd_pfn(pfn_dev);
 	nd_pfn->pfn_sb = pfn_sb;
 	rc = nd_pfn_validate(nd_pfn, PFN_SIG);
-- 
2.34.1


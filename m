Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE1AE86136
	for <nvdimm@lists.linux.dev>; Mon, 29 Apr 2024 17:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714410295; cv=none; b=iFAxHRFKo1vg+Yi1mt1MPb/0nFrwak1PordGAPLOEQaEgsaeTitPkerAhGsWKZG1oh5g5ztudzKd3EDqngghKkBoGawOJoMRdN4yQNMeqSLAZvgXqMBv1IEjMDE65fqiV2iNovT7nQrbq9y+zE0A1fDcpM8R7czBQ/rAgsNxTL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714410295; c=relaxed/simple;
	bh=WMjz9J531Kmle80GG+B28JoC2U8bxRD8YtN4xwrFy4U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=O9TnZUbTMIn1ThSAdPw2U+t8xF8X1eXHVx7wXM6XsZke8ydV+QdKBC1wuTzGYBGO8U9ubwOjn4vhDM/TeB6H8A4p6lELXxHNzu5Jauo53mwT+Pi1pvTgEXEP+7jo3gGTQZ9nsPA08SD+4hgScUEDpO2BoLDJgRNawvQc5IYkhas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MLtvyUWQ; arc=none smtp.client-ip=209.85.210.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MLtvyUWQ"
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-6ea2ac4607aso2546445a34.3
        for <nvdimm@lists.linux.dev>; Mon, 29 Apr 2024 10:04:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714410293; x=1715015093; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yFzk9HeKkizf0o48ibh6kc3Q60VfzVMF4+JwNubBTrc=;
        b=MLtvyUWQqlQf6ouGRmrH7B3Y2ED2Fxgx3gtAdiH9k/pWDaDTwDzdFeyIMcvR3Mz3J3
         U3UEcij84m4Kt7BPFGiZFJFceSnakdZ0MsTeyYXQtaP8BPxbOUKyJ6u8BzxKFuA4ISGv
         LlvoA5rvYMV7bdpX90yrJgOeVSCYTD93ihs8LlbJbUmzfTg56NClidmw1A1iLmHDH5Ue
         HPLOhKiRVOZIkwPt+/HIDQHBHC3Yi0UoXjVq5TCKvqGK0TBB75zHrr7YHGOnu6PaCYIl
         S0rU4gN9dhXxPMCAzZZzPZ+jBo+cNntz/IzklovXOGZgrmdOyHViJFNbX+ewpBfI3s7I
         2vhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714410293; x=1715015093;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yFzk9HeKkizf0o48ibh6kc3Q60VfzVMF4+JwNubBTrc=;
        b=BoLX/KL/SEoi6ObLtQ0eIWQrzERScqYCX4vZXQY1hb6EAHTTwK/LiU6VLuwk44B9f5
         fg5XZCILtJEX5SdlZeReeMoSP0PfLYMwgc1ETIfpDH8y385ENyTCiu0lVGoX1hpwKT53
         dCdGuQ+5hoxxAHHwROe1z2VzQfhNDkkQuSUqmTnSTtdMMzCIrYjKjx1HAWhJPa3SjowG
         8tZ/Ee8N3DO4qlF7DVo+OZKy9/c+exTmz/ftAq52FTWJwiBzn3baZBxSQjAuAI4pAhdc
         MxEcFfHAVwHlBEWKu7TLUo5b4Bvs/qgsOxvsUQc+GCYb1CI1sDNasGRYfSuRvK8iMwhA
         KDFQ==
X-Forwarded-Encrypted: i=1; AJvYcCUX/6FWSdocP1BHCQmvRzZ6qtdGEolNT169EujGuIqmNF1XhQkrBr2TAfYPY1hPd+86kSbE3dhSiAA5szVyeKAVmCzqnPkX
X-Gm-Message-State: AOJu0Yx0MZWG9bBIMVojmGp9QJzx3x1hVYfUdq306kVaHnQK1mQ+QFsq
	1q0TZcs6kTYIVWYuh+/aDDIQg4a/ym011Qg216h14skP5WlSP7wM
X-Google-Smtp-Source: AGHT+IH1LmxDBYpYdV8qfbKzAt1ETJgRjycszT1zAA1fNj6kpgVTUiKrSaeYD5ARjcBkfK0lW4EGeg==
X-Received: by 2002:a05:6830:4a2:b0:6eb:7c52:fd19 with SMTP id l2-20020a05683004a200b006eb7c52fd19mr12585723otd.16.1714410292768;
        Mon, 29 Apr 2024 10:04:52 -0700 (PDT)
Received: from localhost.localdomain ([70.114.203.196])
        by smtp.gmail.com with ESMTPSA id g1-20020a9d6201000000b006ea20712e66sm4074448otj.17.2024.04.29.10.04.49
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Apr 2024 10:04:52 -0700 (PDT)
Sender: John Groves <grovesaustin@gmail.com>
From: John Groves <John@Groves.net>
X-Google-Original-From: John Groves <john@groves.net>
To: John Groves <John@Groves.net>,
	Jonathan Corbet <corbet@lwn.net>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Matthew Wilcox <willy@infradead.org>,
	linux-cxl@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: John Groves <jgroves@micron.com>,
	john@jagalactic.com,
	Dave Chinner <david@fromorbit.com>,
	Christoph Hellwig <hch@infradead.org>,
	dave.hansen@linux.intel.com,
	gregory.price@memverge.com,
	Randy Dunlap <rdunlap@infradead.org>,
	Jerome Glisse <jglisse@google.com>,
	Aravind Ramesh <arramesh@micron.com>,
	Ajay Joshi <ajayjoshi@micron.com>,
	Eishan Mirakhur <emirakhur@micron.com>,
	Ravi Shankar <venkataravis@micron.com>,
	Srinivasulu Thanneeru <sthanneeru@micron.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Steve French <stfrench@microsoft.com>,
	Nathan Lynch <nathanl@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Julien Panis <jpanis@baylibre.com>,
	Stanislav Fomichev <sdf@google.com>,
	Dongsheng Yang <dongsheng.yang@easystack.cn>,
	John Groves <john@groves.net>
Subject: [RFC PATCH v2 02/12] dev_dax_iomap: Move dax_pgoff_to_phys() from device.c to bus.c
Date: Mon, 29 Apr 2024 12:04:18 -0500
Message-Id: <552c86dd6c3c4252994a94e23bad2cb95e3ed392.1714409084.git.john@groves.net>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <cover.1714409084.git.john@groves.net>
References: <cover.1714409084.git.john@groves.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

No changes to the function - just moved it.

dev_dax_iomap needs to call this function from
drivers/dax/bus.c.

drivers/dax/bus.c can't call functions in drivers/dax/device.c -
that creates a circular linkage dependency - but device.c can
call functions in bus.c. Also exports dax_pgoff_to_phys() since
both bus.c and device.c now call it.

Signed-off-by: John Groves <john@groves.net>
---
 drivers/dax/bus.c    | 24 ++++++++++++++++++++++++
 drivers/dax/device.c | 23 -----------------------
 2 files changed, 24 insertions(+), 23 deletions(-)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index 797e1ebff299..f894272beab8 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -1447,6 +1447,30 @@ static const struct device_type dev_dax_type = {
 	.groups = dax_attribute_groups,
 };
 
+/* see "strong" declaration in tools/testing/nvdimm/dax-dev.c  */
+__weak phys_addr_t dax_pgoff_to_phys(struct dev_dax *dev_dax, pgoff_t pgoff,
+			      unsigned long size)
+{
+	int i;
+
+	for (i = 0; i < dev_dax->nr_range; i++) {
+		struct dev_dax_range *dax_range = &dev_dax->ranges[i];
+		struct range *range = &dax_range->range;
+		unsigned long long pgoff_end;
+		phys_addr_t phys;
+
+		pgoff_end = dax_range->pgoff + PHYS_PFN(range_len(range)) - 1;
+		if (pgoff < dax_range->pgoff || pgoff > pgoff_end)
+			continue;
+		phys = PFN_PHYS(pgoff - dax_range->pgoff) + range->start;
+		if (phys + size - 1 <= range->end)
+			return phys;
+		break;
+	}
+	return -1;
+}
+EXPORT_SYMBOL_GPL(dax_pgoff_to_phys);
+
 static struct dev_dax *__devm_create_dev_dax(struct dev_dax_data *data)
 {
 	struct dax_region *dax_region = data->dax_region;
diff --git a/drivers/dax/device.c b/drivers/dax/device.c
index 93ebedc5ec8c..40ba660013cf 100644
--- a/drivers/dax/device.c
+++ b/drivers/dax/device.c
@@ -50,29 +50,6 @@ static int check_vma(struct dev_dax *dev_dax, struct vm_area_struct *vma,
 	return 0;
 }
 
-/* see "strong" declaration in tools/testing/nvdimm/dax-dev.c */
-__weak phys_addr_t dax_pgoff_to_phys(struct dev_dax *dev_dax, pgoff_t pgoff,
-		unsigned long size)
-{
-	int i;
-
-	for (i = 0; i < dev_dax->nr_range; i++) {
-		struct dev_dax_range *dax_range = &dev_dax->ranges[i];
-		struct range *range = &dax_range->range;
-		unsigned long long pgoff_end;
-		phys_addr_t phys;
-
-		pgoff_end = dax_range->pgoff + PHYS_PFN(range_len(range)) - 1;
-		if (pgoff < dax_range->pgoff || pgoff > pgoff_end)
-			continue;
-		phys = PFN_PHYS(pgoff - dax_range->pgoff) + range->start;
-		if (phys + size - 1 <= range->end)
-			return phys;
-		break;
-	}
-	return -1;
-}
-
 static void dax_set_mapping(struct vm_fault *vmf, pfn_t pfn,
 			      unsigned long fault_size)
 {
-- 
2.43.0


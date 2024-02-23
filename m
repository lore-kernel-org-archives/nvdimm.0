Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2898913B7A5
	for <nvdimm@lists.linux.dev>; Fri, 23 Feb 2024 17:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708710148; cv=none; b=YxFYWbOm4E8yse/wgUjXATyCov6ufXpvyUqnYOil76HbQkYKPbBIJHpBpMVI07hYlaMF5zD1UEcPFDgCKnBoOcCABZlAniuYJnK9f3fr0ccUPUo6wbcjh3oH30YLL8Y+Pkhj24uqJjS9ehdi2nIbpBshHvwMLh+KxxmQeQuuPM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708710148; c=relaxed/simple;
	bh=ZbfxtKf+CEH2wGLH6RSoWosZOiwKXV+zrcJLYgSF8z4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FElpCEywKzOTRgZfYV9yktuFdCl8MIB9M+MuBT9xUoi4GK7YaATsBuXRwTzZTzQczEDDFb1fYn689pXzIgbSgb4qUFtaRaTCKiSVJyAHBLI+iITLKgyUm/6Z4RokNXqiyAyG+yWtCgRI6p9im45Q9+2OKdE/qw7JL28W0LhOh0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Wwx7JRwq; arc=none smtp.client-ip=209.85.160.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Wwx7JRwq"
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-21e8a740439so211615fac.1
        for <nvdimm@lists.linux.dev>; Fri, 23 Feb 2024 09:42:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708710146; x=1709314946; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ysyvhoe9WrIZCAbrcazj2rYc9hMFHO2LJz+Ed7fxvok=;
        b=Wwx7JRwqvlq7PUFBYoibOj1FhTTVi2A/CDikqpUXryizemjg9ou7bu4DfKFQsSgVZp
         ERqhDxEoI/0967iNKomReoQrR2kqRVY6o27YGIjPKIAnXPlZlOdv6NcpWNDjwrBSmwt/
         R/PUrWJ1QEyiFuXJC/fKTR3A2SUuEdD+3v8dbid7xYdFSWDOI/f/91wVMxQmRyeHT2ov
         f9Cq1HwH5T6QKxFXzcVFsm2QPJkKQQratDkFSnFYqXFhkG/AJ8LuERojej62KrMq/Y6K
         GGUf0EI7Xq0R9p3sdzs7NYT1zcjDQeEKDFdq9w3h/RJf9F5B5F+RdSeE9uLlCmNbft9e
         QiOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708710146; x=1709314946;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Ysyvhoe9WrIZCAbrcazj2rYc9hMFHO2LJz+Ed7fxvok=;
        b=XUNuLQHmpmgTK8tTJT83BeNIINraAbb+7itzD0GO6nbCU2WiRhV3GV4cBONlmNH5GR
         qZtrY60n49IZN6KicjzR7f90ZUEHFG4P8oK2y7gseJqUBCcVBjhu595ELyU9Kd3P50+e
         VF0XF7Rzdez2lnVCyvCRyOLV/3eU1zU/yMDHlKttntCx4YHiI6A4DSRGPRgRd5OYA/F3
         ETulEjJ7sc8BWEhj0LGbma6yNRmHE6KH8eJNtiT2zZJajENLKHiTvrJRS2Cb8KlnF3aV
         sFLqziiMSfe74Ia/N1KxyPslZGnl6OGJZprgfBfv0Y4eR5YITtgKol8gg6khxbOATo4I
         GmIw==
X-Forwarded-Encrypted: i=1; AJvYcCXQ3OZRSjY3NFZCR89j94OoQxkgr0ANRSzWSqQEgVoX6NqE4/p53e8nbU7tvLdlehurDqa+hCtJUrBIEwB9jEw3yXKRcRUG
X-Gm-Message-State: AOJu0Ywb0ucywvL3GUCk6vpad1cxlzjQggMgVzD434Lfg+/8sIR88DQ4
	CWGdiaj2co0AnSigrbc20Tl2Nm9YowCeCEWyqgivuUcZ5pR53qvw
X-Google-Smtp-Source: AGHT+IG/GUeqabU8ZjvZRSRCOteowuLlcjS4ESz2/EbniniNL6YMrlAifUs32d0i0+teK0sbm9sTzw==
X-Received: by 2002:a05:6870:9108:b0:21f:c734:5b56 with SMTP id o8-20020a056870910800b0021fc7345b56mr99136oae.4.1708710146231;
        Fri, 23 Feb 2024 09:42:26 -0800 (PST)
Received: from localhost.localdomain (070-114-203-196.res.spectrum.com. [70.114.203.196])
        by smtp.gmail.com with ESMTPSA id rb7-20020a056871618700b0021f6a2bd4b9sm1257803oab.3.2024.02.23.09.42.24
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 23 Feb 2024 09:42:26 -0800 (PST)
Sender: John Groves <grovesaustin@gmail.com>
From: John Groves <John@Groves.net>
X-Google-Original-From: John Groves <john@groves.net>
To: John Groves <jgroves@micron.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Matthew Wilcox <willy@infradead.org>,
	linux-cxl@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: John@Groves.net,
	john@jagalactic.com,
	Dave Chinner <david@fromorbit.com>,
	Christoph Hellwig <hch@infradead.org>,
	dave.hansen@linux.intel.com,
	gregory.price@memverge.com,
	John Groves <john@groves.net>
Subject: [RFC PATCH 03/20] dev_dax_iomap: Move dax_pgoff_to_phys from device.c to bus.c since both need it now
Date: Fri, 23 Feb 2024 11:41:47 -0600
Message-Id: <8d062903cded81cba05cc703f61160a0edb4578a.1708709155.git.john@groves.net>
X-Mailer: git-send-email 2.39.3 (Apple Git-145)
In-Reply-To: <cover.1708709155.git.john@groves.net>
References: <cover.1708709155.git.john@groves.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

bus.c can't call functions in device.c - that creates a circular linkage
dependency.

Signed-off-by: John Groves <john@groves.net>
---
 drivers/dax/bus.c    | 24 ++++++++++++++++++++++++
 drivers/dax/device.c | 23 -----------------------
 2 files changed, 24 insertions(+), 23 deletions(-)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index 1ff1ab5fa105..664e8c1b9930 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -1325,6 +1325,30 @@ static const struct device_type dev_dax_type = {
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
 struct dev_dax *devm_create_dev_dax(struct dev_dax_data *data)
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


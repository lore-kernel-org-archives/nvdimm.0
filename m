Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4296E1FF7BC
	for <nvdimm@lists.linux.dev>; Thu,  3 Jul 2025 18:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751568642; cv=none; b=A0Jq61Wu1ZXvXRQoCORVa6KOaY+ITNbks6dVj6SzpI+O7ZJNlfFyBvJGKWIz79ZTZlPGAN8rxbTIIWeUCZhM5iCwqfmNIIS3JsHoH4YL48c3UBIlwBsfz2SpEGZQyRDTp8bou9/rs5IPa/YDgijqaJ/Roc1H50e0xBD0aGoE/qI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751568642; c=relaxed/simple;
	bh=r7zU/NI6k0w2nK9GLUrhezJkiaHouNNrUAqAk2AR65M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Hlfe00+R1N1ejw56FQXxebcNfhYTGXvHbbbnB9jjyXMdLr/uSRoBl+hceq5K2g5z8bzEo3WxpgSNU40zoRLCOo3WgCHzQImlcCM1jiPjYtI6JEgT7CTALulLLOJ/HlF1mpq3fp5awBr6gkVKOQ344WqlRgeIkiAIQ1QBTxmlQOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DQUAsyAE; arc=none smtp.client-ip=209.85.210.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DQUAsyAE"
Received: by mail-ot1-f48.google.com with SMTP id 46e09a7af769-73a5c41a71aso142153a34.0
        for <nvdimm@lists.linux.dev>; Thu, 03 Jul 2025 11:50:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751568640; x=1752173440; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+TgC0a/U5AW9OV2eqK8aHn6K3OlQMlAMMt+8AXwopR0=;
        b=DQUAsyAEuzT+gZbbHgEttk9QD/KL9U2GkW/5uyy5oRREi2DouRu/8/sRDxBVZ51ebw
         73F8aR6w4OrCRhw+YetA6SrxlsJMqGB17W9HVPBv9rXQw922obAzMierrjM+2JHNPrym
         XS7ZA4iHgng6Nux7t1FdYpyidNv36EU2X3IR8Ntl134ct45Xe/NyUKG2mVxJ11vb7FxS
         18hm4xG7ZjzS3bZfWXihq7IYj71+4f/CzX5zXF6U9Zo7+tI+2RyIYEVcA3MC10cgARl0
         zEQfRSMephDMQQI5Hcgb2II8TjQ2NPgOa1dPunE8RPRnrJ6lnv+VNRHHpzxMb6Q+CX8x
         /REQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751568640; x=1752173440;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+TgC0a/U5AW9OV2eqK8aHn6K3OlQMlAMMt+8AXwopR0=;
        b=QhbSWynHr8xDLs9BgvICKzYoaOb+8HJVliI5t5DnaThFr0Olwa37EOAW9YKJ2idBd1
         bfv6dNGGpv1R7bBaIY3N0WDr8M1gDBT3HTMvN0mzRBGZK85cvu0f+n4J9v56n4d+c+Zh
         nLYMf68uCgkriPgiD7Nb8am6Wf1q/k+cqj2Ok+Mv1C6wE2N6ITtmC2ABkvpWyY1JmN8x
         o1VgoNLYqU77fnpb8tHugd1ZjN67lPddYQWrotg72Iz5inqE4iE0B4X3r7Y7wffNBqip
         Jahwtpf2wyZrZwqh1v+A9ovXvD9FxAergo1yxJzjlmPmydBNqz3m78ceSsqq0fsT4FFC
         /vtA==
X-Forwarded-Encrypted: i=1; AJvYcCX+WfmBcPZRD5sNUQbAOmoOc1caf1DoOI1RGjflnIc5jWCZ8SvyCD+1kUg9UiOTWL4n/eTk2fM=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzb6F0h4MG/6iIdLEE5xfH/lHndSu/kfjtHfoVnDRrcu4ha/Uf+
	JzpU42SxOeL15hYwyV6pJ1tmUKReWEO6raYx598rxZCKsUkL0RlNkXTp
X-Gm-Gg: ASbGncsgxXHd2ISlQgjfigvalc9klnSnBr/u27LXRzjiK00x402S1fOkjILB+0SgvkL
	b6u3BppLix/rXM4dSALXxiKs/VyRR0KcnWnvcP72CDJB4+LXQ5TNuDurklbc3K1O1w6lD7SXpYe
	mjlwAHK6+k/NP/2q8c3R3kKbS62QgRep62R12YUDpueYpPMLmBIxeWV4HnsddHpVtHol1CMJbGo
	htIofZV+dPl5aDpV3wSys/6SHQdNqxHQnne8c96Cjbcuc0o5xKw0ZKTYO/maDLBy6EHv4wTraLv
	LYJEACUS6znP2aVBdyU5qcIEoh7SrtUDDkLeasr6x3yDAw8SqavhupnYQBhvQrRxrOotmGZRI5E
	h600HBD1nBVlVZQ==
X-Google-Smtp-Source: AGHT+IF73hX0JJIFBHibtD6A0+6uqUWfKLCEXmyBw6pOmIubhMzzPV9Jpbwsi9M9zd7Nm7jge6Jo8g==
X-Received: by 2002:a05:6808:1b07:b0:404:e0b3:12f with SMTP id 5614622812f47-40b8876eecbmr6495647b6e.11.1751568640087;
        Thu, 03 Jul 2025 11:50:40 -0700 (PDT)
Received: from localhost.localdomain ([2603:8080:1500:3d89:cd4:2776:8c4a:3597])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-73c9f90d1ccsm68195a34.44.2025.07.03.11.50.38
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 11:50:39 -0700 (PDT)
Sender: John Groves <grovesaustin@gmail.com>
From: John Groves <John@Groves.net>
X-Google-Original-From: John Groves <john@groves.net>
To: John Groves <John@Groves.net>,
	Dan Williams <dan.j.williams@intel.com>,
	Miklos Szeredi <miklos@szeredb.hu>,
	Bernd Schubert <bschubert@ddn.com>
Cc: John Groves <jgroves@micron.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jeff Layton <jlayton@kernel.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	Amir Goldstein <amir73il@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Stefan Hajnoczi <shajnocz@redhat.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Aravind Ramesh <arramesh@micron.com>,
	Ajay Joshi <ajayjoshi@micron.com>,
	John Groves <john@groves.net>
Subject: [RFC V2 01/18] dev_dax_iomap: Move dax_pgoff_to_phys() from device.c to bus.c
Date: Thu,  3 Jul 2025 13:50:15 -0500
Message-Id: <20250703185032.46568-2-john@groves.net>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250703185032.46568-1-john@groves.net>
References: <20250703185032.46568-1-john@groves.net>
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
index fde29e0ad68b..9d9a4ae7bbc0 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -1417,6 +1417,30 @@ static const struct device_type dev_dax_type = {
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
index 6d74e62bbee0..29f61771fef0 100644
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
2.49.0


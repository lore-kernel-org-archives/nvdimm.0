Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C2B7348865
	for <nvdimm@lists.linux.dev>; Wed,  7 Jan 2026 15:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767800029; cv=none; b=JrQcG8kx9e9DPHW+ytnX6e9jOo3FJ3N8LBvoJj0/5IGq81aqvFknbuQiC2FXAMfju6zelN9eKCBaoVyrAl1xiy+FMDgQaMJ/OHj4XV1q4wHzdW9KuSY5OFDUTi8y9nmk9RWRx+ZZWO5nWdGcdnZj6+Ka6mczD/woFN3zDmUJRfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767800029; c=relaxed/simple;
	bh=NuWusZLC5UQlkk7hlcFERKM1c2CGKJNdml11bqf0XyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZfHyqWcByAvOX2LXz3sQAzPfBKBFH2XOlLiKHLNv2Xvb3q+GJ3Q90KkArR5QkzEWSxNbChD9OGNd5rNw9eiRbBbp02j4eQRwGX3zhhfWboFROf8Xq1IF8SncP56PbieWehWEfL7sGqRYLyjrZvi+V/BEG8ZMoK0/Ie80rZc1Hp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KGPQh0h8; arc=none smtp.client-ip=209.85.167.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KGPQh0h8"
Received: by mail-oi1-f178.google.com with SMTP id 5614622812f47-455ddb90934so747596b6e.0
        for <nvdimm@lists.linux.dev>; Wed, 07 Jan 2026 07:33:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767800025; x=1768404825; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PmVFHvoo6qZY7RUGgdXNII0ab/XeZ6ETTaZK349UK+g=;
        b=KGPQh0h8oainX+rFZg0o177G/8reKJW7wltmV1wKT630s3dROJ4v7ZqnhuRWLWWhuV
         QKiMvKk7ZD5FcRnaeDZy3LTyKOCpPPwC+CodR+K9RHJ7/FRSqIu1aCv9s7sMAhawU8FS
         upchyaiqjEZeIy0+WmMJXQwE0ZcC1SoAGKBDjVVAr57laLLk0ZD0wcGKd9qm5egGpzJI
         dY8aCnPigdFy0VE5wpSzU+9S0Q60QXnphq3bE7+6up3AAEWIeTHJ63xuaYgOYs5bw7Gp
         YNHba0PZDMmoQj+fiDeXAD7yitqp6h31wuejNhLIlrTSYbDCrqvR284y02nVLsqGuGVc
         cMtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767800025; x=1768404825;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PmVFHvoo6qZY7RUGgdXNII0ab/XeZ6ETTaZK349UK+g=;
        b=g1c2iNT4HCd0Vl5bgk+ltuQChFYMpfNv/I8erbqfB+ao3D4LgzraRvrBxc+x+npHRY
         mA7pGgrq4go3PX8yF/nRGMhQd/anICJzicNT85SzxlJlMbK4SQ9zTTalbduAk3K2qA08
         h9JhQ3i7fJZ8gGht7a/UaBpiiwtoedGpY1+cjpOMAqKQ/Xb6etQB0hWmFeidXEk+9Hgo
         PvtNUi5WoexYTU5OYeORY5srJ4Qlx2uExykf3hHDfuwvyh/MB0Bz04ly1Xbn3GtrqSio
         y1VTy9JnFRGEVRsm+swSvegtcqZHinqfwn7/TiXbOC5Y5sEro96ChLIh6UcRvbE6ATHP
         Hq7A==
X-Forwarded-Encrypted: i=1; AJvYcCW4DbGT/5/VghZFlTgl+QjJi3JaAFm6qtlDoynCopsTYtNqqF5ADqyR9iD1ivJf4gJvfeQYBfo=@lists.linux.dev
X-Gm-Message-State: AOJu0YyGA16+iQ/me6pYKEazhPQMWBSZrlTnY/21HcekwgPg4pc0HtbB
	gJHNsgqo+v+0zvVZ3TbQU6rFtytSgBV2wGb9JLrUTUl9mhrITp2VKEak
X-Gm-Gg: AY/fxX6WF0JA+yC3WgwtK0R6vTomfLxmNlf5Jsq86Ps59NEv7nngTdJ5pG03c5ScKRo
	4JcLPcv969A/np28uzOFVaLOVnzaFNgm77IuuaGCMCngwx/9tDidiTIov3tJEVX6YC5hWsaYlQD
	+SvVeUNnwDb/Cj2goo32LPruseYnguLxH095qSnmvT/iUZ/dmxFmOr3VUVcCPRj1FaD4xnehCqW
	zZ+qcbGVhINO3Pc7gzSTuo40sP8zY0RIGaPPyXuJy2hGdWBlMslwMmcvkLGS2x6GnOdhRkqsGcx
	W7Mt3arLqiGZEZFcDsRaL6BksLL8h0Ry/wQOVJP3uX2d4GEahrCt9R/fSXuECgL0dg+8YWVRpxV
	KSZzZcL7/ddugLcY/ydKWinFSbFKr7smWmjG9BtXazgIro/ffiyWo4ybol8nu+9m457Hq6nAjuw
	pMZ6nbYfQZx79HhhCNkumQJJ6Q/+y65MzDG1LiWbUkUkTJ
X-Google-Smtp-Source: AGHT+IHkLI2SMyhkKOgLjFmL6YFwT+7moAdIUHTTTIFi2bmiuCeEJRn6ElXDVg0S7UXRPCs1iwtC5Q==
X-Received: by 2002:a05:6808:c2d8:b0:45a:5584:b84d with SMTP id 5614622812f47-45a6bebe564mr1179771b6e.32.1767800025297;
        Wed, 07 Jan 2026 07:33:45 -0800 (PST)
Received: from localhost.localdomain ([2603:8080:1500:3d89:a917:5124:7300:7cef])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-45a5e2f1de5sm2398106b6e.22.2026.01.07.07.33.43
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 07 Jan 2026 07:33:44 -0800 (PST)
Sender: John Groves <grovesaustin@gmail.com>
From: John Groves <John@Groves.net>
X-Google-Original-From: John Groves <john@groves.net>
To: John Groves <John@Groves.net>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Dan Williams <dan.j.williams@intel.com>,
	Bernd Schubert <bschubert@ddn.com>,
	Alison Schofield <alison.schofield@intel.com>
Cc: John Groves <jgroves@micron.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	David Hildenbrand <david@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jeff Layton <jlayton@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Stefan Hajnoczi <shajnocz@redhat.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Chen Linxuan <chenlinxuan@uniontech.com>,
	James Morse <james.morse@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Shivank Garg <shivankg@amd.com>,
	Ackerley Tng <ackerleytng@google.com>,
	Gregory Price <gourry@gourry.net>,
	Aravind Ramesh <arramesh@micron.com>,
	Ajay Joshi <ajayjoshi@micron.com>,
	venkataravis@micron.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	John Groves <john@groves.net>
Subject: [PATCH V3 01/21] dax: move dax_pgoff_to_phys from [drivers/dax/] device.c to bus.c
Date: Wed,  7 Jan 2026 09:33:10 -0600
Message-ID: <20260107153332.64727-2-john@groves.net>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260107153332.64727-1-john@groves.net>
References: <20260107153244.64703-1-john@groves.net>
 <20260107153332.64727-1-john@groves.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This function will be used by both device.c and fsdev.c, but both are
loadable modules. Moving to bus.c puts it in core and makes it available
to both.

No code changes - just relocated.

Signed-off-by: John Groves <john@groves.net>
---
 drivers/dax/bus.c    | 27 +++++++++++++++++++++++++++
 drivers/dax/device.c | 23 -----------------------
 2 files changed, 27 insertions(+), 23 deletions(-)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index fde29e0ad68b..a2f9a3cc30a5 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -7,6 +7,9 @@
 #include <linux/slab.h>
 #include <linux/dax.h>
 #include <linux/io.h>
+#include <linux/backing-dev.h>
+#include <linux/range.h>
+#include <linux/uio.h>
 #include "dax-private.h"
 #include "bus.h"
 
@@ -1417,6 +1420,30 @@ static const struct device_type dev_dax_type = {
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
index 22999a402e02..132c1d03fd07 100644
--- a/drivers/dax/device.c
+++ b/drivers/dax/device.c
@@ -57,29 +57,6 @@ static int check_vma(struct dev_dax *dev_dax, struct vm_area_struct *vma,
 			   vma->vm_file, func);
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
 static void dax_set_mapping(struct vm_fault *vmf, unsigned long pfn,
 			      unsigned long fault_size)
 {
-- 
2.49.0


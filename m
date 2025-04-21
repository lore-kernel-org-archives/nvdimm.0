Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AB1078F47
	for <nvdimm@lists.linux.dev>; Mon, 21 Apr 2025 01:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745199241; cv=none; b=Mt1AZ6X7z2buWE+1ykAdtfgudohSVn3IXBDkKOMV790PjVQyTad6HFkBCqUAWoQRtUrAkgxpbRvnakXVA4QvYEc6Vfe7/Rg77niApIQsp4X3qciw4E0HBkrKma8v40apJNiJUzwFz5PMVw5IkzCU1cOSk5RzKMQXUyoUNxf0VFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745199241; c=relaxed/simple;
	bh=r7zU/NI6k0w2nK9GLUrhezJkiaHouNNrUAqAk2AR65M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VXiAb9C72aiWHor4OH42r88I2ubqgOfb2TutnsnuWXRa+mnjhhFHiRPcU9HOQqKg+T9XVVDTJfmYmSyRSLk2Vf2GZewLbEFTZEUMFks9GJtNlkxK24IrkXez+LsNcGd4ltjZB8LAxHJV6xxEN/UP/U9Qwe8zAMn7aQkqtlzxJbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hl131mXV; arc=none smtp.client-ip=209.85.210.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hl131mXV"
Received: by mail-ot1-f49.google.com with SMTP id 46e09a7af769-72bb97260ceso1235609a34.1
        for <nvdimm@lists.linux.dev>; Sun, 20 Apr 2025 18:33:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745199238; x=1745804038; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+TgC0a/U5AW9OV2eqK8aHn6K3OlQMlAMMt+8AXwopR0=;
        b=hl131mXV9XlOBZX1EEeNg4etqcsPoXDFX0bg7+owv8z7Kv42ePFdIp0TGt+B/Cquqx
         ZxnDEYcrZi1HNeGibWSlWE0MinXtbpSJSgV3zo4u3b9IGQEkQehJRRliwB3n0RxoaMGX
         mtAorZJKE9pTLNOSB6Tff/sglJsuL/6R3lSad+ObOoI7X8TWUw6rr7rzyxfOyPPPrQXi
         N3IKo5qzUCcQ2AymHbyF9+tn9BwBkEMhIOp6SCiOsWj2HrNHa5kfivcnWwMszi9j6kAs
         aHOferbV236bY66K+GTyU+7CN/fgguEgLi8uV+B0fwHEakqi50GrG83dMqwnBbQlDa4w
         qtYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745199238; x=1745804038;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+TgC0a/U5AW9OV2eqK8aHn6K3OlQMlAMMt+8AXwopR0=;
        b=EfuxDMgAQx8SwXsEBzeE4r+9ic1vf24NsnFYb57+39YQZZtF+ffWgTMIP+GL6fRWjk
         UcHK6o+/RJpFWzyaunlRVU7v1qo8FsNPCotqaz3YsvaVZELb5YDgp0t0u+9d+xKqcPfG
         H1Oae1CuFYWWvLzJ6NJSdhkGJn/DIfRm1qQIxkCTiKpB9Vz5iBP4IdHUyaL4lrYmKkXQ
         MX69mW+G3CucEfbqopvuCMc8PIZYNWOKtWU+0YWe1MVGHDjMqKPuGr479AzvEOqHdWNg
         Xzi9ZZeJNiB3Fufckqdn0Duh0tIBnpalT1/Io76lcsLOUfBOXdeUA1DmerS9EuwVKGiA
         Vyug==
X-Forwarded-Encrypted: i=1; AJvYcCWt5/pN7iwviPb7SG5R9Aadr/Fba/FC8w1FuAjT32+/Pqm4Tx+UF34H36YbPbSpYFBh2733aTw=@lists.linux.dev
X-Gm-Message-State: AOJu0YwzJbXZEX/Zpf93w1tN+kcdOuFmjPZFgdqflB5zgPZJM/N1PbOa
	kEt7PYZW+UqBJ7jTAp0JGc7kIdP1BNZgGcf6Bt9gAN7WD/9NBVgp
X-Gm-Gg: ASbGncsq4Inu+oqXLsEkVfYkxGsOAyitRxQu+1QMPOp+80AkBWbmWrHDWzhYBMilCXv
	izdnPxF9Kcg9L7LQV8Sf2MQREmK08Zvr1BDQ7Mn55I8X/33wf80W0BClqQD26u0+AHtS9pQibVi
	ViuoIxV47OK/C1C9FQXv52YD8mpuSUjtEXIlhDTLoY2YIMiHcvBus1yV9hx1jXgPwdjmU+UUpsm
	dTV9bplCUtshc2psZn9kp3gKAyt09Emfc11CFnd4AxAuEKW3lT1F0Dby1vbuu84vP5p2AqPLcOX
	CGLMwMi/T9BIbmQjN6gziqbSGBXNapnzslA8h37+DdUA5TISG4UuOUI1gkaYfeC/Nqkijg==
X-Google-Smtp-Source: AGHT+IFBx0fNmEgiQthzAlpMH4F40IVe6eGZu2FBLlSysev0+wG7SqfOtkvNjIGeE/XEwgNUmsfiWQ==
X-Received: by 2002:a05:6830:3483:b0:727:4576:36f9 with SMTP id 46e09a7af769-730061e81edmr6260327a34.3.1745199238227;
        Sun, 20 Apr 2025 18:33:58 -0700 (PDT)
Received: from localhost.localdomain ([2603:8080:1500:3d89:a8f7:1b36:93ce:8dbf])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7300489cd44sm1267588a34.66.2025.04.20.18.33.56
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 20 Apr 2025 18:33:57 -0700 (PDT)
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
	Luis Henriques <luis@igalia.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jeff Layton <jlayton@kernel.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Petr Vorel <pvorel@suse.cz>,
	Brian Foster <bfoster@redhat.com>,
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
Subject: [RFC PATCH 01/19] dev_dax_iomap: Move dax_pgoff_to_phys() from device.c to bus.c
Date: Sun, 20 Apr 2025 20:33:28 -0500
Message-Id: <20250421013346.32530-2-john@groves.net>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250421013346.32530-1-john@groves.net>
References: <20250421013346.32530-1-john@groves.net>
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


Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 443F7239086
	for <nvdimm@lists.linux.dev>; Sat, 10 Jan 2026 19:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768072060; cv=none; b=Q4eMZT4JVG4GWBBhaBInZwpigQ3Q/8uIUkA8BEh0T838WVrEpJJwdoOM7+BXIDx1yjO7hdt/adQrHsvXsSP8hCF6de4oZSuUS3nbpChdHuLzlm04LWKdNJo15X1iro145HyZd+yYKXxqa02fdg1SKy9F23w9IFI5pmrvC2li6Dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768072060; c=relaxed/simple;
	bh=91y8DlsGHvFqSo1YPUhYH5DfNbwDctVaD99uH0fOzzI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Jp7L6ePiiQxmwUjeI1porRpaFYDTjdUhcbRZYILUvuVXsX3k8mzppLzrD5Ll6a/p+BO/Efj+12/7GpvKyJfg5wKRZ2JMvwKx04vj9e1VGoILRw1z9Xpb4FL6KBkixR46LrTc9LY59rNYFwLB+SHdRlauGuPUeLrdcjLJWZV9vsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dZSgTxov; arc=none smtp.client-ip=209.85.167.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dZSgTxov"
Received: by mail-oi1-f169.google.com with SMTP id 5614622812f47-45a84c6746cso872449b6e.1
        for <nvdimm@lists.linux.dev>; Sat, 10 Jan 2026 11:07:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768072057; x=1768676857; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=1kxXWJvr37TXUuYsr8iBFLGiGmenc+CVNu+9/LLD/pI=;
        b=dZSgTxovfWHpIDt3To0DabEwiZzWSrgNksItiCk24oXwWrX6EGB+jOuCtFflG1Jvj2
         eNMZibCeQJmNDZSJwd07xk5c9U+g27iSVUAExzYZKSQijn9a8yQa3kcL6P8UpJyg64KQ
         cAZmjgaWAEDvbSFMnyamifIRgMye0L/P9EDt+m12rArULtmKYzPtiiyszXDzvgDILP0U
         7qY4NU7nHQJq9GqqY6pEH+YxPoYNAXX57kPmtHCb65Ukh4l+n8sSRSVQEf4Kr7PFLNLj
         3IZ4vROZ22y1Q4DnAu8FwtVgwu3XQWeelEsFfoe+UR+Mli6jeF5vHo1s91kzKv7f6COT
         q3yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768072057; x=1768676857;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1kxXWJvr37TXUuYsr8iBFLGiGmenc+CVNu+9/LLD/pI=;
        b=uCZklg5Vij7oCLALxtlxyrEOQcCbnC9f2QQ9NYLVidMi+zh1YCBeVTui25jMnBD9vD
         fFfozQvM86AgvHZySzbEhOlKbkjjioC1V0tyrgNtPuGtQeHVFqg3ck0CDFykkgk7ZOpm
         N7Jmtx+doM6oFNwVI9UNEFkz5FT4KY95t1cLrS0bdlbRrcN4SSWdNuSiEo9u/TNI63DV
         tsxBOppIlF+rV5HeLgdpoNYwu3uew7goN/F0/Hm1OmtM/nv1grAUX6c0LdgFuIwqSyrn
         UU/qVk2DnzPFN9eXLJKCPoylJ13DwYNBQJoKywYbvh9QZC3m0HUXUeSfalP4igHKo13C
         yI1A==
X-Forwarded-Encrypted: i=1; AJvYcCXNzrfzRqoxWkenMatkbEz+G1keussoVD+pgKtSkiR9x/FfdoN/UpS9qieryYpAbH2Dlwv7hzY=@lists.linux.dev
X-Gm-Message-State: AOJu0YxK+/6b6klknr3f7FLuV0zw0pKWdJDye8bUPPtGCcjg3tGTVNls
	86RHZwxzHQwOV6ICTJo9PN0r++8q0BWJEtZ+pF4W0L6zztV/QE+c5trs
X-Gm-Gg: AY/fxX5kPDaQa86ZANxBZTTS13RciPWgCNcAJZanZhfdnK9XqrltdgNwDDm1pkvshVW
	x15p3MaUYWTGbKmQ5LabB4uL/5f0z7i3FRheWROcsuvHCmudECb4OQNnby6qGkPHsBUOADdAcPC
	uquv5WqsDlVe0/dfdOdHZ2lL/izVoh3QGNrTBSuJS27FPnNwsdqfgaNF0Xi8d4xCuIfngy2VYJY
	380EgomTe6zXiG9EZqcQqCaqFr2Y/uRvgNY+q8aHmjLgwgwCnWNsojAttIph/Fl2eiR9WJjXMmu
	q63230aU7q2dBX4DA1qzAK0Wc6pUJcfhRoyLyY8c4MNcVmRmvywNQWv5VGqiy8WwpaNcTykEJH7
	LlOKY/TljHxOjbOOYXQVE/h+I/tW88CUTtF6EhnAlUXaSd5qhmEIW+AegonSEHZ7M7B0MgJ2WWc
	3fC7fGYk5/LBEM6swjfnmlWL7Mo/ML11+7m2qwp3+nyHQc
X-Google-Smtp-Source: AGHT+IHF3kxlvFCYdu1TdAxwzT3/VhpgRW+MaVF+0hexls3iOlpvZgWGzL6a5rAL1q7LEdZ1m6hFrQ==
X-Received: by 2002:a05:6808:2445:b0:450:b8da:b800 with SMTP id 5614622812f47-45a6bf119c0mr6228889b6e.47.1768072057069;
        Sat, 10 Jan 2026 11:07:37 -0800 (PST)
Received: from localhost.localdomain ([2603:8080:1500:3d89:7d36:1b0c:6e77:5735])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-3ffa4de55ffsm9254775fac.2.2026.01.10.11.07.35
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 10 Jan 2026 11:07:36 -0800 (PST)
Sender: John Groves <grovesaustin@gmail.com>
From: John Groves <John@Groves.net>
X-Google-Original-From: John Groves <john@groves.net>
To: John Groves <John@Groves.net>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: John Groves <jgroves@micron.com>,
	Joao Martins <joao.m.martins@oracle.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	David Hildenbrand <david@kernel.org>,
	Ying Huang <huang.ying.caritas@gmail.com>,
	Aravind Ramesh <arramesh@micron.com>,
	Ajay Joshi <ajayjoshi@micron.com>,
	venkataravis@micron.com,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	John Groves <john@groves.net>
Subject: [PATCH] Add some missing kerneldoc comment fields for struct dev_dax
Date: Sat, 10 Jan 2026 13:07:23 -0600
Message-ID: <20260110190723.5562-1-john@groves.net>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add the missing @align and @memmap_on_memory fields to kerneldoc comment
header for struct dev_dax.

Also, some other fields were followed by '-' and others by ':'. Fix all
to be ':' for actual kerneldoc compliance.

Fixes: 33cf94d71766 ("device-dax: make align a per-device property")
Fixes: 4eca0ef49af9 ("dax/kmem: allow kmem to add memory with memmap_on_memory")
Signed-off-by: John Groves <john@groves.net>
---
 drivers/dax/dax-private.h | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/dax/dax-private.h b/drivers/dax/dax-private.h
index 0867115aeef2..a7c4ff258737 100644
--- a/drivers/dax/dax-private.h
+++ b/drivers/dax/dax-private.h
@@ -65,16 +65,17 @@ struct dev_dax_range {
 };
 
 /**
- * struct dev_dax - instance data for a subdivision of a dax region, and
- * data while the device is activated in the driver.
- * @region - parent region
- * @dax_dev - core dax functionality
+ * struct dev_dax - instance data for a subdivision of a dax region
+ * @region: parent region
+ * @dax_dev: core dax functionality
+ * @align: alignment of this instance
  * @target_node: effective numa node if dev_dax memory range is onlined
  * @dyn_id: is this a dynamic or statically created instance
  * @id: ida allocated id when the dax_region is not static
  * @ida: mapping id allocator
- * @dev - device core
- * @pgmap - pgmap for memmap setup / lifetime (driver owned)
+ * @dev: device core
+ * @pgmap: pgmap for memmap setup / lifetime (driver owned)
+ * @memmap_on_memory: allow kmem to put the memmap in the memory
  * @nr_range: size of @ranges
  * @ranges: range tuples of memory used
  */

base-commit: 9ace4753a5202b02191d54e9fdf7f9e3d02b85eb
-- 
2.52.0


Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55F3B762D2
	for <nvdimm@lists.linux.dev>; Wed, 14 Aug 2024 20:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723668797; cv=none; b=nFipEZnWT9yBdZu0TQsM745oMFUAS4FnGQ3A2b5W9d8JGQI3mMXDRX/bm3Ezl+na+PzBlKf0yypcBqY0hUfN+8SkQlqSoqMKORIl81WxfPhUyBlRhp01GnNaNn81hzRQ8tKtdwtd9QBP4/s+oaFj1b1KEkiOF+faw4S4ubpSesI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723668797; c=relaxed/simple;
	bh=SJWzwyGlv+Nc8gQ9e5HFpvciRIYV9HLX1vztKo86ilg=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=NvKMZ1Y399GSXfc4bjMjV937kri4EWYQmVlJRDAOGNr9cDojWQsZggbR6GBOkCvvFKmlMxsU3OJdly0wI0/SwlPnQ3Y5/4HLTL5gpQe4fNvnOmo7I6sAKnH2VIWdYaVGa26fZiFtO4P4FS4vAC5szTYkW0pEtSCUDWsAnuthxOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--kevinloughlin.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ErBbYmoR; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--kevinloughlin.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ErBbYmoR"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e0e78047c98so497084276.3
        for <nvdimm@lists.linux.dev>; Wed, 14 Aug 2024 13:53:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723668795; x=1724273595; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Ot60Zu88uKZNlfK9OMlOraVIkgp3HHdV4RVMLpS6rbU=;
        b=ErBbYmoRdE8C02gX3+yKdprhMoPcevJWUA9L2WO0rtREiDDunQblIHazllTZ2B21NA
         uJEYMw+6dNfXdhUHlUQgIrPor0D9v7EV2GtObiygqMzNTJWcENsBUVKacGhPd+nuk6A+
         iknldSId1Ppmzu/fAx2HK+Itd37XjiSotenlXWUWoCHlTWCl+mpDseIb59hXsNr0Jgfg
         8y2D2lQO7qlnUa6H9zst46S5Csa/tUaPE5TpvN/KhDwbPfKCwHUYRU4fZ5uUsehPrRf6
         Wpo4guzl9gReiI5I1N6a6UnAXafDFoNsgqkPSY+q72nkhKB8RHziFlOkU96rRuol58PW
         LD3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723668795; x=1724273595;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ot60Zu88uKZNlfK9OMlOraVIkgp3HHdV4RVMLpS6rbU=;
        b=AZxRIMAhWR28Ak6aH9v4J3wCxu/14iI99GlBTEVfoc5WKqQUBR1gK4MhWNZZPRZyI4
         hTwVGxKdHS6AZvqYrFjGUjeowGLtd8BgqkSC7wiae2UKvPS8cm4+0uC7E4U+PFoTyaR9
         qyfjEjx5ANre4pDUGV949Y0jtxNUxZdaCeMqYSmeVcM6aSGOy5zcpykFT0UqNnl/LV8u
         zjPVZQ/hEr4EVwouMbU7UmnB4SMzzM/RjKrxXzwp8gsucg8Nqw4wvWA6qhYWsLFbdnIZ
         NflwFGPdBx07vCBlm8oso9GSmTal7v0XWPjpWxIjn9nj2JVXGUdqNXN99xgXnDPJXag3
         ANCQ==
X-Forwarded-Encrypted: i=1; AJvYcCXTWMs2aDbuBnQOl7ZTezWE8Uj/j6WGjjv9CcVeaUiPi+PQhiNZj14UPbJj+N556U1OeBkYxtRXdupYoUivc2kmne5uZwN7
X-Gm-Message-State: AOJu0Yy1HjratVDWmzeXIeKv2gGOsvpgNQkVVll2ZnyNhuaaj/sQWitA
	9ARThH0ngv6Bf8hUghP7Vc7CuczT1fCoGM9R2K2pHbRNwdyU7gCDgw5cIKAMbxRxPFO14bQOqOc
	ClrdkIUaRRx/0bjtXYKgmW3e4naWL/w==
X-Google-Smtp-Source: AGHT+IF3FJYsJiZdSjFbLc4zj2uVgVm96Hcc4lwSXgcRcF+ygJlB0qbJStfqMb0ucTmmZUVCnN+uNRAAN6/Bd1XHq17W
X-Received: from loughlin00.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:1b6f])
 (user=kevinloughlin job=sendgmr) by 2002:a25:e4c4:0:b0:e03:6556:9fb5 with
 SMTP id 3f1490d57ef6-e1155ba2c78mr59475276.11.1723668795372; Wed, 14 Aug 2024
 13:53:15 -0700 (PDT)
Date: Wed, 14 Aug 2024 20:53:03 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.46.0.76.ge559c4bf1a-goog
Message-ID: <20240814205303.2619373-1-kevinloughlin@google.com>
Subject: [PATCH] device-dax: map dax memory as decrypted in CoCo guests
From: Kevin Loughlin <kevinloughlin@google.com>
To: Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Cc: kevinloughlin@google.com, changyuanl@google.com, pgonda@google.com, 
	sidtelang@google.com, tytso@mit.edu, pasha.tatashin@soleen.com, 
	thomas.lendacky@amd.com, pankaj.gupta@amd.com
Content-Type: text/plain; charset="UTF-8"

Confidential Computing (CoCo) guests encrypt private memory by default.
DAX memory regions allow a guest to bypass its own (private) page cache
and instead use host memory, which is not private to the guest.

Commit 867400af90f1 ("mm/memremap.c: map FS_DAX device memory as
decrypted") only ensures that FS_DAX memory is appropriately marked as
decrypted. As such, also mark device-dax memory as decrypted.

Signed-off-by: Kevin Loughlin <kevinloughlin@google.com>
---
 drivers/dax/device.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/dax/device.c b/drivers/dax/device.c
index 2051e4f73c8a..a284442d7ecc 100644
--- a/drivers/dax/device.c
+++ b/drivers/dax/device.c
@@ -11,6 +11,7 @@
 #include <linux/fs.h>
 #include <linux/mm.h>
 #include <linux/mman.h>
+#include <linux/cc_platform.h>
 #include "dax-private.h"
 #include "bus.h"
 
@@ -303,6 +304,8 @@ static int dax_mmap(struct file *filp, struct vm_area_struct *vma)
 
 	vma->vm_ops = &dax_vm_ops;
 	vm_flags_set(vma, VM_HUGEPAGE);
+	if (cc_platform_has(CC_ATTR_MEM_ENCRYPT))
+		vma->vm_page_prot = pgprot_decrypted(vma->vm_page_prot);
 	return 0;
 }
 
-- 
2.46.0.76.ge559c4bf1a-goog


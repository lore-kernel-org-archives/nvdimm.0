Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5395315532A
	for <nvdimm@lists.linux.dev>; Mon, 11 Nov 2024 08:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731312288; cv=none; b=AmBBmEt9og189kBmtbTn4D1wp12fO1rlwJ0U+mcwYcNWlKbxaplCTLI1vEoy8yi6rmNtn2r/ikG/BAglMfsEe+bS6sk+4LmdcEU8p4tUqrcmOfkxmeW/R1LCpvqOK014iw1jJyFjKXuuwCBCpr96R3WrFHwqe9Q3M5pKKd6yBSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731312288; c=relaxed/simple;
	bh=FWuw35zTuOKihJHzlCpRNKQMqJVYA/pDbaVVTKXkXnY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=NuSAPb3cQfpDvVPq7LrkS6xtu+/RhmTNhAQ5cFKJuq/tZ+aUV+AbItXbOYgQzXKp5n/EvS8GpK4imshl7Xl2FIicYY1PU2FmR9QqtZ3KQQ9eV3ka7pI1a+Hz0iX75fgE9yY11LjA4mKJyIZQJy7Jqp/Bat/TChFeln+jjJS5+H8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aqwE7Mtm; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aqwE7Mtm"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-20c693b68f5so42819565ad.1
        for <nvdimm@lists.linux.dev>; Mon, 11 Nov 2024 00:04:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731312286; x=1731917086; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3UT6ZfI59cRDazAWHMhRwJefY/Lo29/Jrx3Vk/czny0=;
        b=aqwE7Mtm4ePO0y1/S/3Iipy8cvJPGrwEXLVWgq8iPrSVedwK7iGBm5HHeMuVDWGQPE
         +z0YQZb66R7bN2goeOVCviRKmrQ428Qg0573QxOO2dZzlxCm504OpJZWpbRUbGXR2gjL
         Q3r1Y2MKblaURIAiFopoaVMK8sApPln0CscYFBbW30LN8TSjuTxOnPoO6w45ZA9yOgUA
         LGCbQMKy4t9o5g1cIa0eu8O8BS+EoSWJkqF65mfZugF06bJReP6m/VRYFAsTtVX8ThgJ
         nI8V1r0QeQPEAOJnpllxz1/rNOIJI3d7CUQGsjuUMuE46QKyvotYXtUgBZtdnxIuyGie
         4AiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731312286; x=1731917086;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3UT6ZfI59cRDazAWHMhRwJefY/Lo29/Jrx3Vk/czny0=;
        b=uI8J7iMMyCNgeV/vNvOgHqi72M6TMCsCSGyWDF6NezI/AFhHhTB5L3n4u5D8hHaWNf
         Ee6kGqYNMDR4ksG4/4PryGv4ZLOj7pPIpDAdkuYifhaudIyjGKfTgDzlP5Rn4cuZILQV
         ipoOIv1flpkmfLNeu+DbnBsqVys+6fKIijV7DOGx/X0gRot11AFi05iv1OPKeNoGvQUP
         WgMXpHKQPClco/AHIYu6gdUAm2WmPcjPtNt8k5ZM4FFMGThqhf4+WgNqEc9vzdtg8HIG
         56paZMRyOuCN9dzdNQ+A/fzo8dEYsKtLYxdpdWOn1G/3N3vF57gSfkJ9kXXOLq8mp/kB
         U6jw==
X-Forwarded-Encrypted: i=1; AJvYcCX8LLeUV5jzDlz7FqR8qruXRb0BPUut2wYOIoSmL+vdWbzlu0ffNb/rH3dgcLkcw1X+VlmJWC4=@lists.linux.dev
X-Gm-Message-State: AOJu0Yydpo55CIqVF0uS9QE5PHFKRyWscZXflyvJK1bON8NEVesP6brR
	ffQm+fXSJwMZ7VoOTB6l71T7akViRSRSxn66ovnc1fKw60FG33oV0miBURMGsus=
X-Google-Smtp-Source: AGHT+IF9aCi7YVWolUezV0kEH14eAYavYX0IFCbOuS9oCD/EYTdHBk6SwYCMWY+FmzpFdW+e2+YBHA==
X-Received: by 2002:a17:902:c942:b0:211:a6d:85dd with SMTP id d9443c01a7336-211835d9930mr158383425ad.47.1731312286442;
        Mon, 11 Nov 2024 00:04:46 -0800 (PST)
Received: from purva-IdeaPad-Gaming-3-15IHU6.. ([14.139.108.62])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21177e6c96fsm71061485ad.255.2024.11.11.00.04.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Nov 2024 00:04:46 -0800 (PST)
From: Suraj Sonawane <surajsonawane0215@gmail.com>
To: dan.j.williams@intel.com
Cc: vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	ira.weiny@intel.com,
	rafael@kernel.org,
	lenb@kernel.org,
	nvdimm@lists.linux.dev,
	linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Suraj Sonawane <surajsonawane0215@gmail.com>,
	syzbot+7534f060ebda6b8b51b3@syzkaller.appspotmail.com
Subject: [PATCH] acpi: nfit: vmalloc-out-of-bounds Read in acpi_nfit_ctl
Date: Mon, 11 Nov 2024 13:34:29 +0530
Message-Id: <20241111080429.9861-1-surajsonawane0215@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix an issue detected by syzbot with KASAN:

BUG: KASAN: vmalloc-out-of-bounds in cmd_to_func drivers/acpi/nfit/
core.c:416 [inline]
BUG: KASAN: vmalloc-out-of-bounds in acpi_nfit_ctl+0x20e8/0x24a0
drivers/acpi/nfit/core.c:459

The issue occurs in `cmd_to_func` when the `call_pkg->nd_reserved2`
array is accessed without verifying that `call_pkg` points to a
buffer that is sized appropriately as a `struct nd_cmd_pkg`. This
could lead to out-of-bounds access and undefined behavior if the
buffer does not have sufficient space.

To address this issue, a check was added in `acpi_nfit_ctl()` to
ensure that `buf` is not `NULL` and `buf_len` is greater than or
equal to `sizeof(struct nd_cmd_pkg)` before casting `buf` to
`struct nd_cmd_pkg *`. This ensures safe access to the members of
`call_pkg`, including the `nd_reserved2` array.

This change preventing out-of-bounds reads.

Reported-by: syzbot+7534f060ebda6b8b51b3@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=7534f060ebda6b8b51b3 
Tested-by: syzbot+7534f060ebda6b8b51b3@syzkaller.appspotmail.com
Fixes: 906bd684e4b1 ("Merge tag 'spi-fix-v6.12-rc6'")
Signed-off-by: Suraj Sonawane <surajsonawane0215@gmail.com>
---
 drivers/acpi/nfit/core.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 5429ec9ef..4a2997b60 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -454,8 +454,13 @@ int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc, struct nvdimm *nvdimm,
 	if (cmd_rc)
 		*cmd_rc = -EINVAL;
 
-	if (cmd == ND_CMD_CALL)
-		call_pkg = buf;
+	if (cmd == ND_CMD_CALL) {
+		if (buf == NULL || buf_len < sizeof(struct nd_cmd_pkg)) {
+			rc = -EINVAL;
+			goto out;
+		}
+		call_pkg = (struct nd_cmd_pkg *)buf;
+	}
 	func = cmd_to_func(nfit_mem, cmd, call_pkg, &family);
 	if (func < 0)
 		return func;
-- 
2.34.1


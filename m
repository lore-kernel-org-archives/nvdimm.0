Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5168F1D5172
	for <nvdimm@lists.linux.dev>; Fri, 15 Nov 2024 16:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731688954; cv=none; b=l3/k3SCWjKI072PUEd4wCQKAsvpgdtwvUicHU/u60U4KsoCUxH4rydu0AJ88uKBoh/QDPFn/XpvquBK1CMVHEXErbLpMBzhvWbkoQtlsxvuLEdpGlNRVG+J+4xpoPDxzSmCsR49aOOvQfFMrRzcaxBSS0g7OKteXzY+Rk6Ec57o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731688954; c=relaxed/simple;
	bh=eGCZvEmA7ie7pKdU66pNqnQZp8Z9obRQA7YclCEYj64=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=IqnDlksC4xxwh7faMZ105pg0Nyb/kTiRSAzAKNZO59jI1qLPbMjV7Ux7xm1RKrKhfJgfUwA1Ic1a6Qyi9xVB/GB4QqUHdu3tIRmkCcHBL7RZOiLjM2Y8dU1Rj3SmmGEih/RpPaU9+IrLoRQbZMJ9aF2AYu6wXesZ31a98vfhHXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DRJsIRcG; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DRJsIRcG"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-20cdbe608b3so22579265ad.1
        for <nvdimm@lists.linux.dev>; Fri, 15 Nov 2024 08:42:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731688952; x=1732293752; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=TODZ+AXcsK9cjGMUdNaxyVTGCoF9DGWEPGU3RYo2xFg=;
        b=DRJsIRcGsT13ruh/C08wx7j+llePgJuT8MmfNyby0rJsE9w4Z733Z+gHkqzWLOuyFn
         QoZSUTbSS/19iZpzZoXl8jc94UlEeGfR9QcRwsnGigazmbzulyImqckCIWU0HL0PyOJs
         +62V64aIZVSkbf8RQvmRS3dwSG9kJuFoYpapS4/PZfLcj3NNVo8rsOR6yYjWITZDKxL/
         XQch9gn1PvTzX8k9IWbgm3RFWaY/IAIaeslzxaXSl+SodGR3yipfpnV6deZyBKLfYvQ5
         EUwP6t/x8zlJlh+SthkTnAhM+ql5GRpZ+x4BvWVyWl5HoywylZwOTejeoMWd4vdt2SeF
         fE+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731688952; x=1732293752;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TODZ+AXcsK9cjGMUdNaxyVTGCoF9DGWEPGU3RYo2xFg=;
        b=jL4nqQeRr4JjdxfnapodebnbKrgfpNEVgq/7jbNxCjaHzRcmFVBReh3D3+Bt1ESw2x
         Kw4jbz1Dzbs2r1W/BzHEX9ZFVZmIDAtTwVBwmHQbhWp1IviQoitmpgb+PNYQNfh83oh7
         F4Vp45VBcxxCaaoT6U3BwAgWBHei+UmMElY8+BeeBcEtSWVZcOUPHvAJKgjHKTTKfs9I
         spidJ9tZzjcQ3T8p/yzyqwad3PzxcAEcfD837ONsP/RbKD6bcyMwQ+Tylhp5o/b/+ivt
         DCdBsLOYGR+97qhFGfHAZWN3iSDanub5Pgm6WhtIiBz450/t3XbZ4l9+DG8i6exEfGY6
         lMrQ==
X-Forwarded-Encrypted: i=1; AJvYcCXBSspStuOl95qY3d1MgRsO28LUgonH8/9OgvVAnI46+CxLAS3/+2oxX7Z6yE8cdBAnnbD1/lM=@lists.linux.dev
X-Gm-Message-State: AOJu0YzN6fame8mzlBiKdukXKvauA802qjONwn/EQuhdnzoXkmb4ISSB
	hJoQHLC5Wtmz7fO2tfketZeH6+Fz9+frwf6Nq7fF83FgWDDipx2s
X-Google-Smtp-Source: AGHT+IFXVEq2Os8nSZr+X/xzuwmlc1jAw5JYzx1aeop97PjJb18gp5M5i6T7dsafCr4jsCVhF8YItA==
X-Received: by 2002:a17:902:e886:b0:20c:b606:d014 with SMTP id d9443c01a7336-211d0ebcc2emr43947885ad.44.1731688952479;
        Fri, 15 Nov 2024 08:42:32 -0800 (PST)
Received: from purva-IdeaPad-Gaming-3-15IHU6.. ([14.139.108.62])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-211d0f32008sm14351125ad.157.2024.11.15.08.42.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Nov 2024 08:42:31 -0800 (PST)
From: Suraj Sonawane <surajsonawane0215@gmail.com>
To: dan.j.williams@intel.com,
	vishal.l.verma@intel.com
Cc: dave.jiang@intel.com,
	ira.weiny@intel.com,
	rafael@kernel.org,
	lenb@kernel.org,
	nvdimm@lists.linux.dev,
	linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Suraj Sonawane <surajsonawane0215@gmail.com>,
	syzbot+7534f060ebda6b8b51b3@syzkaller.appspotmail.com
Subject: [PATCH v4] acpi: nfit: vmalloc-out-of-bounds Read in acpi_nfit_ctl
Date: Fri, 15 Nov 2024 22:12:23 +0530
Message-Id: <20241115164223.20854-1-surajsonawane0215@gmail.com>
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

The issue occurs in cmd_to_func when the call_pkg->nd_reserved2
array is accessed without verifying that call_pkg points to a buffer
that is appropriately sized as a struct nd_cmd_pkg. This can lead
to out-of-bounds access and undefined behavior if the buffer does not
have sufficient space.

To address this, a check was added in acpi_nfit_ctl() to ensure that
buf is not NULL and that buf_len is less than sizeof(*call_pkg)
before accessing it. This ensures safe access to the members of
call_pkg, including the nd_reserved2 array.

Reported-by: syzbot+7534f060ebda6b8b51b3@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=7534f060ebda6b8b51b3
Tested-by: syzbot+7534f060ebda6b8b51b3@syzkaller.appspotmail.com
Fixes: ebe9f6f19d80 ("acpi/nfit: Fix bus command validation")
Signed-off-by: Suraj Sonawane <surajsonawane0215@gmail.com>
---
V1: https://lore.kernel.org/lkml/20241111080429.9861-1-surajsonawane0215@gmail.com/ 
V2: Initialized `out_obj` to `NULL` in `acpi_nfit_ctl()` to prevent
potential uninitialized variable usage if condition is true.
V3: Changed the condition to if (!buf || buf_len < sizeof(*call_pkg))
and updated the Fixes tag to reference the correct commit.
V4: Removed the explicit cast to maintain the original code style.

 drivers/acpi/nfit/core.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 5429ec9ef..84d8eef2a 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -454,8 +454,15 @@ int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc, struct nvdimm *nvdimm,
 	if (cmd_rc)
 		*cmd_rc = -EINVAL;
 
-	if (cmd == ND_CMD_CALL)
+	if (cmd == ND_CMD_CALL) {
+		if (!buf || buf_len < sizeof(*call_pkg)) {
+			rc = -EINVAL;
+			goto out;
+		}
+
 		call_pkg = buf;
+	}
+
 	func = cmd_to_func(nfit_mem, cmd, call_pkg, &family);
 	if (func < 0)
 		return func;
-- 
2.34.1


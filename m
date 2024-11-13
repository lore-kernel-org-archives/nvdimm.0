Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 924542038AA
	for <nvdimm@lists.linux.dev>; Wed, 13 Nov 2024 12:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731502333; cv=none; b=SZDkvF1m9QnNNKfXMIvT9AKXLyTyOiNba7uwbxO78X9KiTrEcKsebKwviA8l6erKmMsBOSjzyGzSx9ikW0weFxYjjBhJoK0JcqMtRjnWdFldzPM0ymEk4M1VcA64796aM4WytYt7onw4ecserhklSNQDPiBB9j11DTGosGi/QSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731502333; c=relaxed/simple;
	bh=IOO+gahwY6lUx7jzJRo2ttmcb/P3yYcCsKHSCzWDji8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Nnv+pblyXqeQU8PP+HWolGTN2/BP057kxg6rbmgrZonE/XS71ZaQgV0mA4IZ5hN5Oy3AmQ78UshCrUrde5wbOpeNbDdPf6USffuQgTJzwXEcx6a1SgMUjSgLPxXYttFmPN0ylbz6JHsZWxBWtfYerXlIt4aae4MPLc/gZ7V9tyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UWMJX19d; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UWMJX19d"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-2e56750bb0dso5020717a91.0
        for <nvdimm@lists.linux.dev>; Wed, 13 Nov 2024 04:52:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731502330; x=1732107130; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fXfaqI+XhSuEYFsBiNURhzLUN5JAhtELIqV1xO9NeS4=;
        b=UWMJX19dRIkLlfae4kGhV7Bm1x29op/wH5ZmKY5magoibXmAvWRY9E1sTCMg28c0AD
         bzdK+WK+N86H5xYCH5bvDN9RxxJH38l6o682jK1ggV9XUFwbjYo8QTUV6OGww1jFrhV/
         Hnvv9ipee1VwA2zqfuZGrBno3ukijHc4QeSJ3ppdZVZ2td0qHSMzA6MtHWDcGXHeYk9o
         b7xpZDwp8FZiDrglwKJ1aY97ynl5C21lUwzS/LX02LKuJtX0KhaY6ztaeoM/Qo4+hsi5
         4nDjh/bPZknT8lnaD988aEU10iRB/6RpB/pPIDQbl0GF84SNHMIFrMTLkP65xmzl93PN
         JIaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731502330; x=1732107130;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fXfaqI+XhSuEYFsBiNURhzLUN5JAhtELIqV1xO9NeS4=;
        b=PIxApAjibaN92SSdw1cIW6EU10Iu4aww7cdv14dNoRrLwhNv/kdk5HUPJwnTtPgo0x
         Wmb4VfyNGLUV7RmznAvJavMy3QSN5aNhk2/N+7hMAEeypT+qL8rlTu5CMFNtrxMM3TnO
         DulyA3J09cLQxA1TNgy8tc8Ltwpa6nmWlrLYPMklMGE5WjkWlZtffvUbBqyaXsXwmiKx
         QsAKaW036Qw8Qd91mqXRehynhmqZY0yVN2WekukTOM1YmF1WDo7xv0fhhI6c0eVJhu17
         HYw0HwRKicQ8wRpj8zI00+Y7BtfrTnQxLWUwr6TdbWNn7H3DSRRAw9KOiHKXs3C12DCe
         8Oyg==
X-Forwarded-Encrypted: i=1; AJvYcCXYBEB0IAiyeJFazSGxPaZgbhLjNkqIKcSxNROf+ftcN3NsqCGd9OLOWyjMG0KogWZXetyptZA=@lists.linux.dev
X-Gm-Message-State: AOJu0YzZhA2kZ6r3sjyiquCDYK5w9NXpqGIHNL+2NYxxgJlCp8mIi0d3
	JaAzKEJ/qclUp3PYA4WfOA4uZ8L7Fy5BPUCxCzqFtRYrAShBBuLa
X-Google-Smtp-Source: AGHT+IFezAIWYeQpIbbXmbe8WTIeLbdz1LgWEQWUIyHbss2jQ4NdhgbFSjIKCtuVZbAeXWoyERtmAQ==
X-Received: by 2002:a17:90b:380a:b0:2e2:bd34:f23b with SMTP id 98e67ed59e1d1-2e9b178fd9dmr25130667a91.32.1731502329524;
        Wed, 13 Nov 2024 04:52:09 -0800 (PST)
Received: from purva-IdeaPad-Gaming-3-15IHU6.. ([14.139.108.62])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e9f3f1138dsm1354513a91.35.2024.11.13.04.52.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Nov 2024 04:52:09 -0800 (PST)
From: Suraj Sonawane <surajsonawane0215@gmail.com>
To: dan.j.williams@intel.com,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	ira.weiny@intel.com
Cc: rafael@kernel.org,
	lenb@kernel.org,
	nvdimm@lists.linux.dev,
	linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Suraj Sonawane <surajsonawane0215@gmail.com>,
	syzbot+7534f060ebda6b8b51b3@syzkaller.appspotmail.com
Subject: [PATCH v3] acpi: nfit: vmalloc-out-of-bounds Read in acpi_nfit_ctl
Date: Wed, 13 Nov 2024 18:21:57 +0530
Message-Id: <20241113125157.14390-1-surajsonawane0215@gmail.com>
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
buf is not NULL and that buf_len is greater than sizeof(*call_pkg)
before casting buf to struct nd_cmd_pkg *. This ensures safe access
to the members of call_pkg, including the nd_reserved2 array.

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

 drivers/acpi/nfit/core.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 5429ec9ef..eb5349606 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -439,7 +439,7 @@ int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc, struct nvdimm *nvdimm,
 {
 	struct acpi_nfit_desc *acpi_desc = to_acpi_desc(nd_desc);
 	struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
-	union acpi_object in_obj, in_buf, *out_obj;
+	union acpi_object in_obj, in_buf, *out_obj = NULL;
 	const struct nd_cmd_desc *desc = NULL;
 	struct device *dev = acpi_desc->dev;
 	struct nd_cmd_pkg *call_pkg = NULL;
@@ -454,8 +454,14 @@ int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc, struct nvdimm *nvdimm,
 	if (cmd_rc)
 		*cmd_rc = -EINVAL;
 
-	if (cmd == ND_CMD_CALL)
-		call_pkg = buf;
+	if (cmd == ND_CMD_CALL) {
+		if (!buf || buf_len < sizeof(*call_pkg)) {
+			rc = -EINVAL;
+			goto out;
+		}
+		call_pkg = (struct nd_cmd_pkg *)buf;
+	}
+
 	func = cmd_to_func(nfit_mem, cmd, call_pkg, &family);
 	if (func < 0)
 		return func;
-- 
2.34.1


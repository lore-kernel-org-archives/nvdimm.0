Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 836B161FD7
	for <nvdimm@lists.linux.dev>; Tue, 12 Nov 2024 05:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731388847; cv=none; b=ucOmh4aoI49VBxXnITCM5zE7H4zqRH9xFmDz5O/sCOtWwFfEiGVPceu0AqcdSkvvBa1VA0jx2N0zB9pz5XbzwWLmsE30zmFapcY/30SHwVj7zCvultkGoun+oRNnByJYeFo4XTP5r2/AYHCResV4yEB2/ip3rROFJB8kF6YENnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731388847; c=relaxed/simple;
	bh=xYGzH9hAlrxBlbHGfPc0XgIXYM4XAfbRpAuBzkRUnz4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=mx0h9uj6fUkc08rYGkju5+r1cvqn0SpqGfBsZ9aCIkPgNYNqOU/ZYuW/Qi5t3CGVvo08JSSVn0JG6o75xs0tAiGGnwFXzOc8hnDmb8sQgXVPWyjJP/Ef0tITxevpsznTBZucBI6K7O/DkLwym/5mZ0O/OIQLSI/SXs6a5C2r4iU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NBIbWPc9; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NBIbWPc9"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-20c767a9c50so50455305ad.1
        for <nvdimm@lists.linux.dev>; Mon, 11 Nov 2024 21:20:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731388846; x=1731993646; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Nraq509unMAALzeVagoiRPKJbfQ4zWQzvCgRLQ6O0iE=;
        b=NBIbWPc9bXCTnfO/LBbSCG2iLE4pdEot/Cg85uF96SbPJ2Q5yyek/RgnwtJaTSFEZE
         AmjgA/3r9zzlDYMNelHZNnsBoM2DyNf5wy7TaE24xoyE8slBVPCkZnVXON8HbzRnU63w
         HYgPOE8hPsjJAThaVIBJPJydZY82nDDDfimPxvfc3FSz50rzQIsusZbxpWrwnMWBshLi
         XNWwJviSXmHtLDv5wjbJDfBTaQTVHx7l4kg82wl4e31tANwmHsMY4xZJGdD9kSkDMyvL
         YWsrFdE6l3hxVZ1SKn4pX67mySnHtHbC5IZdmvfEToBO3W9ID/hrBVKqmnneGXVzWxR5
         11jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731388846; x=1731993646;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Nraq509unMAALzeVagoiRPKJbfQ4zWQzvCgRLQ6O0iE=;
        b=l0n8vPhmQ+Ayq4cEt1h9r7Dgl8eXw5ESVouWbBWtmOBrc8bINZFErzJmNw1Uf8Q7aG
         yJ4r8af3BhSGuUA+JbYqvwRLVY1ZgathtBarj8+zTgWn16ugguc6I+10kpfnQ3+hb2+R
         Bu5sm0C2A+RWKZbZQ60XMppWBZ/cQvT6K4L0l8660FpJv56xdv0kw8W0gWZLMB3hImkX
         KNH8sMupFsyRe+wDLguRjY0ZA78lcgPcMQ/wIU8TyEC0GrdfIsPqg+S6cGinMjbIhgZr
         oVKcUW2pMWPL0V89Gout94lpaAmYqbLvHPEg927p8kvAYT0zGp0JEJSjtwpsJxrsCtkC
         Pa8g==
X-Forwarded-Encrypted: i=1; AJvYcCXMXn1bzV6AFizu4oVqNbCkZT2cCMwsCoXchMq1f63yBcxiveHo9dE7je0x/l0qwaZpek/+M18=@lists.linux.dev
X-Gm-Message-State: AOJu0YyX+o69sNWgr3RyJLNNINnsKnAkk0EoJPaxCSys9B5AjpEmP7Lt
	YKzIdCB2S5E2Odr5MXAgXkAPDWsCZ0IYAzve1F3O7ATsJK7MffoJ
X-Google-Smtp-Source: AGHT+IEqt1K+FlBqj/5RBYdoY6r0noCkeefboU76QtLTtaAGk+R/+2di6v4C395v6POpzeSOxjuQAQ==
X-Received: by 2002:a17:902:d4cc:b0:211:898:7cde with SMTP id d9443c01a7336-21183d23fe0mr185099865ad.31.1731388845729;
        Mon, 11 Nov 2024 21:20:45 -0800 (PST)
Received: from purva-IdeaPad-Gaming-3-15IHU6.. ([2405:204:20ac:21b:f63:7054:e444:2bb5])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-211af0d6f9csm1173445ad.58.2024.11.11.21.20.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Nov 2024 21:20:45 -0800 (PST)
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
Subject: [PATCH v2] acpi: nfit: vmalloc-out-of-bounds Read in acpi_nfit_ctl
Date: Tue, 12 Nov 2024 10:50:35 +0530
Message-Id: <20241112052035.14122-1-surajsonawane0215@gmail.com>
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
Fixes: 2d5404caa8c7 ("Linux 6.12-rc7")
Signed-off-by: Suraj Sonawane <surajsonawane0215@gmail.com>
---
V1: https://lore.kernel.org/lkml/20241111080429.9861-1-surajsonawane0215@gmail.com/ 
V2: Initialized `out_obj` to `NULL` in `acpi_nfit_ctl()` to prevent
potential uninitialized variable usage if condition is true.

 drivers/acpi/nfit/core.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 5429ec9ef..d0e655a9c 100644
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
+		if (buf == NULL || buf_len < sizeof(struct nd_cmd_pkg)) {
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


Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AC34191F99
	for <nvdimm@lists.linux.dev>; Sat, 16 Nov 2024 11:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731757240; cv=none; b=rtyivwkq40Bj+QUJ106aR7Elw8z3ZowsnVdaw8d2Y6be2Kbj5W8DzLGvINGgGj+jPnguRDS3HAIB9hEOSVrxW3e2cbahT9GdN7QeVIU6si0L25Bb+1HletwMtjM46JlQFFn25bVEmgH6zvrDhDugWnOJirbnnFOYlBDIcfDLNAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731757240; c=relaxed/simple;
	bh=4yqtf3TxzZLdieOGloCVo+/KNale2JTxAEniThZmU1A=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=AEMKA78ymybC+9RLILiceGRuJuVf1wc5HUwuahGV6MS6ogvuz6sAkOOujwi51niYxVzPG8sdTWFkiqqX6Z3fnbUdc+hAwlP4MaoR5EXy4hAyqO3c2nZ0VRUQCljFYbr2FHRanD5PJeAoUDLfWUAeJFFRN9FXN+p/Gga9tKkML9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kJI9J7Ed; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kJI9J7Ed"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2118dfe6042so21144335ad.2
        for <nvdimm@lists.linux.dev>; Sat, 16 Nov 2024 03:40:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731757239; x=1732362039; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=QES5ivYy4we8CGU9IJFUjy9+jaCCLBYcx/iDh9H/oSQ=;
        b=kJI9J7EdHz7dEGS3vMAVn1HUEW/oMeDYJhDIHIWN+R9iJsvg9IverLIRSDqAUfN3Nt
         4JayTaIXuJg/Pwjhqkz81LUqc/G0UDgL/RfRXYJUBv76/ZOjlpTGj0wano6NnBabwa1j
         apMOlqY8qaehNGHRweK+TK8LdMbPeaXaADsUFWYngmAm5/9ptcRHhgbI+/7dVCWYCdAj
         Ml9PtRE8EVo9WNzBqu3inQ47en1JewwqK7BgMZMQlrTx4P8ibVrTbSsEgdewVBMaYGO8
         DGv6ElsD9iW4LVvdxlggCbHBWKHAF1bydTE/E8wnGJCIEQi+CG+tPAXFpX9wHLfkWV8M
         904A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731757239; x=1732362039;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QES5ivYy4we8CGU9IJFUjy9+jaCCLBYcx/iDh9H/oSQ=;
        b=ca1rGVaHpn2f59buoQ87GFgltNbKIVY4MEWxmlBJAaONF6SCvcllUEc7La1L3bLm9p
         cueW+nlv26pph9Tz3lm7vxzvrYrmLeyoUl+lQmtAEDAwep+if9Cnkh9hMQ74J+krbtmG
         am5xnD4FbZBaKXShhZdfGNs5Vp/59mACGAGHK6ybLQe1UGeJ02FMOGriDnh33fzrkDKQ
         xO03+v5xHJylLwE5VsNkEB2TgAngF7F+2CjaYnqKQNUVW9Bfwdo5BU1IBUYAIvMCp1Ik
         khBTQqehZFva7mo0/kjVrcy5P1mocjX2rdQxp2edpBrPJE76dXYR4fyCriJRpVOLb2E0
         8PsQ==
X-Forwarded-Encrypted: i=1; AJvYcCXa9mWCJMPBnn5qvwQrpbtvnlDPFlWApJVcNoAaPC55TzzdznF/uqvURYI3CYzlizZl5lsqw94=@lists.linux.dev
X-Gm-Message-State: AOJu0YyV723VW0V7RQj2BPTLBPtYuXAuhAH5cavvEHgJbdY0o8CMPQTk
	FQXScYdiYs9Hr1sjZDmEpoZxtVejNlKyS7qFVx8OsQSD/pXNbU3U
X-Google-Smtp-Source: AGHT+IEcEqeRIULoqbB9V79aG/v2fsxloM/p8RLsB1XrG/4rD4IVC3xsTHDvM3Zh3WY/8ejIOOSrsA==
X-Received: by 2002:a17:903:2b04:b0:20c:79f1:fed9 with SMTP id d9443c01a7336-211d0d7e444mr87833935ad.25.1731757238639;
        Sat, 16 Nov 2024 03:40:38 -0800 (PST)
Received: from purva-IdeaPad-Gaming-3-15IHU6.. ([2409:4040:6e99:f02a:954f:e157:760e:3d30])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-211d0f346d7sm26078255ad.138.2024.11.16.03.40.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Nov 2024 03:40:38 -0800 (PST)
From: Suraj Sonawane <surajsonawane0215@gmail.com>
To: surajsonawane0215@gmail.com,
	dan.j.williams@intel.com
Cc: dave.jiang@intel.com,
	ira.weiny@intel.com,
	lenb@kernel.org,
	linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	rafael@kernel.org,
	syzbot+7534f060ebda6b8b51b3@syzkaller.appspotmail.com,
	vishal.l.verma@intel.com
Subject: [PATCH v5] acpi: nfit: vmalloc-out-of-bounds Read in acpi_nfit_ctl
Date: Sat, 16 Nov 2024 17:10:27 +0530
Message-Id: <20241116114027.19303-1-surajsonawane0215@gmail.com>
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
V5: Re-Initialized `out_obj` to NULL. To prevent
potential uninitialized variable usage if condition is true.

 drivers/acpi/nfit/core.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 5429ec9ef..573ed264c 100644
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


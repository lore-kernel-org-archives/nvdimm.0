Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65CC022F19
	for <nvdimm@lists.linux.dev>; Mon, 18 Nov 2024 16:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731947205; cv=none; b=ZZKs3DGxe2Ew3wfDeFPzm36jz4i7w1LVEkp4R8aR9moDtopT8wphMLJrYjXTTZxCNL2Cue0nJVh3GIAG2BBLc48KENiARLPBOXhesN0VJ/OLYNq5OR2HclEgTtNEmf9Tr74I9GNBLAihuy36dC6/JGoZd7qHURbvKLcfpFgMtTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731947205; c=relaxed/simple;
	bh=QHMLVwqjyzpJ2KbNsx+ktbIbtg5K37IdbLaSNC1Nl6c=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=cGj4Ei0biMGYhdoIL9jKydx9h2LKHYbsM9LkjT+aZzmLRsi4xkqbZ003bSWFSkVLb3dizF6ASo6LNjUuk9abHZ4bsTl76EW3CbjThc93scwkOSLBHEUfooJJeXGDYNdAgr7fikR+ZQ0dUIsp64npPR8GLl//zXZDqK/6WksawZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Gce6VkPV; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Gce6VkPV"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-720d01caa66so2938253b3a.2
        for <nvdimm@lists.linux.dev>; Mon, 18 Nov 2024 08:26:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731947204; x=1732552004; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=By9ts3alHiV5Lex/gW6NiR6HKoO44qWXwHBKt11BkXE=;
        b=Gce6VkPV+yPN7GU2u0SeMlgw//ZhfzV5X+4qMER9P4nZbnlG31vlz/le3R32f/VZBj
         96WdpnLtl0Skj3u0biGvvUNbONisj0KNXhTL2AuAo6nLt4V39IcuUM4XUBFUDSVp8O7d
         AxIxdcgWPyS5FlDnOlgOFshS6d6pANirtWm3iEKRRFkZ7COrPAjCW/DXH40JBpPCaiuS
         5xU4WVQMjpOe2N1D+50hmrhl9ePMyuXrSM/AHNMhUoQop2EcC26Ket1ifm0H7+3MrNpU
         0TGhDJbWZD9Fq8A4RQ+4iFRTbyBoUQc8jgDvu2CbDfZA87cHxpUQ/kivb0iu8w4+Ma/e
         vizA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731947204; x=1732552004;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=By9ts3alHiV5Lex/gW6NiR6HKoO44qWXwHBKt11BkXE=;
        b=cQrj/pmfStfzKq0PZ1p56CBl3ImXPOx9WqJcUSV/KoXGYt/JQCiHW4jTiL4MvoBNtG
         0xiKoGbt69Nh8cTFakamXakJlffskSwIuurgMBCSxqyDwLm0Ohf9v6THK8Rw+BkbxvJM
         N9GqGa8GLYSMC7gMrCpRGFBi2cfU6vQHgzOKFsWjL3paH+Uk8Gb6BMayhvB/eMwK2xI1
         g+zQYCuWs79MXYkqqT4MivlWrbsY8fEO3gf4ZvY6J9S+RU/Gy+WOv8Ife0QtJX++vt4d
         NwWmJrwyCCtermcTgQ/t2lYo01UbYBBnf5E9iZFjYrSbf55tUiZIJG52e8G13XrLde4x
         qEEQ==
X-Forwarded-Encrypted: i=1; AJvYcCURHJ3cUUF4i/TLSoT1VQC2jsPPouN1fQjDqzwdnjSCwo8KYxadR9psmAq5taeb0AMd8OlFULM=@lists.linux.dev
X-Gm-Message-State: AOJu0YwEHTN0jSpyjpW/Dr4+PM1hMWSm6J2MbAV42UjT643R/i4EYsUT
	myr0vuyEHpCSRoV8UcuhnKWftKyaydGxVc7pdeJwsMhjuYYKvWB/
X-Google-Smtp-Source: AGHT+IFiKgz7pu3gD4X7bzU0TJnmSTpiC+2A4HM/HOlp+lRQXsQHOsdhu2AnZV19kQuNxudWLUjyDQ==
X-Received: by 2002:a05:6a00:84f:b0:71e:75c0:2552 with SMTP id d2e1a72fcca58-724769ed786mr17680701b3a.0.1731947203548;
        Mon, 18 Nov 2024 08:26:43 -0800 (PST)
Received: from purva-IdeaPad-Gaming-3-15IHU6.. ([14.139.108.62])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-724771c0dfcsm6589764b3a.106.2024.11.18.08.26.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Nov 2024 08:26:43 -0800 (PST)
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
Subject: [PATCH v6] acpi: nfit: vmalloc-out-of-bounds Read in acpi_nfit_ctl
Date: Mon, 18 Nov 2024 21:56:09 +0530
Message-Id: <20241118162609.29063-1-surajsonawane0215@gmail.com>
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
V6: Remove the goto out condition from the error handling and directly
returned -EINVAL in the check for buf and buf_len

 drivers/acpi/nfit/core.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 5429ec9ef..a5d47819b 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -454,8 +454,13 @@ int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc, struct nvdimm *nvdimm,
 	if (cmd_rc)
 		*cmd_rc = -EINVAL;
 
-	if (cmd == ND_CMD_CALL)
+	if (cmd == ND_CMD_CALL) {
+		if (!buf || buf_len < sizeof(*call_pkg))
+			return -EINVAL;
+
 		call_pkg = buf;
+	}
+
 	func = cmd_to_func(nfit_mem, cmd, call_pkg, &family);
 	if (func < 0)
 		return func;
-- 
2.34.1


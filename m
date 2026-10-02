Received: from mail-wr2-f11.google.com (mail-wr2-f11.google.com [74.125.225.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C75894FD269
	for <nvdimm@lists.linux.dev>; Fri,  2 Oct 2026 16:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.75
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790960231; cv=none; b=bOXgo64pe+jClm2suvA1qwyX14OqyoEHU/DwC1KiQqAzPlM+CwGggXLbv/od8osru0FBtOQ74uZOLcEpAY/ftQWopD+hXNx1DyQcdSo37VnirwoJyFLdnlPWOWWdnf5+KEZ0Pcz2m6bPjID+M4K1vBdLoiq0ohYqDBp7pgmnN2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790960231; c=relaxed/simple;
	bh=DxeMUT4oVuqn3Slh/vUwWCSTkV3fjRC+t9YaTQ801b8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Wtc/EjjE1jVjvsSelewCJpwjBYR1DQcpTlbIbeAn1XKmJ8+qWLmaBy1JOnkLmytRp1b8OgCxPqrGFcwZCjSL7+AlO5h0JK4uLyFKHovXOqzpfVA2asqUAa59OkfdMfDiul9UPXyMgx4rei+OVbNt0QfUVSnzYAVPMnT1HxD2UQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QBYAi0uc; arc=none smtp.client-ip=74.125.225.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QBYAi0uc"
Received: by mail-wr2-f11.google.com with SMTP id ffacd0b85a97d-48b0a57daf6so10639f8f.1
        for <nvdimm@lists.linux.dev>; Fri, 02 Oct 2026 09:57:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790960226; x=1791565026; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=CSATVIW2jC1GbKLcdornHIOpKYy46zxyEdHFo2jVEFQ=;
        b=QBYAi0ucs2OMYOsnnwP7cVpvMoln6H0fovhRYpjgAbSzcdfVLIgNH8837CmdliG6h4
         /RaWS+o3MXUgewOuVyZ7fV9MNOclr/GCQN814vK160CkIL7n/RBrK0NrPfVhtsNWNMMQ
         UVGOS8ZEoG99kSIPLLMoCSB5f5ADrHF7LE5HbsJoaC7HBGujLVTCy8prCCjAkLjl2bjj
         Itj91JMyISegC/wBZZW/a4wD8yYKy5/q6v+FrsYp1PrFKWJe/TzrQtY/91GY0AYcQDM8
         lM07E8FBTNpop4zEg41UY32Wdv9UGPj2bRN8+FfqU5jzcvq1apImk6FeyHDBLXXTLxTL
         3kmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790960226; x=1791565026;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CSATVIW2jC1GbKLcdornHIOpKYy46zxyEdHFo2jVEFQ=;
        b=2TtWWxOctI2Rlp72XBQa+GGZ0/1FPz1cuiN2dbKTbn7OiCe+nhcRA+BW8uhhJA7aHy
         bDY90I+bzE+r2+F9ZOb/s62ZRyWbTaBhxnimNiusXV6vWssffjDwhYIFRKJbBDzqnR0q
         fWzlLAGEC80QfctT50yY1LUkr72LYaPyMbqlD7CJNrDVsvIx7FgXWyDptGs8n58+AzB5
         GuHJ0JpaJzd3u8XNzWjFkm95bY9Jo8bIrYgVNj7lccoWp/vdcrIlBhzvQCnZ4A5Vyggc
         hmUT8yd77XAT6e99yD6e3ckiYRqKjcLqg1BN7HdgikZIcC+7TgtcuErWx1ST0LlY+6QB
         WCKQ==
X-Forwarded-Encrypted: i=1; AKwUvBzFnvqXJu5hiYU1TtwP8DRKP3YRkhx5cmcE2E0Vei04YEj5tvQIMsrUcs1nv1O8NGGtoovir7k=@lists.linux.dev
X-Gm-Message-State: AFq9FYKX4Mw7Et3rNgBvqE3fKe/Ym5ntiEAeOgnIRiguSqYZmIrq5KUx
	wWGrjMCG+qAOdskeW7SDx5mCJZqAZ+dLnub6sHNWfAckPAjXOarhMINO
X-Gm-Gg: AYBFou1UN5WNZlAxSAho5EO9v430xwpocMwWFk9eUHBO9DVAaefJhQ7PdoSFVBoKVJn
	d8Lh79wGS16lHrGTfc2ABN4PYFbPMvGbC/iXaCioEizvWEPhJHnt93/ie7NtWqQ4445L9xC4F04
	JUj34+QbENoxsaVU2WVDISGOQA3YfDUMy+twWeLC4zSgDl3vCCYhijKZpyM/NzQhxkFEt2GUVNL
	G/jp0QcABWLRitdq1gBYQBaTDJ9Fzi2p++NLNiOQCidPhIMLHxHMqVFAufEAhzVp6llHbnjHv32
	ZXBgvl4ARBkABf3Yqq6RAHCt+rBynG1BXYnXCLXKBfTAD1GX+nMwgu1EfnuaEKSuzzydIbXWI6S
	D0GkkhiOZflgUX4hXO4gZXvTltFm8Zd0N/07RMSt5sHFb5wXFHY1DSaTwNo8Z3u6is/0MXS1D9M
	b8keEnZiafPdMG4QIKitdPRXvupRO5nIq8AScSwzUGBiJAyH5k6cjnsf8NIbIGRxQZsjG4rQcXu
	hKXpoA/lYXKx5c=
X-Received: by 2002:a5d:5e0f:0:b0:488:8347:a110 with SMTP id ffacd0b85a97d-48b1272892cmr4421980f8f.7.1790960225928;
        Fri, 02 Oct 2026 09:57:05 -0700 (PDT)
Received: from serhat-ubuntu.home ([212.253.192.148])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48b82253e5bsm6404644f8f.1.2026.10.02.09.57.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2026 09:57:05 -0700 (PDT)
From: Serhat Kumral <serhatkumral1@gmail.com>
To: djbw@kernel.org
Cc: vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	iweiny@kernel.org,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	error27@gmail.com,
	Serhat Kumral <serhatkumral1@gmail.com>
Subject: [PATCH] libnvdimm: Handle negative return from nvdimm_clear_poison() in nsio_rw_bytes()
Date: Fri,  2 Oct 2026 19:56:41 +0300
Message-ID: <20261002165641.14479-1-serhatkumral1@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When nvdimm_clear_poison() fails, it returns a negative error code.
However, 'cleared' is a signed long while 'size' is size_t.
The comparison 'cleared < size' promotes 'cleared' to an unsigned long.
So the error condition can be bypassed and the function can
incorrectly return success if the subsequent flush succeeds.

Explicitly check for negative error codes before comparing with 'size'.

Fixes: 868f036fee4b ("libnvdimm: fix mishandled nvdimm_clear_poison() return value")
Assisted-by: LLM
Reported-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/all/90d3d353-28e9-4f6d-b141-a9b7157d5514@moroto.mountain/
Signed-off-by: Serhat Kumral <serhatkumral1@gmail.com>
---
 drivers/nvdimm/claim.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvdimm/claim.c b/drivers/nvdimm/claim.c
index 309cd2cddb0e..2725dceaf938 100644
--- a/drivers/nvdimm/claim.c
+++ b/drivers/nvdimm/claim.c
@@ -263,7 +263,7 @@ static int nsio_rw_bytes(struct nd_namespace_common *ndns,
 			might_sleep();
 			cleared = nvdimm_clear_poison(&ndns->dev,
 					nsio->res.start + offset, size);
-			if (cleared < size)
+			if (cleared < 0 || cleared < size)
 				rc = -EIO;
 			if (cleared > 0 && cleared / 512) {
 				cleared /= 512;
-- 
2.53.0


Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD3FD29D280
	for <nvdimm@lists.linux.dev>; Mon, 19 Jan 2026 18:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768846665; cv=none; b=niaDM477y8L1zFeUQitCQifA68T5R0+0wiW/Sc9bRfhciS6j7G2dY9VF4haLPyTDbVVjyv5od7xm94MNxm7HA4deFFvXSDR3Awt3y1GGr+MQPIGaqOIVoX/UHMcpHAGpHNgduN7NxSf208HvpkfucYjednG6GNr7S1MDyc8rswk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768846665; c=relaxed/simple;
	bh=/jm4Mas2zraHDvT9PHW0pLh2gbG8Dc3XSEFgWHhsUK4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=OdxZg6ttClEsyElX5jNWawtTMvnXFMa4FhphwZFgdmNLCcmwSRdCiA/5GKf/IWGBZNAUuVSbXHyQq0ZEMs1RVdosJamvOXDn5WS2YaAvfYsKwXKuhVRywSkX4y4LPshfat05DUAAwlTx9UCT2tBfnCMpUpDjXC6KjtA93mgpguA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hFLlHSFG; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hFLlHSFG"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-29f08b909aeso10379695ad.2
        for <nvdimm@lists.linux.dev>; Mon, 19 Jan 2026 10:17:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768846662; x=1769451462; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=X2A95NLnAAenZYeB6sIfMlTKuGidxofuewRgFBA/sdo=;
        b=hFLlHSFGZTnXw3+bq+hje9boMTh/Ufg4OdKFVtaZZhTfEbUXnRkDOiUomr+SfoGI8v
         +vVMySjSUF1QYWEg7V9/+pLjLpUiOeB37ccZM1ts1SsMQrptuZbmVTCmsSDisxx/0Mfk
         b9tzHUDPPEb7CA3PgxcO/pgR+tAEOTXHKZQRn6S1M6JSPLn8+j6Fn3l1a1WYZzQnd/zl
         o/w5gCLpLHdbZBnuBBAdKDKuqJbUYwchlLJAfXm8d7OWoWjHClItxXiytNccHCYpXYcM
         SGCeMsZ4Zs5LXDTLW7LqdxIZ4rSISk4pe1Tz7NpYGukt+Jr4FN5nem02dzhwvtiS6nq1
         +YKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768846662; x=1769451462;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X2A95NLnAAenZYeB6sIfMlTKuGidxofuewRgFBA/sdo=;
        b=Z0jK4S1EHQZiWkJUeY+lwacJQaIXkp9hIdyDJDP9OLs1L0rQnx51uLIaE7E5Y45kWf
         ZjJGkNYf9ChCvwtCUNTK7OXTciPRxaLEnAr9/vtGsdzF5FR92EWmkTNWRKnsxZ3+gnue
         cKmJAbjxAALRUGm8T4qzl8JFjBVtmMsgUZkHgoojrKH+TZYVuziBBlVnDtuLf7al6QQK
         T3yNEjwH0IxWbrXUDFgSBAm+vby8hT8MhA/v8IfjteMSBVU+FTShY8dS4urb0fIooC5V
         vFi0MYGFREvAPLntSPxUZlCYZFY2f9Iwl//IqeGTzoxEMBU53exyQLHK2oUrGNDlJbIQ
         sRUQ==
X-Forwarded-Encrypted: i=1; AJvYcCW+/5mfOrGMRwBgGDiHcNe6Ldiity8YC/KDTdzqxbtSShDhal7QWIJ1uvE7RmyO9WagW5WfT+w=@lists.linux.dev
X-Gm-Message-State: AOJu0YxlYEpaT5c61vX6GZB1J73eccclIhH1Daw77blLgmW/WzRg6Phi
	Qu+K2atnDAoXmEQuYKWRpqD6G14PkfBNSXA32NQ30RjYjx5thcJTjbEr
X-Gm-Gg: AZuq6aIY9nxdlLlyyl6pAwMxAtIn1A4Cp9uVQN09D5xZSKr3iKg5sOrSoYrpzqBCvar
	/B3KR6fjyhz1Qw18B91mR7ETNspn6EskToqZGvHU/kS/g5TX9ffdSS8hWoyWLksw6iI/zSZa6H+
	lAEpdzzcdwyqjn9F6C6ncpt4Uj2hEI3I+ygJKfhsGOvFVgdH4vHFniozcdiaiMTrUxXXtqAyW4F
	AtzF8PDLteijePSG2LHzznuB33mtmZkrSqzxK60ebwdJVyfg1m6UkrhIiwBhoUZm8HyoL4JJhGD
	MMBL4wst26EPpD51f6j+Wj+ckzdeRTmuTKaP6Q3nsDvnx3WEpK4oKXzqYduilEvRObSfMaGIdrf
	wDumq3NF+OGS+3s6H1L6AZKoczMgdV7mA/GnTkssrtgcgQLOi5YgjtggLwS58VIpz1z+MTmypfK
	7ndctRJ4sYNE4xAEAbcgM69NPHaOjgz7NQxit1
X-Received: by 2002:a17:903:1a2c:b0:2a0:d07a:bb2f with SMTP id d9443c01a7336-2a7175283d3mr88983575ad.3.1768846661950;
        Mon, 19 Jan 2026 10:17:41 -0800 (PST)
Received: from localhost.localdomain ([132.237.156.254])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a7193dbebasm102334145ad.55.2026.01.19.10.17.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jan 2026 10:17:41 -0800 (PST)
From: Shubhakar Gowda <shubakargowdaps@gmail.com>
X-Google-Original-From: Shubhakar Gowda <Shubhakar_gowda.P_s@dell.com>
To: dan.j.williams@intel.com
Cc: vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	ira.weiny@intel.com,
	rafael@kernel.org,
	lenb@kernel.org,
	nvdimm@lists.linux.dev,
	linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Shubhakar Gowda <Shubhakar_gowda.P_s@dell.com>
Subject: [PATCH] ACPI: NFIT: Advertise DSM function 0xA (ARS error inject capabilities)
Date: Mon, 19 Jan 2026 23:48:22 +0530
Message-ID: <20260119181824.15408-1-Shubhakar_gowda.P_s@dell.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

ACPI 6.6 defines DSM function index 0xA to query ARS error injection
capabilities. Advertise support for this function in the NFIT DSM mask
so that userspace can detect platform support.

No kernel ABI changes are introduced; this uses the existing DSM
infrastructure.

Signed-off-by: Shubhakar Gowda <Shubhakar_gowda.P_s@dell.com>
---
 drivers/acpi/nfit/core.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 5a1ced5..8dcd159 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -2113,6 +2113,8 @@ enum nfit_aux_cmds {
 	NFIT_CMD_ARS_INJECT_SET = 7,
 	NFIT_CMD_ARS_INJECT_CLEAR = 8,
 	NFIT_CMD_ARS_INJECT_GET = 9,
+	/* ACPI 6.5: DSM function 0xA — Query ARS Error Inject Capabilities */
+	NFIT_CMD_ARS_QUERY_CAP = 10,
 };
 
 static void acpi_nfit_init_dsms(struct acpi_nfit_desc *acpi_desc)
@@ -2152,10 +2154,13 @@ static void acpi_nfit_init_dsms(struct acpi_nfit_desc *acpi_desc)
 		(1 << NFIT_CMD_TRANSLATE_SPA) |
 		(1 << NFIT_CMD_ARS_INJECT_SET) |
 		(1 << NFIT_CMD_ARS_INJECT_CLEAR) |
-		(1 << NFIT_CMD_ARS_INJECT_GET);
+		(1 << NFIT_CMD_ARS_INJECT_GET)	|
+		(1 << NFIT_CMD_ARS_QUERY_CAP);
 	for_each_set_bit(i, &dsm_mask, BITS_PER_LONG)
 		if (acpi_check_dsm(adev->handle, guid, 1, 1ULL << i))
 			set_bit(i, &acpi_desc->bus_dsm_mask);
+	dev_dbg(acpi_desc->dev, "NFIT DSM mask detected: %#lx\n",
+	acpi_desc->bus_dsm_mask);
 
 	/* Enumerate allowed NVDIMM_BUS_FAMILY_INTEL commands */
 	dsm_mask = NVDIMM_BUS_INTEL_FW_ACTIVATE_CMDMASK;
-- 
2.43.0


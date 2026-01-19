Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB3F82C1590
	for <nvdimm@lists.linux.dev>; Mon, 19 Jan 2026 18:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768848236; cv=none; b=V7DwT99C2Ng7nrjdlnowtERZ7sab2b9W6OT/KMjAud6wQ4caLY2C0fqt0FaWaP14OymTeIzH9zQlkZzzgPi2rY8QIbYGSr9yREuc1I7M1zZDdQwOBl7R7YoBnxHXqU6kCZpHfL//wjgZF95ZL35vHKeRtv32sg6LEY0ujAPXpZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768848236; c=relaxed/simple;
	bh=EORSyWTZBwNF1raDitypZ1JbYxUbDPTZfmSxwsWftPk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Rf+UlXXUBmwhv6PU3+cJP8VxFtz57Y3oiWZNNZhA6EnHfcTXtBV/TincMKCpe/615DELWqieh3EgQp1ASlDX/bulsXClt94078EPwsGngxuailRvTXIssNaSzk7AK4Cq+U8/4r1edIeJRZA30Qvr/2tvFjEZtW8JfIfXNiR9eHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mLUsGkra; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mLUsGkra"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-29f3018dfc3so9707155ad.0
        for <nvdimm@lists.linux.dev>; Mon, 19 Jan 2026 10:43:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768848234; x=1769453034; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5rQM+3IbfMPNIay1Twh0Q12FnCMhsPC2tkfESLTSnl0=;
        b=mLUsGkra4LG9VoGF5fGj0xI1zqx6Fq3mbuo9UZoALaTdIYAsLSw4ifrP4qI4TM2ZcK
         ffZ8wTM0SM+DD7daB5CRjOcuor/xgwB17rMdzRGj95lysfTD3cPM9/5q7C0cmIK3yG6B
         oz/wn/QeYI8v+Zugj0YJfNvjIX8Nh4UBO81Rv4/TIFaDq/mr6QA/qzHVuQSRWAY2Mijf
         H16Eu4meNhazg7HCqwQqtq9jEyCHvXY20e7iXdXPSiXXIaktjP5Sa2OyEM+381qLeB7n
         RTPjTqosThJWsW7IKlSYUUfK5zMgdk6I/8rUoFiExCCK0ZQ1qu9Ie43WAgpkFlMAmrLg
         HIsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768848234; x=1769453034;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5rQM+3IbfMPNIay1Twh0Q12FnCMhsPC2tkfESLTSnl0=;
        b=mAtfn/NRcQ3TUk3OXDKrhzf8a8QH4L2Wk8od6O8iYF9Ko5dQHPvbT9bIFAP4cPUQaw
         SQLq9jCrb0ivUysyjE2hYYY+gaNarm9xHSNT5CJDoohQgbqZWMW+j/KBx8UlVIfbzZdr
         3Jx+Mb1TzRspej+j0QpLKvke7SMmzFlU+zt4qdvh75w+nxgdZrIMU6clIcXg4ebyl81V
         uW3Y0mmkaoMGEAss1/ChGli7M/+addgy1TNx8gBzoFWAIWGfGjN1T1XCpe610uSMuHJW
         kbJdZQugKrOn8i3woJ5TZgClxX0tblkfeYbBkHZxbDChOnRJq9cy2iH0BJXcvtciYi92
         k7iQ==
X-Forwarded-Encrypted: i=1; AJvYcCUJsafodLWUnagx4hz2O5tXOFBwO+5OQMzcYfDLAHNY1YYrD4XB9G3BrOYfkiY78ZzLE+1VOCI=@lists.linux.dev
X-Gm-Message-State: AOJu0YzSqxAIhlFbZEZqTwPmlb8kq4Wy+DCUeXAU6bcFJuiua5oimJ61
	zVHXzWn9eM85T2/D6rV9tkvIuY7iPXEvREgph/iRX3WLzo8c+9XsVpIZ
X-Gm-Gg: AZuq6aLS0f6iRwLY8Y7qKu1V/HTrBNBqunw0LBL2Ifs3wxgieoQd39wn0HX6nzVtpJ4
	dgzmSflICZg9CdcHDGCENe8th0KF1fs5phe5PqxPJnQgzwvbRsoMinx9biHPPNnztR5/wpgDU/G
	D8tmYdWbuUS4k7dt55QcD6WJDrEGnfqhDt9IdUVpRqZzQKgIPxKROwJhHr8+OQzdG3oj3em1RbY
	5mlCfZI8IZmTsPEcU9KJvtq1THcPnJ+XFzzD6Rh2Q/2O0osUeCX+yVP4OxiYrj+eH60F7O6QyPp
	L9AruhwKhInwx/wo3qjx8Lwp6kYpxLZJRraEnQF8TZB1YPwovBLyfgprXL7VwS8r8hXPQ6OgY3T
	3VmD3veEbi8OqfYk50+Ewhf1UpqaDXc4MiYcK/lfWVVi9333m6LaQyBDBUZSyMiiekuMnS4//g4
	TFmj9E6dGYQB0YGj8Y/s79thxzRKdBdBJZFg14whmY3TKdsws=
X-Received: by 2002:a17:903:2304:b0:2a0:9424:7dc7 with SMTP id d9443c01a7336-2a7504df561mr3155255ad.4.1768848233978;
        Mon, 19 Jan 2026 10:43:53 -0800 (PST)
Received: from localhost.localdomain ([132.237.156.254])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a7190eee39sm99854165ad.45.2026.01.19.10.43.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jan 2026 10:43:53 -0800 (PST)
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
Subject: [PATCH] ACPI: NFIT:Advertise DSM function 0xA (Query ARS error inject capabilities)
Date: Tue, 20 Jan 2026 00:14:36 +0530
Message-ID: <20260119184438.19942-1-Shubhakar_gowda.P_s@dell.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

ACPI 6.6 defines DSM function index 0xA to Query Address Range Scrub
(ARS) error injection capabilities. This patch adds support for this
DSM function in the NFIT DSM mask so that userspace and ndctl tool can
detect platform support for Query ARS error injection capabilities features.

The patch updates NFIT initialization to include DSM 0xA, logs
supported DSMs for debugging, and uses the existing DSM infrastructure.
No kernel ABI changes are introduced.

Signed-off-by: Shubhakar Gowda <Shubhakar_gowda.P_s@dell.com>
---
 drivers/acpi/nfit/core.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 5a1ced5..6cc863e 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -2113,6 +2113,8 @@ enum nfit_aux_cmds {
 	NFIT_CMD_ARS_INJECT_SET = 7,
 	NFIT_CMD_ARS_INJECT_CLEAR = 8,
 	NFIT_CMD_ARS_INJECT_GET = 9,
+	/* ACPI 6.6: DSM function 0xA — Query ARS Error Inject Capabilities */
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


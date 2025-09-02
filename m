Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60A6F30C63C
	for <nvdimm@lists.linux.dev>; Tue,  2 Sep 2025 11:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756813576; cv=none; b=TVfIPGEglgwYc/QHZvK2FYcsVYc+xlsfdQMHTZbYmfRyuTe+q1hNKtP6MuTHIt4lQk0bUiD4DPMnSIAERcTy5fEtV/FdPwCNuPs2MBWKnuqVw/gQMLyjRgqyNsEIlU1JPiO60P67J0EB/AhufBP+KgkBxpjFPMW4TUBfAYQI5co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756813576; c=relaxed/simple;
	bh=b2dzqMeUqWyWDJ6+jIt81dE/5kfkNj+Ptj+goWcMI5g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=tEem3Hf4FWF/8RGlwgfE7ou+CLD5mVeFN9QK9Xh/6+WQYGmJiOtHUkoA2caQ8HvflXxLQI62VK6oJqHnqKiMe836uTETgY3ijN/4jXmde9pAQOBfWvOPpFOP+nuYMRp3dV+p0JqNlpldMx4VHECoBgyXd2IActcfOJCYJ/HPOOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IARCXFXg; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IARCXFXg"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-3b9edf4cf6cso4523924f8f.3
        for <nvdimm@lists.linux.dev>; Tue, 02 Sep 2025 04:46:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756813570; x=1757418370; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=CSpYSwOXNofPRqPJb67ltbn5EWSPohwy2KpciLMYW2U=;
        b=IARCXFXg/pSS1351tgKAGfWtu/JUICzvrJF1LEzDrjo+5PiU2Bwmz8P8XQ7BiM0/14
         I5M5rvfvnt1Q6D2i7r3bKD70bJYUP+zR2Xl5sHpjNh5yuQbTucroAxEOghEnOhCtlV3t
         QV86/s8zI+f+JhiXHbkMTi/jANHWLz6r79A7N9+i7i8V//yQHM2zTia5prfL/PHKvdDv
         3s/Q5QhG/VgDFPHVKTiVRop1dXllR953D6QPj+L1KPLWb8ngkJA/Q0e1WzRpDWCkJX1E
         W0wkz2tlMFh75oQzo9VhTt027h0vPB4rmndtGDL7NhO8Wyw99n8t5JHJhlzECCxP1b9o
         PFpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756813571; x=1757418371;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CSpYSwOXNofPRqPJb67ltbn5EWSPohwy2KpciLMYW2U=;
        b=XNClhrA3i67EfoVT2Xl+MzWVvHnbjfCh0gKzd/1kErM7zYUGyGg/9TJWlU/9vnfmjj
         ACvLhZyCYFH3DZ+B5X+CsCLIXq9xW6vvuq62zOduB1pMTs73nZyQ1oCnlMXD05M8j9br
         DNWLZKyUgKNa6hOv01fL5y+Jjy/wflWVfDFC3p2DWxYWU7+wv3v9WaQgGAGjBRw5IZ9m
         nq6ma1Qah/EOXHFDKXremJwjPXyRBO5BPqYzY8AxzQXVZa9Uff9phGLlwQ4GZ+cwFO6B
         GQDDsPJxPxxcH9Dh5hnT9fmp4v1II2myw8fvuuR9wzOMSsabPU51xFp4CtWPrF83gH7Z
         g0wg==
X-Forwarded-Encrypted: i=1; AJvYcCVyXzALWrUm7Ha8S+tBEGl4yiIMI04I2Bm4JxXoX6B6hXFwu3YiM0L8cFrdKjTjdM8cOdn5J3k=@lists.linux.dev
X-Gm-Message-State: AOJu0Yya3ngQOSnHsTEXGEAl7aa+f2T3waMsTXGqvs20LADBxCWaFjdk
	uJlPkSff5wneBa29twW+bCp/x/aHoMArHCM1Ny6Qep/kKTdjJVl5NTT9
X-Gm-Gg: ASbGncsFszRImh5e+ZB0vlEWXcjE/0esPoEi/axsFZCkrYh7nYe2VKJ+06PT2fYCV2F
	QrAVVuo6vQ0FA4Kyn+GLJ2rj71D7kaeUzllGekqobcp3W2/tkpcWNOZpXRlGOyWhy3V5tMIVt3s
	Dl+gKDATS3hZEXPSH0zD/Ueswrs5JY1NJN61SwbtOoxiIZK4dZwuHrCx+G69RzdoyVXHcY7rTdP
	32/a7OzPlO1ED3k6cz2hUQTeEYCAl5HyI9GZD5IcX8EQ/QCwVtrzF5Y3LIXv07ZL1kxq5eVAhtm
	weroT/gRcpQ6N4cCpWUaAxkx8jKroRbbaQfxUJtKJmPIQudGIj2Rii39Ku3WESh5nN06iAGsBPm
	dTvXG6otaBH0qETb5wAh/
X-Google-Smtp-Source: AGHT+IFSx1ZLxuVxr4IHYwG/kkbItLSnigBFcwtrJLVgNw4wTdNNofAu9Ao+jN20uMosvQnfKfZH2g==
X-Received: by 2002:a05:6000:4202:b0:3cb:285f:8d9c with SMTP id ffacd0b85a97d-3d1dea8e31amr8673398f8f.48.1756813570540;
        Tue, 02 Sep 2025 04:46:10 -0700 (PDT)
Received: from localhost ([87.254.0.133])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3cf8a64fce8sm19086547f8f.34.2025.09.02.04.46.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Sep 2025 04:46:04 -0700 (PDT)
From: Colin Ian King <colin.i.king@gmail.com>
To: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Len Brown <lenb@kernel.org>,
	Jia He <justin.he@arm.com>,
	nvdimm@lists.linux.dev,
	linux-acpi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH][next] ACPI: NFIT: Fix incorrect ndr_desc being reportedin dev_err message
Date: Tue,  2 Sep 2025 12:45:18 +0100
Message-ID: <20250902114518.2625680-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

There appears to be a cut-n-paste error with the incorrect field
ndr_desc->numa_node being reported for the target node. Fix this by
using ndr_desc->target_node instead.

Fixes: f060db99374e ("ACPI: NFIT: Use fallback node id when numa info in NFIT table is incorrect")
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/acpi/nfit/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index ae035b93da08..3eb56b77cb6d 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -2637,7 +2637,7 @@ static int acpi_nfit_register_region(struct acpi_nfit_desc *acpi_desc,
 	if (ndr_desc->target_node == NUMA_NO_NODE) {
 		ndr_desc->target_node = phys_to_target_node(spa->address);
 		dev_info(acpi_desc->dev, "changing target node from %d to %d for nfit region [%pa-%pa]",
-			NUMA_NO_NODE, ndr_desc->numa_node, &res.start, &res.end);
+			NUMA_NO_NODE, ndr_desc->target_node, &res.start, &res.end);
 	}
 
 	/*
-- 
2.51.0


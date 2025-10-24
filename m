Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6AA82FFDDB
	for <nvdimm@lists.linux.dev>; Fri, 24 Oct 2025 21:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761339949; cv=none; b=r8Tm6ad5bRS2R+hkPV6SicHIep/aLmO0tGKVTTh3Rle2mF2OIJfgOb7ymJffEyxSmE2wgmW1gnXYXyTNPI73le/0m79nslr62g5gxjXBGyDwi1mBHvL4ZAhKi30ZOYVsXgow56tZWpG+6Qi/K7Ld7Kyz+JSIGcHh+mgKuW2+NFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761339949; c=relaxed/simple;
	bh=h5jtxongNcjudQdK+LVORRb8tcuO7D5U5JAQHylsP2Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZlMh28KO13r8Igrk0rOXnYjJEBgF5nB74mCp0SA/S2VQZiul45SyFYCnBwoaS5gcWLfFs8/aK66SXG/2efaBAeAb25DnVj20tGKJY8iTwPK77cKnu984272rxQRlqi4cvBNjbv3l8Aqs5fC7UlDtpcc0qExhFLExo0oWITvtf7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mclapinski.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Qm4r0xlf; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mclapinski.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Qm4r0xlf"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-47105bfcf15so15563395e9.2
        for <nvdimm@lists.linux.dev>; Fri, 24 Oct 2025 14:05:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761339946; x=1761944746; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nYRMTzFMIJeQxcHsoH28yuNEVa8nEsoNdV+uHVle8Mc=;
        b=Qm4r0xlfISPuD3ssfcbaqVWsu0R8Gm28ANTZtP4Zg3RPZjvYUDdCCkRzFMhqiZkTu7
         rPpSqz9CCMy2igCT5XxtezlJpJYuyUY/5CTTEud/fe6EKI9ZCRiLBggTtnVPT9fDF8bu
         HHbKvRaNO7gWFoPe8OT8ZCUGFEuFfu/45/Un1R1V5o3wmD1R9nh93PEVJcYM9Fonv0yR
         QVgSG6G2j26QXb9nA5WpZTyCndEUc5bdIDXJ2Oz1co9fScd4FctDrOsFqPeZzE8mTY1V
         nyvYgAazPMI/qbIzU1aCta4CFZOZNQmtjhdT6H0j2A+fvIrniNRrUj7xSpZ2vrc5Ue2Z
         SbEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761339946; x=1761944746;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nYRMTzFMIJeQxcHsoH28yuNEVa8nEsoNdV+uHVle8Mc=;
        b=lhW/RGA4Wm8WUG5gdcxR3n24nalexMiMydQonFfh+1IUPIB8gnTla8TPdoJyMbuFzi
         +4XMXYhGvQEwYq6LwycTSl92XXJxGK+xnmdmHczTLQFJw5GD3o9cIyzRtke5uIApZ8bV
         4F29mlxU7PzkJTRbBbSQQR+vZu2l9LyBmtjqwsKhK/Ot2SWb3BLdHPXQ0qVlq6APvIOe
         +GnusiQr7Qw2IC6TTOQSd39fMwji08VL+HBBa1PtAVCPvynUhmM9kcRSYDcUh0Xdutve
         n/YujsKgP082OmD1Wh26gpv+c83hU65YaFb8Zj1tyNeTac6zS0hGpwWZrU37PT5tZi7W
         28GA==
X-Forwarded-Encrypted: i=1; AJvYcCU5PcCFTBnydgcEPOCiM1KGxxitw3/ED7wW3GNilHqXzDLTJWxFFfv7jo4gxYEdF0pj2AN1YSc=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw4ccvHQf5dk24NnYNvSk8F3lM7Bl+d1Sww4w1/UEBiYGjom7Tg
	CADUlU19B80+OF9cICpS/KK8GMhI7uoSfdl4NRJkmIh2o/WFRvIDY/lPpzEIjKFLFyilFFAtplH
	1rL7zglA90NyuJYM6699UjA==
X-Google-Smtp-Source: AGHT+IFC+txOdBGCTvYrXat3a6tqgz8KACNhyZM9BjnWie/36t5aj2thznsQ3BgXECLv7OJoPPxu8dvYNdoSHEKd
X-Received: from wmju16.prod.google.com ([2002:a7b:cb10:0:b0:475:d804:bfd2])
 (user=mclapinski job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3553:b0:471:a73:a9d2 with SMTP id 5b1f17b1804b1-471178a6484mr221961815e9.11.1761339946187;
 Fri, 24 Oct 2025 14:05:46 -0700 (PDT)
Date: Fri, 24 Oct 2025 23:05:18 +0200
In-Reply-To: <20251024210518.2126504-1-mclapinski@google.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251024210518.2126504-1-mclapinski@google.com>
X-Mailer: git-send-email 2.51.1.821.gb6fe4d2222-goog
Message-ID: <20251024210518.2126504-6-mclapinski@google.com>
Subject: [PATCH v3 5/5] dax: add PROBE_PREFER_ASYNCHRONOUS to the dax device driver
From: Michal Clapinski <mclapinski@google.com>
To: Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, linux-kernel@vger.kernel.org, 
	Michal Clapinski <mclapinski@google.com>
Content-Type: text/plain; charset="UTF-8"

Signed-off-by: Michal Clapinski <mclapinski@google.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/device.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/dax/device.c b/drivers/dax/device.c
index 2bb40a6060af..74f2381a7df6 100644
--- a/drivers/dax/device.c
+++ b/drivers/dax/device.c
@@ -470,6 +470,9 @@ static int dev_dax_probe(struct dev_dax *dev_dax)
 static struct dax_device_driver device_dax_driver = {
 	.probe = dev_dax_probe,
 	.type = DAXDRV_DEVICE_TYPE,
+	.drv = {
+		.probe_type = PROBE_PREFER_ASYNCHRONOUS,
+	},
 };
 
 static int __init dax_init(void)
-- 
2.51.1.821.gb6fe4d2222-goog


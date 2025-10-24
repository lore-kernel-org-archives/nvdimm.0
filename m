Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF69F2FF164
	for <nvdimm@lists.linux.dev>; Fri, 24 Oct 2025 21:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761339937; cv=none; b=B/mBCeEU1OpixDzTCuYOKuqs3AJpBFzGnL1pZqR4/FSwiJLrxaJtRIqREuMC9oyKWNtxJtSunVa+AW7iZZPe5aempER93W2EaO4ApxrT0HJ/swUOYzhPJCWMeP4w3AsgTRAbk17RiahCBjygFZiMaEtE2MVjBAxXKSe94XXP9XI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761339937; c=relaxed/simple;
	bh=S8tX1I3NnXmp83ECQLkp0HtMupL6iB6KWNRunTE4S4g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YhC7Q6w9dn38/bn1j1951k//K5iR7ZVRUfJ7K12/kL4sMhk/GyQF+1OPcuozltDQSSq0bAAIzJfDKma7rX5AoOmB7SRQP9ZXPKY5k2d3YgwjipLzGis5x8l6hWgJXL5ioOKktgaryuyXT8hSGhkxNZ7VaAL0JpQsGr7ZHxL5ZqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mclapinski.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=N1VRUEBi; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mclapinski.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="N1VRUEBi"
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-63c299835ebso5489441a12.0
        for <nvdimm@lists.linux.dev>; Fri, 24 Oct 2025 14:05:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761339934; x=1761944734; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UyyDskZ6zQPcCI/8YHZiXytq5M9mCn+dOU7TwJSjkxw=;
        b=N1VRUEBiZ9gzr149UaWY8ZmcS8hHPxU3fPp3Pzp9JEzNtxhU2lldLGW3wUkAgYUbbI
         zalR7TMG+MCL7QH1X7fQebMUqSPImMzfIKIJujPSXdfIsyoiKiaPgleu+gB4gs6TRy/i
         KlVTJX5x2/8UsVEeS7J3lLaFfzOeAD8WyI54626xNqi85ibVE7ElPxBWRn+eWxlehDKw
         WioKl0zIfbPjP/DDuQVW9uCMTInZGWd3wN8TDo8BJFUA8QyJmHCLFP5GHZLldNBIXTAi
         Z2ju2mP6vwQ5uBtxRnXBoJK/3sU0St7VlYeglKuWEyoHn26K/bsedCIvOyDmEDeRbgr0
         ek/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761339934; x=1761944734;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UyyDskZ6zQPcCI/8YHZiXytq5M9mCn+dOU7TwJSjkxw=;
        b=IcSNjoWP+PohtfOAoTSiBbcryS5gLEa2uWpl614ZgYxNrgT+ZKbJz286oGH/6pskYG
         i8V4rPzZhi0L9vDx68NXuRaZTQql9fP0Mlj2PU9zIbMyGfo10tz6T42cjs2ma2B9Jbvv
         d+siHNfLW2a+SHdQrYCGRRWf3pGYC0eWodo9XVOJkIM18lOTaVnFZMx2jw4l4Y8gBsnI
         bdOU47vqf330q/qK6CtN5YDbFRjSVW/Vs+TXLh/bYuGmXJd2ee5YrYOG8G5ublsxfT1M
         og411hp0H4EBFCeKmcA/r3c7xZH1gppOXm0o8WSNcZnY8+fC9TyGPcLDdxMs0poZMngb
         E1Zw==
X-Forwarded-Encrypted: i=1; AJvYcCX+TS328nwoNGepGFEjLz6ped/RZaQkfS3GKahOkz96iqKMvKiMe8pBjBqT6KFqn6Kfoj/RMTg=@lists.linux.dev
X-Gm-Message-State: AOJu0YwZkwsexIeA56E2MSGaDE2vtoNb1Lo2UsecDhOgzb9h1kfh55l3
	LWcdzg3dCTOQLzMckkIs45BfPBNUcvz28/pE/3SthwYg25WU88UzjtxfLDrCtNuOfuokMxRHTzV
	+IY+gDzOFjr0ftw4nE3vrmQ==
X-Google-Smtp-Source: AGHT+IFgqdh0PGBfpPjLJUmHPsb/alPmW29UdHjvj2vTXlQfjvz+HF6Nq2nius5r1WBMT4eb//7EEJZR468bGx9T
X-Received: from edi26.prod.google.com ([2002:a05:6402:305a:b0:63b:da80:b28a])
 (user=mclapinski job=prod-delivery.src-stubby-dispatcher) by
 2002:aa7:d446:0:b0:63b:fc79:393 with SMTP id 4fb4d7f45d1cf-63e5eb4b580mr2513452a12.14.1761339934347;
 Fri, 24 Oct 2025 14:05:34 -0700 (PDT)
Date: Fri, 24 Oct 2025 23:05:14 +0200
In-Reply-To: <20251024210518.2126504-1-mclapinski@google.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251024210518.2126504-1-mclapinski@google.com>
X-Mailer: git-send-email 2.51.1.821.gb6fe4d2222-goog
Message-ID: <20251024210518.2126504-2-mclapinski@google.com>
Subject: [PATCH v3 1/5] dax: add PROBE_PREFER_ASYNCHRONOUS to the pmem driver
From: Michal Clapinski <mclapinski@google.com>
To: Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, linux-kernel@vger.kernel.org, 
	Michal Clapinski <mclapinski@google.com>
Content-Type: text/plain; charset="UTF-8"

Signed-off-by: Michal Clapinski <mclapinski@google.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/pmem.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dax/pmem.c b/drivers/dax/pmem.c
index bee93066a849..737654e8c5e8 100644
--- a/drivers/dax/pmem.c
+++ b/drivers/dax/pmem.c
@@ -77,6 +77,7 @@ static struct nd_device_driver dax_pmem_driver = {
 	.probe = dax_pmem_probe,
 	.drv = {
 		.name = "dax_pmem",
+		.probe_type = PROBE_PREFER_ASYNCHRONOUS,
 	},
 	.type = ND_DRIVER_DAX_PMEM,
 };
-- 
2.51.1.821.gb6fe4d2222-goog


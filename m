Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA8A840097D
	for <nvdimm@lists.linux.dev>; Mon, 27 Jul 2026 12:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785154267; cv=none; b=pSxMVnnawADfA9+uBWOfaTUQvQh2Hdk7JHnDmTB72XJi7eTfxsi+dmjLj6qD0DNIgLP2ZX0liAZAdv0CRwW2kiB8eN7p0hIJleoXX+OIeF965zBNeaOYRYmXZl8dhv8CwygIOLYByKcMy9Yh2Eu1oBsTvAsxcems8EeXjt/rI8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785154267; c=relaxed/simple;
	bh=zrA6C2Wn6O6irBjX1A7U6/j0mruV7VakTyxcAWQ/gzY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=I4uZxC5SfRpZShLJE4cmbOorW32RM3bwKl285nGEEXIKtY/jvYhDN8f6f8yoo08qd7zKnNTsm0k05iPhSXzHom52tZIK49VThG3XBvwTC87KFfWfwBNArzEu2iXHOe5vvsHua0sbKw2hb8PeoaXQRiwkfbnJSaFTiw8RWxM4yKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=thegoodpenguin.co.uk; spf=pass smtp.mailfrom=thegoodpenguin.co.uk; dkim=pass (2048-bit key) header.d=thegoodpenguin-co-uk.20251104.gappssmtp.com header.i=@thegoodpenguin-co-uk.20251104.gappssmtp.com header.b=eL4YkfmN; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=thegoodpenguin.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=thegoodpenguin.co.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=thegoodpenguin-co-uk.20251104.gappssmtp.com header.i=@thegoodpenguin-co-uk.20251104.gappssmtp.com header.b="eL4YkfmN"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4954a2e73a9so14454325e9.3
        for <nvdimm@lists.linux.dev>; Mon, 27 Jul 2026 05:11:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=thegoodpenguin-co-uk.20251104.gappssmtp.com; s=20251104; t=1785154260; x=1785759060; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=P1gHEnus99pEhhk1X+Z0rEei8S8+ToTCVA6TNsBFI+8=;
        b=eL4YkfmNX1jL+kXwboXp3k/KvvImSnM5SMsSWgo/2Tfe/avAAS3LJNPprPNtl8YVz/
         NxN+FR1dD1+aoK95DzeKCtBbKQMApa6Ip9w1P0J/o3H8CS/BjPvarTqfl5dMfWv3ehWw
         2H2xN2vRicfOd7ejQyYv8SNCQVeKIQB+YdfRy6eFSxVAkR3PGTJCsTQqq+IMgYGM9GOg
         IhWsWa75IgSvRJL1meh76Q8/nV4gSMP0gsmuG7Tlub5DjMAvyeLbqKOp6DeWeNDEIJ+n
         Xe5XTyAbwuEpc4UxANrbGQg7DENTGzaWu/4SrPJg/UtPtYgeZYV3jW8hkn9JdjnY0kSG
         +zlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785154260; x=1785759060;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=P1gHEnus99pEhhk1X+Z0rEei8S8+ToTCVA6TNsBFI+8=;
        b=UlzMo1FjDxLkfy4+p1pDuIxX7Fl8Bd5rEKjGnuIDkdu9onWcdGcNpv3axOvH8RQyd/
         YAE4R0Qx2hY5+8vW08DKqDLC/C2oZCpOFAcGpJwMh3DBS8nGAgxNVVQT08k8rwAvhtDw
         0uj3dbQUE0i///Dbt8J1iOrA53rfdgXx6AFJKiW2JtzNpHOVBQQSz2xscpaMEk5gm99k
         s4FeSKHVBawlJRirotc+4qhswzEBqJBuwxxp85rOMrMhNQfI380EEaRdUC/X69JQJzsw
         ZQRZ1JsPFc4W2AR+ch2vYH19plmM04emCavLKocTLBqL319fev+o5Om12FkIktbSVwWl
         wYCg==
X-Forwarded-Encrypted: i=1; AHgh+RqGPPhOMmlVtR5+QZ24JUWdcx8h8K6ZWrUREtNYSLUBWZ75Bla7ZZqyULqwfVJ5uKGxY1EGkPA=@lists.linux.dev
X-Gm-Message-State: AOJu0YwzZBS7mQD3mLdoEtenhaausj+sh1NGBemHkfhVE+uIEozRWuI9
	3IB6gmTNQYO865t8Y9UN+GwdQyXbHzaowlTRX3O9efgTXzlOdwVPqQoT/3tV0ztFG8M=
X-Gm-Gg: AR+sD10KQ5QYKx0R00FHVxdtP27FB3zzJWDVa2wNJBPnCo8AYQwNggq4sAeRzroWxYD
	dlkQGLfNaJyOsW2vP+oWk4a1VhzWnJvb3ZrsIBk2HYKfYUWrRK7t6d/SEO4hbirdn9BBhC4+ZfL
	tRYvahjmC93iHfODJ3xh5HEveP3JYPh+cqtP08gQDI3EeLqaZ64AFr+wUQbYnHcFpLfK1JoKqhR
	dWQBd/ejRWltIJ/SyLyvu/9bjIntKpE2LSJTBdw+Zi7nadrGlJyY7v3ABGBpwWLYV3foCGbUWcW
	EarbFzWnZgCC5v9VRu6yQGa24xfA9x6VKwdM1ZJvH1bPEtdhNgAKrMWkbzjLgwi6TnYtXfO5plV
	nG1dBkH5O1bN+TyzdZZVoAr8GmQ8XlE/GQt+I9ONM73gE8UgAcThs4cPyIgEBiaY7LBRSQw8/B8
	ADl4aMt1Mm433eiw56AgvqwhKUcWKNTg==
X-Received: by 2002:a05:600c:1906:b0:495:6b8a:5227 with SMTP id 5b1f17b1804b1-496b56ff17cmr116342545e9.23.1785154260529;
        Mon, 27 Jul 2026 05:11:00 -0700 (PDT)
Received: from [10.42.0.1] ([2a00:23c7:1d1a:9c01:7aab:bc55:e039:4aac])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-496b4f302f8sm211778055e9.12.2026.07.27.05.10.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 05:11:00 -0700 (PDT)
From: "Pawel Zalewski (The Capable Hub)" <pzalewski@thegoodpenguin.co.uk>
Date: Mon, 27 Jul 2026 13:10:42 +0100
Subject: [PATCH 4/9] ACPI: ghes-nvidia: use a named initializer for
 acpi_device_id::id
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260727-acpi-refactor-v1-4-ff900aa326ee@thegoodpenguin.co.uk>
References: <20260727-acpi-refactor-v1-0-ff900aa326ee@thegoodpenguin.co.uk>
In-Reply-To: <20260727-acpi-refactor-v1-0-ff900aa326ee@thegoodpenguin.co.uk>
To: "Rafael J. Wysocki" <rafael@kernel.org>, Len Brown <lenb@kernel.org>, 
 Bjorn Helgaas <bhelgaas@google.com>, Zhang Rui <rui.zhang@intel.com>, 
 Kai-Heng Feng <kaihengf@nvidia.com>, Tony Luck <tony.luck@intel.com>, 
 Borislav Petkov <bp@alien8.de>, Hanjun Guo <guohanjun@huawei.com>, 
 Mauro Carvalho Chehab <mchehab@kernel.org>, 
 Shuai Xue <xueshuai@linux.alibaba.com>, 
 Lorenzo Pieralisi <lpieralisi@kernel.org>, 
 Sudeep Holla <sudeep.holla@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>, 
 Dave Jiang <dave.jiang@intel.com>, 
 Alison Schofield <alison.schofield@intel.com>, 
 Ira Weiny <iweiny@kernel.org>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-pci@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 nvdimm@lists.linux.dev, 
 "Pawel Zalewski (The Capable Hub)" <pzalewski@thegoodpenguin.co.uk>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785154252; l=732;
 i=pzalewski@thegoodpenguin.co.uk; s=20260430; h=from:subject:message-id;
 bh=zrA6C2Wn6O6irBjX1A7U6/j0mruV7VakTyxcAWQ/gzY=;
 b=S6PIbfdwzeRS6uAnwlEAg/bFB4cywsN5K95TfQqHoJbODLCpFQlWBQM/pWKmzNszJMLADygl2
 HXSTp5kuGaRAoubKt8FGxqKuHW3tvNk9iqIksjW5VI4dh0qwHh6QbLA
X-Developer-Key: i=pzalewski@thegoodpenguin.co.uk; a=ed25519;
 pk=vHq4n9IonORH2GTzLv8r6CWAFHzgfBuNkQPXA8NSly0=

Use a named initializer for the acpi_device_id::id field for
readability.

Signed-off-by: Pawel Zalewski (The Capable Hub) <pzalewski@thegoodpenguin.co.uk>
---
 drivers/acpi/apei/ghes-nvidia.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/apei/ghes-nvidia.c b/drivers/acpi/apei/ghes-nvidia.c
index 597275d81de8..1d3a6997a019 100644
--- a/drivers/acpi/apei/ghes-nvidia.c
+++ b/drivers/acpi/apei/ghes-nvidia.c
@@ -130,7 +130,7 @@ static int nvidia_ghes_probe(struct platform_device *pdev)
 }
 
 static const struct acpi_device_id nvidia_ghes_acpi_match[] = {
-	{ "NVDA2012" },
+	{ .id = "NVDA2012" },
 	{ }
 };
 MODULE_DEVICE_TABLE(acpi, nvidia_ghes_acpi_match);

-- 
2.43.0


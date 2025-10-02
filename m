Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADAB430CB5D
	for <nvdimm@lists.linux.dev>; Thu,  2 Oct 2025 13:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759411150; cv=none; b=Jr5CBWwAIAcG2OzE4fuHxc/sAHrMIKcIRavuphXCoPrCT6VIreyqA8m0bkM17DIUIa+YIjHINfSjmLKHBisTkBHF6bIK/hH91UhHAtKcVmKt+5kWk0rMPEQoZ910H7M73myczaMzj7Y3q46lGac0vt9NHbvpxLmZ22HsgkyAS04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759411150; c=relaxed/simple;
	bh=ppas900mz8UZ1nAze0k0cgvVf6bsDr1n1l1Zsx5qMIg=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=tcRWU4ByxKJGprxF/04dztzOWmvPgdz8JIAPtU6M4AQ7RTsSwEyeYDBohkivnyFJSQpK+7Fd7SBkoJjwoYzGiAP/hHF1VWtZAbg5ue4r7043xtOpR5yiG7mqfaPQ3Z15/HMv165mFAegCfbV8nEURPu5M1G07gS+r2JJp1Ea4Xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mclapinski.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rleKfnRh; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mclapinski.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rleKfnRh"
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-b3d6645acd3so104084266b.1
        for <nvdimm@lists.linux.dev>; Thu, 02 Oct 2025 06:19:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759411147; x=1760015947; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=opsuLXZalKgBtjjtUFfr16++aW0WmcWbDZvURSoXadw=;
        b=rleKfnRhTTo+JoPlThhF+7ydZsxhtn7gQswEpax32WJKapu1TgnETksfEwP+qPOAwh
         y2yHlPuUupFS4qAnfl4bcAVDSsCwSTn10KOHtnDWJjJzpLw2+oB23kqEAznXI33jJRDu
         QblsIRrV9TngL/KM0GeyDpIHmB00bU8AmQzZYB+Mgpmt7zDJ0PCUqIFH6YzuMfcEuHom
         shajcHPKkVseApm55CZpWxGYl8IXcthQ+Aa/YUxX4jMC0fVYHSIExp3JNkmwi4D5L/00
         QDtz8LsuXsEgoBQYtfY/rWKupT0F5JPEl7Q0+hSOwaCW3ADWHZLGv1d2VVHxW9h5CAUI
         neuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759411147; x=1760015947;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=opsuLXZalKgBtjjtUFfr16++aW0WmcWbDZvURSoXadw=;
        b=PYKSQnfTtYIZwDubV/iINwU3Kc1kRIdYx1h0J5JJcUZf0PeX91mby1PX9hfkqqs87k
         KCdp95/Fb+PhEi+ZhQiuxIc5K+D+I1XdyDTvNMcaFdMB2ZONk4sYC38Fu+B/hiVyq74j
         wzoFRNjOyikz64+awLcsinlu2/6co3EFEqjujsiVn/mH9lOk9Ifwt7+kuy5hPRrzZQv2
         0PUUzL8tDlx3xKku/d300TJElT0HGwluZOMNFWgwQruwJBu/UNTkNuR88BynWf7HICnA
         JYZhjJVGwMd0gyT5lVYkcjwh+pDKywaZ5hkuDfyTZssCg3kcg1jhyUnxGrfD3ti4tSd/
         lE/g==
X-Forwarded-Encrypted: i=1; AJvYcCX9de4RVcgGP1zgFKHtds43oVMzgjeDI/lyqqdgF+Prl9w60OynUbtGcKE/tzNb/hlRl0yN4yY=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywd4/kZS/XBlAK2FbI8fEwaDjd9QLcJDPpu74xuy0ZqNexy1BJN
	szDFRsc/p/GcwFXf1TtF0DeEEuiBd58uf/JqbEIGuXRoPzdCaCmK6rloxOunZcFow29aasSaHff
	8943zpjOpUlyQPbOY/XbI9Q==
X-Google-Smtp-Source: AGHT+IEBOtinBILzYUipbzKT6uP64K+v7i7D/BSugv8X6CMyxWJNMehP5LgieusjsvQy15d5i9FRZHYKNzdUhUgV
X-Received: from edqh26.prod.google.com ([2002:aa7:c61a:0:b0:637:b54a:d88e])
 (user=mclapinski job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:94d2:b0:b2f:2c8a:680b with SMTP id a640c23a62f3a-b46e7bbb560mr870743666b.58.1759411147168;
 Thu, 02 Oct 2025 06:19:07 -0700 (PDT)
Date: Thu,  2 Oct 2025 15:19:00 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.618.g983fd99d29-goog
Message-ID: <20251002131900.3252980-1-mclapinski@google.com>
Subject: [PATCH 1/1] dax: add PROBE_PREFER_ASYNCHRONOUS to the pmem driver
From: Michal Clapinski <mclapinski@google.com>
To: Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, linux-kernel@vger.kernel.org, 
	Michal Clapinski <mclapinski@google.com>
Content-Type: text/plain; charset="UTF-8"

Comments in linux/device/driver.h say that the goal is to do async
probing on all devices. The current behavior unnecessarily slows down
the boot by synchronous probing dax_pmem devices, so let's change that.

Signed-off-by: Michal Clapinski <mclapinski@google.com>
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
2.51.0.618.g983fd99d29-goog


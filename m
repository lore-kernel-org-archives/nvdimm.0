Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E26F42FE595
	for <nvdimm@lists.linux.dev>; Fri, 24 Oct 2025 21:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761339934; cv=none; b=Fc5R5xhTinkAH2evKY/AGnqwd0s18bJSxxoU6wIR60b1fBwGcC2HaxpvyXFkfas0Rd2Km7oDAHNV0Sasw3V0MSEVtFBFac4VrWJRklCRby9DYkVNtl3N/wQN5wJUtBPKALE/26Rn9D6XqY+0k5yRvF0wIGD1vwTdMu75cATXwgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761339934; c=relaxed/simple;
	bh=GR8vGx9QcuyzlnuWwnQyINXnx42sczidTEfEcLBemfE=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=LfqJJWyXKHHZPaYOyEdttRNq52I+fepERLCqkvQk6xiDcsWQJW+/EPF5HNVEdGQj0ExxPYLMh/hez4qwP6BSnmtTQmetAF9yg86/C737zMz4evkoCTqcObEO4NZLF3t2dJ0UhUXAp60jYYDUUftKRf8Ov2VaFCnM5J3ziOm9tMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mclapinski.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=COVOhXwk; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mclapinski.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="COVOhXwk"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-429893e2905so2043678f8f.3
        for <nvdimm@lists.linux.dev>; Fri, 24 Oct 2025 14:05:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761339931; x=1761944731; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=T3YI5eM57RqyqbEDMR7KooO+xOjSR2Ak5rIAHhIlRyY=;
        b=COVOhXwkMP1rnVVpUzNckABdm319J4EfRhs8kOxC22xEDY1TwbRYOj63GDSUeozbJj
         7/dwS14g8eVBJ8Hf0hrZqZ/uXr2OnWmHeI270SpXG/YR4j0Wsi2OV/ujWL5KSu9ziq/d
         qbdnBvsCd6xJkV0bTYzB85Ub+uRPCwLaQ0GREkVbXWbwgrshcux60CC2dM3JnVsBdYwQ
         wtWKlbXRm66Y3NB9fwnuzL7ybH6pnZ1D/1amfl9twPTZd0KygvVdQb/02IgVnLOlyceY
         o4lXoVELuelY87EpGH6UQ/ZFwjyTkxltx8+J1jUFujssT8fjW0JZ0rm5MqbClcM6QPvQ
         V5jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761339931; x=1761944731;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=T3YI5eM57RqyqbEDMR7KooO+xOjSR2Ak5rIAHhIlRyY=;
        b=e0RV38Wp/mEfYyZONeumpGSz8T7CsSEg3oQ7TYu3RqvDPrmyY6n/+u1+VjbxIzYzWu
         Tp/OM+Yvzu/vULu6p7P7RQEVXYTRT3V+qo+eFILqbG5QRvzdb7scgdYeSU6v9RrDAI55
         Ahh0bBdOds/9996lzqDGUw1sU2/TT82HQsC0jrvCQPQO4TsM9YiOXKLtsVi0yPliw30y
         vT7fBCFxHEfW8oqeSkWRM4WFNB1vQj6Zlr4uQ6WeizfPl4Hdypib1Z7A7srpcYGPvYf3
         4TaGMlEL8vuSH6AuUGeCNH9wfVrdEVs14rFcS1TrIGC6Lf5Y4rafAIRyEqV1VmhDIOMu
         G8EQ==
X-Forwarded-Encrypted: i=1; AJvYcCW9PMfy0rKYQO2G0flcgGY9bXCja9O6YwD/1ByAYvz6w8PqFgEsJL/WrmINpScVKLM2lLcNmhM=@lists.linux.dev
X-Gm-Message-State: AOJu0YynRhjOfGCoJ39xI/hnHL3TY9/DibdBEq0i3OEkuWZQoxU9twrU
	v8xDfzSJUK4uBoc6ZpQWZlDRi0kI3+lcoWWw+Lg2WsxdkgejEzMyhPVk6zKT94xvuUtONXJPbbH
	vuzpXj4HnvGskQgomt4zwPA==
X-Google-Smtp-Source: AGHT+IEDBqFflHgl/gW/+KklR8SPQ/ktyy9jGNLtSJYZsdW07iwdQXTRprPA6mSiDkYJURLlI1bHDRD111BgD1be
X-Received: from wrbbn12.prod.google.com ([2002:a05:6000:60c:b0:425:f04a:4d8d])
 (user=mclapinski job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:24c6:b0:427:928:787f with SMTP id ffacd0b85a97d-427092879c8mr15711106f8f.21.1761339931205;
 Fri, 24 Oct 2025 14:05:31 -0700 (PDT)
Date: Fri, 24 Oct 2025 23:05:13 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.1.821.gb6fe4d2222-goog
Message-ID: <20251024210518.2126504-1-mclapinski@google.com>
Subject: [PATCH v3 0/5] dax: add PROBE_PREFER_ASYNCHRONOUS to all the dax drivers
From: Michal Clapinski <mclapinski@google.com>
To: Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, linux-kernel@vger.kernel.org, 
	Michal Clapinski <mclapinski@google.com>
Content-Type: text/plain; charset="UTF-8"

Comments in linux/device/driver.h say that the goal is to do async
probing on all devices. The current behavior unnecessarily slows down
the boot by synchronously probing dax devices, so let's change that.

For thousands of devices, this change saves >1s of boot time.

Michal Clapinski (5):
  dax: add PROBE_PREFER_ASYNCHRONOUS to the pmem driver
  dax: add PROBE_PREFER_ASYNCHRONOUS to the kmem driver
  dax: add PROBE_PREFER_ASYNCHRONOUS to the cxl driver
  dax: add PROBE_PREFER_ASYNCHRONOUS to the hmem drivers
  dax: add PROBE_PREFER_ASYNCHRONOUS to the dax device driver

 drivers/dax/cxl.c       | 1 +
 drivers/dax/device.c    | 3 +++
 drivers/dax/hmem/hmem.c | 2 ++
 drivers/dax/kmem.c      | 3 +++
 drivers/dax/pmem.c      | 1 +
 5 files changed, 10 insertions(+)

-- 
2.51.1.821.gb6fe4d2222-goog


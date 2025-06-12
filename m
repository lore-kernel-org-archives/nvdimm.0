Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B232219A8D
	for <nvdimm@lists.linux.dev>; Thu, 12 Jun 2025 11:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749728549; cv=none; b=el4ecnIclwpty9esBJ8rYtUxL0SIbYo1y0KKNNBjvwXOqBLgmqYrF+b45j+zjP0qFERRmAqlxJuLFQ+11GXr8angxY3UfbfKrlZpXTTcS4Q/pYkc8dQLL364SrllG5BDz03rmSZz2GhZrydMZ/3RQKlJmXhM8x0v/Mnwqg74tqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749728549; c=relaxed/simple;
	bh=QXtBQLsLvmgKCeZpy9SACWHhgLdOix4C6WfpyVk7tJ8=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=N0bO74dn4UO+8HTxHEu2DJdH0YqvtrrrXldSyVY5XXJTqUXEVA/FhD4FIpX38b6LA00rLU9XZMAt7Kxm3esLdCJAeaIqOB02t+XORyuUTkxgfLah6xzIk6PVanQI2caT4l+6w5x1EXgjz7zsWpg7dQ8jML1U9q+cD6SaldCTXzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mclapinski.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uzoCg5IB; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mclapinski.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uzoCg5IB"
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-606f507ede7so861051a12.0
        for <nvdimm@lists.linux.dev>; Thu, 12 Jun 2025 04:42:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749728545; x=1750333345; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=zzguWUlfoEXe+YlTaZtG+0rEZ7v9uyUK3wef2hG/zAY=;
        b=uzoCg5IB3wFoX22pkqlBSvUoLHm4a3ZQajqIPe08CmgufG/JdFvmJGjF3eaqweZDFQ
         SSdxKkXY09qoqJNp7wgu9b/bdagMMpPJiP6wL0omWXKMFIbXJGVtGAGVZjhTmDp5EEVR
         6UlpDO49g6PzFo9X9dVMOkBT1nZpMVwFDmtA/yDfb+g8EiXFbi2jqZfo4RROMhz8boeD
         IV1UCdcETqi08B8WIxowWUBjRl+5AWKprzVhLE+GVhc6wnulESLVibPw10JE2d6hCCUU
         VN1llNw9d2WeRZTgss7reJBNeIj7UFNU+sG7wmwa9ipeRl078HoGZLCQFAST44OFGLYa
         00cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749728545; x=1750333345;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zzguWUlfoEXe+YlTaZtG+0rEZ7v9uyUK3wef2hG/zAY=;
        b=sJXmBOck1dMqHTVq7YcLogGsd9TxXosQoVVHDehqVKu8oMPIqiMcg7675ener7bzm/
         9H0GalgnTIY6kgaMZRXr6UAWUyS9uMhby3rf/Jz4lqI58J+ucHQXGAvdxBMNJQBUXM9s
         JzWx3DaW+3uiS/uf/6mnrwxq4jaGaO8CSb/+u82vN0cZ7cWjDUJ2dtalt1fgbiu3s/P8
         6+5sDUJgA7Tu/WdQ4GYWGkcUKB8ffhc6hLhxxaRHkD5n12DOTApmowAWU8a14IVkeBpr
         RCszbv/9HHGoB7KzYNScTcgbxXTQlpKHyaKckgwivTeni2iqscqQW8FgHipJNw3E2SzK
         /nVw==
X-Forwarded-Encrypted: i=1; AJvYcCXMeLpUI66xCfunTJxRUIrZVaEH6XFMOGcffa6u3hl6Jn8rEmG6g2kjYrunWU2zBVKo5SI6ht4=@lists.linux.dev
X-Gm-Message-State: AOJu0YyY5wJgvPA9UrjtZrf+DXNtTaFprFkWvcjstsJXCBwfLpR+ZHSQ
	nDI74jLGhWQQK5fUBbT404fB7nclZWc9E6s+ZBmn/RfGl1crPCxaYn1RlgDdVkR0WOe2Tv7LVib
	kqO7ZlULegu2WB4Rw4kQFmg==
X-Google-Smtp-Source: AGHT+IHQhB9KxEerkKZiu9qR2EkYzNfHsYj6AxxV/xNEcdvJShwSN5Xny18JELLkZkfVd8q068snd0PkYT5KwIGL
X-Received: from edil3.prod.google.com ([2002:a50:cbc3:0:b0:607:e52:389])
 (user=mclapinski job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:5cd:b0:607:d235:87b1 with SMTP id 4fb4d7f45d1cf-60863c28483mr2905583a12.32.1749728545512;
 Thu, 12 Jun 2025 04:42:25 -0700 (PDT)
Date: Thu, 12 Jun 2025 13:42:08 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250612114210.2786075-1-mclapinski@google.com>
Subject: [PATCH v3 0/2] libnvdimm/e820: Add a new parameter to configure many
 regions per e820 entry
From: Michal Clapinski <mclapinski@google.com>
To: Jonathan Corbet <corbet@lwn.net>, Dan Williams <dan.j.williams@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, nvdimm@lists.linux.dev
Cc: "Paul E. McKenney" <paulmck@kernel.org>, Thomas Huth <thuth@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Steven Rostedt <rostedt@goodmis.org>, 
	"Borislav Petkov (AMD)" <bp@alien8.de>, Ard Biesheuvel <ardb@kernel.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Mike Rapoport <rppt@kernel.org>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-cxl@vger.kernel.org, Michal Clapinski <mclapinski@google.com>
Content-Type: text/plain; charset="UTF-8"

This includes:
1. Splitting one e820 entry into many regions.
2. Conversion to devdax during boot.

This change is needed for the hypervisor live update. VMs' memory will
be backed by those emulated pmem devices. To support various VM shapes
I want to create devdax devices at 1GB granularity similar to hugetlb.
Also detecting those devices as devdax during boot speeds up the whole
process. Conversion in userspace would be much slower which is
unacceptable while trying to minimize

v3:
- Added a second commit.
- Reworked string parsing.
- I was asked to rename the parameter to 'split' but I'm not sure it
  fits anymore with the conversion functionality, so I didn't do that
  yet. LMK.
v2: Fixed a crash when pmem parameter is omitted.

Michal Clapinski (2):
  libnvdimm/e820: Add a new parameter to split e820 entry into many
    regions
  libnvdimm: add nd_e820.pmem automatic devdax conversion

 .../admin-guide/kernel-parameters.txt         |  10 +
 drivers/dax/pmem.c                            |   2 +-
 drivers/nvdimm/dax_devs.c                     |   5 +-
 drivers/nvdimm/e820.c                         | 211 +++++++++++++++++-
 drivers/nvdimm/nd.h                           |   6 +
 drivers/nvdimm/pfn_devs.c                     | 158 +++++++++----
 include/linux/libnvdimm.h                     |   3 +
 7 files changed, 346 insertions(+), 49 deletions(-)

-- 
2.50.0.rc1.591.g9c95f17f64-goog


Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F7EA3382C6
	for <nvdimm@lists.linux.dev>; Thu, 29 Jan 2026 21:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769720692; cv=none; b=nPUC4Bq01djfMgwWryR9m6a0P9ulR7099QAavAoNXaCEup0hfvPkLVDQi/SkILMfFd/32Jl87UrRVjAwe4tm6cm5pjCkmCX58sHCwYf2tYWqMffcDNST5YuNjYSWuqufXyQm6zPGfrNmXgUHweMyjChhz+kVyEcMLC1A+o90Dko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769720692; c=relaxed/simple;
	bh=akrBn4JPwvLBEstJQ9HeJN9q5u1vwp5xfi2e9tVFX44=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Mk58wa1Dy/6YS2b5EWDqjkCKhuQfSEgdSfndkUeXYWe4qUBOZu3YRcJk+hoT5tp8ZGVsW/dqWtkS12ZXypwvYLh0VZRVJoT1ikwO3wWZB4VelcwmZ6VeuD8HNmiGTdc1LRGm7KXAioEQXwYUihHGzEPScs+5tI9hVevvYXbjazw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=qoxYRG01; arc=none smtp.client-ip=209.85.222.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="qoxYRG01"
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-8c7199e7f79so222038685a.0
        for <nvdimm@lists.linux.dev>; Thu, 29 Jan 2026 13:04:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1769720688; x=1770325488; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=p7dwhjhUx8amshGTbVFKhqWt51EOp/YvCZDul2or7c8=;
        b=qoxYRG01/BKCXUa3qWU7cyg6dHniyoUyG7iGd09ESLWxUCSXj3kkTukD95Hjz6mlnx
         82iGNAOJZv8LitgvIboNvNLJfClM5tYcKiRlkqP3rADmmKGT6ChGwaVMIo6wkBY512xJ
         1irzKqs4EhVRkklw5GhiPjF7/w6iiplPXaEDRbuX5LrnbDs3daLZX1+kvU6kGWwl9lTf
         KMJ0XLSxGnQWgnRtgsUEI+9pJ3lf+XNPHr09RGf0dH56jiMxs4EDQ/BkH9y3vboGopCb
         HvLQ5BRvOfbe3Cw582NK0efvYZzJBV/UoRNuJ5bCXEQGZi1mzKktT/anPN5cWWkz5RL5
         55iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769720688; x=1770325488;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p7dwhjhUx8amshGTbVFKhqWt51EOp/YvCZDul2or7c8=;
        b=GMdaCdkztd9BplhvVhF32EXgvx2nXcwh3fVUCNZzrQfqpKsEiwTWw+D5yEbRYgnhoN
         s0j1d2h+Qgc535XE39uvajwe+gRqYr4Dg6RNaP7OxwgEfdQr52k4HepNmQT1h1SCujUD
         qg87dl4GMMbOiE1cXyxX/sOLDwcXcJoOcgokjE55WSy0RbvMbh4lemOMbbq8q9nltPjT
         csoxnQLE29Z/tRgCKyMRGZqWhst2DQLOIGyC6t1TFD2wqLqDIYUKc98tK+U4ttvSBoa1
         uVe2Id4kTr18IqCw6R4gGCyPdksq/sfNYN9QxBwDa26B8OWgga6aH3t/uLt5UlFAz1qo
         oL+g==
X-Forwarded-Encrypted: i=1; AJvYcCVJAlejWJ+/rPZqjks+AEFEhY8y31ne0jv8gWrdePw8+ed7H8zfLuvZxf9o2t0mvG+gsXr3gDs=@lists.linux.dev
X-Gm-Message-State: AOJu0YyFgxhb5VBESXUl2UzXYn93aR+wI7uNIMHb5mHgtHw1zLAf93QA
	M2G7D3HAWM3fQ6CWZ3WrKHgo2FDbkw7jFX+EZFX0+KLf8e76083R7jjQYb2Rv99Cc0s=
X-Gm-Gg: AZuq6aIw1Ml4EFzfINFtuiL+c3boCbzQ486THWVUWzdHqBsqjzEH6WlbiAGcw43dXwh
	PuL3LPIirWmswvA2LyqOudnd4CyW7rQQmT0RCB7RR0crE8VUdaBb4Py73Ba/tf527hquKJ9Xm6a
	MX9LmGWYVU9h3RJAFlaziyROH6G/F28X0NBLwbsBDgaoFmeCG9qo2NOFyIrbpUoS3J+7m6C8dgl
	VHAQ7B98kWqUysoNRhD3+f/kS7ZzvsNyb89Li+Ppqfzf5H/lkBN8XDQb6mfPohZ8qxX+1n/FKlr
	80+uSxOSXSLKXGbj/0lHgFgIu5CawbLQYrT14djxSLp7dl+5R1/6tCmIefP6LRMxGQ6K4Y8QmBT
	xeo+kZ5JdHSX1rSWmJ/dhM+4VuBgQ2xuQEhA4hNcRG19dPT1rkPnR2JlqmFkNIPQ8VftviHuhwU
	6HGdXxlK6N4ZEBkdSgASwMXxIOpbav2cVisjfdYl9r8iv6x6eP2kza8ZdPSQ18PwZk+fc2eYeZq
	dQlUVUCfqjtPw==
X-Received: by 2002:a05:620a:4801:b0:8c5:2d4c:4f0e with SMTP id af79cd13be357-8c9eb26aabbmr143736485a.25.1769720688060;
        Thu, 29 Jan 2026 13:04:48 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c71b859eaesm282041685a.46.2026.01.29.13.04.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jan 2026 13:04:47 -0800 (PST)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	kernel-team@meta.com,
	dave@stgolabs.net,
	jonathan.cameron@huawei.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	dan.j.williams@intel.com,
	willy@infradead.org,
	jack@suse.cz,
	terry.bowman@amd.com,
	john@jagalactic.com
Subject: [PATCH 0/9] cxl: explicit DAX driver selection and hotplug
Date: Thu, 29 Jan 2026 16:04:33 -0500
Message-ID: <20260129210442.3951412-1-gourry@gourry.net>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently, CXL regions that create DAX devices have no mechanism to
control select the hotplug online policy for kmem regions at region
creation time. Users must either rely on a build-time default or
manually configure each memory block after hotplug occurs.

Additionally, there is no explicit way to choose between device_dax
and dax_kmem modes at region creation time - regions default to kmem.

This series addresses both issues by:

1. Plumbing an online_type parameter through the memory hotplug path,
   from mm/memory_hotplug through the DAX layer, enabling drivers to
   specify the desired policy (offline, online, online_movable).

2. Adding infrastructure for explicit dax driver selection (kmem vs
   device) when creating CXL DAX regions.

3. Introducing new CXL region drivers that provide a two-stage binding
   process with user-configurable policy between region creation and
   memory hotplug.

The new drivers are:
- cxl_devdax_region: Creates dax_regions that bind to device_dax driver
- cxl_sysram_region: Creates sysram_region devices with hotplug policy
- cxl_dax_kmem_region: Probes sysram_regions to create kmem dax_regions

The sysram_region device exposes an 'online_type' sysfs attribute
allowing users to configure the memory online type before hotplug:

    echo region0 > cxl_sysram_region/bind
    echo online_movable > sysram_region0/online_type
    echo sysram_region0 > cxl_dax_kmem_region/bind

This enables explicit control over both the dax driver mode and the
memory hotplug policy for CXL memory regions.

In the future, with DCD regions, this will also provide a policy step
which dictates how extents will be surfaces and managed (e.g. if the
dc region is bound to the sysram driver, it will surface as system
memory, while the devdax driver will surface extents as new devdax).

Gregory Price (9):
  mm/memory_hotplug: pass online_type to online_memory_block() via arg
  mm/memory_hotplug: add __add_memory_driver_managed() with online_type
    arg
  dax: plumb online_type from dax_kmem creators to hotplug
  drivers/cxl,dax: add dax driver mode selection for dax regions
  cxl/core/region: move pmem region driver logic into pmem_region
  cxl/core/region: move dax region device logic into dax_region.c
  cxl/core: add cxl_devdax_region driver for explicit userland region
    binding
  cxl/core: Add dax_kmem_region and sysram_region drivers
  Documentation/driver-api/cxl: add dax and sysram driver documentation

 Documentation/ABI/testing/sysfs-bus-cxl       |  21 ++
 .../driver-api/cxl/linux/cxl-driver.rst       |  43 +++
 .../driver-api/cxl/linux/dax-driver.rst       |  29 ++
 drivers/cxl/core/Makefile                     |   3 +
 drivers/cxl/core/core.h                       |  11 +
 drivers/cxl/core/dax_region.c                 | 179 ++++++++++
 drivers/cxl/core/pmem_region.c                | 191 +++++++++++
 drivers/cxl/core/port.c                       |   2 +
 drivers/cxl/core/region.c                     | 321 ++----------------
 drivers/cxl/core/sysram_region.c              | 180 ++++++++++
 drivers/cxl/cxl.h                             |  29 ++
 drivers/dax/bus.c                             |   3 +
 drivers/dax/bus.h                             |   7 +-
 drivers/dax/cxl.c                             |   7 +-
 drivers/dax/dax-private.h                     |   2 +
 drivers/dax/hmem/hmem.c                       |   2 +
 drivers/dax/kmem.c                            |  13 +-
 drivers/dax/pmem.c                            |   2 +
 include/linux/dax.h                           |   5 +
 include/linux/memory_hotplug.h                |   3 +
 mm/memory_hotplug.c                           |  95 ++++--
 21 files changed, 826 insertions(+), 322 deletions(-)
 create mode 100644 drivers/cxl/core/dax_region.c
 create mode 100644 drivers/cxl/core/pmem_region.c
 create mode 100644 drivers/cxl/core/sysram_region.c

-- 
2.52.0


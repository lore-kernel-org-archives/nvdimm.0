Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58C4F37F729
	for <nvdimm@lists.linux.dev>; Wed, 14 Jan 2026 08:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768380759; cv=none; b=uXf0vmgSSoaMGH4FkAZizE0vqngLe10E6Mi62mYXcCE6amnPwlAAGrSjVQ4vThMIwRyyoMusClMPiC+b+LH4lLBCW0o9Elz/+hVb8uIxSAxCR1A9vD0Lv529l6GgsRY4xi1tBR0rNpVZLKFhAvVsolR4HhgfKWUk/J7O8TEcF0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768380759; c=relaxed/simple;
	bh=6Gf3O1Z46A6A3V618QjzgUC3TwEE6jvcWp4vN0GZKB8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=k3PnMbpjaXnZTDaB6dMj9OeXLp2t8/b8F1QkINT4HuDdu568ICd8xcbdniLpOUN2O5SKDgF2lesYRFau5Ydp7GW8bbbBZP3y0Z82OBODv2NzfaCwzb4+GgRj1pdXSMonhkSzhsi9TtLdxjlqTnvueAPrfCsRRgcWu/XNhLbhxX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=nvsYvXkT; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="nvsYvXkT"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4eda26a04bfso101924891cf.2
        for <nvdimm@lists.linux.dev>; Wed, 14 Jan 2026 00:52:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1768380754; x=1768985554; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4uI7G8mzCwfWt6hpevWSKMuVc2LUYnlWS3FX4pvAwGI=;
        b=nvsYvXkT8STPzuEmOh1XF3MGHxbEVqvnc1/z3bpGiQsg7wtrlQ9XW20KvJZih3dBKH
         AD38nXmc2bve0Xtk0HB0tRonIQdr3J9dRQp0ht/Wq2a3euuxbwGQZCKChzzbYcH6b9Pi
         ahWc7vl6emWc/V/no1I1OumQJl9vpI+u+N/vMUfLi66kAX5bUc2nfIctlIzw4s5Nr7LE
         c2/aRMoCoo5YXDv94pKvc4jU0hlR+v5J7L2kbyNBcM6GC+d6kus3JAMdEYe+dFGhqEtz
         YauO0FEs0atBwTEW0MpfpaVce07n7+FwNSn1Wxs+M5gvaYyavQRyZ6RzNGiJb1qyVjw8
         U3eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768380754; x=1768985554;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4uI7G8mzCwfWt6hpevWSKMuVc2LUYnlWS3FX4pvAwGI=;
        b=svO/ioEYZNvLVXpgkze1ow2hecqAz69g4WbWzYYr8tekUNPn7t0GgROdp+Ufe3n3Xt
         Falrl5TZEbj+anRVPkIkEDgWBInDtlelLq5TsXAdruubr5CBQpvBziqKvBIfzk64G4mq
         hAY9Hz/cflxC3bVP1BWwUV1GrXUIKThIx4bmYv1k5NaqzZgtzzGudajJrh/zzbJV9SV9
         /QPtPXu5pUASfnoEj0SL7CBmL9/IOcG9X5wW/UXGv65W2HysmxATwHItNtNHHbjTgupb
         4MAbfjeZcPqVPxaMjwASwv9Icp1MR/PAH3jQm3N9QnILbYRMWgFgmjZJhRnZ5rqf0UVc
         SoeA==
X-Forwarded-Encrypted: i=1; AJvYcCX6uzh2TuBErTS+MGgN4OW9AyHIZKlQ4XbUgWfxHxaMNmKm9qefNIif7n5XC67VwC8q9NUOyE8=@lists.linux.dev
X-Gm-Message-State: AOJu0YwnsEhI3zXt7JWn3jM4UXlnIWdSD5Fn73OPBSo4Crt5wbqvgSpL
	DeoV63imyeXyCHdZFYbLIlLixfFOuR6W5ty24vCH5OukDNUbcPCfWT9Jn+EoPmmf214=
X-Gm-Gg: AY/fxX6qfBiIFPM6HKYtknbMlgCOj2WUTHKzKbtqJqfd8wu/yHw2E0InNUupCpfHO9a
	QusFk3j6MJJibum3+wmz5xt9eLEUwDRBUMnyJ0Fyg4haRTQNzb9FKKj9H0ujUpTCtOe35fsmRUr
	2ZfaqGYyCUYB8BTBfSGV3CXa8ULE/uwXvb/CkbvO+70Gybg5X+a0O1ILMQzLQm+kKaMjwBbAhhz
	mnlfdzSRIuxskVu5XHsmwt+aALV9M3UrF15Yknu+8aYMHA+fQpn93q8RM9L5yJjCcP+jyqSAtAF
	akusBxi05uyatdikDWzVqj9SlAifM373kaKl7PNvqCaTrBW/Ls/ubgfsXGpv/frTbls/EJ0Q0EQ
	lNU1rWCvWyxHQ5oQPHfGj4EmTBDwzMbfICYmNdM+9EMpOST24Qv0EdNevvPeSBDZzG13n2Q9skB
	lS21jIUdPouVRzQ0sco2g50uAAxB/Gz7oByVo8EhsSoyiqz5WgNpp2yzk7X0vclW7rERjDf8HXW
	kQ=
X-Received: by 2002:a05:622a:58c5:b0:4f1:ab46:8e36 with SMTP id d75a77b69052e-5014a905f74mr11547531cf.9.1768380754428;
        Wed, 14 Jan 2026 00:52:34 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50148df8759sm10131931cf.10.2026.01.14.00.52.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jan 2026 00:52:33 -0800 (PST)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev,
	kernel-team@meta.com,
	dan.j.williams@intel.com,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	david@kernel.org,
	mst@redhat.com,
	jasowang@redhat.com,
	xuanzhuo@linux.alibaba.com,
	eperezma@redhat.com,
	osalvador@suse.de,
	akpm@linux-foundation.org
Subject: Subject: [PATCH 0/8] dax/kmem: add runtime hotplug state control    
Date: Wed, 14 Jan 2026 03:51:52 -0500
Message-ID: <20260114085201.3222597-1-gourry@gourry.net>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series adds the ability for the dax_kmem driver to control the
online/offline state of its entire memory region at runtime through a
single sysfs interface. This eliminates the need to manually iterate
over individual memory blocks when changing memory state.             
                                                                                                                                                  
Problem                                                                  
=======                                                                  
                                                                         
The dax_kmem driver currently provides no runtime control over memory
state after probe. Memory is automatically onlined using the system
default policy, and any subsequent state changes require userspace to:

  1. Enumerate all memory blocks backing the dax region                                                                                           
  2. Individually offline/online each block via
     /sys/devices/system/memory/memoryXXX/state
  3. Handle races with auto-online policies that may re-online blocks
  4. Coordinate offline+remove operations across multiple blocks

This is error-prone and creates race conditions between userspace
operations and kernel memory policies. There is no atomic way to                                                                                  
offline and remove an entire dax region, and no mechanism to prevent
external interference with driver-managed memory.

Solution
========

This series introduces a 'hotplug' sysfs attribute for dax devices that
provides atomic control over the entire memory region:

  /sys/bus/dax/devices/<device>/hotplug

The interface accepts the following states:
  - "offline": memory is added but not online
  - "online": memory is online as normal system RAM
  - "online_movable": memory is online in ZONE_MOVABLE
  - "unplug": memory is offlined and removed

The driver handles all memory blocks atomically and prevents external
state changes through a memory notifier that blocks operations not
initiated by the driver itself.

Series Organization
===================

Patches 1-4 refactor the mm/memory_hotplug infrastructure:

  - Patch 1: Pass online_type to online_memory_block() via arg
  - Patch 2: Extract __add_memory_resource() and __offline_memory()
  - Patch 3: Add APIs for explicit online type control
  - Patch 4: Return online type from add_memory_driver_managed()

Patches 5-8 implement the dax_kmem functionality:

  - Patch 5: Extract hotplug/hotremove helper functions
  - Patch 6: Add online/offline helper functions
  - Patch 7: Add sysfs interface for runtime hotplug state control
  - Patch 8: Add memory notifier to block external state changes

Backwards Compatibility
=======================
The driver uses MMOP_SYSTEM_DEFAULT at probe time to preserve existing
behavior. Systems with auto-online policies will continue to work as
before. The new sysfs interface is additive and does not change the
default probe behavior.


Gregory Price (8):
  mm/memory_hotplug: pass online_type to online_memory_block() via arg
  mm/memory_hotplug: extract __add_memory_resource() and
    __offline_memory()
  mm/memory_hotplug: add APIs for explicit online type control
  mm/memory_hotplug: return online type from add_memory_driver_managed()
  dax/kmem: extract hotplug/hotremove helper functions
  dax/kmem: add online/offline helper functions
  dax/kmem: add sysfs interface for runtime hotplug state control
  dax/kmem: add memory notifier to block external state changes

 drivers/dax/kmem.c             | 645 ++++++++++++++++++++++++++++-----
 drivers/virtio/virtio_mem.c    |   8 +-
 include/linux/memory_hotplug.h |   6 +-
 mm/memory_hotplug.c            | 139 +++++--
 4 files changed, 678 insertions(+), 120 deletions(-)

-- 
2.52.0


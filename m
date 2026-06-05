Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BC14305691
	for <nvdimm@lists.linux.dev>; Fri,  5 Jun 2026 21:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780694358; cv=none; b=Ln2Y92vp7oUTFxSsyLux5IFJUgg7LPHrfKxU0peNm+/ASzeTdW21o/3dqlGJ5MftBiuj1eUg/1NNXsI3Vot3N5elz+p58TguU1AnDcIFyL8LYSFI4g/Y/4fGYoBs/pbCOWtGo0mvZivvCfyIpnT6jHWp8nNLiymP/Kw4AMG581o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780694358; c=relaxed/simple;
	bh=QCRviciADGj1pekUeaVvIfpuqOLQFXYDvbirzdj0qiI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DckeJz2xFXsbAJWhWN8p7e/f9zAcPEd2x+v9PVoadG4H8qaI8xqGofPPRPFxO9dJCOq8vvgf4UKAMYtYoIukfhDRoFHPU12wxlWsZ3pbp9KiJPKBn//lC2ZW43VJKRnDM7WINsusmGWv70lal91z5JRFWY/TxTw+Y6JM6FjK6qM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=cOGWY5yM; arc=none smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="cOGWY5yM"
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-8ccf6a63a45so28534966d6.3
        for <nvdimm@lists.linux.dev>; Fri, 05 Jun 2026 14:19:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1780694355; x=1781299155; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=DBoOnWfEM7GbopQoF/ni1AEm1oH3LvPc3svVnbeBTyA=;
        b=cOGWY5yM1EJi0GWzjwIR6a33GPxvUDSNRJfkppheUsYdr897wOU/Breywf7CbgERUQ
         gBvhJwlUE/ZLVuAy2N9nvUpRmL4a5NzjIwIh9TIOBydSq7fgqiQVRaZkkJG7XfKYCxBx
         31sSnlBjv7vq1lBDtmZANwXSJPrrMudjUp6pkOrkEsbtc6ib6YdrMp7j0ult1A0XCN5/
         B+t4KsA1xEjegFk9o48C1ubAcIT/h3+r9Co/CEOUlEiXd/hY7Knq3osYfjHI903vIYOG
         GqZRBWMlZ/V6wFUFStGHFZB4+HtE1MJ1hw0Y+9AeKIfYf/FadN+eBnIYz99Dl0q3M/wu
         IczA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780694355; x=1781299155;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DBoOnWfEM7GbopQoF/ni1AEm1oH3LvPc3svVnbeBTyA=;
        b=YyATSJFqB6gkTbi+2fgX1URg/q5upWVAh8DJm7KD1njz53HC5ze4cdw9iw1rylJpQz
         TeNHVXrkrpfRMMauBKDp1E1mcV8qKmqP90W4h6zHnMSXLYN/34P191/zyK+UhN66q3Mh
         2PBmieuCBzcjqGrU1NF/Cwp3wOTX8xcNjah47qLj2VFK/eZv/WYfM4CtuZ5Ly95xbMhQ
         KO6CE2+ElrhPiP3B3a7SyAGfDMScZmBq0bNKGQbnSfwCk+E9GYbf4hqcKPW2/+5bVFSA
         /VmNmTwnDc+VEF3TGO0+oIcdSide4XkIxBVovDJOZ55X4IdT7sWkfrC2/LB33GM9ONbZ
         vfFQ==
X-Forwarded-Encrypted: i=1; AFNElJ/ePTjUxKmXWDMLXPvtyQOBVGg6mQbxTo5dNZM8jv6mzyDntiEJcJwBQifYNONZdXggKqDII+4=@lists.linux.dev
X-Gm-Message-State: AOJu0YyvRB+gftF6i0ezO5pgShPP+uHeegYj/ZumXewgJRdGOcrzHXwg
	YY5gO7Yi2nQlcbFbyi7LgpaUITNcH4hmg5ijEpG0UP46OK4blJ+OAyXC+otwPTUSRi4=
X-Gm-Gg: Acq92OETeuy4DQaBZLyywuAgV/DrTQCdQUSRMcak6I1dmL2GG/BpTDCrN3Ahuy+NFR3
	5ZKXC59RDAL6Xk+ztjnMqtd/tTctXydAAu0MnicjajHIc106lAClrkhRjXMVZCcj4hC+RefQnw2
	sV4rh6dDY70/v/wgEh9jOoSCORm0c63T3XNWNVm3Xb0Q/ILTWU6e5Z2cPQh6RhHpTwVVgMabc5y
	ksZ3bbAhqcS+ZkOL7FZwlGg/s3pimIqnPeLv0F0L9sr71OvVPnVmf9yXbyq8w4Ws2u/2EV7gzQO
	hgdCKxQCkyoWyfXgNbqBYgCndSYaIq4Zo66nw1aZGPqZEvLlnDHMNTM135Fb6qFqthDrFNF92Gm
	S1DzUfFG/tbH+P/fWBPx7xc6f/sB0kJveGWFzK6kLbnRASOkxw28QWTrkYBP4FRKvbBCKcaib85
	BrpYddfmZ2XOmaSWBmT3Il8uYUep+tXA+DvliIDRlOkoOPIFhEmwiGLQ1jUiXBT8NmnDZbRh6AO
	KC1mo/mxBZ+eZ3dxwKIYs8=
X-Received: by 2002:a05:6214:484a:b0:8ca:1ddd:a6b8 with SMTP id 6a1803df08f44-8cee600836dmr88586746d6.14.1780694354764;
        Fri, 05 Jun 2026 14:19:14 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8cecd277bbcsm90518196d6.49.2026.06.05.14.19.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2026 14:19:14 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org,
	nvdimm@lists.linux.dev
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	linux-cxl@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	osalvador@suse.de,
	shuah@kernel.org,
	gourry@gourry.net,
	alison.schofield@intel.com,
	Smita.KoralahalliChannabasappa@amd.com,
	ira.weiny@intel.com,
	apopple@nvidia.com
Subject: [PATCH v4 0/9] dax/kmem: atomic whole-device hotplug via sysfs
Date: Fri,  5 Jun 2026 22:19:02 +0100
Message-ID: <20260605211911.2160954-1-gourry@gourry.net>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The dax kmem driver onlines memory during probe using the system
default policy, with no atomic control for the state of an entire
region at runtime - only by toggling individual memory blocks.

Offlining and removing a whole region therefore races with other
userland controllers that interfere between the offline and remove
steps. This was discussed in the LPC2025 device memory sessions [1].

This series adds a sysfs "hotplug" attribute for atomic whole-device
hotplug control, plus the mm and dax plumbing to support it.

Transitions are atomic across every range of the device. The state
names mirror the per-block memoryX/state ABI with one modification:

  - "unplugged":      memory blocks are not present
  - "online":         online as system RAM, zone chosen by the kernel
  - "online_kernel":  online in ZONE_NORMAL
  - "online_movable": online in ZONE_MOVABLE

"offline" (blocks present but offline) is reportable for backward
compatibility but is not writable because it entices the race condition
we are trying to solve (offlining all the memory blocks in one atomic
and unplugging them in another atomic).

mm preparation:
  1. mm/memory: add memory_block_aligned_range() helper.
  2. mm/memory_hotplug: pass online_type to online_memory_block().
  3. mm/memory_hotplug: export mhp_get_default_online_type().
  4. mm/memory_hotplug: add __add_memory_driver_managed() so a driver can
     select the online policy.  The override is restricted to in-tree
     modules via EXPORT_SYMBOL_FOR_MODULES().
  5. mm/memory_hotplug: add offline_and_remove_memory_ranges() for atomic,
     all-or-nothing offline+remove of several ranges under a single
     lock_device_hotplug().

dax/kmem feature:
  6. Plumb online_type through the dax device creation path.
  7. Extract hotplug/hotremove into helper functions.
  8. Add the "hotplug" sysfs attribute.
  9. selftests/dax: regression test for the attribute.

DAX Kmem probe still creates the memory blocks by default, even when
the default policy is "offline" to preserve backwards compatibility.

Unplug (atomic offline+remove of the whole device) is the new
capability provided by the attribute.

I downgraded a BUG() to a WARN() when unbind is called while the device
is not unplugged.  The old per-block toggling pattern is still used by
userland tools and disconnects the 'hotplug' value from the real region
state; until per-block control is deprecated or restricted in some way,
WARN() flags that tools should move to the new atomic pattern.

Changes since v3 [2]:
  - Dropped the memory-tier dedup patch - mt_get_memory_type()
  - Added offline_and_remove_memory_ranges() with rollback
  - Added online_kernel so we mirror memoryX/state ABI.
  - Fixed a backward-compatibility regression: probe now always creates
    memory blocks (offline policy -> present+offline) instead an unplugged
    device, which broke tools expecting the blocks to be present.
  - Restricted the __add_memory_driver_managed() export to the kmem module
    only (was "kmem,cxl_core"); cxl_core can be added when it grows a user.
  - Renamed the alignment helper to memory_block_aligned_range() and
    dropped a dead enum->string helper (reusing online_type_to_str[]).
  - Added an in-tree selftest.

[1] https://lpc.events/event/19/contributions/2016/
[2] https://lore.kernel.org/all/20260321150404.3288786-1-gourry@gourry.net/

Gregory Price (9):
  mm/memory: add memory_block_aligned_range() helper
  mm/memory_hotplug: pass online_type to online_memory_block() via arg
  mm/memory_hotplug: export mhp_get_default_online_type
  mm/memory_hotplug: add __add_memory_driver_managed() with online_type
    arg
  mm/memory_hotplug: add offline_and_remove_memory_ranges()
  dax: plumb hotplug online_type through dax
  dax/kmem: extract hotplug/hotremove helper functions
  dax/kmem: add sysfs interface for atomic whole-device hotplug
  selftests/dax: add dax/kmem hotplug sysfs regression test

 Documentation/ABI/testing/sysfs-bus-dax       |  25 +
 drivers/dax/bus.c                             |   3 +
 drivers/dax/bus.h                             |   2 +
 drivers/dax/cxl.c                             |   1 +
 drivers/dax/dax-private.h                     |   3 +
 drivers/dax/hmem/hmem.c                       |   1 +
 drivers/dax/kmem.c                            | 500 ++++++++++++++----
 drivers/dax/pmem.c                            |   1 +
 include/linux/memory.h                        |  22 +
 include/linux/memory_hotplug.h                |  12 +
 mm/memory_hotplug.c                           | 163 +++++-
 tools/testing/selftests/Makefile              |   1 +
 tools/testing/selftests/dax/Makefile          |   6 +
 tools/testing/selftests/dax/config            |   4 +
 .../testing/selftests/dax/dax-kmem-hotplug.sh | 145 +++++
 tools/testing/selftests/dax/settings          |   1 +
 16 files changed, 774 insertions(+), 116 deletions(-)
 create mode 100644 tools/testing/selftests/dax/Makefile
 create mode 100644 tools/testing/selftests/dax/config
 create mode 100755 tools/testing/selftests/dax/dax-kmem-hotplug.sh
 create mode 100644 tools/testing/selftests/dax/settings


base-commit: 7f981ca4cef222e26fc2b4ceb2d2bfe7a6153d3a
-- 
2.54.0

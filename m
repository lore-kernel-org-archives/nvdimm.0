Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 162EA2D3ECF
	for <nvdimm@lists.linux.dev>; Tue, 30 Jun 2026 21:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782854331; cv=none; b=grZYgqnJfN1svl8XPrmP4QsnayLXwRZxJ1hwlBmtjcpoNtZR/iEWPoC8ZM8+4LrU8p0xP7KAxlubBXUEQc4kRuvyNl4b9amTvJR4hhrOKqhBLmTIwu95aSreNCSTHTY7lAbmLf52wUqiMwOkPj+4vmIkKR426meXnErLGVMjxsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782854331; c=relaxed/simple;
	bh=ZxDj2bIyTYA2VqEzR9BlPCz00cVKtf/fVVQwM0leMSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kks1UUIitCFs3tl6YLemWPT0+CQBFpCpwEDk2rwj/CohJInRx6pL5C+LwSBVvbsmgwLT6pzTeBmcWNRJPHd+TcSD9pIc1gLM1wPa743NT0nh6sz59S7h2iZbcMxEDsQV02y4rgwwWzA0nzj7pWzzzOX3XMLRagH+DZz8Vv4PG/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=RoHcimzs; arc=none smtp.client-ip=209.85.222.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="RoHcimzs"
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-92e5c92c389so167794185a.3
        for <nvdimm@lists.linux.dev>; Tue, 30 Jun 2026 14:18:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1782854328; x=1783459128; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=15soTVn10pZL1HzcUE7vkWAPLmAyPlWsN9L93RXfdBQ=;
        b=RoHcimzssnQ2zJm7ykmY/xdleLl68KmyS7e9dnjV8oxabDBBDlkUeVMEEslxWrcCAR
         0NwNbInR6FHC8h7UxwwEbzI5ybrb7mZjdsFgTf16EFVj6smzpVR5uJWe/kyr8H/QqWNc
         Pa61MCsg4M5eQh7w2KbJ77zP17G8Hjz83U+vpsO6yvzXMrep7aYmrQVGNkPiZz0M4GxO
         JJVU6lB5QJj1uKI3a5f0+/vl7SUqNBbq/wFpb0hdQ3n2jmRvHH+x89KgcGkOv34bGsFz
         37FhL9q7HBujfKYXq2A8R2eVo/ebKRpgcoY4w5lykpCQHsL0nZpkA54BA1fqwbxvL+3/
         VPrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782854328; x=1783459128;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=15soTVn10pZL1HzcUE7vkWAPLmAyPlWsN9L93RXfdBQ=;
        b=i7pBXiy1Mh7qs8fYbeSHaQdZqHgHwarJw8AFpaac9RLxlTtf2epeDb19zC2KPL57+w
         FG1QxIA40zXxDOiHZnewjgdSAzzqreAXWLJpBpMxtPb+XQUKLKu43CsrM/oBHs7msKGF
         uu9apvaJ8g35suyE4g0UXQsx/wikaEwvB4YfuKhF1f3HIldzdtH4ojA+SNzs/3qvVRSw
         s16VXhThkxZDI5OLTm7y5W00koQpjOboAJ9BMdauBnb+R/kN1/Rvb2jBAO9d0ToGnKKZ
         bW4Dvh3AeOAThnvTsN9H3npgF+anqUEOsQIgXlfEI5MQMDXLt/SouPM+rUABkJvQyKi1
         OpLg==
X-Gm-Message-State: AOJu0YwRB8jt6rXABUjl7Jtsw5QvqfGtd7Is+eIi5ICRf8ESze6dx7Ya
	Qq5rtgwvpCg8t9uuBr7d1P51wyIpqRDzIhq4EFBVm+SXV+kfMX63B3t0DEGunj5s6ao=
X-Gm-Gg: AfdE7cn6wb8POWK7iKXYc54vNTgxW+CLpD31UHXBuUWoQSg+Wp7yD+zEGh6vdCwPduQ
	UzNbYx34L8etl9b79n2o8lmkdypawlISZqDgblEAw7iRwIh207nlthhkTbD/IvJ/fAVVpjJmrKF
	N0BD/TOIRM92JtV0g3qReHjVyKyNI8IRVlKaMBrd6uJT9SFsQRDohIOv/jyMe2f7OZuOeMLX116
	BAULneUzD1igjoG55LCWWgx7au4yhWjEnrjZioFhs+07Q3+5i6BnJzfR+0YKyl5b8LV+fZvoCfI
	BVij6/cSimE9UNmV53rsaJxx4tNomkieE2zKIvFO9CmVAvVUfSrJ7sLz7X0M1KHDIaiQMBM2Fet
	2KOpUgVnLTC6bOqnVCdQ4f/SPHjWZHxtyyaW3ZD1KQb+C219g//wHJWQgSaMMviWcMMOOlX+8EN
	cvU4ilL0QcqJUA/upXWtwl5YtACt0yan2avlQ5cks6//CFcvcjyH2M9vGBGxlQiNxrdr1NfyzmA
	g==
X-Received: by 2002:a05:620a:29d5:b0:92b:67e6:8ac0 with SMTP id af79cd13be357-92e6284f33dmr789795885a.74.1782854328078;
        Tue, 30 Jun 2026 14:18:48 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92e62366303sm335924285a.40.2026.06.30.14.18.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 14:18:47 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	driver-core@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	kernel-team@meta.com,
	david@kernel.org,
	osalvador@suse.de,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	akpm@linux-foundation.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	gourry@gourry.net,
	iweiny@kernel.org,
	Smita.KoralahalliChannabasappa@amd.com,
	apopple@nvidia.com
Subject: [PATCH v6 00/10] dax/kmem: atomic whole-device hotplug via sysfs
Date: Tue, 30 Jun 2026 17:18:32 -0400
Message-ID: <20260630211842.2252800-1-gourry@gourry.net>
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
steps. This was discussed in the LPC2025 device memory sessions.

This series adds a sysfs "state" attribute for atomic whole-device
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
  2. mm/memory_hotplug: add mhp_online_type_to_str() and export the
     online-type string helpers.
  3. mm/memory_hotplug: pass online_type to online_memory_block().
  4. mm/memory_hotplug: export mhp_get_default_online_type().
  5. mm/memory_hotplug: add __add_memory_driver_managed() so a driver can
     select the online policy.  The override is restricted to in-tree
     modules via EXPORT_SYMBOL_FOR_MODULES().
  6. mm/memory_hotplug: add offline_and_remove_memory_ranges() for atomic,
     all-or-nothing offline+remove of several ranges under a single
     lock_device_hotplug().

dax/kmem feature:
  7. Plumb online_type through the dax device creation path.
  8. Extract hotplug/hotremove into helper functions.
  9. Add the "state" sysfs attribute.
  10. selftests/dax: regression test for the attribute.

DAX Kmem probe still creates the memory blocks by default, even when
the default policy is "offline" to preserve backwards compatibility.

Unplug (atomic offline+remove of the whole device) is the new
capability provided by the attribute.

I downgraded a BUG() to a WARN() when unbind is called while the device
is not unplugged.  The old per-block toggling pattern is still used by
userland tools and disconnects the 'state' attribute from the real region
state; until per-block control is deprecated or restricted in some way,
WARN() flags that tools should move to the new atomic pattern.

Changes since v5:
  - mm/memory_hotplug helper into own patch (david)
  - offline_and_remove_memory_ranges - nits (david)
  - offline_and_remove_memory_ranges - warn and continue (david)
  - memory_block_aligned_range(): end-address underflow (sashiko)
  - dax: store the online_type sentinel as int (sashiko)
  - dax/kmem: skip ranges that failed reservation on hotplug (sashiko)
  - dax/kmem: on unbind fallback to legacy if still online (sashiko)
  - selftests/dax: avoid cascading skips, clobbered state (sashiko)

Gregory Price (10):
  mm/memory: add memory_block_aligned_range() helper
  mm/memory_hotplug: add mhp_online_type_to_str() and export string
    helpers
  mm/memory_hotplug: pass online_type to online_memory_block() via arg
  mm/memory_hotplug: export mhp_get_default_online_type
  mm/memory_hotplug: add __add_memory_driver_managed() with online_type
    arg
  mm/memory_hotplug: add offline_and_remove_memory_ranges()
  dax: plumb hotplug online_type through dax
  dax/kmem: extract hotplug/hotremove helper functions
  dax/kmem: add sysfs interface for atomic whole-device hotplug
  selftests/dax: add dax/kmem hotplug sysfs regression test

 Documentation/ABI/testing/sysfs-bus-dax       |  26 +
 drivers/base/memory.c                         |   9 +
 drivers/dax/bus.c                             |   3 +
 drivers/dax/bus.h                             |   9 +
 drivers/dax/cxl.c                             |   1 +
 drivers/dax/dax-private.h                     |   4 +
 drivers/dax/hmem/hmem.c                       |   1 +
 drivers/dax/kmem.c                            | 516 ++++++++++++++----
 drivers/dax/pmem.c                            |   1 +
 include/linux/memory.h                        |  27 +
 include/linux/memory_hotplug.h                |  14 +
 mm/memory_hotplug.c                           | 161 ++++--
 tools/testing/selftests/Makefile              |   1 +
 tools/testing/selftests/dax/Makefile          |   6 +
 tools/testing/selftests/dax/config            |   4 +
 .../testing/selftests/dax/dax-kmem-hotplug.sh | 190 +++++++
 tools/testing/selftests/dax/settings          |   1 +
 17 files changed, 836 insertions(+), 138 deletions(-)
 create mode 100644 tools/testing/selftests/dax/Makefile
 create mode 100644 tools/testing/selftests/dax/config
 create mode 100755 tools/testing/selftests/dax/dax-kmem-hotplug.sh
 create mode 100644 tools/testing/selftests/dax/settings

-- 
2.53.0-Meta


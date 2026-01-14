Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 742231C3BEB
	for <nvdimm@lists.linux.dev>; Wed, 14 Jan 2026 23:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768434660; cv=none; b=PbTlTD6n6CSBSlVxHl96fW3lOzqJwgWZsiEbGVxAR6niP6wKL4+bgQFbCuYZ+XTWgzb1eSWEBI7tzjyzFQFnCBVyUXIKcH7A4Yx+/Ck8FTiQfH8/AzHAAJpYF3ueUEOZCIBT29MfyNeFhh+uTNmC4iW01sREpdBF5Lrp5CCY2hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768434660; c=relaxed/simple;
	bh=PsXVKNSP2IV5lNxkAtsT/bNWk13Co+2vRu/D64cg554=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fJ7/K1a4kyBAAlMMEClN3SLelxC60rIVK9OeCCf0wR0VFq4ZbbpDSDwdZxMiKU8yDfSFAJ1dbsAf/TRCqfAg4La0k1HWsmZU1MBLg38uTaLMwueMQX+88qNUpInsdq2t4MEXRst9Ni7l7uuQiStyy7VWE+WUNDfWurqEO4Bjrcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=L13/Ntbu; arc=none smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="L13/Ntbu"
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-88ffcb14e11so3562306d6.0
        for <nvdimm@lists.linux.dev>; Wed, 14 Jan 2026 15:50:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1768434657; x=1769039457; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vjrrFW0XqdppZNNWqIznZXzloYpv+TypGhEeLOQrMhw=;
        b=L13/NtbuTZXFJjtMsE32EvGfUMsKfw/nTCBrfsZLKl2YN3A9UPHFhBn5creVn/x+nY
         g1c5UEeerXGqsH7dZDNhr5M7p0jWFNxK0KVrda2PRs4as5O8360CEA/92Bs8DZ6zAkxY
         +rG9SVJoVwXPCyS+ysw7ZWAmSzVDXwxy731HuAkhwjXihKrCxJwmMF9jOwIlxbaFNPV0
         xTgjXQik8vpmWej/027zQguFMVNP+ioBS8Tam2Ir69XLHE5fUKUYDoVs/MveSkABgRFA
         DWlwym+kvw2H6tWuLAR80Hzc8meuSDKqwuSxEJiawgq38A8Kl1VviW7wJ6W/o8NXDiQD
         2sgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768434657; x=1769039457;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vjrrFW0XqdppZNNWqIznZXzloYpv+TypGhEeLOQrMhw=;
        b=ltha9KPf9gGn9QhWwOfD8v/QSVlSst93nc55E/1Lu0ouUqgRcGcQm0COWqmAx3UVmR
         Nq/qSInr4s2WQo/Ui1dyrzzQKkJA9zj7ftazLwGV0081SySYmYHteNvQQSoKXJdd5jFu
         uPCLhtnX/XaGPOKAuboAccYlsHyKkx8Ghu3gvD6OAZ+6Zxa+E2mOTjf8wUu/QxXOzUKj
         uXsfmN4VAwhcH6Hg7HqxvdmzgbHBoVUqVkHz4vefWaGZMaX7wpxFKdZm5hHf7KBgAnK7
         Ku3tgPmP5FKyve+k27RqnC+JQ29VC95CoS8wHyn6x5fXz3l/VcTn/4dWvMcgsGKB18fn
         hRdg==
X-Forwarded-Encrypted: i=1; AJvYcCXNL5E3Sx1XRME3DOeXUgDSW0g7jjssn1iOcXUEgpVnAX/eJhWvvlM4J+TfAkPlG5W3t3l6ayo=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy7RAj868psyneZTpfk2+U4eENd/IjzRW5Q7HRJliLAGI7xctVK
	octnRcQNuEklQDl/5gSDMzj/RInXblym7oz3IM3eqMQ8BpXx+E4YywNjeEm1UDWrgRc=
X-Gm-Gg: AY/fxX5z6ZReLkVVm06hCKuTWiGUJdKx3O9cdMN9O8d2W1Ub2lofbAmmDfSLakVQwqr
	AMdMORfyYvYYjnkkv0baVuhRvc8sDdYyA3jJFK9DBvRBtatJvgZRW5/SjE+q6bKdW+hYTyJ0EfX
	1n6maYK4eCTKEQOfaMnFS+nzgscFC5oKteGH7Hf3Fxq+p2SAotw/P+04lOmpiqIdSvTJkpl2IvI
	BG8YtQa+J1DZRw5NdIMCKeFsm1XM1vCEFYpmATGS3Jx4Y7wizkwzoRCUfwiKo+11Da6LsklQVsF
	W0q9U3atsLIf2rY+3/Ox4RI89f4zdhW862dsKjl8Wmsl4qo9krFMMHG+nILq+Cl/cBlJfHpZCYx
	NntalM8pz3QVJYU0nOPwQQjrV/zeG5seUzIPOSitlR6CI9miP9//OePtRkaXB0/5aotTuIkmij6
	Fbxi68C/50iAHSML0UjNBA+LGrqQcOQ5jY4Pv4UfMUAPP2hVoGGdolx/z90wfCYXjCxhNrjX25f
	cE=
X-Received: by 2002:a05:6214:401:b0:890:6603:f258 with SMTP id 6a1803df08f44-89274373da6mr61800136d6.12.1768434657410;
        Wed, 14 Jan 2026 15:50:57 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-890772346f8sm188449106d6.35.2026.01.14.15.50.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jan 2026 15:50:56 -0800 (PST)
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
Subject: [PATCH v2 0/5] add runtime hotplug state control
Date: Wed, 14 Jan 2026 18:50:16 -0500
Message-ID: <20260114235022.3437787-1-gourry@gourry.net>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The dax kmem driver currently onlines memory automatically during
probe using the system's default online policy but provides no way
to control or query the entire region state at runtime.

This series adds a sysfs interface to control DAX kmem memory
hotplug state, and refactors the memory_hotplug paths to make it
possible for drivers to request an online type at hotplug time.

Problem
=======

Once dax_kmem onlines memory during probe, there's no mechanism in
the dax driver to:

- Query the current state of the memory region
- Offline and hot-remove memory blocks atomically
- Control online type (ZONE_NORMAL vs ZONE_MOVABLE)
- Prevent external interference with driver-managed memory state

This forces users (such as ndctl) to toggle individual memory blocks
prior to unbinding the dax device, and has lead to some race conditions
between competing hotplug policies.

Solution
========

This series introduces a 'hotplug' sysfs attribute for dax_kmem devices
that allows userspace to control and query memory region state:

/sys/bus/dax/devices/daxN.M/hotplug

Supported states:
- "unplug": memory is offline and blocks are not present
- "online": memory is online as normal system RAM
- "online_movable": memory is online in ZONE_MOVABLE

A memory notifier prevents external operations (auto-online policies,
direct sysfs manipulation) from changing memory state, ensuring the
driver maintains consistent state tracking.

Patches
=======

Patches 1-2 prepare mm/memory_hotplug to allow callers to specify an
explicit online type rather than implicitly using the system default.

Patch 3 refactors dax_kmem to extract hotplug/hotremove helpers,
preparing for the sysfs interface.

Patch 4 adds the 'hotplug' sysfs interface for runtime state control.

Patch 5 adds a memory notifier to prevent external state changes and
maintain consistency between the sysfs interface and actual memory
block state.

Gregory Price (5):
  mm/memory_hotplug: pass online_type to online_memory_block() via arg
  mm/memory_hotplug: add 'online_type' argument to
    add_memory_driver_managed
  dax/kmem: extract hotplug/hotremove helper functions
  dax/kmem: add sysfs interface for runtime hotplug state control
  dax/kmem: add memory notifier to block external state changes

 Documentation/ABI/testing/sysfs-bus-dax |  17 +
 drivers/dax/kmem.c                      | 577 ++++++++++++++++++++----
 drivers/virtio/virtio_mem.c             |   3 +-
 include/linux/memory_hotplug.h          |   2 +-
 mm/memory_hotplug.c                     |  35 +-
 5 files changed, 528 insertions(+), 106 deletions(-)

-- 
2.52.0


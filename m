Received: from mail-vs1-f53.google.com (mail-vs1-f53.google.com [209.85.217.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 892D82DC332
	for <nvdimm@lists.linux.dev>; Sat, 21 Mar 2026 15:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774105451; cv=none; b=GCAvXvOonkjo5tJQsqNFrXBddM4LeM/q0ih5dyrcUV8b7dIU+bL1/XGueW1SueTInievvO7rWccha2cke+uJ19Dmj7bJ5D2ZT54JlAKXAKbshr2GOsEWK/zy244GIzJMCyq1yLQfE6AEmFFpI0Pw4xpYYnI2pnDJg2Ct4hCJ+RI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774105451; c=relaxed/simple;
	bh=aDELlooxNdwnVkBOav2pG7nLNFo7hMZ9D//B2Ne87+I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tullXGR7mWHVUo+f6bhZowzVZ7gDGQ9TVpbqCIR5CSpTstM2bk3KJbipStJ0whhlZouMxlTUK8nMrNYsxWGbbfj0uC6ZV4rDLIyK+8Vy2HtyIaUJ43KNyMrloJAsO/zJs0RgyUMmoPXpYhrsRyqh975Ebano+yhIvnK8HzL6yCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=DsgMbfAX; arc=none smtp.client-ip=209.85.217.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="DsgMbfAX"
Received: by mail-vs1-f53.google.com with SMTP id ada2fe7eead31-5fff18d44fbso1750794137.1
        for <nvdimm@lists.linux.dev>; Sat, 21 Mar 2026 08:04:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1774105448; x=1774710248; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=81HYMZ3vgCAeT6eFRo3fsP2FLDXA0ujBDRYZ8Ob/cJk=;
        b=DsgMbfAX9r+uLmTNKnBqbnxYYZEEvlzv6fDepuoyNLAd7awWN8ZG+/uL+yIJ8jvVlW
         FQf4CpLmKunlNC8Ou8tjEbJPO9WikOIJ9TfQ+3cXQo8h2X2XeXqW5OHZmoRRtbUf0WrX
         gXi6TycNgcc1zJbxDZBVz+NZ4OTUCPRRW1pg3XC5mmuwahvhKrqNs6vRwGqBvv1Pwmpx
         QrIGRSpFvDoXo0x+nX/CtVRU0YQ1vK+nSSM3q/rEE9RzupbJ90uNsAD8dExJtCKFjajN
         1bcIJOqOftU0j79gun+e6viJN76RrqWfImsIDX/lhPwfcbwF8xffQaRUwO08uZcoa359
         Rrfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774105448; x=1774710248;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=81HYMZ3vgCAeT6eFRo3fsP2FLDXA0ujBDRYZ8Ob/cJk=;
        b=O5QXfLtc3jA3egnqDQ7i1VEVE0810SklMPW9tZJ3R8EHQylExFXjH3J3uwmLohG0hy
         vdUAR9Dg5v71hoOGsUv1wqB5+A6gKINAxRYpcB57JBToSwvvnVl5spY6h/7XrQza8BSu
         wN6C9VDg6Mu8/j1+B4YJVd88tXO20lic/+HO7ed2jDTd27Tzh4iPq3MFj9BjzgTrMi3v
         OV5rj5hQkIUCY1oF8pt+EfAjshFeeEdPex+9Rr80G8M67oSKLkUk9djOkQ/FuUW65RS/
         3KLJW/J+wXfYl9lgRisaU4fZtxS/xq5dQtL8rylukGNFnj1X5o0cdiNYDsRcs3XeZNn0
         IXZQ==
X-Forwarded-Encrypted: i=1; AJvYcCXBQbhVEP6f9yrA3Jnf6LeSlqKQKBPVKZp700CdCq/NrBE+PzxLPPRvcLnAbo0xdDgg1x+ItEU=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw/C/T1bRj3PXT6lf791K3TjME79B/6d3+gWEYHaLwgQKQm2Oaw
	Of98Yjh/pFhj6oMfFz1+RxRhDofz4e1YTL12h0LTXjCLg4S/laWasMDaSI5vJvDa5kA=
X-Gm-Gg: ATEYQzz7voB+8TfSGTvmKXc+mRWZZQeUwNrnp6D/YZtcN/i7Ez1wgOgxMjL8hWEDHZl
	08qIGlTlKHGH/7/VsQtwxvasBRqn5sW58+cOfqp1/MUok/dLSicg1S9tt25SxunwkZNY+kZuq9N
	hvg6ET0InRXK+8l58Lr5SiY06o0/0AcAhJkl6xSTa4gf7STK215NdadMcEZJQz9uAThqX9aGFgW
	Ihz7ODG4aUkDQo1hgqypXbVFOrfStKA7iB86rdSBmjxnMROoDOjPDpDCdvh//uj8WosRVzlEqlU
	fw/+6efO4iB6R7fIXAdWr6eOf0e9sNleLHLz/NQ4cskrUarg06edHzlf3VD5dt94ART+EF/sgeA
	pTOhlauirADk5faJjxhXAguKqDex/lpXtjeoFEiAweJIuVWoQN2a20JRxtOkDq8SVnolOOQ9SWF
	T4EJcn1eGOv5gXSwMk4p6YsuqtyEP9ZxDPOArQKNHDXDOVDNoFUATXdX2EXQxISHmJDR/3JY3E2
	iWOcR1yMW6vhh9EcUcgpp3XaQ==
X-Received: by 2002:a05:6102:5989:b0:602:79ed:643c with SMTP id ada2fe7eead31-602aea8cc48mr3376178137.7.1774105448304;
        Sat, 21 Mar 2026 08:04:08 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cfc90ba89fsm391979885a.40.2026.03.21.08.04.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Mar 2026 08:04:07 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	osalvador@suse.de
Cc: dan.j.williams@intel.com,
	ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH 0/8] dax/kmem: atomic whole-device hotplug via sysfs
Date: Sat, 21 Mar 2026 11:03:56 -0400
Message-ID: <20260321150404.3288786-1-gourry@gourry.net>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The dax kmem driver currently onlines memory during probe using the
system default policy, with no way to control or query the region state
at runtime - other than by inspecting the state of individual blocks.

Offlining and removing an entire region requires operating on individual
memory blocks, creating race conditions where external entities can
interfere between the offline and remove steps.

The problem was discussed specifically in the LPC2025 device memory
sessions - https://lpc.events/event/19/contributions/2016/ - where
it was discussed how the non-atomic interface for dax hotplug is causing
issues in some distributions which have competing userland controllers
that interfere with each other.

This series adds a sysfs "hotplug" attribute for atomic whole-device
hotplug control, along with the mm and dax plumbing to support it.

The first five patches prepare the mm and dax layers:

  1. Consolidate memory-tier type deduplication into mt_get_memory_type(),
     removing redundant per-driver infrastructure.
  2. Add a memory_block_align_range() helper for hotplug range alignment.
  3-5. Thread an explicit online_type through the memory hotplug and dax
     paths, allowing drivers to specify a preferred auto-online policy
     (ZONE_NORMAL vs ZONE_MOVABLE) instead of being forced to the
     system default.

The last three patches build the dax/kmem feature:

  6. Plumb online_type through the dax device creation path.
  7. Extract hotplug/hotremove into helper functions to separate resource
     lifecycle from memory onlining.
  8. Add the "hotplug" sysfs attribute supporting three states:
     - "unplug": memory blocks removed
     - "online": online as normal system RAM
     - "online_movable": online in ZONE_MOVABLE

Transitions are atomic across all ranges in the device.  Backward
compatibility is preserved: probe still auto-onlines when the configured
policy matches the system default.

Specific notes for maintainers:

I downgraded a BUG() to a WARN() when unbind is called while the dax
device is not un an UNPLUGGED state.  This is because the old pattern of
toggling individual memory blocks is still used by userland tools, and
will disconnect the `hotplug` value from the actual state of the overall
memory region.

Unless we move to deprecate per-block controls, we should just WARN()
instead of BUG() as an indicator that userland tools need to be updated
to use the new pattern (the old pattern is subject to race conditions).

The first two commits are semi-unrelated cleanups that conflict with the
changes made in the refactoring commits. (memory-tier dedup and align_range
helper). These are intended to be used for future cxl region extensions,
but if you prefer them to be dropped or submitted separately let me
know.

This is technically v3, but the patch line has diverged considerably and
I've reworked the cover letter, apologies for prior obtuseness
Link: https://lore.kernel.org/all/20260114235022.3437787-1-gourry@gourry.net/

Gregory Price (8):
  mm/memory-tiers: consolidate memory type dedup into
    mt_get_memory_type()
  mm/memory: add memory_block_align_range() helper
  mm/memory_hotplug: pass online_type to online_memory_block() via arg
  mm/memory_hotplug: export mhp_get_default_online_type
  mm/memory_hotplug: add __add_memory_driver_managed() with online_type
    arg
  dax: plumb hotplug online_type through dax
  dax/kmem: extract hotplug/hotremove helper functions
  dax/kmem: add sysfs interface for atomic whole-device hotplug

 Documentation/ABI/testing/sysfs-bus-dax |  17 +
 drivers/dax/bus.c                       |   3 +
 drivers/dax/bus.h                       |   2 +
 drivers/dax/cxl.c                       |   1 +
 drivers/dax/dax-private.h               |   3 +
 drivers/dax/hmem/hmem.c                 |   1 +
 drivers/dax/kmem.c                      | 457 ++++++++++++++++++------
 include/linux/memory-tiers.h            |  34 +-
 include/linux/memory.h                  |  22 ++
 include/linux/memory_hotplug.h          |  32 ++
 mm/memory-tiers.c                       |  29 +-
 mm/memory_hotplug.c                     |  67 +++-
 12 files changed, 501 insertions(+), 167 deletions(-)

-- 
2.53.0


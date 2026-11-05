Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=130.117.225.111
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793898065;
	b=GsGJe7PwwE/WOS6Xgbq4ON5UP6dmcscTnCux+7a0nLsj9v19D/9K6zH1G4V0/p98tl3w
	 KXNX96b6Vat5Ts3fakZnVaaIb1v+tT+ZFK3DzjKv5bWC0hS63KkpCnVAq/rYImSXO2POW
	 Zxr3qttcc6/CkWi7eO9tv+lMlzePwQThC0xnpMzDrEcBYQXbdYyljvCIF8rdAUOrxXVLP
	 opsD4k25kgi/dBuTfpkI3ot2GTfXLbPPRkKTeOpHy/0BUCnCghqIF0hvXEUo6OKwCk9Vs
	 6wrv4SBSQySjh7DmwdZoQrKqhcoDp0mozpZsxxX1HCByaD6lUeD/TDuNLtkABzw2qvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793898065;
	h=DMARC-Filter:DKIM-Signature:Received:From:Subject:Date:Message-Id:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=imn662agbdX5zP5xBLIUgWlwgaext2h6zc6JhEY5gWY=;
	b=BoksOoihky/OTjtq6140Asstm7ipA9FuoYyAlxjC4badD0UStHmnpKpftT7etBz9zRwf
	 CJ0JeOFpjDkqiqIwidx1m5mr4qT4zynJ+VCedeSGbtLtq3J40YynhPzGh0yCfz7ji8yue
	 UHQ80xvAuo4ljwBxYekGh6qhTSmCwgvKaK7keU2wM1XA5jCJiOlpB1zI9gnI/OjyQ670O
	 TDvFpW9b22E4DbfQqqhqmrnrP9fSFs+Gb0tCTvlHrOjzKFJTP+3tGjRs2DTCSz9IT08KF
	 +oftw0PEbsj6AoGouJg4OzKyeztcWXFr7kTXiZLbvbWVU+jlmMLbvj+bt5xY7syEfpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=virtuozzo.com;
	spf=pass smtp.mailfrom=virtuozzo.com;
	dkim=pass header.d=virtuozzo.com header.i=@virtuozzo.com header.a=rsa-sha256 header.s=relay header.b=lWOC+ru8;
	arc=none smtp.remote-ip=130.117.225.111
Received: from relay.virtuozzo.com (relay.virtuozzo.com [130.117.225.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C75E9606EE8B;
	Thu,  5 Nov 2026 17:01:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C75E9606EE8B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=virtuozzo.com header.i=@virtuozzo.com header.a=rsa-sha256 header.s=relay header.b=lWOC+ru8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Message-Id:Date:Subject
	:From; bh=imn662agbdX5zP5xBLIUgWlwgaext2h6zc6JhEY5gWY=; b=lWOC+ru8GzAs4Oeudsz
	C/hktTnNK4iW1AiktlGT4mPASk69DX1djvErs/V4C+AjCGcJQvNuQHPpYGbvs1pbzLzE8Lt0spjrJ
	Ar5tiI42W2PxRQIr7pgJbobKxB8m1jGtceCk2KxoAXA0ziCNFRgEi+jmaNNrm/rXn115XLMj2uOkl
	AOKWkoGDUgzxlL1aUc6yYlNpt3tMhzYapthmCXioRAg8qqQ9LpEWTKVqeUJXdHOj7KBxzNkk2ipGy
	mPTRvH/KcJz8PSccRVu+WvbM/hyrGTwclutvLzerbQg2vDECIsQdJZPCvFiSx6zvou1n1wJFbclCi
	ZMqHkpDXCJs37/Q==;
Received: from ch-demo-asa.virtuozzo.com ([130.117.225.8] helo=f0.sw.ru)
	by relay.virtuozzo.com with esmtp (Exim 4.96)
	(envelope-from <khorenko@virtuozzo.com>)
	id 1xP0li-005CiT-0E;
	Thu, 05 Nov 2026 18:00:58 +0100
From: Konstantin Khorenko <khorenko@virtuozzo.com>
Subject: [PATCH v2 0/2] mm/huge_memory: take a reference on a device DAX
 PUD copied by fork
Date: Thu, 05 Nov 2026 18:00:54 +0100
Message-Id: <20261105-vstor-150143-copy_huge_pud-folio-refcount-v2-0-2828fe5a51ed@virtuozzo.com>
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAEa27GoC/52OQQ6CMBREr2K69pu2ChZX3sMQAuUDNconLW0Ew
 t2leAOXLzOZNwtzaA06djsszGIwzlC/gTwemO7KvkUw9cZMcpkKLgUEN5IFkXBxOYOmYSo632I
 x+BoaehkCi40m34+ApUwzTFMlr5xte8OWmM/ueuQ/dr56oh6jIDY6E8en/UwQsfePNwjgoKpaq
 SQRTVbhPRg7eppnOml6s3xd1y//lHuB+AAAAA==
X-Change-ID: 20261021-vstor-150143-copy_huge_pud-folio-refcount-ea269e668270
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Lorenzo Stoakes <ljs@kernel.org>, Alistair Popple <apopple@nvidia.com>, 
 Dan Williams <djbw@kernel.org>
Cc: linux-mm@kvack.org, nvdimm@lists.linux.dev, 
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Konstantin Khorenko <khorenko@virtuozzo.com>, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3904;
 i=khorenko@virtuozzo.com; h=from:subject:message-id;
 bh=hqQriZN4cRnxi6WxgUqzU1/jjFn9IHmUhJ5AFoUsixc=;
 b=owEBbQKS/ZANAwAKAVGWCkf5YVwqAcsmYgBq7LZLdsf/zRRI4qD3Olsg7Qy3mRGp8u4UGzafb
 xnv0bqOryGJAjMEAAEKAB0WIQRWD23IPcXT0GO9CCxRlgpH+WFcKgUCauy2SwAKCRBRlgpH+WFc
 KmIEEAC3HeGbT/5CXaKDpF9nFXNwlWDV0OSm7UtzheK5642SvASEByaFcqWTFtUCT0V+q+ldtdb
 MPKMsqSm/m+O73Y+zdNrKG14t4qWmK6FUPSKJT0qqRegz88xdOJD7RIFORpT7LxYCsTsZIWpcxl
 V8hwMEI82rNY9tGEM6vSYfKRAWshb9vMd00vU60Gcn6HCF9AcISvbnQfCHF7qntlFT1o1+kvSSS
 cfAsvJslcehDJ3ZfuoSwTB1N33L2uI2D2ZR9FufknEOx5v/cK6g98PxrShIAPWXPhBABJHZL4Iw
 BjB6U9V3VuQG2ZG9bl8LGgP6V3qd2/Ka6XYr+hA4lvPrhgiGJIwaq0yuVWXx+dwCcqmWPPQJSqk
 2bxwvsivb9k9A+Y5DCJIIrH6zGXuMxYVHQscBI9VTquNQrKYrz1BWfHrP6qTWHI0u/WoR7oLrWk
 Pu/EPVGbn75OjNVHw8U91HDlPMRskwRkvlcBvxa1VUUyeTAfsTbxotHfq3UWMFjzIic24G0ul71
 gQh+YQV5pGp8xsU3+zUOU8GuHUoMAM+UtcMKND07e6+Qobrj+5ME6fjsSRVDlbbOLIj9dcTNye9
 oSeiHQbmq3uxYtXmNumJgCgWh0ZKb7Ld3s9fdz1ju2K9BtaMuMje7o9fr+TPRABW1nkcSTCSBXK
 IL76YdHSFA3Y4Fw==
X-Developer-Key: i=khorenko@virtuozzo.com; a=openpgp;
 fpr=560F6DC83DC5D3D063BD082C51960A47F9615C2A

copy_huge_pud() copies a device DAX PUD into the child without the
reference, rmap and counter that vmf_insert_folio_pud() took, so the
child's unmap takes them from the parent. fork copies a device DAX VMA
once it has a guard region, so it takes no more than:

1. map a devdax instance with 1 GiB alignment and fault in a PUD;
2. MADV_GUARD_INSTALL a page elsewhere in the VMA;
3. fork, and let the child exit.

Patch 1 is the fix, patch 2 a selftest for it. I found it while
reworking copy_huge_pmd() for fork after David's review [1]; it is
independent of that series.

v2 is based on mm-hotfixes-unstable, as patch 1 is a fix for stable.

Testing
=======

 * mm-hotfixes-unstable x86_64 KVM guest with CONFIG_DEBUG_VM
 * pmem from memmap=3G!4G
 * devdax made with "ndctl create-namespace -m devdax -a 1G":

  +----------------------+--------------+------------------------------+
  | kernel               | fork_dax_pud | log                          |
  +----------------------+--------------+------------------------------+
  | mm-hotfixes-unstable | not ok       | BUG: Bad rss-counter state   |
  |                      |              | mm:... type:MM_FILEPAGES     |
  |                      |              | val:-262144                  |
  +----------------------+--------------+------------------------------+
  | + this series        | ok           | clean                        |
  +----------------------+--------------+------------------------------+

A variant that writes to the device and forks three times also hit,
on mm-hotfixes-unstable:

  WARNING: ./include/linux/rmap.h:159 at
  __folio_large_mapcount_sanity_checks+0x90/0x150

With the series it is clean, and the guard-regions selftest passes.

The selftest only runs on a device given in FORK_DAX_PUD_DEVICE or
argv[1], as on an unfixed kernel it leaves that device's folio with a
mapcount below zero. On pmem emulated in RAM, with
CONFIG_X86_PMEM_LEGACY and CONFIG_DEV_DAX_PMEM:

  boot with memmap=3G!4G
  ndctl create-namespace -f -e namespace0.0 -m devdax -a 1G
  FORK_DAX_PUD_DEVICE=/dev/dax0.0 ./fork_dax_pud

[1] https://lore.kernel.org/linux-mm/20261014-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v3-0-85eaec8417f6@virtuozzo.com/

Assisted-by: LLM
Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
---
Changes in v2:
- Patch 1: copy_huge_pud() takes only the VMAs, and the TODO moves next
  to the rmap duplication, as in David's fix for the same bug:
  https://lore.kernel.org/all/26862633-c3d1-4b82-8ca2-346cb78570d7@kernel.org/
- Patch 2: read_sysfs() and a new rss_file() in vm_util instead of local
  helpers (Sashiko).
- Assisted-by moved from the patches to this cover letter.
- Rebased onto mm-hotfixes-unstable.
- Link to v1: https://patch.msgid.link/20261021-vstor-150143-copy_huge_pud-folio-refcount-v1-0-8bd88551f9be@virtuozzo.com

---
Konstantin Khorenko (2):
      mm/huge_memory: take a reference on a folio PUD copied by fork
      selftests/mm: test fork of a device DAX PUD

 MAINTAINERS                               |   1 +
 include/linux/huge_mm.h                   |   5 +-
 include/linux/rmap.h                      |  22 ++++++
 mm/huge_memory.c                          |  27 ++++---
 mm/memory.c                               |   4 +-
 tools/testing/selftests/mm/Makefile       |   1 +
 tools/testing/selftests/mm/fork_dax_pud.c | 114 ++++++++++++++++++++++++++++++
 tools/testing/selftests/mm/run_vmtests.sh |   1 +
 tools/testing/selftests/mm/vm_util.c      |  21 ++++++
 tools/testing/selftests/mm/vm_util.h      |   1 +
 10 files changed, 183 insertions(+), 14 deletions(-)
---
base-commit: af05d765a4476d2e48099148c80f9b13f462e309
change-id: 20261021-vstor-150143-copy_huge_pud-folio-refcount-ea269e668270

Best regards,
--  
Konstantin Khorenko,
Virtuozzo Linux Kernel Team


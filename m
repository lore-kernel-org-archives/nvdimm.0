Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=130.117.225.111
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792606274;
	b=EfizN+zw7Ig5Jll/YDo5gye2AHfHoYcbeW3HjmCU/r5ISbiuDjhbPLxa2EAV2Azc//4+
	 nPNazTGlFqs97xMgdX26z6hCgJd2fMlhMK9g38BJSdIKSplQ1y++kuUAODaGQnHHXy9j5
	 T1rWnRW7kNOOhe6pI0NvUfvAHf/714RwzQj3cltPRjbjXPduG50+lbupriCAXQTT1uO4c
	 +L5OUI59rvSop98fVB5BIhLDkb/46vs3u360IA7StuZ2dRgnnvzTqzm8GWSCPV4hhb9p4
	 +5UKnXOQc7ili8a2qPWTMsg1HYetl+R1OP/cuYEVOrM8wJjchK9VunFx5B5IrWofViA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792606274;
	h=DMARC-Filter:DKIM-Signature:Received:From:Subject:Date:Message-Id:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=SBcAfdk1AvTqfXhE/cLVYMH0/26jRBw6wDx068f64L8=;
	b=VACkkpfC8ac7TrkRvqidGY/oIlozWWyA6EfD1xY4u6jcsYkl+6fPd9DlRJoWxvG9EHwH
	 jQwmzL8xkQxrK+JKl+VMPycf6QwGnsfwImxuvf2+/RZS9Vt5HzkI+dP4DrD4XzJ9KN+YU
	 NFsiRPkwJdr3h+jc8L0NgKG5EjPjnGTq7nYzc8HCmFT3F8KUeOWYmr/QN6tlzhW3HRYP5
	 rKnxl97y3Mj+9jLcLFnPqjlNqY+WbQQGbsEZBzkSgY47YHVlkgLzWvzN598FSqgk7nOQH
	 TMq4yv//d4pzqp7Kl+wXNdLEozfEewHVY4YnooFTdQZtD4F98geewTTce9qlshXlJ1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=virtuozzo.com;
	spf=pass smtp.mailfrom=virtuozzo.com;
	dkim=pass header.d=virtuozzo.com header.i=@virtuozzo.com header.a=rsa-sha256 header.s=relay header.b=Y0nGvAzD;
	arc=none smtp.remote-ip=130.117.225.111
Received: from relay.virtuozzo.com (relay.virtuozzo.com [130.117.225.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 636DD606A31D;
	Wed, 21 Oct 2026 18:11:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 636DD606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=virtuozzo.com header.i=@virtuozzo.com header.a=rsa-sha256 header.s=relay header.b=Y0nGvAzD
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Message-Id:Date:Subject
	:From; bh=SBcAfdk1AvTqfXhE/cLVYMH0/26jRBw6wDx068f64L8=; b=Y0nGvAzD9q/QlX076wT
	H2f//OoLXdbANexbqcrmpWSPR9oNkB2XZrtg3dQZ8y6KGI0BdpYPef7z2Ujb2z17R8ODE4V+DSrO5
	tQUXQC8uEKqI0mFKvHnexfbZdrKcepz4y9BniXxAqTq6ynhhPsZPsDoAtf5/DaxO5Nq0k+R4mZxmL
	/NZlV5D8yyq+YS+7AxmP2s1/zi0GcK7GDnNGarXWPNCoXA3Fvu0eV6ZXJzSBLXa2TSpJtjVmqS0Ww
	a1OvwhBIqvdJqudA8D5dJrfDxBEhdgCyvE3slHgCYGHijsAI07Rzk2YdKzYHmvJzKUD84Wn0vPcmL
	YiDq4MV/zjlikIg==;
Received: from ch-demo-asa.virtuozzo.com ([130.117.225.8] helo=f0.sw.ru)
	by relay.virtuozzo.com with esmtp (Exim 4.96)
	(envelope-from <khorenko@virtuozzo.com>)
	id 1xJaif-00ANvl-0p;
	Wed, 21 Oct 2026 20:11:04 +0200
From: Konstantin Khorenko <khorenko@virtuozzo.com>
Subject: [PATCH 0/2] mm/huge_memory: take a reference on a device DAX PUD
 copied by fork
Date: Wed, 21 Oct 2026 20:10:52 +0200
Message-Id: <20261021-vstor-150143-copy_huge_pud-folio-refcount-v1-0-8bd88551f9be@virtuozzo.com>
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
X-B4-Tracking: v=1; b=H4sIACwA2WoC/yXNWwrCMBCF4a2UeXYgiRovWylSajptRyQTcilK6
 d6N+vhx4PwrJIpMCa7NCpEWTiy+Qu8acHPvJ0IeqsEoY7UyGpeUJaI+Kn3Yo5Pw7uYyURfKgKM
 8WTDS6KT4jNQbeyFrz+akoP6FuvDr12pvf6dyf5DL3wBs2weyRX6cjQAAAA==
X-Change-ID: 20261021-vstor-150143-copy_huge_pud-folio-refcount-ea269e668270
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Alistair Popple <apopple@nvidia.com>, Dan Williams <djbw@kernel.org>
Cc: linux-mm@kvack.org, nvdimm@lists.linux.dev, 
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Konstantin Khorenko <khorenko@virtuozzo.com>, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2640;
 i=khorenko@virtuozzo.com; h=from:subject:message-id;
 bh=u9/28GqAiRcjxN3gSB/+og/EEsQKnoWl2BqSCLQbuXw=;
 b=owEBbQKS/ZANAwAKAVGWCkf5YVwqAcsmYgBq2QA38h+Jm/HpSxjoZpvbreseAaPuYo90VD7VG
 Wcb5XtQjcqJAjMEAAEKAB0WIQRWD23IPcXT0GO9CCxRlgpH+WFcKgUCatkANwAKCRBRlgpH+WFc
 Kg4lEADGj9dohxRIf7msa+ab+qR251KQGQWsoZ160OAxzAbbcuxLeuNED8iLrada1ekOGqlIALq
 9TeT8csTn+1QtEppLfRD3T7G9aM7gSGsdfe7u0qgXj8d37mer0svdAirPkw97VXbAf8nVEtuH2i
 5+Dj1pBnuIUG3oRyLz7Lvmp7WNGmNFlfjnT8NpSMoAc6b7b+2Ws2EVokRSwghtZ5L0ufxWQ+uzr
 7Pe7/Lm4sTM6C9EwY6W+8xP7epOz/wm7d/RiMDd6zkAww7CZvU8lPXW3ZRm0FAza0YgWa3oqQE5
 lZ8uPyun37txmrB/e/3kngt3VLlpwnphMBYYWqoSs3LJfGh4JfWsRM7c4lHwP4uvRi3CfXfZTAq
 RaNeTW1IXsIJP7edjxZb2LcadEhXbq7gbmgE+ix9l3kAOPtXdyL+5re75E9o0QF/uAh28AFDNYD
 0dfO53P/W3BcEsRwCaUP/QoLPHwX+b44oONpstxfEGeN76Ho52xzm9HGVNijxF/sFcPh8zbYUyI
 X1OdK/NYrbs8hRsjwRRS0xdOcW6vZnG0/tJUpH/nGT3cinC88aIuGwV7b3uv6Y9mCmIDu9zTFdQ
 RB96wlBCgdyrUwX0UC7Itu172JsXEcaUXbCkitF71D4WJ1oJDp+G/XYHa3p2lWg6Bq05MRSY9gc
 B7qrnxk3a0hPLUg==
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
independent of that series and applies to v7.3-rc7 on its own.

Testing
=======

 * v7.3-rc7 x86_64 KVM guest with CONFIG_DEBUG_VM
 * pmem from memmap=3G!4G
 * devdax made with "ndctl create-namespace -m devdax -a 1G":

  kernel              fork_dax_pud   log
  7.3-rc7             not ok         BUG: Bad rss-counter state mm:...
                                     type:MM_FILEPAGES val:-262144
  7.3-rc7 + patch 1   ok             clean

A variant that writes to the device and forks three times also hit,
on 7.3-rc7:

  WARNING: ./include/linux/rmap.h:159 at
  __folio_large_mapcount_sanity_checks+0x90/0x150

The selftest only runs on a device given in FORK_DAX_PUD_DEVICE or
argv[1], as on an unfixed kernel it leaves that device's folio with a
mapcount below zero. On pmem emulated in RAM, with
CONFIG_X86_PMEM_LEGACY and CONFIG_DEV_DAX_PMEM:

  boot with memmap=3G!4G
  ndctl create-namespace -f -e namespace0.0 -m devdax -a 1G
  FORK_DAX_PUD_DEVICE=/dev/dax0.0 ./fork_dax_pud

[1] https://lore.kernel.org/linux-mm/20261014-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v3-0-85eaec8417f6@virtuozzo.com/

Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
---
Konstantin Khorenko (2):
      mm/huge_memory: take a reference on a folio PUD copied by fork
      selftests/mm: test fork of a device DAX PUD

 MAINTAINERS                               |   1 +
 include/linux/huge_mm.h                   |   2 +-
 include/linux/rmap.h                      |  22 +++++
 mm/huge_memory.c                          |  13 ++-
 mm/memory.c                               |   4 +-
 tools/testing/selftests/mm/Makefile       |   1 +
 tools/testing/selftests/mm/fork_dax_pud.c | 136 ++++++++++++++++++++++++++++++
 tools/testing/selftests/mm/run_vmtests.sh |   1 +
 8 files changed, 175 insertions(+), 5 deletions(-)
---
base-commit: a804c5742bff224d4cb4d25dd383554d598be32b
change-id: 20261021-vstor-150143-copy_huge_pud-folio-refcount-ea269e668270

Best regards,
--  
Konstantin Khorenko,
Virtuozzo Linux Kernel Team


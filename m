Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0A9234887E;
	Thu, 23 Apr 2026 17:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776963740; cv=none; b=RMg7JDR9Tx4Udojo8yM79EqvCSrfnyRLRbxOtOVM0QHO6LisIEGu9AGk4wi2z97aOlhJDooCYQI3pKblj0qyzzS22tNs6fUqMlOWbdix4UANGcMiJR5+4Mxyq3WVWyn+IPLfPzv/0OJuu0No/Hzc62B5M+Tnf17LczOVD2/FaT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776963740; c=relaxed/simple;
	bh=qgnQlWxXaF5HdEgHEIQNIizPPhmxwjQki4MyYBs8IWM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=N/UJmt9JGK5YFA0M5DznnS1UFiGWAUZS232HkKnBJ//xHxb39M0gMqd/rMqY7marf/8S5zg59GuGUriEgedGu8ZP2BL6mg/ok1XAq8Nltzp4FSxULtpEHrCJY7TAHAOhCiwy6EPmFHljhcmlDPJ+AtyZsxfbia0nUwAMws56uoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CEB8C2BCAF;
	Thu, 23 Apr 2026 17:02:20 +0000 (UTC)
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: djbw@kernel.org,
	iweiny@kernel.org,
	pasha.tatashin@soleen.com,
	mclapinski@google.com,
	rppt@kernel.org,
	joao.m.martins@oracle.com,
	jic23@kernel.org,
	gourry@gourry.net,
	john@groves.net,
	rick.p.edgecombe@intel.com
Subject: [RFC PATCH 00/12] dax: Add DAX to guest memfd support for KVM
Date: Thu, 23 Apr 2026 10:02:07 -0700
Message-ID: <20260423170219.281618-1-dave.jiang@intel.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This RFC series is created as a proof of concept to connect device DAX to guest
memory by riding on top of guest memfd in order to prove out that device DAX
can be used as guest memory. The series seeks to jump start a discussion on
if there are interests in creating a DAX bridge to utilize CXL memory for guest
memory until the N_PRIVATE implementation by Gregory [1] is available upstream
and DAX users are ready to move to the new scheme. Once there's an established
consensus of interest, we can move the discussion to the best way to implement
the DAX bridge and the future of device DAX as guest.

I did the bare minimal to get the PoC to pass a modified version of KVM gmem
selftest (guest_memfd_test) in order to prove out that DAX can go in the gmem
path. A DAX char dev is created and the fd is passed in user space with
vm_set_user_memory_region2(). The DAX region is passed in as a whole when used
unlike memfd where any size can be passed in to be allocated.

The folks on the cc line are people that Dan Williams has mentioned that may be
of interest to this.

[1]: https://lore.kernel.org/linux-cxl/aeWV1CvP9ImZ3eEG@gourry-fedora-PF4VCD3F/T/#t


Dave Jiang (12):
  dax: rate limit dev_dax_huge_fault() output
  dax: Save the kva from memremap
  dax: Add fallocate support to device dax
  dax: Move dax_pgoff_to_phys() to dax bus to be used by dev dax
  dax: Add dax_operations and supporting functions to device dax
  dax: Add helper to determine if a 'struct file' supports dax
  KVM: guest_memfd: Add setup of daxfd when binding gmem
  fs: allow char dev to go through fallocate
  dax: Add dax_get_dev_dax() helper function
  kvm: Implement dax support for KVM faulting
  kvm: Add daxfd support for supported flags
  selftest/kvm: Add daxfd support for gmem selftest

 arch/x86/kvm/Kconfig                          |   1 +
 arch/x86/kvm/mmu/mmu.c                        |  48 ++-
 drivers/dax/bus.c                             | 132 ++++++-
 drivers/dax/dax-private.h                     |   8 +
 drivers/dax/device.c                          |  80 +++--
 fs/open.c                                     |   3 +-
 include/linux/dax.h                           |  15 +
 include/linux/kvm_host.h                      |  39 +++
 include/uapi/linux/kvm.h                      |   4 +
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../testing/selftests/kvm/guest_daxfd_test.c  | 329 ++++++++++++++++++
 virt/kvm/Kconfig                              |   4 +
 virt/kvm/guest_memfd.c                        |  92 ++++-
 virt/kvm/kvm_main.c                           |   6 +
 14 files changed, 711 insertions(+), 51 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/guest_daxfd_test.c


base-commit: 05f7e89ab9731565d8a62e3b5d1ec206485eeb0b
-- 
2.53.0


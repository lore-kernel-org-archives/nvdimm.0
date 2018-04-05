Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-it0-x242.google.com (mail-it0-x242.google.com
 [IPv6:2607:f8b0:4001:c0b::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1C207225264B7
 for <linux-nvdimm@lists.01.org>; Thu,  5 Apr 2018 00:15:10 -0700 (PDT)
Received: by mail-it0-x242.google.com with SMTP id x144-v6so1041903itc.0
 for <linux-nvdimm@lists.01.org>; Thu, 05 Apr 2018 00:15:10 -0700 (PDT)
From: Balbir Singh <bsingharora@gmail.com>
Subject: [PATCH v2 0/3]  Add support for memcpy_mcsafe
Date: Thu,  5 Apr 2018 17:14:57 +1000
Message-Id: <20180405071500.22320-1-bsingharora@gmail.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linuxppc-dev@lists.ozlabs.org
Cc: mpe@ellerman.id.au, npiggin@gmail.com, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

memcpy_mcsafe() is an API currently used by the pmem subsystem to convert
errors while doing a memcpy (machine check exception errors) to a return
value. This patchset consists of three patches

1. The first patch is a bug fix to handle machine check errors correctly
while walking the page tables in kernel mode, due to huge pmd/pud sizes
2. The second patch adds memcpy_mcsafe() support, this is largely derived
from existing code
3. The third patch registers for callbacks on machine check exceptions and
in them uses specialized knowledge of the type of page to decide whether
to handle the MCE as is or to return to a fixup address present in
memcpy_mcsafe(). If a fixup address is used, then we return an error
value of -EFAULT to the caller.

Testing

A large part of the testing was done under a simulator by selectively
inserting machine check exceptions in a test driver doing memcpy_mcsafe
via ioctls.

Changelog v2
 - Fix the logic of shifting in addr_to_pfn
 - Use shift consistently instead of PAGE_SHIFT
 - Fix a typo in patch1

Balbir Singh (3):
  powerpc/mce: Bug fixes for MCE handling in kernel space
  powerpc/memcpy: Add memcpy_mcsafe for pmem
  powerpc/mce: Handle memcpy_mcsafe

 arch/powerpc/include/asm/mce.h      |   3 +-
 arch/powerpc/include/asm/string.h   |   2 +
 arch/powerpc/kernel/mce.c           |  77 ++++++++++++-
 arch/powerpc/kernel/mce_power.c     |  26 +++--
 arch/powerpc/lib/Makefile           |   2 +-
 arch/powerpc/lib/memcpy_mcsafe_64.S | 212 ++++++++++++++++++++++++++++++++++++
 6 files changed, 308 insertions(+), 14 deletions(-)
 create mode 100644 arch/powerpc/lib/memcpy_mcsafe_64.S

-- 
2.13.6

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

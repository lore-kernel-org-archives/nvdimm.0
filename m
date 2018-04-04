Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pl0-x241.google.com (mail-pl0-x241.google.com
 [IPv6:2607:f8b0:400e:c01::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8CEE422526490
 for <linux-nvdimm@lists.01.org>; Wed,  4 Apr 2018 16:19:56 -0700 (PDT)
Received: by mail-pl0-x241.google.com with SMTP id 61-v6so14404439plb.2
 for <linux-nvdimm@lists.01.org>; Wed, 04 Apr 2018 16:19:56 -0700 (PDT)
From: Balbir Singh <bsingharora@gmail.com>
Subject: [RESEND 0/3] Add support for memcpy_mcsafe
Date: Thu,  5 Apr 2018 09:19:40 +1000
Message-Id: <20180404231943.29581-1-bsingharora@gmail.com>
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

Balbir Singh (3):
  powerpc/mce: Bug fixes for MCE handling in kernel space
  powerpc/memcpy: Add memcpy_mcsafe for pmem
  powerpc/mce: Handle memcpy_mcsafe

 arch/powerpc/include/asm/mce.h      |   3 +-
 arch/powerpc/include/asm/string.h   |   2 +
 arch/powerpc/kernel/mce.c           |  76 +++++++++++-
 arch/powerpc/kernel/mce_power.c     |  17 +--
 arch/powerpc/lib/Makefile           |   2 +-
 arch/powerpc/lib/memcpy_mcsafe_64.S | 225 ++++++++++++++++++++++++++++++++++++
 6 files changed, 314 insertions(+), 11 deletions(-)
 create mode 100644 arch/powerpc/lib/memcpy_mcsafe_64.S

-- 
2.13.6

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

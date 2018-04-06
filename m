Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2B9A722620E91
 for <linux-nvdimm@lists.01.org>; Fri,  6 Apr 2018 08:46:32 -0700 (PDT)
From: "Luck, Tony" <tony.luck@intel.com>
Subject: RE: [RESEND 2/3] powerpc/memcpy: Add memcpy_mcsafe for pmem
Date: Fri, 6 Apr 2018 15:46:30 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F7B3C797F@ORSMSX110.amr.corp.intel.com>
References: <20180404231943.29581-1-bsingharora@gmail.com>
 <20180404231943.29581-3-bsingharora@gmail.com>
 <20180405095755.58b3891f@roar.ozlabs.ibm.com>
 <CAPcyv4hqKsOy9GU=NcMGj38pXnuEMRhXfox6jVwQ37+mcjnvhA@mail.gmail.com>
 <20180405150405.5b902b41@roar.ozlabs.ibm.com>
 <20180405155307.49f748f3@gmail.com>
 <20180405164508.7a15a770@roar.ozlabs.ibm.com>
 <x496055gzet.fsf@segfault.boston.devel.redhat.com>
 <20180406112600.454432f0@roar.ozlabs.ibm.com>
 <CAKTCnz=LD_uO7bdwFHDHy9KHHJ_dPA1LdxF1Pm7OUFFGr4s_VA@mail.gmail.com>
In-Reply-To: <CAKTCnz=LD_uO7bdwFHDHy9KHHJ_dPA1LdxF1Pm7OUFFGr4s_VA@mail.gmail.com>
Content-Language: en-US
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Balbir Singh <bsingharora@gmail.com>, Nicholas Piggin <npiggin@gmail.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, Michael Ellerman <mpe@ellerman.id.au>, Matthew Wilcox <mawilcox@microsoft.com>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

> I thought the cache-aligned might make sense, since usually we'd expect the
> failure to be at a cache-line level, but our copy_tofrom_user does accurate
> accounting

That's one of the wrinkles in the current x86 memcpy_mcsafe(). It starts by
checking alignment of the source address, and moves a byte at a time until
it is 8-byte aligned. We do this because current x86 implementations do not
gracefully handle an unaligned read that spans from a good cache-line into
a poisoned one.

This is different from copy_tofrom_user which aligns the destination for speed
reasons (unaligned reads have a lower penalty than unaligned writes).

-Tony
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

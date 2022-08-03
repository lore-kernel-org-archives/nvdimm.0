Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01CBD20E4
	for <nvdimm@lists.linux.dev>; Wed,  3 Aug 2022 17:37:34 +0000 (UTC)
Received: from fraeml715-chm.china.huawei.com (unknown [172.18.147.200])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Lyf7p6KTNz682vm;
	Thu,  4 Aug 2022 01:32:38 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 fraeml715-chm.china.huawei.com (10.206.15.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 3 Aug 2022 19:37:31 +0200
Received: from localhost (10.202.226.42) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 3 Aug
 2022 18:37:31 +0100
Date: Wed, 3 Aug 2022 18:37:29 +0100
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: Dave Jiang <dave.jiang@intel.com>
CC: Davidlohr Bueso <dave@stgolabs.net>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <dan.j.williams@intel.com>, <bwidawsk@kernel.org>,
	<ira.weiny@intel.com>, <vishal.l.verma@intel.com>,
	<alison.schofield@intel.com>, <a.manzanares@samsung.com>,
	<linux-arch@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH RFC 10/15] x86: add an arch helper function to
 invalidate all cache for nvdimm
Message-ID: <20220803183729.00002183@huawei.com>
In-Reply-To: <4bedc81d-62fa-7091-029e-a2e56b4f8f7a@intel.com>
References: <165791918718.2491387.4203738301057301285.stgit@djiang5-desk3.ch.intel.com>
	<165791937063.2491387.15277418618265930924.stgit@djiang5-desk3.ch.intel.com>
	<20220718053039.5whjdcxynukildlo@offworld>
	<4bedc81d-62fa-7091-029e-a2e56b4f8f7a@intel.com>
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.29; i686-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [10.202.226.42]
X-ClientProxiedBy: lhreml740-chm.china.huawei.com (10.201.108.190) To
 lhrpeml500005.china.huawei.com (7.191.163.240)
X-CFilter-Loop: Reflected

On Tue, 19 Jul 2022 12:07:03 -0700
Dave Jiang <dave.jiang@intel.com> wrote:

> On 7/17/2022 10:30 PM, Davidlohr Bueso wrote:
> > On Fri, 15 Jul 2022, Dave Jiang wrote:
> > =20
> >> The original implementation to flush all cache after unlocking the=20
> >> nvdimm
> >> resides in drivers/acpi/nfit/intel.c. This is a temporary stop gap unt=
il
> >> nvdimm with security operations arrives on other archs. With support C=
XL
> >> pmem supporting security operations, specifically "unlock" dimm, the=20
> >> need
> >> for an arch supported helper function to invalidate all CPU cache for
> >> nvdimm has arrived. Remove original implementation from acpi/nfit and=
=20
> >> add
> >> cross arch support for this operation.
> >>
> >> Add CONFIG_ARCH_HAS_NVDIMM_INVAL_CACHE Kconfig and allow x86_64 to=20
> >> opt in
> >> and provide the support via wbinvd_on_all_cpus() call. =20
> >
> > So the 8.2.9.5.5 bits will also need wbinvd - and I guess arm64 will ne=
ed
> > its own semantics (iirc there was a flush all call in the past). Cc'ing
> > Jonathan as well.
> >
> > Anyway, I think this call should not be defined in any place other=20
> > than core
> > kernel headers, and not in pat/nvdimm. I was trying to make it fit in=20
> > smp.h,
> > for example, but conviniently we might be able to hijack=20
> > flush_cache_all()
> > for our purposes as of course neither x86-64 arm64 uses it :)
> >
> > And I see this as safe (wrt not adding a big hammer on unaware=20
> > drivers) as
> > the 32bit archs that define the call are mostly contained thin their=20
> > arch/,
> > and the few in drivers/ are still specific to those archs.
> >
> > Maybe something like the below. =20
>=20
> Ok. I'll replace my version with yours.

Careful with flush_cache_all(). The stub version in=20
include/asm-generic/cacheflush.h has a comment above it that would
need updating at very least (I think). =20
Note there 'was' a flush_cache_all() for ARM64, but:
https://patchwork.kernel.org/project/linux-arm-kernel/patch/1429521875-1689=
3-1-git-send-email-mark.rutland@arm.com/

Also, I'm far from sure it will be the right choice on all CXL supporting
architectures.
+CC linux-arch, linux-arm and Arnd.

>=20
>=20
> >
> > Thanks,
> > Davidlohr
> >
> > ------8<----------------------------------------
> > Subject: [PATCH] arch/x86: define flush_cache_all as global wbinvd
> >
> > With CXL security features, global CPU cache flushing nvdimm
> > requirements are no longer specific to that subsystem, even
> > beyond the scope of security_ops. CXL will need such semantics
> > for features not necessarily limited to persistent memory.
> >
> > So use the flush_cache_all() for the wbinvd across all
> > CPUs on x86. arm64, which is another platform to have CXL
> > support can also define its own semantics here.
> >
> > Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>
> > ---
> > =A0arch/x86/Kconfig=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
|=A0 1 -
> > =A0arch/x86/include/asm/cacheflush.h |=A0 5 +++++
> > =A0arch/x86/mm/pat/set_memory.c=A0=A0=A0=A0=A0 |=A0 8 --------
> > =A0drivers/acpi/nfit/intel.c=A0=A0=A0=A0=A0=A0=A0=A0 | 11 ++++++-----
> > =A0drivers/cxl/security.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 5 +++--
> > =A0include/linux/libnvdimm.h=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 9 ---------
> > =A06 files changed, 14 insertions(+), 25 deletions(-)
> >
> > diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> > index 8dbe89eba639..be0b95e51df6 100644
> > --- a/arch/x86/Kconfig
> > +++ b/arch/x86/Kconfig
> > @@ -83,7 +83,6 @@ config X86
> > =A0=A0=A0=A0select ARCH_HAS_MEMBARRIER_SYNC_CORE
> > =A0=A0=A0=A0select ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
> > =A0=A0=A0=A0select ARCH_HAS_PMEM_API=A0=A0=A0=A0=A0=A0=A0 if X86_64
> > -=A0=A0=A0 select ARCH_HAS_NVDIMM_INVAL_CACHE=A0=A0=A0 if X86_64
> > =A0=A0=A0=A0select ARCH_HAS_PTE_DEVMAP=A0=A0=A0=A0=A0=A0=A0 if X86_64
> > =A0=A0=A0=A0select ARCH_HAS_PTE_SPECIAL
> > =A0=A0=A0=A0select ARCH_HAS_UACCESS_FLUSHCACHE=A0=A0=A0 if X86_64
> > diff --git a/arch/x86/include/asm/cacheflush.h=20
> > b/arch/x86/include/asm/cacheflush.h
> > index b192d917a6d0..05c79021665d 100644
> > --- a/arch/x86/include/asm/cacheflush.h
> > +++ b/arch/x86/include/asm/cacheflush.h
> > @@ -10,4 +10,9 @@
> >
> > =A0void clflush_cache_range(void *addr, unsigned int size);
> >
> > +#define flush_cache_all()=A0=A0=A0=A0=A0=A0=A0 \
> > +do {=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 \
> > +=A0=A0=A0 wbinvd_on_all_cpus();=A0=A0=A0=A0=A0=A0=A0 \
> > +} while (0)
> > +
> > =A0#endif /* _ASM_X86_CACHEFLUSH_H */
> > diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
> > index e4cd1286deef..1abd5438f126 100644
> > --- a/arch/x86/mm/pat/set_memory.c
> > +++ b/arch/x86/mm/pat/set_memory.c
> > @@ -330,14 +330,6 @@ void arch_invalidate_pmem(void *addr, size_t size)
> > =A0EXPORT_SYMBOL_GPL(arch_invalidate_pmem);
> > =A0#endif
> >
> > -#ifdef CONFIG_ARCH_HAS_NVDIMM_INVAL_CACHE
> > -void arch_invalidate_nvdimm_cache(void)
> > -{
> > -=A0=A0=A0 wbinvd_on_all_cpus();
> > -}
> > -EXPORT_SYMBOL_GPL(arch_invalidate_nvdimm_cache);
> > -#endif
> > -
> > =A0static void __cpa_flush_all(void *arg)
> > =A0{
> > =A0=A0=A0=A0unsigned long cache =3D (unsigned long)arg;
> > diff --git a/drivers/acpi/nfit/intel.c b/drivers/acpi/nfit/intel.c
> > index 242d2e9203e9..1b0ecb4d67e6 100644
> > --- a/drivers/acpi/nfit/intel.c
> > +++ b/drivers/acpi/nfit/intel.c
> > @@ -1,6 +1,7 @@
> > =A0// SPDX-License-Identifier: GPL-2.0
> > =A0/* Copyright(c) 2018 Intel Corporation. All rights reserved. */
> > =A0#include <linux/libnvdimm.h>
> > +#include <linux/cacheflush.h>
> > =A0#include <linux/ndctl.h>
> > =A0#include <linux/acpi.h>
> > =A0#include <asm/smp.h>
> > @@ -226,7 +227,7 @@ static int __maybe_unused=20
> > intel_security_unlock(struct nvdimm *nvdimm,
> > =A0=A0=A0=A0}
> >
> > =A0=A0=A0=A0/* DIMM unlocked, invalidate all CPU caches before we read =
it */
> > -=A0=A0=A0 arch_invalidate_nvdimm_cache();
> > +=A0=A0=A0 flush_cache_all();
> >
> > =A0=A0=A0=A0return 0;
> > =A0}
> > @@ -296,7 +297,7 @@ static int __maybe_unused=20
> > intel_security_erase(struct nvdimm *nvdimm,
> > =A0=A0=A0=A0=A0=A0=A0 return -ENOTTY;
> >
> > =A0=A0=A0=A0/* flush all cache before we erase DIMM */
> > -=A0=A0=A0 arch_invalidate_nvdimm_cache();
> > +=A0=A0=A0 flush_cache_all();
> > =A0=A0=A0=A0memcpy(nd_cmd.cmd.passphrase, key->data,
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 sizeof(nd_cmd.cmd.passphrase));
> > =A0=A0=A0=A0rc =3D nvdimm_ctl(nvdimm, ND_CMD_CALL, &nd_cmd, sizeof(nd_c=
md), NULL);
> > @@ -316,7 +317,7 @@ static int __maybe_unused=20
> > intel_security_erase(struct nvdimm *nvdimm,
> > =A0=A0=A0=A0}
> >
> > =A0=A0=A0=A0/* DIMM erased, invalidate all CPU caches before we read it=
 */
> > -=A0=A0=A0 arch_invalidate_nvdimm_cache();
> > +=A0=A0=A0 flush_cache_all();
> > =A0=A0=A0=A0return 0;
> > =A0}
> >
> > @@ -353,7 +354,7 @@ static int __maybe_unused=20
> > intel_security_query_overwrite(struct nvdimm *nvdimm)
> > =A0=A0=A0=A0}
> >
> > =A0=A0=A0=A0/* flush all cache before we make the nvdimms available */
> > -=A0=A0=A0 arch_invalidate_nvdimm_cache();
> > +=A0=A0=A0 flush_cache_all();
> > =A0=A0=A0=A0return 0;
> > =A0}
> >
> > @@ -379,7 +380,7 @@ static int __maybe_unused=20
> > intel_security_overwrite(struct nvdimm *nvdimm,
> > =A0=A0=A0=A0=A0=A0=A0 return -ENOTTY;
> >
> > =A0=A0=A0=A0/* flush all cache before we erase DIMM */
> > -=A0=A0=A0 arch_invalidate_nvdimm_cache();
> > +=A0=A0=A0 flush_cache_all();
> > =A0=A0=A0=A0memcpy(nd_cmd.cmd.passphrase, nkey->data,
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 sizeof(nd_cmd.cmd.passphrase));
> > =A0=A0=A0=A0rc =3D nvdimm_ctl(nvdimm, ND_CMD_CALL, &nd_cmd, sizeof(nd_c=
md), NULL);
> > diff --git a/drivers/cxl/security.c b/drivers/cxl/security.c
> > index 3dc04b50afaf..e2977872bf2f 100644
> > --- a/drivers/cxl/security.c
> > +++ b/drivers/cxl/security.c
> > @@ -6,6 +6,7 @@
> > =A0#include <linux/ndctl.h>
> > =A0#include <linux/async.h>
> > =A0#include <linux/slab.h>
> > +#include <linux/cacheflush.h>
> > =A0#include "cxlmem.h"
> > =A0#include "cxl.h"
> >
> > @@ -137,7 +138,7 @@ static int cxl_pmem_security_unlock(struct nvdimm=20
> > *nvdimm,
> > =A0=A0=A0=A0=A0=A0=A0 return rc;
> >
> > =A0=A0=A0=A0/* DIMM unlocked, invalidate all CPU caches before we read =
it */
> > -=A0=A0=A0 arch_invalidate_nvdimm_cache();
> > +=A0=A0=A0 flush_cache_all();
> > =A0=A0=A0=A0return 0;
> > =A0}
> >
> > @@ -165,7 +166,7 @@ static int=20
> > cxl_pmem_security_passphrase_erase(struct nvdimm *nvdimm,
> > =A0=A0=A0=A0=A0=A0=A0 return rc;
> >
> > =A0=A0=A0=A0/* DIMM erased, invalidate all CPU caches before we read it=
 */
> > -=A0=A0=A0 arch_invalidate_nvdimm_cache();
> > +=A0=A0=A0 flush_cache_all();
> > =A0=A0=A0=A0return 0;
> > =A0}
> >
> > diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
> > index 07e4e7572089..0769afb73380 100644
> > --- a/include/linux/libnvdimm.h
> > +++ b/include/linux/libnvdimm.h
> > @@ -309,13 +309,4 @@ static inline void arch_invalidate_pmem(void=20
> > *addr, size_t size)
> > =A0{
> > =A0}
> > =A0#endif
> > -
> > -#ifdef CONFIG_ARCH_HAS_NVDIMM_INVAL_CACHE
> > -void arch_invalidate_nvdimm_cache(void);
> > -#else
> > -static inline void arch_invalidate_nvdimm_cache(void)
> > -{
> > -}
> > -#endif
> > -
> > =A0#endif /* __LIBNVDIMM_H__ */
> > --=20
> > 2.36.1
> > =20
>=20


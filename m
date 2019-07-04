Return-Path: <owner-linux-mm@kvack.org>
From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH] mm/nvdimm: Add is_ioremap_addr and use that to check ioremap address
In-Reply-To: <87r2792jq5.fsf@linux.ibm.com>
References: <20190701134038.14165-1-aneesh.kumar@linux.ibm.com> <20190701165152.7a55299eb670b0ca326f24dd@linux-foundation.org> <87r2792jq5.fsf@linux.ibm.com>
Date: Fri, 05 Jul 2019 00:23:49 +1000
Message-ID: <87a7dt3mkq.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: owner-linux-mm@kvack.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, dan.j.williams@intel.com, linuxppc-dev@lists.ozlabs.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

"Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com> writes:
> Andrew Morton <akpm@linux-foundation.org> writes:
>
>> On Mon,  1 Jul 2019 19:10:38 +0530 "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com> wrote:
>>
>>> Architectures like powerpc use different address range to map ioremap
>>> and vmalloc range. The memunmap() check used by the nvdimm layer was
>>> wrongly using is_vmalloc_addr() to check for ioremap range which fails for
>>> ppc64. This result in ppc64 not freeing the ioremap mapping. The side effect
>>> of this is an unbind failure during module unload with papr_scm nvdimm driver
>>
>> The patch applies to 5.1.  Does it need a Fixes: and a Cc:stable?
>
> Actually, we want it to be backported to an older kernel possibly one
> that added papr-scm driver, b5beae5e224f ("powerpc/pseries: Add driver
> for PAPR SCM regions"). But that doesn't apply easily. It does apply
> without conflicts to 5.0

Don't worry about where it applies or doesn't, just tag it with the
correct Fixes: and stable versions and then if it doesn't backport
cleanly then we deal with that later.

cheers

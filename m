Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22f.google.com (mail-oi0-x22f.google.com
 [IPv6:2607:f8b0:4003:c06::22f])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6D04A1A1ECF
 for <linux-nvdimm@lists.01.org>; Wed,  7 Sep 2016 08:47:14 -0700 (PDT)
Received: by mail-oi0-x22f.google.com with SMTP id m11so31755689oif.1
 for <linux-nvdimm@lists.01.org>; Wed, 07 Sep 2016 08:47:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <57CFA1A1.7060704@linux.vnet.ibm.com>
References: <147318056046.30325.5100892122988191500.stgit@dwillia2-desk3.amr.corp.intel.com>
 <147318058712.30325.12749411762275637099.stgit@dwillia2-desk3.amr.corp.intel.com>
 <57CFA1A1.7060704@linux.vnet.ibm.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 7 Sep 2016 08:47:13 -0700
Message-ID: <CAPcyv4hvv4nhE-9aO1p2+MsCDBAx-8kqwSUQ7FA15LZJAHz=8Q@mail.gmail.com>
Subject: Re: [PATCH 5/5] mm: cleanup pfn_t usage in track_pfn_insert()
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
To: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: Linux MM <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Sep 6, 2016 at 10:12 PM, Anshuman Khandual
<khandual@linux.vnet.ibm.com> wrote:
> On 09/06/2016 10:19 PM, Dan Williams wrote:
>> Now that track_pfn_insert() is no longer used in the DAX path, it no
>> longer needs to comprehend pfn_t values.
>>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>> ---
>>  arch/x86/mm/pat.c             |    4 ++--
>>  include/asm-generic/pgtable.h |    4 ++--
>>  mm/memory.c                   |    2 +-
>>  3 files changed, 5 insertions(+), 5 deletions(-)
>
> A small nit. Should not the arch/x86/mm/pat.c changes be separated out
> into a different patch ? Kind of faced little bit problem separating out
> generic core mm changes to that of arch specific mm changes when going
> through the commits in retrospect.

I'm going to drop this change.  Leaving it as is does no harm, and
users of pfn_t are likely to grow over time.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

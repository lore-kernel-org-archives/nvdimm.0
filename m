Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com
 [IPv6:2607:f8b0:4864:20::343])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4E8B3211F2696
 for <linux-nvdimm@lists.01.org>; Thu,  4 Apr 2019 13:58:23 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id c16so3690807otn.4
 for <linux-nvdimm@lists.01.org>; Thu, 04 Apr 2019 13:58:23 -0700 (PDT)
MIME-Version: 1.0
References: <155440490809.3190322.15060922240602775809.stgit@dwillia2-desk3.amr.corp.intel.com>
 <155440492414.3190322.12683374224345847860.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20190404205818.GC24499@localhost.localdomain>
In-Reply-To: <20190404205818.GC24499@localhost.localdomain>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 4 Apr 2019 13:58:12 -0700
Message-ID: <CAPcyv4jua8GeyL7jNOZoEf9MhNXADvQX2T+h1D5FRRd9GLwNeA@mail.gmail.com>
Subject: Re: [RFC PATCH 3/5] acpi/hmat: Track target address ranges
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
To: Keith Busch <kbusch@kernel.org>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, X86 ML <x86@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Jonathan Cameron <Jonathan.Cameron@huawei.com>, Len Brown <lenb@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Apr 4, 2019 at 1:56 PM Keith Busch <kbusch@kernel.org> wrote:
>
> On Thu, Apr 04, 2019 at 12:08:44PM -0700, Dan Williams wrote:
> > As of ACPI 6.3 the HMAT no longer advertises the physical memory address
> > range for its entries. Instead, the expectation is the corresponding
> > entry in the SRAT is looked up by the target proximity domain.
> >
> > Given there may be multiple distinct address ranges that share the same
> > performance profile (sparse address space), find_mem_target() is updated
> > to also consider the start address of the memory range. Target property
> > updates are also adjusted to loop over all possible 'struct target'
> > instances that may share the same proximity domain identification.
>
> Since this may allocate multiple targets with the same PXM,
> hmat_register_targets() will attempt to register the same node multiple
> times.
>
> Would it make sense if the existing struct memory_target adds a resource
> list that we can append to as we parse SRAT? That way we have one target
> per memory node, and also track the ranges.

That sounds reasonable to me.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

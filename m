Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com
 [IPv6:2607:f8b0:4864:20::341])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 09687211F35E7
 for <linux-nvdimm@lists.01.org>; Tue,  9 Apr 2019 07:49:30 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id j10so15826831otq.0
 for <linux-nvdimm@lists.01.org>; Tue, 09 Apr 2019 07:49:30 -0700 (PDT)
MIME-Version: 1.0
References: <155440490809.3190322.15060922240602775809.stgit@dwillia2-desk3.amr.corp.intel.com>
 <155440492988.3190322.4475460421334178449.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20190409121318.GA16955@infradead.org>
In-Reply-To: <20190409121318.GA16955@infradead.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 9 Apr 2019 07:49:18 -0700
Message-ID: <CAPcyv4h3M7fGtdWt_dUVGkp1A2VZjR98wg0xAzipVccYZuChqg@mail.gmail.com>
Subject: Re: [RFC PATCH 4/5] acpi/hmat: Register special purpose memory as a
 device
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
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, X86 ML <x86@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Jonathan Cameron <Jonathan.Cameron@huawei.com>, Len Brown <lenb@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Apr 9, 2019 at 5:13 AM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Thu, Apr 04, 2019 at 12:08:49PM -0700, Dan Williams wrote:
> > Memory that has been tagged EFI_SPECIAL_PURPOSE, and has performance
> > properties described by the ACPI HMAT is expected to have an application
> > specific consumer.
> >
> > Those consumers may want 100% of the memory capacity to be reserved from
> > any usage by the kernel. By default, with this enabling, a platform
> > device is created to represent this differentiated resource.
>
> This sounds more than weird.  Since when did we let the firmware decide
> who can use the memory?

There's 2 related motivations for playing along with this "special
purpose" attribute. Before this bit we've seen gross hacks in platform
firmware trying to game OS behavior by lying about numa distances in
the ACPI SLIT. For example "near" high bandwidth memory being set at a
large distance to prevent the kernel from allocating from it by
default as much as possible. Secondly, allow niche applications
guarantees about being able to claim all of a given designated
resource.

The above comes with the option to override this default reservation
and just turn it back over to the page allocator i.e. ignore the
platform firmware hint.

The alternative is arranging for "special purpose" memory to be given
to the page allocator by default with the hope that it can be reserved
/ claimed early so the administrator can prevent unwanted allocations.
It just seemed overall easier to "default reserve with the option to
hot-add" instead of "default online with option / hope of hot-remove
or early allocation".
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

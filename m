Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com
 [IPv6:2607:f8b0:4864:20::343])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DC2EA211CA2C7
 for <linux-nvdimm@lists.01.org>; Tue,  5 Feb 2019 20:06:26 -0800 (PST)
Received: by mail-ot1-x343.google.com with SMTP id s5so9756895oth.7
 for <linux-nvdimm@lists.01.org>; Tue, 05 Feb 2019 20:06:26 -0800 (PST)
MIME-Version: 1.0
References: <20190206020453.25534-1-oohall@gmail.com>
 <CAPcyv4iiuK9iMo-JKxsd7JyOFdeZ5vh2C9r3oujDQe5qRjjN9Q@mail.gmail.com>
In-Reply-To: <CAPcyv4iiuK9iMo-JKxsd7JyOFdeZ5vh2C9r3oujDQe5qRjjN9Q@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 5 Feb 2019 20:06:14 -0800
Message-ID: <CAPcyv4imhTtqfsSafWb2nuHZoogqoA_=N3=uqsE_i=02Y5kDVQ@mail.gmail.com>
Subject: Re: [PATCH] libnvdimm: Fix altmap reservation size calculation
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
To: Oliver O'Halloran <oohall@gmail.com>
Cc: stable <stable@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Feb 5, 2019 at 6:38 PM Dan Williams <dan.j.williams@intel.com> wrote:
>
> On Tue, Feb 5, 2019 at 6:05 PM Oliver O'Halloran <oohall@gmail.com> wrote:
> >
> > Libnvdimm reserves the first 8K of pfn and devicedax namespaces to
> > store a superblock describing the namespace. This 8K reservation
> > is contained within the altmap area which the kernel uses for the
> > vmemmap backing for the pages within the namespace. The altmap
> > allows for some pages at the start of the altmap area to be reserved
> > and that mechanism is used to protect the superblock from being
> > re-used as vmemmap backing.
> >
> > The number of PFNs to reserve is calculated using:
> >
> >         PHYS_PFN(SZ_8K)
> >
> > Which is implemented as:
> >
> >  #define PHYS_PFN(x) ((unsigned long)((x) >> PAGE_SHIFT))
> >
> > So on systems where PAGE_SIZE is greater than 8K the reservation
> > size is truncated to zero and the superblock area is re-used as
> > vmemmap backing. As a result all the namespace information stored
> > in the superblock (i.e. if it's a PFN or DAX namespace) is lost
> > and the namespace needs to be re-created to get access to the
> > contents.
> >
> > This patch fixes this by using PFN_UP() rather than PHYS_PFN() to ensure
> > that at least one page is reserved. On systems with a 4K pages size this
> > patch should have no effect.
> >
> > Cc: stable@vger.kernel.org
> > Cc: Dan Williams <dan.j.williams@intel.com>
> > Fixes: ac515c084be9 ("libnvdimm, pmem, pfn: move pfn setup to the core")
> > Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
> > ---
> > ---
> >  drivers/nvdimm/pfn_devs.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
> > index 6f22272e8d80..9b9be83da0e7 100644
> > --- a/drivers/nvdimm/pfn_devs.c
> > +++ b/drivers/nvdimm/pfn_devs.c
> > @@ -593,7 +593,7 @@ static unsigned long init_altmap_base(resource_size_t base)
> >
> >  static unsigned long init_altmap_reserve(resource_size_t base)
> >  {
> > -       unsigned long reserve = PHYS_PFN(SZ_8K);
> > +       unsigned long reserve = PFN_UP(SZ_8K);
> >         unsigned long base_pfn = PHYS_PFN(base);
>
> Good find. I know how annoying it is to debug altmap issues.
>
> I'll get this queued up.

Hmm, this consideration should also be included in the data_offset
calculation. I'll take a look.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

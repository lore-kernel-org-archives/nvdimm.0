Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-it1-x144.google.com (mail-it1-x144.google.com
 [IPv6:2607:f8b0:4864:20::144])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9AE8C21173C83
 for <linux-nvdimm@lists.01.org>; Sun, 14 Oct 2018 17:05:42 -0700 (PDT)
Received: by mail-it1-x144.google.com with SMTP id c85-v6so2995934itd.1
 for <linux-nvdimm@lists.01.org>; Sun, 14 Oct 2018 17:05:42 -0700 (PDT)
MIME-Version: 1.0
References: <20181014231828.17139-1-oohall@gmail.com>
 <20181014231828.17139-2-oohall@gmail.com>
 <CAPcyv4jr4Y66wt7KtE7ke9OGX6kqNDQkO6yqAP8iaa2BzgdW2w@mail.gmail.com>
In-Reply-To: <CAPcyv4jr4Y66wt7KtE7ke9OGX6kqNDQkO6yqAP8iaa2BzgdW2w@mail.gmail.com>
From: Oliver <oohall@gmail.com>
Date: Mon, 15 Oct 2018 11:05:30 +1100
Message-ID: <CAOSf1CERAKnD=biAhAyBUqR4ZtULaVV=A1ZuA2iHaLU6mhVg6Q@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] powerpc/pseries: Add driver for PAPR SCM regions
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Nathan Fontenot <nfont@linux.vnet.ibm.com>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Oct 15, 2018 at 10:44 AM Dan Williams <dan.j.williams@intel.com> wrote:
>
> On Sun, Oct 14, 2018 at 4:19 PM Oliver O'Halloran <oohall@gmail.com> wrote:
> >
> > Adds a driver that implements support for enabling and accessing PAPR
> > SCM regions. Unfortunately due to how the PAPR interface works we can't
> > use the existing of_pmem driver (yet) because:
> >
> >  a) The guest is required to use the H_SCM_BIND_MEM h-call to add
> >     add the SCM region to it's physical address space, and
> >  b) There is currently no mechanism for relating a bare of_pmem region
> >     to the backing DIMM (or not-a-DIMM for our case).
> >
> > Both of these are easily handled by rolling the functionality into a
> > seperate driver so here we are...
> >
> > Acked-by: Dan Williams <dan.j.williams@intel.com>
> > Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
> > ---
> > The alternative implementation here is that we have the pseries code
> > do the h-calls and craft a pmem-region@<addr> node based on that.
> > However, that doesn't solve b) and mpe has expressed his dislike of
> > adding new stuff to the DT at runtime so i'd say that's a non-starter.
> > ---
> > v2: no change
> > v3: Corrected the mapping to use a DPA start address of zero
> >     Added cond_resched() calls in the bind/unbind loops
>
> Looks good, could I trouble you for an ack on the build / merge fix?
>
> https://patchwork.kernel.org/patch/10640385/

Sure thing. I checked that it built when rebased on top of your
pending branch before posting.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

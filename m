Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x22f.google.com (mail-ot0-x22f.google.com
 [IPv6:2607:f8b0:4003:c0f::22f])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 91A39226FAA74
 for <linux-nvdimm@lists.01.org>; Thu,  5 Apr 2018 19:26:00 -0700 (PDT)
Received: by mail-ot0-x22f.google.com with SMTP id a14-v6so11443718otf.6
 for <linux-nvdimm@lists.01.org>; Thu, 05 Apr 2018 19:26:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOSf1CGtNg4_siQtAw-H95Ay1m7YPvjZeqnmWvELb1xH1stRJQ@mail.gmail.com>
References: <20180403142415.30083-1-oohall@gmail.com>
 <20180403142415.30083-3-oohall@gmail.com>
 <CAPcyv4jW5H8A96MFD7-UazNSZq-t1_NfrChNB3p9=somdBpsNw@mail.gmail.com>
 <20180404220750.0436bbe1@gmail.com>
 <CAOSf1CGdKU4zQQauqo3UoNvKnKDMHteAEtsMWVtTG7T01csMbg@mail.gmail.com>
 <CAPcyv4if4un9mgFon4ttjKDYEtHC_GP6VoxUENp7YNS50T3afA@mail.gmail.com>
 <CAOSf1CHu4R-t8q-8fL6Dyk7myFR0gTfd6-0cxqtBVGZgYZWGAw@mail.gmail.com>
 <87bmexua3s.fsf@concordia.ellerman.id.au>
 <CAOSf1CEUnucUhW_pXG=7h5QBHvaH2-ENPKjGD42_0WEvbU6-Wg@mail.gmail.com>
 <CAPcyv4jEFMnYqpcop=Ox-dZR3dSBRMhT05JSS-gPABX_YQGw1g@mail.gmail.com>
 <CAOSf1CGtNg4_siQtAw-H95Ay1m7YPvjZeqnmWvELb1xH1stRJQ@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 5 Apr 2018 19:25:58 -0700
Message-ID: <CAPcyv4gv0rVQ+TTV=omcAO7tA5orufBadQn9ugK1jYwGH_NT=g@mail.gmail.com>
Subject: Re: [RESEND v2 3/4] doc/devicetree: Persistent memory region bindings
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
To: Oliver <oohall@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>, linux-nvdimm <linux-nvdimm@lists.01.org>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, Device Tree <devicetree@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Apr 5, 2018 at 7:14 PM, Oliver <oohall@gmail.com> wrote:
>
> On Fri, Apr 6, 2018 at 12:43 AM, Dan Williams <dan.j.williams@intel.com> wrote:
> > On Thu, Apr 5, 2018 at 5:43 AM, Oliver <oohall@gmail.com> wrote:
> >> On Thu, Apr 5, 2018 at 10:11 PM, Michael Ellerman <mpe@ellerman.id.au> wrote:
> >>> Oliver <oohall@gmail.com> writes:
> >>> ...
> >>>>
> >>>> For context Balbir is working with me on some of the pmem stuff. You
> >>>> probably want an Ack from Rob rather than one of us.
> >>>
> >>> I'll ack it if you make all the niggly nit picky trivial annoying
> >>> changes I asked for :D
> >>
> >> *groan*
> >>
> >> Fine, I'll respin it tomorrow. If anyone else has comments now would
> >> be the time to make them.
> >
> > Please also include my niggly nit picky trivial annoying bike shed
> > color for the driver name to *not* use the "nd_region" suffix for a
> > driver registering "nvdimm_bus" objects. "of_pmem_range" or
> > "of_pmem_bus" or almost anything else would be fine.
>
> Oh sure, would using of_pmem_region to match the compatible be ok?

That works for me.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

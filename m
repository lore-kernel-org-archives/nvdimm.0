Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com
 [IPv6:2607:f8b0:4864:20::344])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 35FA221195BCA
 for <linux-nvdimm@lists.01.org>; Mon, 21 Jan 2019 14:34:19 -0800 (PST)
Received: by mail-ot1-x344.google.com with SMTP id s5so21923628oth.7
 for <linux-nvdimm@lists.01.org>; Mon, 21 Jan 2019 14:34:19 -0800 (PST)
MIME-Version: 1.0
References: <154785884329.2202034.3295476681016958230.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20190121075102.GA3758@richard>
 <CAPcyv4iGZdEw-agURohZdC7hkjrDp74M_gVdSbCB5DP-bk5YYw@mail.gmail.com>
 <20190121205713.vai2oor3saopcja7@master>
In-Reply-To: <20190121205713.vai2oor3saopcja7@master>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 21 Jan 2019 14:34:06 -0800
Message-ID: <CAPcyv4g7hR34mNSQOLARTrX--UFpgg68thfg75hZOzq5AaBw5A@mail.gmail.com>
Subject: Re: [PATCH] libnvdimm: Clarify nd_pfn_init() flow
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
To: Wei Yang <richard.weiyang@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jan 21, 2019 at 12:57 PM Wei Yang <richard.weiyang@gmail.com> wrote:
>
> On Mon, Jan 21, 2019 at 10:04:40AM -0800, Dan Williams wrote:
> >On Sun, Jan 20, 2019 at 11:51 PM Wei Yang <richardw.yang@linux.intel.com> wrote:
> >> On Fri, Jan 18, 2019 at 04:47:23PM -0800, Dan Williams wrote:
> >[..]
> >> Also, I have one confusion about your saying: two probes.
> >>
> >> If the two probes are:
> >>
> >>     * for dax%d.%d: 1. nd_dax_probe 2. dax_pmem_probe
> >>     * for pfn%d.%d: 1. nd_pfn_probe 2. nd_pmem_probe
> >>
> >> Then, if the first probe fails, the device itself would be destroyed. How the
> >> second probe do its job?
> >>
> >> >       rc = nd_pfn_validate(nd_pfn, sig);
> >> >       if (rc != -ENODEV)
> >> >               return rc;
> >
> >Here is an example path for a device-dax instance:
> >
> >    /sys/devices/platform/e820_pmem/ndbus0/region0/dax0.1/dax0.0
> >
> >In this case the order of events is:
> >
> >1/ region0 discovers it contains a pmem namespace and registers namespace0.0
> >2/ The pmem namespace driver calls nd_dax_probe() to check for the
> >presence of a device-dax configuration
> >3/ If present, nd_pfn_validate() returns 0 and nd_dax_probe()
> >registers the dax0.1 device (this is a libnvdimm 'personality device).
> >4/ When nd_pmem_probe() sees nd_dax_probe() return 0 it in turn fails
> >the probe of namespace0.0 with -ENXIO. All devm allocations during the
> >probe of namespace0.0 are released.
>
> I may have another opinion here.
>
> The probe return error means the device will not attach to this driver.
> But the device itself it not released.
>
> We allocate devm on one device and those memory will be released when
> the device is destroyed. If I am correct.
>
> This means at this point, pfn_sb's memory still exists in the system.
> Even finally we will release it, when namespace0.0 is destroyed.

No, that's not the way devm works. Memory allocated by devm is
released at ->probe() failure, or after ->remove()

See the devres_release_all() call in drivers/base/dd.c::really_probe()
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

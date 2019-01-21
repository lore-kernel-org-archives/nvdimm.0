Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com
 [IPv6:2607:f8b0:4864:20::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F15B6211B737C
 for <linux-nvdimm@lists.01.org>; Mon, 21 Jan 2019 10:04:52 -0800 (PST)
Received: by mail-oi1-x244.google.com with SMTP id m6so15220039oig.11
 for <linux-nvdimm@lists.01.org>; Mon, 21 Jan 2019 10:04:52 -0800 (PST)
MIME-Version: 1.0
References: <154785884329.2202034.3295476681016958230.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20190121075102.GA3758@richard>
In-Reply-To: <20190121075102.GA3758@richard>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 21 Jan 2019 10:04:40 -0800
Message-ID: <CAPcyv4iGZdEw-agURohZdC7hkjrDp74M_gVdSbCB5DP-bk5YYw@mail.gmail.com>
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
To: Wei Yang <richardw.yang@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sun, Jan 20, 2019 at 11:51 PM Wei Yang <richardw.yang@linux.intel.com> wrote:
> On Fri, Jan 18, 2019 at 04:47:23PM -0800, Dan Williams wrote:
[..]
> Also, I have one confusion about your saying: two probes.
>
> If the two probes are:
>
>     * for dax%d.%d: 1. nd_dax_probe 2. dax_pmem_probe
>     * for pfn%d.%d: 1. nd_pfn_probe 2. nd_pmem_probe
>
> Then, if the first probe fails, the device itself would be destroyed. How the
> second probe do its job?
>
> >       rc = nd_pfn_validate(nd_pfn, sig);
> >       if (rc != -ENODEV)
> >               return rc;

Here is an example path for a device-dax instance:

    /sys/devices/platform/e820_pmem/ndbus0/region0/dax0.1/dax0.0

In this case the order of events is:

1/ region0 discovers it contains a pmem namespace and registers namespace0.0
2/ The pmem namespace driver calls nd_dax_probe() to check for the
presence of a device-dax configuration
3/ If present, nd_pfn_validate() returns 0 and nd_dax_probe()
registers the dax0.1 device (this is a libnvdimm 'personality device).
4/ When nd_pmem_probe() sees nd_dax_probe() return 0 it in turn fails
the probe of namespace0.0 with -ENXIO. All devm allocations during the
probe of namespace0.0 are released.
5/ Meanwhile the created dax0.1 device is recognized by the dax_pmem device.
6/ dax_pmem_probe() uses nd_pfn_init() to validate the configuration
and ultimately creates the dax0.0 character device

The pmem namepsace driver is effectively a router to other personality
drivers that may be layered on top of the base namespace capacity.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

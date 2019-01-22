Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com
 [IPv6:2607:f8b0:4864:20::343])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4CEB1211B76C9
 for <linux-nvdimm@lists.01.org>; Mon, 21 Jan 2019 17:00:59 -0800 (PST)
Received: by mail-ot1-x343.google.com with SMTP id 32so22142795ota.12
 for <linux-nvdimm@lists.01.org>; Mon, 21 Jan 2019 17:00:59 -0800 (PST)
MIME-Version: 1.0
References: <154785884329.2202034.3295476681016958230.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20190122002615.GB5855@richard>
 <CAPcyv4jXS-doCdyTrcV3DL63N-q4m1H2=Msgm1z88HnF8bcEig@mail.gmail.com>
 <20190122004647.GA6575@richard>
In-Reply-To: <20190122004647.GA6575@richard>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 21 Jan 2019 17:00:47 -0800
Message-ID: <CAPcyv4iVg09ryVAqOnxXAGUJf7xZqzxL0CWxGY4WOTEman--8w@mail.gmail.com>
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

On Mon, Jan 21, 2019 at 4:47 PM Wei Yang <richardw.yang@linux.intel.com> wrote:
>
> On Mon, Jan 21, 2019 at 04:29:08PM -0800, Dan Williams wrote:
> >On Mon, Jan 21, 2019 at 4:26 PM Wei Yang <richardw.yang@linux.intel.com> wrote:
> >[..]
> >> >@@ -706,6 +711,22 @@ static int nd_pfn_init(struct nd_pfn *nd_pfn)
> >> >               sig = DAX_SIG;
> >> >       else
> >> >               sig = PFN_SIG;
> >> >+
> >> >+      /*
> >> >+       * Check for an existing 'pfn' superblock before writing a new
> >> >+       * one. The intended flow is that on the first probe of an
> >> >+       * nd_{pfn,dax} device the superblock is calculated and written
> >> >+       * to the namespace. In this case nd_pfn_validate() returns
> >> >+       * -ENODEV because no valid superblock exists currently.
> >>
> >> As you replied in following mail:
> >>
> >> 3/ If present, nd_pfn_validate() returns 0 and nd_dax_probe()
> >> registers the dax0.1 device (this is a libnvdimm 'personality device).
> >>
> >> So at this point, nd_pfn_validate() return 0 or -ENODEV?
> >
> >In this case 0, because the configuration was successfully validated.
> >
> >-ENODEV, is only returned for the initial case where we want the
> >kernel to write the configuration.
> >
> >All other error codes are an actual failure and the probe procedure stops.
>
> To be honest, this maybe crystal clear for you. But I still feel a little
> confused. Especially on differentiating those cases. How many cases we have?

There are 4 cases:

1/ namespace probed, no personality info-block found, namespace
results in 'raw' mode

2/ namespace probed, {pfn,btt,dax} info-block found, {pfn,btt,dax}
device created and attached to the corresponding personality driver

3/ namespace probing ends in failure like -ENOMEM, or a -EIO error
reading namespace capacity, for example due to a bad block.

4/ namespace force assigned to a {pfn,btt,dax} device instance,
{pfn,btt,dax} device force enabled  leading to the info-block being
written out to the device

> And what's your first probe mean? This the nd_btt/pfn/dax_probe()? or the
> linux driver probe?

The first probe is always nd_pmem_probe(). nd_{pfn,btt,dax}_probe()
are secondary.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

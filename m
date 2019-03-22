Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com
 [IPv6:2607:f8b0:4864:20::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 914D4211E7439
 for <linux-nvdimm@lists.01.org>; Thu, 21 Mar 2019 21:13:31 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id e22so779503oiy.0
 for <linux-nvdimm@lists.01.org>; Thu, 21 Mar 2019 21:13:31 -0700 (PDT)
MIME-Version: 1.0
References: <PU1P153MB01691E80896E9EAA0C8245EDBF7D0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
 <9876fd8a491e339f2f41a47e2195d354bf0d5fb2.camel@intel.com>
 <PU1P153MB0169CA436F52268DD2BEF745BF430@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
 <PU1P153MB0169F3CEDB7C2F4965450BB6BF430@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
In-Reply-To: <PU1P153MB0169F3CEDB7C2F4965450BB6BF430@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 21 Mar 2019 21:13:19 -0700
Message-ID: <CAPcyv4hVZLW2OSMZ9NqqsQWMg7vxyS9J1ekDZW8G44cmD9_YCw@mail.gmail.com>
Subject: Re: [ndctl PATCH v2 4/4] ndctl, monitor: support NVDIMM_FAMILY_HYPERV
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
To: Dexuan Cui <decui@microsoft.com>
Cc: "qi.fuli@fujitsu.com" <qi.fuli@fujitsu.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Michael Kelley <mikelley@microsoft.com>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Mar 21, 2019 at 9:06 PM Dexuan Cui <decui@microsoft.com> wrote:
>
> > From: Dexuan Cui
> > Sent: Thursday, March 21, 2019 7:09 PM
>
> > IMO there are 2 issues in ndctl/monitor.c: filter_dimm():
> >
> > 1. IMO the cmd numbers ND_CMD_SMART (1) and
> > ND_CMD_SMART_THRESHOLD(2) are not really device-neutral. They
> > work for ndctl/lib/intel.c and it looks they happen to work for
> > ndctl/lib/hpe1.c, as hpe "happens" to have:
> >        NDN_HPE1_CMD_SMART = 1,
> >        NDN_HPE1_CMD_SMART_THRESHOLD = 2,
> >
> > But for ndctl/lib/msft.c, 1 and 2 mean different things. See [1].
> > So the current "ndctl monitor" can't support msft.c.
> >
> > For ndctl/lib/hyperv.c, 1 and 2 means:
> >         ND_HYPERV_CMD_GET_HEALTH_INFO = 1,
> >         ND_HYPERV_CMD_GET_SHUTDOWN_INFO = 2,
> > They're also incompatible with ND_CMD_SMART and
> > ND_CMD_SMART_THRESHOLD.
> > Of source, the current code can "work" since these ND_HYPERV_CMD*
> > numbers happen to be the same as ND_CMD_SMART and
> > ND_CMD_SMART_THRESHOLD. So this may not be an isue for hyperv.c.
>
> Actually, this _is_ an issue for NVDIMM_FAMILY_HYPERV (and the other
> families except for NVDIMM_FAMILY_INTEL) : see the kernel function
> acpi_nfit_register_dimms(), where ND_CMD_SMART is set in the
> "cmd_mask" only for NVDIMM_FAMILY_INTEL.
>
> So, on Hyper-V, ndctl_dimm_is_cmd_supported(dimm, ND_CMD_SMART)
> is always false, and "ndctl monitor" exits with "no smart support".

Can the Hyper-V implementation emulate those commands? That's the
expectation, i.e. that the implementation can return they required
payloads, but it's fine if the payloads disclaim support for certain
fields.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

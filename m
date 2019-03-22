Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com
 [IPv6:2607:f8b0:4864:20::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C4048211E370A
 for <linux-nvdimm@lists.01.org>; Thu, 21 Mar 2019 22:37:06 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id v7so844516oie.8
 for <linux-nvdimm@lists.01.org>; Thu, 21 Mar 2019 22:37:06 -0700 (PDT)
MIME-Version: 1.0
References: <PU1P153MB01691E80896E9EAA0C8245EDBF7D0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
 <9876fd8a491e339f2f41a47e2195d354bf0d5fb2.camel@intel.com>
 <PU1P153MB0169CA436F52268DD2BEF745BF430@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
 <PU1P153MB0169F3CEDB7C2F4965450BB6BF430@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
 <CAPcyv4hVZLW2OSMZ9NqqsQWMg7vxyS9J1ekDZW8G44cmD9_YCw@mail.gmail.com>
 <PU1P153MB0169A7A65DB3A54040DE291ABF430@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
In-Reply-To: <PU1P153MB0169A7A65DB3A54040DE291ABF430@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 21 Mar 2019 22:36:53 -0700
Message-ID: <CAPcyv4hM_DTcMJdWhWbtPFfVH_V-kYxXSSCg=MQZLoxVka=Mng@mail.gmail.com>
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

On Thu, Mar 21, 2019 at 10:09 PM Dexuan Cui <decui@microsoft.com> wrote:
>
> > From: Dan Williams <dan.j.williams@intel.com>
> > Sent: Thursday, March 21, 2019 9:13 PM
> > > ...
> > > Actually, this _is_ an issue for NVDIMM_FAMILY_HYPERV (and the other
> > > families except for NVDIMM_FAMILY_INTEL) : see the kernel function
> > > acpi_nfit_register_dimms(), where ND_CMD_SMART is set in the
> > > "cmd_mask" only for NVDIMM_FAMILY_INTEL.
> > >
> > > So, on Hyper-V, ndctl_dimm_is_cmd_supported(dimm, ND_CMD_SMART)
> > > is always false, and "ndctl monitor" exits with "no smart support".
> >
> > Can the Hyper-V implementation emulate those commands? That's the
> > expectation, i.e. that the implementation can return they required
> > payloads, but it's fine if the payloads disclaim support for certain
> > fields.
>
> Hyper-V Virtual NVDIMM doesn't emulate ND_CMD_SMART(1).
> The _DSM Function 1 on Hyper-V is "Get Health Information" [1], which is
> incomptabile with NVDIMM_FAMILY_INTEL's ND_CMD_SMART(1).
>
> Even if Hyper-V could emulate ND_CMD_SMART, the current "ndctl monitor"
> code still wouldn't work for Hyper-V (and the other families): the essence of the
> issue is that:
> 1. the kernel only sets ND_CMD_SMART flag for NVDIMM_FAMILY_INTEL.
> 2. "ndctl monitor" assumes the ND_CMD_SMART should be set by checking
> /sys/class/nd/ndctl0/device/nmem0/commands.
>
> This means ndctl_dimm_is_cmd_supported(dimm, ND_CMD_SMART) can
> only be true on NVDIMM_FAMILY_INTEL.
>
> My patch skips the assumption of ndctl on Hyper-V, so "ndctl monitor"
> can work on Hyper-V.
>
> It looks we do need an ops->monitor_supported() in ndctl?

No, I think you misunderstand. Hyper-V implements "function-1",
"command-1" support can be emulated. The request is to translate the
Hyper-V function-1 payload into the command-1 payload format.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

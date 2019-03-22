From: Dexuan Cui <decui-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: RE: [ndctl PATCH v2 4/4] ndctl, monitor: support NVDIMM_FAMILY_HYPERV
Date: Fri, 22 Mar 2019 05:09:27 +0000
Message-ID: <PU1P153MB0169A7A65DB3A54040DE291ABF430@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
References: <PU1P153MB01691E80896E9EAA0C8245EDBF7D0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
 <9876fd8a491e339f2f41a47e2195d354bf0d5fb2.camel@intel.com>
 <PU1P153MB0169CA436F52268DD2BEF745BF430@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
 <PU1P153MB0169F3CEDB7C2F4965450BB6BF430@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
 <CAPcyv4hVZLW2OSMZ9NqqsQWMg7vxyS9J1ekDZW8G44cmD9_YCw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <CAPcyv4hVZLW2OSMZ9NqqsQWMg7vxyS9J1ekDZW8G44cmD9_YCw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Verma, Vishal L" <vishal.l.verma-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Michael Kelley <mikelley-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, "qi.fuli-LMvhtfratI1BDgjK7y7TUQ@public.gmane.org" <qi.fuli-LMvhtfratI1BDgjK7y7TUQ@public.gmane.org>, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

> From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Sent: Thursday, March 21, 2019 9:13 PM
> > ...
> > Actually, this _is_ an issue for NVDIMM_FAMILY_HYPERV (and the other
> > families except for NVDIMM_FAMILY_INTEL) : see the kernel function
> > acpi_nfit_register_dimms(), where ND_CMD_SMART is set in the
> > "cmd_mask" only for NVDIMM_FAMILY_INTEL.
> >
> > So, on Hyper-V, ndctl_dimm_is_cmd_supported(dimm, ND_CMD_SMART)
> > is always false, and "ndctl monitor" exits with "no smart support".
> 
> Can the Hyper-V implementation emulate those commands? That's the
> expectation, i.e. that the implementation can return they required
> payloads, but it's fine if the payloads disclaim support for certain
> fields.

Hyper-V Virtual NVDIMM doesn't emulate ND_CMD_SMART(1). 
The _DSM Function 1 on Hyper-V is "Get Health Information" [1], which is
incomptabile with NVDIMM_FAMILY_INTEL's ND_CMD_SMART(1). 

Even if Hyper-V could emulate ND_CMD_SMART, the current "ndctl monitor"
code still wouldn't work for Hyper-V (and the other families): the essence of the
issue is that:
1. the kernel only sets ND_CMD_SMART flag for NVDIMM_FAMILY_INTEL.
2. "ndctl monitor" assumes the ND_CMD_SMART should be set by checking
/sys/class/nd/ndctl0/device/nmem0/commands.

This means ndctl_dimm_is_cmd_supported(dimm, ND_CMD_SMART) can
only be true on NVDIMM_FAMILY_INTEL.

My patch skips the assumption of ndctl on Hyper-V, so "ndctl monitor"
can work on Hyper-V.

It looks we do need an ops->monitor_supported() in ndctl?

Thanks,
-- Dexuan

[1] See http://www.uefi.org/RFIC_LIST ("Virtual NVDIMM 0x1901").

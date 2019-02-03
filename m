Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com
 [IPv6:2607:f8b0:4864:20::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3361721962301
 for <linux-nvdimm@lists.01.org>; Sun,  3 Feb 2019 09:49:23 -0800 (PST)
Received: by mail-oi1-x243.google.com with SMTP id i6so9769349oia.6
 for <linux-nvdimm@lists.01.org>; Sun, 03 Feb 2019 09:49:23 -0800 (PST)
MIME-Version: 1.0
References: <PU1P153MB0169977604493B82B662A01CBF920@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
 <154915640488.3541628.4947340559510114602.stgit@dwillia2-desk3.amr.corp.intel.com>
 <PU1P153MB0169BD9237F2DC1FA64721BABF6C0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
In-Reply-To: <PU1P153MB0169BD9237F2DC1FA64721BABF6C0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 3 Feb 2019 09:49:10 -0800
Message-ID: <CAPcyv4h0B0sBMjiAC=Tk=Mu58A4vZ5F9yUPQsXqf5jyYF37VCw@mail.gmail.com>
Subject: Re: [PATCH] libnvdimm/dimm: Add a no-BLK quirk based on NVDIMM family
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
Cc: Michael Kelley <mikelley@microsoft.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sun, Feb 3, 2019 at 9:22 AM Dexuan Cui <decui@microsoft.com> wrote:
>
> > From: Dan Williams <dan.j.williams@intel.com>
> > Sent: Saturday, February 2, 2019 5:13 PM
> > ...
> > As Dexuan reports the NVDIMM_FAMILY_HYPERV platform is incompatible with
> > the existing Linux namespace implementation because it uses
> > NSLABEL_FLAG_LOCAL for x1-width PMEM interleave sets. Quirk it as an
> > platform / DIMM that does not provide BLK-aperture access. Allow the
> > libnvdimm core to assume no potential for aliasing. In case other
> > implementations make the same mistake, provide a "noblk" module
> > parameter to force-enable the quirk.
>
> Hi Dan,
> Thanks very much for the patch! With it, "ndctl list" can show the below:
>
> root@decui-gen2-u1904:~/ndctl# ndctl list
> [
>   {
>     "dev":"namespace1.0",
>     "mode":"raw",
>     "size":137438953472,
>     "uuid":"c258aaab-f72b-e546-bfa5-be5e07761dbc",
>     "blockdev":"pmem1",
>     "name":"Microsoft Hyper-V NVDIMM 1 Label"
>   },
>   {
>     "dev":"namespace0.0",
>     "mode":"raw",
>     "size":34359738368,
>     "uuid":"9f0497a7-4453-7c40-ad35-21a791e00345",
>     "blockdev":"pmem0",
>     "name":"Microsoft Hyper-V NVDIMM 0 Label"
>   }
> ]
>
> And /dev/pmem0 can appear, but /dev/pmem0p1 can not appear, and the "mode" of
> "namespace0.0" is not correct.  With the Ubuntu 19.04 4.18 kenel, I get the below:
>
> root@decui-gen2-u1904:~/ndctl# ndctl list
> [
>   {
>     "dev":"namespace1.0",
>     "mode":"raw",
>     "size":137438953472,
>     "blockdev":"pmem1"
>   },
>   {
>     "dev":"namespace0.0",
>     "mode":"fsdax",
>     "map":"dev",
>     "size":33820770304,
>     "uuid":"ef028c4e-2b1f-4bf8-b92a-1109d7a1c914",
>     "blockdev":"pmem0"
>   }
> ]
> and /dev/pmem0p1 can appear.
>
> It looks the namespace created by Ubuntu 19.04 (4.18) is incompatible with
> the libnvdimm-pending branch + this patch.

This is correct, the configuration switched from label-less by default
to labeled.

> It looks we need to completely disable the label usage for NVDIMM_FAMILY_HYPERV
> due to compability?

It's either going to be a quirk in Linux or a quirk in the Hyper-V
configuration. I think it's more manageable for Hyper-V to ship a
"label disable" switch than to try to ship a workaround in Linux. The
"noblk" quirk in Linux works around the LOCAL bit in the labels.
However, the namespace mode regression can only be resolved by hiding
the label capability until the administrator manually switches from
label-less to labeled operation.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

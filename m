Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com
 [IPv6:2607:f8b0:4864:20::329])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 76E51211D391E
 for <linux-nvdimm@lists.01.org>; Fri, 15 Mar 2019 16:12:20 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id q24so9820547otk.0
 for <linux-nvdimm@lists.01.org>; Fri, 15 Mar 2019 16:12:20 -0700 (PDT)
MIME-Version: 1.0
References: <54fb48ed-f681-1420-b2d0-082ed14802a7@inria.fr>
In-Reply-To: <54fb48ed-f681-1420-b2d0-082ed14802a7@inria.fr>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 15 Mar 2019 16:12:09 -0700
Message-ID: <CAPcyv4g0KCON5KfTyeoK3UWApD=Gg=-eg=9Cc0OR-QcArXKMFA@mail.gmail.com>
Subject: Re: failure to setup devdax over fake nvdimm
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
To: Brice Goglin <Brice.Goglin@inria.fr>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Mar 15, 2019 at 3:31 PM Brice Goglin <Brice.Goglin@inria.fr> wrote:
>
> Hello Dan,
>
> On a machine emulating nvdimms over DDR using the memmap kernel parameter,
> I can't enable devdax anymore with ndctl, when using your libnvdimm-pending
> branch (1ffc664f9b8ca7346f2af0fb4f62b923193bf65c):
>
> # ndctl create-namespace -f -e namespace1.0 -t pmem -m devdax
> libndctl: ndctl_dax_enable: dax1.0: failed to enable
>   Error: namespace1.0: failed to enable
> failed to reconfigure namespace: No such device or address
>
> In the previous version of your libnvdimm-pending branch that I used before
> (8d4a7e3da68e88a6efd3acb5cc971d0c2ca219a4 from January 8th) this ndctl line
> worked fine right after boot.
>
> The difference between strace ndctl doesn't show anything obvious.
> * /sys/devices/platform/e820_pmem/ndbus0/region1/namespace1.0/holder_class contains nothing instead of "dax"
> * /sys/devices/platform/e820_pmem/ndbus0/region1/dax_seed contains dax1.0 instead of dax1.1
>
> Any idea where to look?

If my libnvdimm-pending branch worked it is likely due to the
alignment padding fixes I had pending there. Can you post the dmesg
from this failure?

The alignment padding fixes are being abandoned in favor of just
teaching the core-mm to not require section (128MB) alignment, but
until then you need to make sure your persistent memory is 128MB
aligned.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

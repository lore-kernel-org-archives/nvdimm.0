Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-it1-x144.google.com (mail-it1-x144.google.com
 [IPv6:2607:f8b0:4864:20::144])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BC48221A07A82
 for <linux-nvdimm@lists.01.org>; Tue, 27 Nov 2018 05:27:23 -0800 (PST)
Received: by mail-it1-x144.google.com with SMTP id g85so34122469ita.3
 for <linux-nvdimm@lists.01.org>; Tue, 27 Nov 2018 05:27:23 -0800 (PST)
MIME-Version: 1.0
References: <20181119080056.13386-1-oohall@gmail.com>
 <20181119080056.13386-2-oohall@gmail.com>
 <CAPcyv4idzcVa8XnA1G8DjEux=RRvCi_wF8hBk=4jmg1JFuRdDA@mail.gmail.com>
In-Reply-To: <CAPcyv4idzcVa8XnA1G8DjEux=RRvCi_wF8hBk=4jmg1JFuRdDA@mail.gmail.com>
From: Oliver <oohall@gmail.com>
Date: Wed, 28 Nov 2018 00:27:11 +1100
Message-ID: <CAOSf1CH1yGws3c0aOJZCLvsUxf5mvqtkQpe3CY7KS7UdKjMjuQ@mail.gmail.com>
Subject: Re: [PATCH 2/4] ndctl/namespace: Check for seed namespaces earlier
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
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Nov 26, 2018 at 7:12 AM Dan Williams <dan.j.williams@intel.com> wrote:
>
> On Mon, Nov 19, 2018 at 12:11 AM Oliver O'Halloran <oohall@gmail.com> wrote:
> >
> > When creating an fsdax or devdax namespace we need to verify that the
> > seed namespaces exist. This patch reworks the validation so that it's
> > done earlier to simplify the subsequent patches in the series.
> >
> > No functional changes.
>
> It does appear to have a functional change. do_setup_pfn() supports
> the case of statically allocated namespaces in NDCTL_NS_MODE_MEMORY
> mode.

Hmm, ok. Up until now I had assumed that as far as ndctl was concerned
NS_MODE_MEMORY was synonymous with a pfn namespace.

> This is what one gets by default with "legacy" pmem defined as
> E820-type-12 memory. In that case the kernel assumes that the
> resulting memmap is always small enough to be allocated from DRAM and
> there is no need to use a dynamic  pfn device. So, if I'm not
> mistaken, the deletion of do_setup_pfn() loses that special case
> handling.

>From what I see, the main difference is that ndctl would fail
validation when fsdax mode is specified and there's no pfn namespace
support in the kernel. I agree that's not great, but I'm not sure what
we should be doing here. The current behaviour will silently ignore -a
if "-m fsdax -M mem" is specified in the reconfigure case, which
doesn't seem great either.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com
 [IPv6:2607:f8b0:4864:20::341])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F220F21A07A92
 for <linux-nvdimm@lists.01.org>; Sun, 25 Nov 2018 12:12:12 -0800 (PST)
Received: by mail-ot1-x341.google.com with SMTP id a11so14719183otr.10
 for <linux-nvdimm@lists.01.org>; Sun, 25 Nov 2018 12:12:12 -0800 (PST)
MIME-Version: 1.0
References: <20181119080056.13386-1-oohall@gmail.com>
 <20181119080056.13386-2-oohall@gmail.com>
In-Reply-To: <20181119080056.13386-2-oohall@gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 25 Nov 2018 12:12:01 -0800
Message-ID: <CAPcyv4idzcVa8XnA1G8DjEux=RRvCi_wF8hBk=4jmg1JFuRdDA@mail.gmail.com>
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
To: Oliver O'Halloran <oohall@gmail.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Nov 19, 2018 at 12:11 AM Oliver O'Halloran <oohall@gmail.com> wrote:
>
> When creating an fsdax or devdax namespace we need to verify that the
> seed namespaces exist. This patch reworks the validation so that it's
> done earlier to simplify the subsequent patches in the series.
>
> No functional changes.

It does appear to have a functional change. do_setup_pfn() supports
the case of statically allocated namespaces in NDCTL_NS_MODE_MEMORY
mode. This is what one gets by default with "legacy" pmem defined as
E820-type-12 memory. In that case the kernel assumes that the
resulting memmap is always small enough to be allocated from DRAM and
there is no need to use a dynamic  pfn device. So, if I'm not
mistaken, the deletion of do_setup_pfn() loses that special case
handling.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

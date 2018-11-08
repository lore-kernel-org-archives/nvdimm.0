Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com
 [IPv6:2607:f8b0:4864:20::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 02EDE21A07A92
 for <linux-nvdimm@lists.01.org>; Thu,  8 Nov 2018 13:38:16 -0800 (PST)
Received: by mail-oi1-x241.google.com with SMTP id 192-v6so17490768oii.6
 for <linux-nvdimm@lists.01.org>; Thu, 08 Nov 2018 13:38:16 -0800 (PST)
MIME-Version: 1.0
References: <20181108212659.15570-1-toshi.kani@hpe.com>
In-Reply-To: <20181108212659.15570-1-toshi.kani@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 8 Nov 2018 13:38:03 -0800
Message-ID: <CAPcyv4jfkFasM1CsceXNvB9Pr8Nq0=B7nr0=fn38LDD721eBmg@mail.gmail.com>
Subject: Re: [PATCH] ndctl: fix zero-labels to handle firmware error properly
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
To: Toshi Kani <toshi.kani@hpe.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Nov 8, 2018 at 1:27 PM Toshi Kani <toshi.kani@hpe.com> wrote:
>
> ndctl zero-labels completes with a large number of zeroed nmems when
> it fails to do zeroing on a protected NVDIMM.
>
>   # ndctl zero-labels nmem1
>   zeroed 65504 nmems
>
> do_cmd() called from ndctl_dimm_zero_labels() sets a transfer size to
> rc when FW status is non-zero.  This transfer size gets mistreated as
> zeroed nmems count in the end.
>
> Fix ndctl_dimm_zero_labels() to handle this FW error case properly.
>
> Reported-by: Robert Elliott <elliott@hpe.com>
> Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
> Cc: Vishal Verma <vishal.l.verma@intel.com>
> Cc: Dan Williams <dan.j.williams@intel.com>

Looks good,

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

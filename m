Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x230.google.com (mail-oi0-x230.google.com
 [IPv6:2607:f8b0:4003:c06::230])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id ACE8021A04E2A
 for <linux-nvdimm@lists.01.org>; Wed, 10 May 2017 12:39:54 -0700 (PDT)
Received: by mail-oi0-x230.google.com with SMTP id l18so6752215oig.2
 for <linux-nvdimm@lists.01.org>; Wed, 10 May 2017 12:39:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170510192531.13032-1-vishal.l.verma@intel.com>
References: <20170510192531.13032-1-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 10 May 2017 12:39:53 -0700
Message-ID: <CAPcyv4iF3QxhOzshrBx+L5G=vE7M=dbCyNHZmeuKs+0BuKgDXA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] libnvdimm: add an atomic vs process context flag
 to rw_bytes
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
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, May 10, 2017 at 12:25 PM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> nsio_rw_bytes can clear media errors, but this cannot be done while we
> are in an atomic context due to locking within ACPI. From the BTT,
> ->rw_bytes may be called either from atomic or process context depending
> on whether the calls happen during initialization or during IO.
>
> During init, we want to ensure error clearing happens, and the flag
> marking process context allows nsio_rw_bytes to do that. When called
> during IO, we're in atomic context, and error clearing can be skipped.
>

Looks good, I would just rename NVDIMM_IO_NORMAL to either just
passing zero directly or something like NVDIMM_IO_MAY_SLEEP.
NVDIMM_IO_NORMAL tells me nothing when I read it, and I think I prefer
just passing zero unless you can come up with a better name.

The canonical flags type is 'unsigned long' instead of 'u32'.

> diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
> index 77d0321..12be701 100644
> --- a/drivers/nvdimm/nd.h
> +++ b/drivers/nvdimm/nd.h
> @@ -33,6 +33,11 @@ enum {
>         INT_LBASIZE_ALIGNMENT = 64,
>  };
>
> +enum {
> +       NVDIMM_IO_NORMAL = 0,
> +       NVDIMM_IO_ATOMIC = 1,
> +};

No need for a new enum block, just merge this with the one above.

Other than those minor fixups, looks good.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

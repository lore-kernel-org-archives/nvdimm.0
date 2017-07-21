Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-yw0-x230.google.com (mail-yw0-x230.google.com
 [IPv6:2607:f8b0:4002:c05::230])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D601421D0DE47
 for <linux-nvdimm@lists.01.org>; Thu, 20 Jul 2017 20:21:38 -0700 (PDT)
Received: by mail-yw0-x230.google.com with SMTP id a12so19952684ywh.3
 for <linux-nvdimm@lists.01.org>; Thu, 20 Jul 2017 20:23:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170717235655.26424-7-vishal.l.verma@intel.com>
References: <20170717235655.26424-1-vishal.l.verma@intel.com>
 <20170717235655.26424-7-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 20 Jul 2017 20:23:34 -0700
Message-ID: <CAPcyv4jbMwtZLnNuwpaVF-W21HLc8QD5rYn6b7wBxcnV5eDAow@mail.gmail.com>
Subject: Re: [PATCH v3 6/6] libnvdimm: fix potential deadlock while clearing
 errors
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
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Robert Moore <robert.moore@intel.com>, Linux ACPI <linux-acpi@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jul 17, 2017 at 4:56 PM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> With the ACPI NFIT 'DSM' methods, acpi can be called from IO paths.
> Specifically, the DSM to clear media errors is called during writes, so
> that we can provide a writes-fix-errors model.
>
> However it is easy to imagine a scenario like:
>  -> write through the nvdimm driver
>    -> acpi allocation
>      -> writeback, causes more IO through the nvdimm driver
>        -> deadlock
>
> Fix this by using memalloc_noio_{save,restore}, which sets the GFP_NOIO
> flag for the current scope when issuing commands/IOs that are expected
> to clear errors.
>
> Cc: <linux-acpi@vger.kernel.org>
> Cc: <linux-nvdimm@lists.01.org>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Robert Moore <robert.moore@intel.com>
> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Looks good to me. Please move this up in the series before we start
calling nvdimm_clear_poison() in the btt I/O path so there's no
bisection point where this deadlock comes back.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

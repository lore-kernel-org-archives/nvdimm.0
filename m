Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-yb0-x22d.google.com (mail-yb0-x22d.google.com
 [IPv6:2607:f8b0:4002:c09::22d])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7BC812095D2BB
 for <linux-nvdimm@lists.01.org>; Fri, 14 Jul 2017 22:24:54 -0700 (PDT)
Received: by mail-yb0-x22d.google.com with SMTP id n205so38678455yba.1
 for <linux-nvdimm@lists.01.org>; Fri, 14 Jul 2017 22:26:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170714221148.11232-6-vishal.l.verma@intel.com>
References: <20170714221148.11232-1-vishal.l.verma@intel.com>
 <20170714221148.11232-6-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 14 Jul 2017 22:26:42 -0700
Message-ID: <CAPcyv4jkJHKh0kXA3jGSU=QdmoZCVQuM7YaMBzoSPqn4hVXk4g@mail.gmail.com>
Subject: Re: [PATCH 5/6] acpi: change memory allocations to GFP_NOIO
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
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Moore,
List-ID: <linux-nvdimm@lists.01.org>

[ adding Bob ]

On Fri, Jul 14, 2017 at 3:11 PM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> With the ACPI NFIT 'DSM' methods, acpi can be called from IO paths.
> Specifically, the DSM to clear media errors is called during writes, so
> that we can provide a writes-fix-errors model.
>
> However it is easy to imagine a scenario like:
>  - write through the nvdimm driver
>  - acpi allocation
>  - writeback, causes more IO through the nvdimm driver
>  - deadlock
>
> Making the acpi allocations GPF_NOIO would ensure that it doesn't
> trigger writeback, and avoids the above deadlock.

Another option would be to custom code an acpi_ars_clear_error()
routine that manages to issue the proper DSM without needing to
perform any memory allocations, but this will have implications for
the common ACPICA code.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

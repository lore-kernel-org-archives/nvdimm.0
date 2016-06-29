Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ob0-x235.google.com (mail-ob0-x235.google.com
 [IPv6:2607:f8b0:4003:c01::235])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 10BBC1A1DF5
 for <linux-nvdimm@lists.01.org>; Wed, 29 Jun 2016 16:13:28 -0700 (PDT)
Received: by mail-ob0-x235.google.com with SMTP id o10so34878002obp.2
 for <linux-nvdimm@lists.01.org>; Wed, 29 Jun 2016 16:12:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1467241230-15054-1-git-send-email-vishal.l.verma@intel.com>
References: <1467241230-15054-1-git-send-email-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 29 Jun 2016 16:12:50 -0700
Message-ID: <CAPcyv4gFZc2CizeMhc7v+ZzdLpL5tWRO+0JrTY-GDTFMryVefA@mail.gmail.com>
Subject: Re: [PATCH] acpi, nfit: print command names instead of numbers
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
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jun 29, 2016 at 4:00 PM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> For the debug prints in acpi_nfit_ctl(), all the prints except the input
> buffer dump printed the command name. Make this also do the same for
> better readability.
>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  drivers/acpi/nfit.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

We used to do this, but nvdimm_cmd_name() currently only knows the
names for the "Intel" DSMs.  At a minimum we should force cmd_name to
"unknown" for the other formats until support is added.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

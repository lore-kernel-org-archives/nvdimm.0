Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22d.google.com (mail-oi0-x22d.google.com
 [IPv6:2607:f8b0:4003:c06::22d])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 261951A1E27
 for <linux-nvdimm@lists.01.org>; Thu, 28 Jul 2016 08:06:58 -0700 (PDT)
Received: by mail-oi0-x22d.google.com with SMTP id w18so66912717oiw.3
 for <linux-nvdimm@lists.01.org>; Thu, 28 Jul 2016 08:06:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1469699369-70824-1-git-send-email-jthumshirn@suse.de>
References: <1469699369-70824-1-git-send-email-jthumshirn@suse.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 28 Jul 2016 08:06:56 -0700
Message-ID: <CAPcyv4iXorbSiazDDfwn6AJSrkH1uybEu02Ms+VAniXmcPpW=w@mail.gmail.com>
Subject: Re: [PATCH] nfit: Get rid of CONFIG_ACPI_NFIT_DEBUG
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
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Linux NVDIMM Mailing List <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jul 28, 2016 at 2:49 AM, Johannes Thumshirn <jthumshirn@suse.de> wrote:
> CONFIG_ACPI_NFIT_DEBUG is currently used to dump the buffers used in NFIT _DSM
> calls. Within the statements guarded by CONFIG_ACPI_NFIT_DEBUG we use dynamic
> debugging as well as print_hex_dump_debug(). Change the print_hex_dump_debug()
> call to dynamic_hex_dump() so we can enable it on demand and at runtime, not
> dependend on a compile time option.
>
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> ---

Looks good to me, not sure how I missed dynamic_hex_dump() in the first place.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

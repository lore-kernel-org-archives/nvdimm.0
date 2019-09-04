Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com
 [IPv6:2607:f8b0:4864:20::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 17EE121A070B6
 for <linux-nvdimm@lists.01.org>; Tue,  3 Sep 2019 19:22:51 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id g128so14651238oib.1
 for <linux-nvdimm@lists.01.org>; Tue, 03 Sep 2019 19:21:41 -0700 (PDT)
MIME-Version: 1.0
References: <20190904010819.11012-1-vishal.l.verma@intel.com>
In-Reply-To: <20190904010819.11012-1-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 3 Sep 2019 19:21:30 -0700
Message-ID: <CAPcyv4ia8aQLk_p04bS-SdCSc5BSTJtdO-XWAKJhS=7_C5DyzA@mail.gmail.com>
Subject: Re: [ndctl PATCH 1/2] libdaxctl: fix the system-ram capability check
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
Cc: Brice Goglin <Brice.Goglin@inria.fr>, Dave Hansen <dave.hansen@linux.intel.com>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Sep 3, 2019 at 6:08 PM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> When checking a daxctl device for system-ram capability, we needn't look
> at the symlink resolution for /sys/bus/dax.../driver/module since the
> driver in question may not always have an associated module, and could
> be builtin instead.
>
> Change the symlink we resolve to simply '/sys/bus/dax.../driver' and
> since that too resolves to '.../kmem' in the system-ram case, the
> rest of the check remains unchanged.
>
> This is a pre-requisite to making daxctl-reconfigure-device work
> correctly when the target mode's driver might be builtin.
>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  daxctl/lib/libdaxctl.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/daxctl/lib/libdaxctl.c b/daxctl/lib/libdaxctl.c
> index c0a859c..d9f2c33 100644
> --- a/daxctl/lib/libdaxctl.c
> +++ b/daxctl/lib/libdaxctl.c
> @@ -406,7 +406,7 @@ static int dev_is_system_ram_capable(struct daxctl_dev *dev)
>         if (!daxctl_dev_is_enabled(dev))
>                 return false;
>
> -       if (snprintf(path, len, "%s/driver/module", dev->dev_path) >= len) {
> +       if (snprintf(path, len, "%s/driver", dev->dev_path) >= len) {

Nice catch.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

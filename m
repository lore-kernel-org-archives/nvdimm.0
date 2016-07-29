Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x233.google.com (mail-oi0-x233.google.com
 [IPv6:2607:f8b0:4003:c06::233])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 209151A1DFF
 for <linux-nvdimm@lists.01.org>; Fri, 29 Jul 2016 13:32:00 -0700 (PDT)
Received: by mail-oi0-x233.google.com with SMTP id j185so121155000oih.0
 for <linux-nvdimm@lists.01.org>; Fri, 29 Jul 2016 13:32:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160729182314.6368-1-ross.zwisler@linux.intel.com>
References: <20160729182314.6368-1-ross.zwisler@linux.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 29 Jul 2016 13:31:58 -0700
Message-ID: <CAPcyv4h+TFEkLm-6MJkM4Xdp+cjBR2LCyeAqcjv0SaLWYpuCXA@mail.gmail.com>
Subject: Re: [PATCH] block: remove BLK_DEV_DAX config option
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Dave Hansen <dave.hansen@linux.intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-block@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jul 29, 2016 at 11:23 AM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> The functionality for block device DAX was already removed with this
> commit:
>
> commit acc93d30d7d4 ("Revert "block: enable dax for raw block devices"")
>
> However, we still had a config option hanging around that was always
> disabled because it depended on CONFIG_BROKEN.  This config option was
> introduced in this commit:
>
> commit 03cdadb04077 ("block: disable block device DAX by default")
>
> This change reverts that commit, removing the dead config option.
>
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Dan Williams <dan.j.williams@intel.com>

Acked-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

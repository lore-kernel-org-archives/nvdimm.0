Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x234.google.com (mail-oi0-x234.google.com
 [IPv6:2607:f8b0:4003:c06::234])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BE5781A1E9E
 for <linux-nvdimm@lists.01.org>; Fri, 14 Oct 2016 10:35:06 -0700 (PDT)
Received: by mail-oi0-x234.google.com with SMTP id y2so145344817oie.0
 for <linux-nvdimm@lists.01.org>; Fri, 14 Oct 2016 10:35:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1476465913-25305-1-git-send-email-toshi.kani@hpe.com>
References: <1476465913-25305-1-git-send-email-toshi.kani@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 14 Oct 2016 10:35:05 -0700
Message-ID: <CAPcyv4gLTayEYpmEz0V-EjU4hmAVt9BCs_p8wqW=1kTfEakqMA@mail.gmail.com>
Subject: Re: [PATCH] DAX: enable iostat for read/write
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
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Oct 14, 2016 at 10:25 AM, Toshi Kani <toshi.kani@hpe.com> wrote:
> DAX IO path does not support iostat, but its metadata IO path does.
> Therefore, iostat shows metadata IO statistics only, which has been
> confusing to users.
>
> Add iostat support to the DAX read/write path.
>
> Note, iostat still does not support the DAX mmap path as it allows
> user applications to access directly.
>
> Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
> ---
>  fs/dax.c |   37 +++++++++++++++++++++++++++++++++++++
>  1 file changed, 37 insertions(+)
>
> diff --git a/fs/dax.c b/fs/dax.c
> index 014defd..3aaaac2 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -144,6 +144,34 @@ static sector_t to_sector(const struct buffer_head *bh,
>         return sector;
>  }
>
> +static void dax_iostat_start(struct gendisk *disk, struct iov_iter *iter,
> +                            unsigned long *start)
> +{
> +       int rw = iov_iter_rw(iter);
> +       int sec = iov_iter_count(iter) >> 9;

Should this be a minimum of one sector since we allow unaligned
transfers through this interface?

...or is iov_iter_count() somehow guaranteed to be sector aligned here?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

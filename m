Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-io0-x244.google.com (mail-io0-x244.google.com
 [IPv6:2607:f8b0:4001:c06::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2A0FF220757FA
 for <linux-nvdimm@lists.01.org>; Sun, 12 Nov 2017 10:06:44 -0800 (PST)
Received: by mail-io0-x244.google.com with SMTP id h70so18306103ioi.4
 for <linux-nvdimm@lists.01.org>; Sun, 12 Nov 2017 10:10:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <151034311187.59853.17265892705257743788.stgit@djiang5-desk3.ch.intel.com>
References: <151034311187.59853.17265892705257743788.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 12 Nov 2017 10:10:48 -0800
Message-ID: <CAA9_cmc7j1KbY2FUdyz4sX17qz_s1kYFq8EJPBS+d0Ssn9uwuA@mail.gmail.com>
Subject: Re: [PATCH] ndctl: daxctl: fix mmap size
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
To: Dave Jiang <dave.jiang@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Nov 10, 2017 at 11:45 AM, Dave Jiang <dave.jiang@intel.com> wrote:
> The size for mmap needs to be aligned to the region alignment. Add helper
> funciton to determine the actual size to be mmap'd.
>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  daxctl/io.c |   23 ++++++++++++++++++++++-
>  1 file changed, 22 insertions(+), 1 deletion(-)
>
> diff --git a/daxctl/io.c b/daxctl/io.c
> index 2f8cb4a..97a4169 100644
> --- a/daxctl/io.c
> +++ b/daxctl/io.c
> @@ -80,9 +80,26 @@ static bool is_stdinout(struct io_dev *io_dev)
>                         io_dev->fd == STDOUT_FILENO) ? true : false;
>  }
>
> +static int get_mmap_size(struct io_dev *io_dev, size_t size, size_t *map_size)
> +{
> +       unsigned long align;
> +
> +       align = ndctl_dax_get_align(io_dev->dax);
> +       if (align == ULLONG_MAX)
> +               return -ERANGE;
> +
> +       if (size <= align)
> +               *map_size = align;
> +       else
> +               *map_size = (size / align) * align;

We have the ALIGN() macro in util/size.h for this.

> +
> +       return 0;
> +}
> +
>  static int setup_device(struct io_dev *io_dev, size_t size)
>  {
>         int flags, rc;
> +       size_t map_size;
>
>         if (is_stdinout(io_dev))
>                 return 0;
> @@ -104,8 +121,12 @@ static int setup_device(struct io_dev *io_dev, size_t size)
>         if (!io_dev->is_dax)
>                 return 0;
>
> +       rc = get_mmap_size(io_dev, size, &map_size);
> +       if (rc < 0)
> +               return rc;
> +
>         flags = (io_dev->direction == IO_READ) ? PROT_READ : PROT_WRITE;
> -       io_dev->mmap = mmap(NULL, size, flags, MAP_SHARED, io_dev->fd, 0);
> +       io_dev->mmap = mmap(NULL, map_size, flags, MAP_SHARED, io_dev->fd, 0);

Why is offset 0 here? I would expect it to come from the command line
arguments and also use ALIGN_DOWN() to align to first aligned offset
before the target offset.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

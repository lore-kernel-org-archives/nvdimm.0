Return-Path: <owner-linux-mm@kvack.org>
MIME-Version: 1.0
In-Reply-To: <1455640227-21459-1-git-send-email-toshi.kani@hpe.com>
References: <1455640227-21459-1-git-send-email-toshi.kani@hpe.com>
Date: Tue, 16 Feb 2016 16:40:48 -0800
Message-ID: <CAPcyv4jziaJokaG_MSR7CWjOKswS9vbZTeZqOLf_9YP+=p0+MQ@mail.gmail.com>
Subject: Re: [PATCH] devm_memremap_release: fix memremap'd addr handling
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: owner-linux-mm@kvack.org
To: Toshi Kani <toshi.kani@hpe.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Linux MM <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Feb 16, 2016 at 8:30 AM, Toshi Kani <toshi.kani@hpe.com> wrote:
> The pmem driver calls devm_memremap() to map a persistent memory
> range.  When the pmem driver is unloaded, this memremap'd range
> is not released.
>
> Fix devm_memremap_release() to handle a given memremap'd address
> properly.
>
> Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> ---
>  kernel/memremap.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/kernel/memremap.c b/kernel/memremap.c
> index 2c468de..7a1b5c3 100644
> --- a/kernel/memremap.c
> +++ b/kernel/memremap.c
> @@ -114,7 +114,7 @@ EXPORT_SYMBOL(memunmap);
>
>  static void devm_memremap_release(struct device *dev, void *res)
>  {
> -       memunmap(res);
> +       memunmap(*(void **)res);
>  }

Ugh, yup.  Thanks Toshi!

Acked-by: Dan Williams <dan.j.williams@intel.com>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

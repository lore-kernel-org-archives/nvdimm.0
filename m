Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x243.google.com (mail-oi0-x243.google.com
 [IPv6:2607:f8b0:4003:c06::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D63B0203BEA5E
 for <linux-nvdimm@lists.01.org>; Thu,  3 May 2018 17:08:32 -0700 (PDT)
Received: by mail-oi0-x243.google.com with SMTP id 11-v6so17692055ois.8
 for <linux-nvdimm@lists.01.org>; Thu, 03 May 2018 17:08:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180503185050.7559-3-vishal.l.verma@intel.com>
References: <20180503185050.7559-1-vishal.l.verma@intel.com>
 <20180503185050.7559-3-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 3 May 2018 17:08:31 -0700
Message-ID: <CAPcyv4hK19S=O1skqrvgZSbKKfWew2nreJDYPTbKMP+nxW73PA@mail.gmail.com>
Subject: Re: [ndctl PATCH 3/4] libndctl,
 test: fix a couple of unchecked returns
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
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, May 3, 2018 at 11:50 AM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> -Wunused-result with -D_FORTIFY_SOURCE=2 reported a couple of unchecked
> return values, fix them by appropriately failing on errors.

*Building with '-Wunused-result -D_FORTIFY_SOURCE=2' reports...

>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  ndctl/lib/libndctl.c | 5 ++++-
>  test/dax-pmd.c       | 5 ++++-
>  2 files changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
> index 6733b85..47e005e 100644
> --- a/ndctl/lib/libndctl.c
> +++ b/ndctl/lib/libndctl.c
> @@ -1243,7 +1243,10 @@ NDCTL_EXPORT int ndctl_bus_wait_for_scrub_completion(struct ndctl_bus *bus)
>                                 break;
>                         }
>                         dbg(ctx, "poll wake: revents: %d\n", fds.revents);
> -                       pread(fd, buf, 1, 0);
> +                       if (pread(fd, buf, 1, 0) == -1) {
> +                               rc = -errno;
> +                               break;
> +                       }
>                         fds.revents = 0;
>                 }
>         }
> diff --git a/test/dax-pmd.c b/test/dax-pmd.c
> index 06fe522..65bee6f 100644
> --- a/test/dax-pmd.c
> +++ b/test/dax-pmd.c
> @@ -125,7 +125,10 @@ int test_dax_directio(int dax_fd, unsigned long align, void *dax_addr, off_t off
>                                 rc = -ENXIO;
>                         }
>                         ((char *) buf)[0] = 0;
> -                       pread(fd2, buf, 4096, 0);
> +                       if (pread(fd2, buf, 4096, 0) != 4096) {
> +                               faili(i);
> +                               rc = -ENXIO;
> +                       }
>                         if (strcmp(buf, "odirect data") != 0) {
>                                 faili(i);
>                                 rc = -ENXIO;


Reviewed-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x243.google.com (mail-oi0-x243.google.com
 [IPv6:2607:f8b0:4003:c06::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C14192261815D
 for <linux-nvdimm@lists.01.org>; Tue, 10 Apr 2018 16:01:17 -0700 (PDT)
Received: by mail-oi0-x243.google.com with SMTP id c3-v6so12835158oib.5
 for <linux-nvdimm@lists.01.org>; Tue, 10 Apr 2018 16:01:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <152339792009.39156.13688341802570458197.stgit@djiang5-desk3.ch.intel.com>
References: <152339792009.39156.13688341802570458197.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 10 Apr 2018 16:01:16 -0700
Message-ID: <CAPcyv4h9W4_tsVJ_aNWEVTAdg7L=YbVQpAoTW3j4-bgDLGreRw@mail.gmail.com>
Subject: Re: [PATCH v2] ndctl: add support in libndctl to provide deep flush
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
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Apr 10, 2018 at 3:06 PM, Dave Jiang <dave.jiang@intel.com> wrote:
> Providing an API call in libndctl to support accessing the region deep_flush
> in sysfs.
>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>
> v2: Cover case where deep_flush doesn't exist, i.e. memmap=nn!ss. (Dan)
>
>  ndctl/lib/libndctl.c   |   35 +++++++++++++++++++++++++++++++++++
>  ndctl/lib/libndctl.sym |    1 +
>  ndctl/libndctl.h       |    1 +
>  3 files changed, 37 insertions(+)
>
> diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
> index 580a450e..c34f1e09 100644
> --- a/ndctl/lib/libndctl.c
> +++ b/ndctl/lib/libndctl.c
> @@ -181,6 +181,8 @@ struct ndctl_region {
>         FILE *badblocks;
>         struct badblock bb;
>         enum ndctl_persistence_domain persistence_domain;
> +       /* file descriptor for deep flush sysfs entry */
> +       int flush_fd;
>  };
>
>  /**
> @@ -511,6 +513,8 @@ static void free_region(struct ndctl_region *region)
>         free(region->region_path);
>         if (region->badblocks)
>                 fclose(region->badblocks);
> +       if (region->flush_fd > 0)
> +               close(region->flush_fd);
>         free(region);
>  }
>
> @@ -1049,6 +1053,14 @@ NDCTL_EXPORT unsigned long long ndctl_region_get_resource(struct ndctl_region *r
>         return strtoull(buf, NULL, 0);
>  }
>
> +NDCTL_EXPORT int ndctl_region_deep_flush(struct ndctl_region *region)
> +{
> +       int rc = pwrite(region->flush_fd, "1", 1, 0);

Make this write "1\n" to match standard sysfs manipulation done by
"echo" that includes a newline.

> +
> +       return (rc == -1) ? -errno : 0;
> +}
> +
> +
>  NDCTL_EXPORT const char *ndctl_bus_get_cmd_name(struct ndctl_bus *bus, int cmd)
>  {
>         return nvdimm_bus_cmd_name(cmd);
> @@ -1791,6 +1803,7 @@ static void *add_region(void *parent, int id, const char *region_base)
>         struct ndctl_bus *bus = parent;
>         struct ndctl_ctx *ctx = bus->ctx;
>         char *path = calloc(1, strlen(region_base) + 100);
> +       int perm;
>
>         if (!path)
>                 return NULL;
> @@ -1866,6 +1879,28 @@ static void *add_region(void *parent, int id, const char *region_base)
>         else
>                 region->persistence_domain = region_get_pd_type(buf);
>
> +       sprintf(path, "%s/deep_flush", region_base);
> +       region->flush_fd = open(path, O_RDWR);

Make this O_CLOEXEC, so we don't leak fds on exec.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x233.google.com (mail-oi0-x233.google.com
 [IPv6:2607:f8b0:4003:c06::233])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BE6ED2095B081
 for <linux-nvdimm@lists.01.org>; Sat,  7 Oct 2017 09:08:11 -0700 (PDT)
Received: by mail-oi0-x233.google.com with SMTP id n82so26616054oig.3
 for <linux-nvdimm@lists.01.org>; Sat, 07 Oct 2017 09:11:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20171006015405.29908-4-vishal.l.verma@intel.com>
References: <20171006015405.29908-1-vishal.l.verma@intel.com>
 <20171006015405.29908-4-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 7 Oct 2017 09:11:35 -0700
Message-ID: <CAPcyv4gnwXTc5uWqUv2AcpFEhVJvVfzEmR4eou4983J48AJuRw@mail.gmail.com>
Subject: Re: [ndctl PATCH 3/8] libndctl: add APIs to get scrub count and to
 wait for a scrub
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
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Oct 5, 2017 at 6:54 PM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> The kernel uses sysfs to notify userspace of the number of completed
> Address Range Scrubs, as well as any ongoing scrubs. Add libndctl
> helpers to get the scrub count, and to wait for an in-progress scrub to
> complete.
>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  ndctl/lib/libndctl.c   | 85 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  ndctl/lib/libndctl.sym |  2 ++
>  ndctl/lib/private.h    |  1 +
>  ndctl/libndctl.h.in    |  2 ++
>  4 files changed, 90 insertions(+)
>
> diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
> index 60143d9..3943978 100644
> --- a/ndctl/lib/libndctl.c
> +++ b/ndctl/lib/libndctl.c
> @@ -555,6 +555,7 @@ static void free_bus(struct ndctl_bus *bus, struct list_head *head)
>         free(bus->bus_path);
>         free(bus->bus_buf);
>         free(bus->wait_probe_path);
> +       free(bus->scrub_path);
>         free(bus);
>  }
>
> @@ -785,6 +786,11 @@ static void *add_bus(void *parent, int id, const char *ctl_base)
>         if (!bus->wait_probe_path)
>                 goto err_read;
>
> +       sprintf(path, "%s/device/nfit/scrub", ctl_base);
> +       bus->scrub_path = strdup(path);
> +       if (!bus->scrub_path)
> +               goto err_read;
> +
>         bus->bus_path = parent_dev_path("char", bus->major, bus->minor);
>         if (!bus->bus_path)
>                 goto err_dev_path;
> @@ -810,6 +816,7 @@ static void *add_bus(void *parent, int id, const char *ctl_base)
>   err_dev_path:
>   err_read:
>         free(bus->wait_probe_path);
> +       free(bus->scrub_path);
>         free(bus->provider);
>         free(bus->bus_buf);
>         free(bus);
> @@ -1082,6 +1089,84 @@ NDCTL_EXPORT int ndctl_bus_wait_probe(struct ndctl_bus *bus)
>         return rc < 0 ? -ENXIO : 0;
>  }
>
> +NDCTL_EXPORT unsigned int ndctl_bus_get_scrub_count(struct ndctl_bus *bus)
> +{
> +       struct ndctl_ctx *ctx = ndctl_bus_get_ctx(bus);
> +       char buf[SYSFS_ATTR_SIZE];
> +       unsigned int scrub_count;
> +       char in_progress = '\0';
> +       int rc;
> +
> +       rc = sysfs_read_attr(ctx, bus->scrub_path, buf);
> +       if (rc < 0)
> +               return UINT_MAX;
> +
> +       rc = sscanf(buf, "%u%c", &scrub_count, &in_progress);
> +       if (rc < 0)
> +               return UINT_MAX;
> +       if (rc == 0) {
> +               /* unable to read scrub count */
> +               return UINT_MAX;
> +       }
> +       if (rc >= 1)
> +               return scrub_count;
> +
> +       return UINT_MAX;
> +}
> +
> +/**
> + * ndctl_bus_wait_for_scrub - wait for a scrub to complete
> + * @bus: bus for which to check whether a scrub is in progress
> + *
> + * Upon return this bus has completed any in-progress scrubs. This is
> + * different from ndctl_cmd_ars_in_progress in that the latter checks
> + * the output of an ars_status command to see if the in-progress flag
> + * is set, i.e. provides the firmware's view of whether a scrub is in
> + * progress. ndctl_bus_wait_for_scrub instead checks the kernel's view
> + * of whether a scrub is in progress by looking at the 'scrub' file in
> + * sysfs.
> + */
> +NDCTL_EXPORT int ndctl_bus_wait_for_scrub_completion(struct ndctl_bus *bus)
> +{
> +       struct ndctl_ctx *ctx = ndctl_bus_get_ctx(bus);
> +       unsigned int tmo = 120, scrub_count;
> +       char buf[SYSFS_ATTR_SIZE];
> +       char in_progress = '\0';
> +       int rc, elapsed = 0;
> +
> +       do {
> +               rc = sysfs_read_attr(ctx, bus->scrub_path, buf);
> +               if (rc < 0)
> +                       break;
> +
> +               rc = sscanf(buf, "%u%c", &scrub_count, &in_progress);
> +               if (rc < 0)
> +                       break;
> +               else if (rc <= 1) {
> +                       /* scrub complete, break successfully */
> +                       rc = 0;
> +                       break;
> +               } else if (rc == 2 && in_progress == '+') {
> +                       /* scrub in progress, continue to wait */
> +                       ;
> +               } else {
> +                       /* unknown condition */
> +                       rc = -ENXIO;
> +                       break;
> +               }
> +
> +               elapsed++;
> +               sleep(1);
> +       } while (tmo-- != 0);

Hmm, we don't need to do a sleep loop here we can use select(2) or
poll(2) to wait until the scrub notifies completion.

Something like:

seq = read_count()
fd = ndctl_bus_get_scrub_eventfd()
while (in_progress(seq)) {
    select(..., fd, timeout);
    seq = read_count();
}

We already have the kernel doing sleep polling, no need to compound
wake up the problem in userspace.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

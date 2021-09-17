Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FC5D3FC3
	for <nvdimm@lists.linux.dev>; Fri, 17 Sep 2021 01:59:22 +0000 (UTC)
Received: by mail-pg1-f177.google.com with SMTP id n18so8046434pgm.12
        for <nvdimm@lists.linux.dev>; Thu, 16 Sep 2021 18:59:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7tmJkHE9ZnhLhr7IuDmZ4S5i+U1EL61djJboo2rzluc=;
        b=WlCuDzy4YpytTQFh9BDGS6Azk9SSbF9WpZ8d0vM8V/BupkkmPblPiCqBNQpdf5I9ur
         xDlhxc4mG6miX+TEVRVkbQs8J8Jd4fwlbflmw52Rx09HsvaPllm60yO0+D3c6auEPhSs
         0s5+P56UbKgjjv2nFPYRjkhG60DqN4wtaHnY9D2HH6ZWeSxepkQ8E9JLMyE7xSwJgiag
         Z9GJnoRmWBIXLqoiEisXO9oLXPzkMXEucmprlvJtuHf+Rvls6aj5tLSY+yDlzDztMy39
         u8tvNs/STHYjKGK5jCNk/YO85WCNpudr1fGzqZfq/EXhoyRA3glMcKVxeDW4IDvId5ze
         gtEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7tmJkHE9ZnhLhr7IuDmZ4S5i+U1EL61djJboo2rzluc=;
        b=uCrSarlriQ15fQXfcmmpDhAUZQftClRBv644ji9ISNbDLwNPA5SZvL56Pv8eoqix5y
         EU7Zcnnxhv6+gGmAh2ZVq1LQwhwH4V8k3cBkfD0jtXH8Zk99oDLKz6u1bSnDhSEpNaqZ
         Gx88HGLJ6ZEc07HpL9DVqptpnBzSARFRWnXwcpxgC9vgaZYzDrvP/Ay0waq30LqYJhXe
         yaaKCphfL4VdVAnip1gvrQNLkPSA9D2N3N4pXD9IZVlbeJkpCJz496vifZGqXOmqVxhx
         pCEUj1mw0/BC+TF5r9zbVs0yU1G06v+efavRYGQj+HyuXir5nsahyKJ+2P4A6mh7etg/
         6j7Q==
X-Gm-Message-State: AOAM531es4M+1W/hrFJwzsF1bfPEjYlRvpYwbs0j5ue3dOYTybiQFW9s
	GEc1hR2LokNqK3BIHgeO3ZUUH9xz/TCmdwAwJUOVCQ==
X-Google-Smtp-Source: ABdhPJzXhrTVxa7qPxA36VXSe6bdCx2s/aRq/ZXyB1wPw3DdTFo6kDsJEtgOzO7rfN8mf8Nnasq0F0qs9iaLB6CWgxo=
X-Received: by 2002:a62:1b92:0:b0:3eb:3f92:724 with SMTP id
 b140-20020a621b92000000b003eb3f920724mr8104210pfb.3.1631843961914; Thu, 16
 Sep 2021 18:59:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210831090459.2306727-1-vishal.l.verma@intel.com> <20210831090459.2306727-7-vishal.l.verma@intel.com>
In-Reply-To: <20210831090459.2306727-7-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 16 Sep 2021 18:59:10 -0700
Message-ID: <CAPcyv4iR3CSPBQrcU6JLLqKRaAChcfd=REQR+1NEthNZsDmTBQ@mail.gmail.com>
Subject: Re: [ndctl PATCH 6/7] daxctl/device.c: add an option for getting
 params from a config file
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, QI Fuli <qi.fuli@jp.fujitsu.com>, 
	"Hu, Fenghua" <fenghua.hu@intel.com>, QI Fuli <qi.fuli@fujitsu.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, Aug 31, 2021 at 2:05 AM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> Add a new option to daxctl-reconfigure-device that allows it to
> comprehend the new global config system in ndctl/daxctl. With this, the
> reconfigure-device command can query the config to match a specific
> device UUID, and operate using the parameters supplied in that INI
> section.
>
> This is in preparation to make daxctl device reconfiguration (usually
> as system-ram) policy based, so that reconfiguration can happen
> automatically on boot.
>
> Cc: QI Fuli <qi.fuli@fujitsu.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  daxctl/daxctl.c    |   1 +
>  daxctl/device.c    | 141 ++++++++++++++++++++++++++++++++++++++++++++-
>  daxctl/Makefile.am |   1 +
>  3 files changed, 142 insertions(+), 1 deletion(-)
>
> diff --git a/daxctl/daxctl.c b/daxctl/daxctl.c
> index 928814c..dc7ac5f 100644
> --- a/daxctl/daxctl.c
> +++ b/daxctl/daxctl.c
> @@ -95,6 +95,7 @@ int main(int argc, const char **argv)
>         rc = daxctl_new(&ctx);
>         if (rc)
>                 goto out;
> +       daxctl_set_configs(&ctx, DAXCTL_CONF_DIR);

Now that I see how this is used, I think this wants to be called:

daxctl_ctx_add_configs()

...because the operation is populating the context with all the
configuration fragments found in the given directory.

I would also have an option to specify an override for the config
directory, maybe that could be an environment variable?

>         main_handle_internal_command(argc, argv, ctx, commands,
>                         ARRAY_SIZE(commands), PROG_DAXCTL);
>         daxctl_unref(ctx);
> diff --git a/daxctl/device.c b/daxctl/device.c
> index a427b7d..99a4548 100644
> --- a/daxctl/device.c
> +++ b/daxctl/device.c
> @@ -14,8 +14,10 @@
>  #include <util/filter.h>
>  #include <json-c/json.h>
>  #include <json-c/json_util.h>
> +#include <ndctl/libndctl.h>
>  #include <daxctl/libdaxctl.h>
>  #include <util/parse-options.h>
> +#include <util/parse-configs.h>
>  #include <ccan/array_size/array_size.h>
>
>  static struct {
> @@ -25,6 +27,7 @@ static struct {
>         const char *size;
>         const char *align;
>         const char *input;
> +       bool check_config;
>         bool no_online;
>         bool no_movable;
>         bool force;
> @@ -75,7 +78,9 @@ OPT_STRING('m', "mode", &param.mode, "mode", "mode to switch the device to"), \
>  OPT_BOOLEAN('N', "no-online", &param.no_online, \
>         "don't auto-online memory sections"), \
>  OPT_BOOLEAN('f', "force", &param.force, \
> -               "attempt to offline memory sections before reconfiguration")
> +               "attempt to offline memory sections before reconfiguration"), \
> +OPT_BOOLEAN('C', "check-config", &param.check_config, \
> +               "use config files to determine parameters for the operation")
>
>  #define CREATE_OPTIONS() \
>  OPT_STRING('s', "size", &param.size, "size", "size to switch the device to"), \
> @@ -218,6 +223,130 @@ err:
>         return rc;
>  }
>
> +static int conf_string_to_bool(const char *str)
> +{
> +       if (!str)
> +               return INT_MAX;
> +       if (strncmp(str, "t", 1) == 0 ||
> +                       strncmp(str, "T", 1) == 0 ||
> +                       strncmp(str, "y", 1) == 0 ||
> +                       strncmp(str, "Y", 1) == 0 ||
> +                       strncmp(str, "1", 1) == 0)
> +               return true;
> +       if (strncmp(str, "f", 1) == 0 ||
> +                       strncmp(str, "F", 1) == 0 ||
> +                       strncmp(str, "n", 1) == 0 ||
> +                       strncmp(str, "N", 1) == 0 ||
> +                       strncmp(str, "0", 1) == 0)
> +               return false;

Doesn't iniparser_getboolean() already do this conversion for you?

> +       return INT_MAX;
> +}
> +
> +#define conf_assign_inverted_bool(p, conf_var) \
> +do { \
> +       if (conf_string_to_bool(conf_var) != INT_MAX) \
> +               param.p = !conf_string_to_bool(conf_var); \
> +} while(0)
> +
> +static int parse_config_reconfig_set_params(struct daxctl_ctx *ctx, const char *device,
> +                                           const char *uuid)
> +{
> +       const char *conf_online = NULL, *conf_movable = NULL;
> +       const struct config configs[] = {
> +               CONF_SEARCH("auto-online", "uuid", uuid, "mode", &param.mode, NULL),
> +               CONF_SEARCH("auto-online", "uuid", uuid, "online", &conf_online, NULL),
> +               CONF_SEARCH("auto-online", "uuid", uuid, "movable", &conf_movable, NULL),
> +               CONF_END(),
> +       };
> +       const char *prefix = "./";
> +       int rc;
> +
> +       rc = parse_configs_prefix(daxctl_get_configs(ctx), prefix, configs);
> +       if (rc < 0)
> +               return rc;
> +
> +       conf_assign_inverted_bool(no_online, conf_online);
> +       conf_assign_inverted_bool(no_movable, conf_movable);
> +
> +       return 0;
> +}
> +
> +static bool daxctl_ndns_has_device(struct ndctl_namespace *ndns,
> +                                   const char *device)
> +{
> +       struct daxctl_region *dax_region;
> +       struct ndctl_dax *dax;
> +
> +       dax = ndctl_namespace_get_dax(ndns);
> +       if (!dax)
> +               return false;
> +
> +       dax_region = ndctl_dax_get_daxctl_region(dax);
> +       if (dax_region) {
> +               struct daxctl_dev *dev;
> +
> +               dev = daxctl_dev_get_first(dax_region);
> +               if (dev) {
> +                       if (strcmp(daxctl_dev_get_devname(dev), device) == 0)
> +                               return true;
> +               }
> +       }
> +       return false;
> +}
> +
> +static int parse_config_reconfig(struct daxctl_ctx *ctx, const char *device)
> +{
> +       struct ndctl_namespace *ndns;
> +       struct ndctl_ctx *ndctl_ctx;
> +       struct ndctl_region *region;
> +       struct ndctl_bus *bus;
> +       struct ndctl_dax *dax;
> +       int rc, found = 0;
> +       char uuid_buf[40];
> +       uuid_t uuid;
> +
> +       if (strcmp(device, "all") == 0)
> +               return 0;
> +
> +       rc = ndctl_new(&ndctl_ctx);
> +       if (rc < 0)
> +               return rc;
> +
> +        ndctl_bus_foreach(ndctl_ctx, bus) {
> +               ndctl_region_foreach(bus, region) {
> +                       ndctl_namespace_foreach(region, ndns) {
> +                               if (daxctl_ndns_has_device(ndns, device)) {
> +                                       dax = ndctl_namespace_get_dax(ndns);
> +                                       if (!dax)
> +                                               continue;
> +                                       ndctl_dax_get_uuid(dax, uuid);
> +                                       found = 1;
> +                               }
> +                       }
> +               }
> +       }
> +
> +       if (!found) {
> +               fprintf(stderr, "no UUID match for %s found in config files\n",
> +                       device);
> +               return 0;
> +       }
> +
> +       uuid_unparse(uuid, uuid_buf);
> +       return parse_config_reconfig_set_params(ctx, device, uuid_buf);
> +}
> +
> +static int parse_device_config(struct daxctl_ctx *ctx, const char *device,
> +                              enum device_action action)
> +{
> +       switch (action) {
> +       case ACTION_RECONFIG:
> +               return parse_config_reconfig(ctx, device);
> +       default:
> +               return 0;
> +       }
> +}
> +
>  static const char *parse_device_options(int argc, const char **argv,
>                 enum device_action action, const struct option *options,
>                 const char *usage, struct daxctl_ctx *ctx)
> @@ -279,6 +408,16 @@ static const char *parse_device_options(int argc, const char **argv,
>         if (param.human)
>                 flags |= UTIL_JSON_HUMAN;
>
> +       /* Scan config file(s) for options. This sets param.foo accordingly */
> +       if (param.check_config) {
> +               rc = parse_device_config(ctx, argv[0], action);

What happens if someone does:

daxctl reconfigure-device -C --no-online /dev/dax0.0

...and it matches an entry in the configuration file that has
"system-ram.online = true".

My expectation is that precedence ordering is:

built-in defaults
configuration file settings
command line options

Where later entries in that list override settings from the previous
entry. That said, I don't see an easy way to achieve this with parse
options, so might need to fail if anything but -C is specified as an
option until we can fix that conflict.

> +               if (rc) {
> +                       fprintf(stderr, "error parsing config file: %s\n",
> +                               strerror(-rc));
> +                       return NULL;
> +               }
> +       }
> +
>         /* Handle action-specific options */
>         switch (action) {
>         case ACTION_RECONFIG:
> diff --git a/daxctl/Makefile.am b/daxctl/Makefile.am
> index a9845a0..f30c485 100644
> --- a/daxctl/Makefile.am
> +++ b/daxctl/Makefile.am
> @@ -23,6 +23,7 @@ daxctl_SOURCES =\
>
>  daxctl_LDADD =\
>         lib/libdaxctl.la \
> +       ../ndctl/lib/libndctl.la \
>         ../libutil.a \
>         $(UUID_LIBS) \
>         $(KMOD_LIBS) \
> --
> 2.31.1
>

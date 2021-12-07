Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD88A2C9E
	for <nvdimm@lists.linux.dev>; Tue,  7 Dec 2021 22:51:56 +0000 (UTC)
Received: by mail-pf1-f173.google.com with SMTP id x5so841105pfr.0
        for <nvdimm@lists.linux.dev>; Tue, 07 Dec 2021 14:51:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5rSL8hBY3lcDm64SOyga8P4XYNfBAM+vdO8RQLyRkTA=;
        b=ILpdMwS0cTX+rtHxVqLc5kj8MsI6EnA8sIxKVKPfEMI7B2FlgmXpIawyf78vo4SW9A
         HsbjPV5OQmFee3xJRy/M1iIQLiPnPeGgAfI4f9trcqfmnvZVUmbCbv4k/PlE34lUIjp+
         q/sTiiW1QC5gNg8BMM8XOFgBiMnSoyFqPv/evTn5Qujm7AR6Rzf4g42tPT+h2EAuD562
         YUfh9Ixwn3XDQ7Ut3zmsXuNSG+dIxZkhFpjN0upNGKkX/GKdVOrwMqyDpYY6Iz1PH7mD
         PayHINiBKfY9cRAjbh4l/J+83t7tCM0dc8mpjsrSzl69kZbvhK71CU6nFnhCaoLUTIFs
         Cpfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5rSL8hBY3lcDm64SOyga8P4XYNfBAM+vdO8RQLyRkTA=;
        b=NRvYXPtmf3bzPs/E1TWwdZSWWZFiUNRHM0zvjT/G5Ndf5MnHGQQ/ZWjhrgGnSB0uOh
         KYlJz1wemeNQbIwZwE3WwnxRZXduut3X62Az+PUin9SEZKeAk4dfG0Pr70rrPueBQaiq
         AMa/N6KslaE3bSddm+zuzwx3MOrR3L6RSKQi4XtFCWU73gI8H4f7sZV3/bv3iK6zDMWp
         J3zCoJaleu4oDwMadJdvz2GSaLHVl41BTp4pWAmGyCtU+QSTvCw+tZFlICfQRAunhyAj
         H4LTkuonBwx/8sKFU6IaLA0GbT42DDiDTJyunXIde2bHQCWI7ywRfe67yPjoSi8WwTfi
         EaDA==
X-Gm-Message-State: AOAM532lrKIldosUueBu6Uru9UEF3BX81jHNC5PuxWvXq7YM8oyU7XIk
	HyfKk3Jqlw084XfZMnXp8i5OUPlZavJnfnagQmtWlA==
X-Google-Smtp-Source: ABdhPJwjuOMimGBrmeyfnSHF8k6hkDn1NyRgX5VwEi6YfEKinB0zv7oSJKf3Zy/HBskUqECRDJo8ezO1NtftpBV+Yc0=
X-Received: by 2002:a05:6a00:2405:b0:4a8:3294:743e with SMTP id
 z5-20020a056a00240500b004a83294743emr1935561pfh.61.1638917516186; Tue, 07 Dec
 2021 14:51:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211206222830.2266018-1-vishal.l.verma@intel.com> <20211206222830.2266018-4-vishal.l.verma@intel.com>
In-Reply-To: <20211206222830.2266018-4-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 7 Dec 2021 14:51:41 -0800
Message-ID: <CAPcyv4gafiH1RmV=4BK6xk=D-nq78hDMMi3PQx8=p4es88aXFQ@mail.gmail.com>
Subject: Re: [ndctl PATCH v2 03/12] ndctl: make ndctl support configuration files
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, QI Fuli <qi.fuli@jp.fujitsu.com>, 
	"Hu, Fenghua" <fenghua.hu@intel.com>, QI Fuli <qi.fuli@fujitsu.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, Dec 6, 2021 at 2:28 PM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> From: QI Fuli <qi.fuli@fujitsu.com>
>
> Add ndctl_configs to ndctl_ctx for supporting ndctl global configuration
> files. All files with .conf suffix under {sysconfdir}/ndctl can be

I expect this should be named a ".d" directory to match expectations
of when a directory supports multiple config-file snippets. Either
"{sysconfdir}/ndctl/ndctl.d", "{sysconfdir}/ndctl/conf.d",
""{sysconfdir}/ndctl.d"  would be ok with me. "{sysconfdir}/ndctl" is
still needed for the security keys.

> regarded as global configuration files that all ndctl commands can refer
> to. Add ndctl_set_configs() public function for setting ndctl default
> configuration files' path. Add ndctl_get_configs() public function for
> getting ndctl configuration files' path form ndctl_ctx.

s/form/from/

Lets those ndctl_{get,set}_config_path().


>
> Link: https://lore.kernel.org/r/20210824095106.104808-4-qi.fuli@fujitsu.com
> Signed-off-by: QI Fuli <qi.fuli@fujitsu.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  configure.ac           |  4 ++--
>  ndctl/lib/private.h    |  1 +
>  ndctl/lib/libndctl.c   | 54 ++++++++++++++++++++++++++++++++++++++++++
>  ndctl/libndctl.h       |  2 ++
>  ndctl/ndctl.c          |  1 +
>  ndctl/Makefile.am      |  5 ++--
>  ndctl/lib/Makefile.am  |  4 ++++
>  ndctl/lib/libndctl.sym |  2 ++
>  8 files changed, 69 insertions(+), 4 deletions(-)
>
> diff --git a/configure.ac b/configure.ac
> index dc39dbe..42a66e1 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -171,9 +171,9 @@ fi
>  AC_SUBST([systemd_unitdir])
>  AM_CONDITIONAL([ENABLE_SYSTEMD_UNITS], [test "x$with_systemd" = "xyes"])
>
> -ndctl_monitorconfdir=${sysconfdir}/ndctl
> +ndctl_confdir=${sysconfdir}/ndctl
>  ndctl_monitorconf=monitor.conf
> -AC_SUBST([ndctl_monitorconfdir])
> +AC_SUBST([ndctl_confdir])
>  AC_SUBST([ndctl_monitorconf])
>
>  daxctl_modprobe_datadir=${datadir}/daxctl
> diff --git a/ndctl/lib/private.h b/ndctl/lib/private.h
> index 8f4510e..f4ca71f 100644
> --- a/ndctl/lib/private.h
> +++ b/ndctl/lib/private.h
> @@ -129,6 +129,7 @@ struct ndctl_ctx {
>         int regions_init;
>         void *userdata;
>         struct list_head busses;
> +       const char *configs;
>         int busses_init;
>         struct udev *udev;
>         struct udev_queue *udev_queue;
> diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
> index 536e142..6b68e3a 100644
> --- a/ndctl/lib/libndctl.c
> +++ b/ndctl/lib/libndctl.c
> @@ -24,6 +24,7 @@
>  #include <util/util.h>
>  #include <util/size.h>
>  #include <util/sysfs.h>
> +#include <util/strbuf.h>
>  #include <ndctl/libndctl.h>
>  #include <ndctl/namespace.h>
>  #include <daxctl/libdaxctl.h>
> @@ -265,6 +266,58 @@ NDCTL_EXPORT void ndctl_set_userdata(struct ndctl_ctx *ctx, void *userdata)
>         ctx->userdata = userdata;
>  }
>
> +static int filter_conf(const struct dirent *dir)
> +{
> +       if (!dir)
> +               return 0;
> +
> +       if (dir->d_type == DT_REG) {
> +               const char *ext = strrchr(dir->d_name, '.');

Oh, I guess clang-format does not insert line breaks between
declarations and code.

> +               if ((!ext) || (ext == dir->d_name))
> +                       return 0;
> +               if (strcmp(ext, ".conf") == 0)
> +                       return 1;
> +       }
> +
> +       return 0;
> +}
> +
> +NDCTL_EXPORT void ndctl_set_configs_dir(struct ndctl_ctx **ctx, char *conf_dir)

ndctl_set_config_path

Why is ctx a 'struct ndctl_ctx **' instead of a 'struct ndctl_ctx *'?

> +{
> +       struct dirent **namelist;
> +       struct strbuf value = STRBUF_INIT;
> +       int rc;
> +
> +       if ((!ctx) || (!conf_dir))

I think this function needs to return an error. If someone does:
ndctl_set_config_path(NULL, "/path") nothing will notify them that
/path is not established as the config directory. The ENOENT check is
helpful, but why not tell the caller?

> +               return;
> +
> +       rc = scandir(conf_dir, &namelist, filter_conf, alphasort);
> +       if (rc == -1) {
> +               if (errno != ENOENT)
> +                       err(*ctx, "scandir for configs failed: %s\n",
> +                               strerror(errno));
> +               return;
> +       }
> +
> +       while (rc--) {
> +               if (value.len)
> +                       strbuf_addstr(&value, " ");
> +               strbuf_addstr(&value, conf_dir);
> +               strbuf_addstr(&value, "/");
> +               strbuf_addstr(&value, namelist[rc]->d_name);
> +               free(namelist[rc]);
> +       }

Any reason this needs to be converted to a space separated list? What
if there are spaces in the path name?

This could just cache the scandir result in the ctx directly and skip
the strbuf usage.

> +       (*ctx)->configs = strbuf_detach(&value, NULL);
> +       free(namelist);
> +}
> +
> +NDCTL_EXPORT const char *ndctl_get_configs_dir(struct ndctl_ctx *ctx)
> +{
> +       if (ctx == NULL)
> +               return NULL;
> +       return ctx->configs;
> +}
> +
>  /**
>   * ndctl_new - instantiate a new library context
>   * @ctx: context to establish
> @@ -331,6 +384,7 @@ NDCTL_EXPORT int ndctl_new(struct ndctl_ctx **ctx)
>         c->daxctl_ctx = daxctl_ctx;
>
>         return 0;
> +

Unnecessary newline.

>   err_ctx:
>         daxctl_unref(daxctl_ctx);
>   err_daxctl:
> diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
> index 87d07b7..883a56f 100644
> --- a/ndctl/libndctl.h
> +++ b/ndctl/libndctl.h
> @@ -92,6 +92,8 @@ int ndctl_get_log_priority(struct ndctl_ctx *ctx);
>  void ndctl_set_log_priority(struct ndctl_ctx *ctx, int priority);
>  void ndctl_set_userdata(struct ndctl_ctx *ctx, void *userdata);
>  void *ndctl_get_userdata(struct ndctl_ctx *ctx);
> +void ndctl_set_configs_dir(struct ndctl_ctx **ctx, char *conf_dir);
> +const char *ndctl_get_configs_dir(struct ndctl_ctx *ctx);
>
>  enum ndctl_persistence_domain {
>         PERSISTENCE_NONE = 0,
> diff --git a/ndctl/ndctl.c b/ndctl/ndctl.c
> index 31d2c5e..0f908db 100644
> --- a/ndctl/ndctl.c
> +++ b/ndctl/ndctl.c
> @@ -125,6 +125,7 @@ int main(int argc, const char **argv)
>         rc = ndctl_new(&ctx);
>         if (rc)
>                 goto out;
> +       ndctl_set_configs_dir(&ctx, NDCTL_CONF_DIR);

I expect this to happen by default in ndctl_new().

In fact, ndctl_new() might want to grow a config path argument to
override the default.

>         main_handle_internal_command(argc, argv, ctx, commands,
>                         ARRAY_SIZE(commands), PROG_NDCTL);
>         ndctl_unref(ctx);
> diff --git a/ndctl/Makefile.am b/ndctl/Makefile.am
> index a63b1e0..1caa031 100644
> --- a/ndctl/Makefile.am
> +++ b/ndctl/Makefile.am
> @@ -7,8 +7,9 @@ BUILT_SOURCES = config.h
>  config.h: $(srcdir)/Makefile.am
>         $(AM_V_GEN) echo "/* Autogenerated by ndctl/Makefile.am */" >$@ && \
>         echo '#define NDCTL_CONF_FILE \
> -               "$(ndctl_monitorconfdir)/$(ndctl_monitorconf)"' >>$@
> +               "$(ndctl_confdir)/$(ndctl_monitorconf)"' >>$@
>         $(AM_V_GEN) echo '#define NDCTL_KEYS_DIR  "$(ndctl_keysdir)"' >>$@
> +       $(AM_V_GEN) echo '#define NDCTL_CONF_DIR  "$(ndctl_confdir)"' >>$@
>
>  ndctl_SOURCES = ndctl.c \
>                 builtin.h \
> @@ -73,7 +74,7 @@ ndctl_SOURCES += ../test/libndctl.c \
>                  test.c
>  endif
>
> -monitor_configdir = $(ndctl_monitorconfdir)
> +monitor_configdir = $(ndctl_confdir)
>  monitor_config_DATA = $(ndctl_monitorconf)
>
>  if ENABLE_SYSTEMD_UNITS
> diff --git a/ndctl/lib/Makefile.am b/ndctl/lib/Makefile.am
> index e15bb22..f741c44 100644
> --- a/ndctl/lib/Makefile.am
> +++ b/ndctl/lib/Makefile.am
> @@ -14,6 +14,10 @@ libndctl_la_SOURCES =\
>         ../../util/log.h \
>         ../../util/sysfs.c \
>         ../../util/sysfs.h \
> +       ../../util/strbuf.h \
> +       ../../util/strbuf.c \
> +       ../../util/wrapper.c \
> +       ../../util/usage.c \

Seems this new utility code linking is not necessary per the above
recommendation to just cache the scandir results in the ctx.

>         ../../util/fletcher.h \
>         dimm.c \
>         inject.c \
> diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
> index 58afb74..6e1b510 100644
> --- a/ndctl/lib/libndctl.sym
> +++ b/ndctl/lib/libndctl.sym
> @@ -454,4 +454,6 @@ LIBNDCTL_25 {
>
>  LIBNDCTL_26 {
>         ndctl_bus_nfit_translate_spa;
> +       ndctl_set_configs_dir;
> +       ndctl_get_configs_dir;
>  } LIBNDCTL_25;
> --
> 2.33.1
>

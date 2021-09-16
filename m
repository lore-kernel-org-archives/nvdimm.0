Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56B263FC9
	for <nvdimm@lists.linux.dev>; Thu, 16 Sep 2021 22:59:07 +0000 (UTC)
Received: by mail-pg1-f176.google.com with SMTP id k24so7696834pgh.8
        for <nvdimm@lists.linux.dev>; Thu, 16 Sep 2021 15:59:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YqMraqrdMO+3ZioUhbMPdskSKGYlTsFSH9RJHaLfqwc=;
        b=UENQlNMg+5wsMWgeIKoWxVdsvykFR3d+u5sHxkm2Lq9zy6h473sHbyAx8UF5KV/ftu
         66ulQWpoBdODRXX8aabFaLCqm3nhxzo8NK2LaQOzaJvWuc+4GdSontSUQCTBuKKHTSZs
         cRxBZho/GZQ7l8ERfyizvRmAr/2Rp0d0S/MJfTmq0UyhD7MnmDwIiWVs483to40LMupK
         R3He/YLGo56sLNy0tlOVMhBY2yMvSTyLMjcpyrbuRzAhPCDMFXz/AkyQ5NFYZUeftp6K
         /olH97inPHzXafcVyywhTB278Ko8u6oRYqWO8Qjo68Af971wm8v+807ob6lu9CWPb1b7
         8kvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YqMraqrdMO+3ZioUhbMPdskSKGYlTsFSH9RJHaLfqwc=;
        b=rtAJzkIHkVz5DBwx87TffovagWilrGDi2v9lwF90QUW0dZAhbNwOUAOgBqhocxq3sx
         NigPxPIE8fdPvdBXnCg3i0I9XBm6NG6G+mcREPMdsOcrKVQzDRUgxcmFQ8t3q22jdkPn
         20Hj1VpeT6uRbZkPloXHanxK3Re27UoVmszVGm1HKSSbCII5EHm/mchfBO281iHRXiI+
         tx7/YiP6lQ2/LQBIuPlCcUYDUYYA0btE3DnGYXjtJgwasvszfrOikbfBB2YM5pf7XnZD
         z0dWjZlNVPZUrqw4JiwmGxeiz4d5A+wWtYpF3kxtjQYcKt+NjQnMp9xAGWoat3Z7G07W
         sZdg==
X-Gm-Message-State: AOAM533mwgEDUXP8cGhRTXzuskaISCgkyxfdlW56O4HlRDjD5TKoMr/7
	MYNKyYBEYn6cT49BcWrFm2r2Qf2zYXZRELLMy6+M1g==
X-Google-Smtp-Source: ABdhPJykkYHZz8tnNtV8jpqOA4tWCFy8D5Pwry6eABl84A859+ZFsuDij2aysofVrdraAWHOYrkoyDtDxgaao3NTYzs=
X-Received: by 2002:a63:3545:: with SMTP id c66mr6998679pga.377.1631833146816;
 Thu, 16 Sep 2021 15:59:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210831090459.2306727-1-vishal.l.verma@intel.com> <20210831090459.2306727-5-vishal.l.verma@intel.com>
In-Reply-To: <20210831090459.2306727-5-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 16 Sep 2021 15:58:56 -0700
Message-ID: <CAPcyv4iFJrCCVzV66dNjzP_tF1Soq9UGyT36QdWxm-pWwVjZGg@mail.gmail.com>
Subject: Re: [ndctl PATCH 4/7] daxctl: add basic config parsing support
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, QI Fuli <qi.fuli@jp.fujitsu.com>, 
	"Hu, Fenghua" <fenghua.hu@intel.com>, QI Fuli <qi.fuli@fujitsu.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, Aug 31, 2021 at 2:05 AM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> Add support similar to ndctl and libndctl for parsing config files. This
> allows storing a config file path/list in the daxctl_ctx, and adds APIs
> for setting and retrieving it.
>
> Cc: QI Fuli <qi.fuli@fujitsu.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  daxctl/lib/libdaxctl.c   | 37 +++++++++++++++++++++++++++++++++++++
>  daxctl/libdaxctl.h       |  2 ++
>  daxctl/Makefile.am       |  1 +
>  daxctl/lib/Makefile.am   |  4 ++++
>  daxctl/lib/libdaxctl.sym |  2 ++
>  5 files changed, 46 insertions(+)
>
> diff --git a/daxctl/lib/libdaxctl.c b/daxctl/lib/libdaxctl.c
> index 860bd9c..659d2fe 100644
> --- a/daxctl/lib/libdaxctl.c
> +++ b/daxctl/lib/libdaxctl.c
> @@ -17,6 +17,8 @@
>  #include <util/log.h>
>  #include <util/sysfs.h>
>  #include <util/iomem.h>
> +#include <util/strbuf.h>
> +#include <util/parse-configs.h>
>  #include <daxctl/libdaxctl.h>
>  #include "libdaxctl-private.h"
>
> @@ -37,6 +39,7 @@ struct daxctl_ctx {
>         struct log_ctx ctx;
>         int refcount;
>         void *userdata;
> +       const char *configs;
>         int regions_init;
>         struct list_head regions;
>         struct kmod_ctx *kmod_ctx;
> @@ -68,6 +71,40 @@ DAXCTL_EXPORT void daxctl_set_userdata(struct daxctl_ctx *ctx, void *userdata)
>         ctx->userdata = userdata;
>  }
>
> +DAXCTL_EXPORT void daxctl_set_configs(struct daxctl_ctx **ctx, char *conf_dir)
> +{
> +       struct dirent **namelist;
> +       struct strbuf value = STRBUF_INIT;
> +       int rc;
> +
> +       if ((!ctx) || (!conf_dir))
> +               return;
> +
> +       rc = scandir(conf_dir, &namelist, filter_conf_files, alphasort);
> +       if (rc == -1) {
> +               perror("scandir");
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
> +       (*ctx)->configs = strbuf_detach(&value, NULL);
> +       free(namelist);
> +}
> +
> +DAXCTL_EXPORT const char *daxctl_get_configs(struct daxctl_ctx *ctx)
> +{
> +       if (ctx == NULL)
> +               return NULL;
> +       return ctx->configs;
> +}
> +
>  /**
>   * daxctl_new - instantiate a new library context
>   * @ctx: context to establish
> diff --git a/daxctl/libdaxctl.h b/daxctl/libdaxctl.h
> index 683ae9c..9388f85 100644
> --- a/daxctl/libdaxctl.h
> +++ b/daxctl/libdaxctl.h
> @@ -28,6 +28,8 @@ int daxctl_get_log_priority(struct daxctl_ctx *ctx);
>  void daxctl_set_log_priority(struct daxctl_ctx *ctx, int priority);
>  void daxctl_set_userdata(struct daxctl_ctx *ctx, void *userdata);
>  void *daxctl_get_userdata(struct daxctl_ctx *ctx);
> +void daxctl_set_configs(struct daxctl_ctx **ctx, char *conf_dir);
> +const char *daxctl_get_configs(struct daxctl_ctx *ctx);
>
>  struct daxctl_region;
>  struct daxctl_region *daxctl_new_region(struct daxctl_ctx *ctx, int id,
> diff --git a/daxctl/Makefile.am b/daxctl/Makefile.am
> index 9b1313a..a9845a0 100644
> --- a/daxctl/Makefile.am
> +++ b/daxctl/Makefile.am
> @@ -10,6 +10,7 @@ config.h: $(srcdir)/Makefile.am
>                 "$(daxctl_modprobe_datadir)/$(daxctl_modprobe_data)"' >>$@ && \
>         echo '#define DAXCTL_MODPROBE_INSTALL \
>                 "$(sysconfdir)/modprobe.d/$(daxctl_modprobe_data)"' >>$@
> +       $(AM_V_GEN) echo '#define DAXCTL_CONF_DIR  "$(ndctl_confdir)"' >>$@

This gets back to my namespace question about collisions between
daxctl, ndctl, and cxl-cli conf snippets. I think they should each get
their own directory in /etc, then we don't need to encode any prefixes
into section names. What do you think?

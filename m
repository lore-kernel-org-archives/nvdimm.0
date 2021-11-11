Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9353672
	for <nvdimm@lists.linux.dev>; Thu, 11 Nov 2021 23:49:32 +0000 (UTC)
Received: by mail-pf1-f175.google.com with SMTP id y5so6935044pfb.4
        for <nvdimm@lists.linux.dev>; Thu, 11 Nov 2021 15:49:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AQQ2dBHOX1MHYLz00dmBVOpxVUELnFcM/5SIEGNy+Jk=;
        b=xGQMsNTqvSL/lf1gCmPCjZZpnZSkcEyS3MBDUB2P1G8CQoHta7AcOywMkKEyUfTAeZ
         fbrNRUgOxevEHK0q8ZRfKgTwDsRsMp+nutMln1KE4CxYdnxmwtyoP4sOfgZjJiGlZ6n+
         4qKrDRaXNhrdvwcknccPq/Koa1eEsYB2WSTWdGNclgl/6ThTTCSiBZj1CIt0r3Qu6dkN
         D6G9I7HXEM0f1tDXzfvyNth9i7dW3C+J9RABEsNiDAzKMWNbhiVAeb1neQaoHH0Ybf84
         TeDN0XK4zRBF9T43PFIAN6hF5nM3PCH1eg/F7I/8MsXeRxXtP6FoOTncQ7QdBpMVl7RZ
         oyqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AQQ2dBHOX1MHYLz00dmBVOpxVUELnFcM/5SIEGNy+Jk=;
        b=SJa9Au1U4RHaHVqvi2PhDgrzj0nrqkvZi9+gfS8Q/z8aGIq+8BFHrqwTrMtoX9kN6t
         rsVMFzgD56n9S/x4WuCOjyuzsnRPq1c+bCLQb2G+4ieVq3NXoyZ7NQ01nwdncxh+aRiM
         MsbklbdFx25+TCIBF5DOrFpT1eTcsuSjgBo7x/uo5PQk50+5xlVwBIKOhIFE56gMrqvW
         aZZaGS5yvQ6NSCV3ZOoZhIwSNUTW0QpURTR8lZkRo6YjCFuxhkiGaYcgsZrrPzhr9SSB
         OJea0eZDZmCiUkTs+8A+qSnMn9JdE9N2ADT9mr4q09SdQa5NYWs8bY94hQwL4Ntv5zBK
         oTAA==
X-Gm-Message-State: AOAM532LDq+E5j+X/vRNJmT6qxrDWZXwLVEdgXACr/mXHCi5+2pXPqSj
	OlbnBncylj2hCrxI3JAYON2QJeSjF82arnxtTS2/mQ==
X-Google-Smtp-Source: ABdhPJynzx6gt/Z42ncA0aLnhwk+rteMzTq96jMVHhE9sp3K5RukLz0iKil78SG2hfMLibzNskV9rTCuTdSiJbCod7A=
X-Received: by 2002:aa7:8019:0:b0:44d:d761:6f79 with SMTP id
 j25-20020aa78019000000b0044dd7616f79mr10217362pfi.3.1636674571975; Thu, 11
 Nov 2021 15:49:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211111204436.1560365-1-vishal.l.verma@intel.com> <20211111204436.1560365-11-vishal.l.verma@intel.com>
In-Reply-To: <20211111204436.1560365-11-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 11 Nov 2021 15:49:19 -0800
Message-ID: <CAPcyv4j760G=RFkBVy5rB_dOOV3Vj1cL+LvdVzwLS1rT81vZ=A@mail.gmail.com>
Subject: Re: [ndctl PATCH v5 10/16] libcxl: add representation for an nvdimm
 bridge object
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: linux-cxl@vger.kernel.org, Ben Widawsky <ben.widawsky@intel.com>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"

On Thu, Nov 11, 2021 at 12:45 PM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> Add an nvdimm bridge object representation internal to libcxl. A bridge
> object is ited to its parent memdev object, and this patch adds its

s/ited/tied/

> first interface, which checks whether a bridge is 'active' - i.e.
> implying the label space on the memdev is owned by the kernel.

Just some minor fixups below and you can add:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  cxl/lib/private.h  |  9 ++++++
>  cxl/lib/libcxl.c   | 73 ++++++++++++++++++++++++++++++++++++++++++++++
>  cxl/libcxl.h       |  1 +
>  cxl/lib/libcxl.sym |  1 +
>  4 files changed, 84 insertions(+)
>
> diff --git a/cxl/lib/private.h b/cxl/lib/private.h
> index c4ed741..2f0b6ea 100644
> --- a/cxl/lib/private.h
> +++ b/cxl/lib/private.h
> @@ -10,6 +10,14 @@
>
>  #define CXL_EXPORT __attribute__ ((visibility("default")))
>
> +
> +struct cxl_nvdimm_br {

Might as well spell out "bridge".

> +       int id;
> +       void *dev_buf;
> +       size_t buf_len;
> +       char *dev_path;
> +};
> +
>  struct cxl_memdev {
>         int id, major, minor;
>         void *dev_buf;
> @@ -23,6 +31,7 @@ struct cxl_memdev {
>         int payload_max;
>         size_t lsa_size;
>         struct kmod_module *module;
> +       struct cxl_nvdimm_br *bridge;
>  };
>
>  enum cxl_cmd_query_status {
> diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
> index def3a97..7bc0696 100644
> --- a/cxl/lib/libcxl.c
> +++ b/cxl/lib/libcxl.c
> @@ -45,11 +45,19 @@ struct cxl_ctx {
>         void *private_data;
>  };
>
> +static void free_bridge(struct cxl_nvdimm_br *bridge)
> +{
> +       free(bridge->dev_buf);
> +       free(bridge->dev_path);
> +       free(bridge);
> +}
> +
>  static void free_memdev(struct cxl_memdev *memdev, struct list_head *head)
>  {
>         if (head)
>                 list_del_from(head, &memdev->list);
>         kmod_module_unref(memdev->module);
> +       free_bridge(memdev->bridge);
>         free(memdev->firmware_version);
>         free(memdev->dev_buf);
>         free(memdev->dev_path);
> @@ -205,6 +213,40 @@ CXL_EXPORT void cxl_set_log_priority(struct cxl_ctx *ctx, int priority)
>         ctx->ctx.log_priority = priority;
>  }
>
> +static void *add_cxl_bridge(void *parent, int id, const char *br_base)
> +{
> +       const char *devname = devpath_to_devname(br_base);
> +       struct cxl_memdev *memdev = parent;
> +       struct cxl_ctx *ctx = memdev->ctx;
> +       struct cxl_nvdimm_br *bridge;
> +
> +       dbg(ctx, "%s: bridge_base: \'%s\'\n", devname, br_base);
> +
> +       bridge = calloc(1, sizeof(*bridge));
> +       if (!bridge)
> +               goto err_dev;
> +       bridge->id = id;
> +
> +       bridge->dev_path = strdup(br_base);
> +       if (!bridge->dev_path)
> +               goto err_read;
> +
> +       bridge->dev_buf = calloc(1, strlen(br_base) + 50);
> +       if (!bridge->dev_buf)
> +               goto err_read;
> +       bridge->buf_len = strlen(br_base) + 50;
> +
> +       memdev->bridge = bridge;
> +       return bridge;
> +
> + err_read:
> +       free(bridge->dev_buf);
> +       free(bridge->dev_path);
> +       free(bridge);
> + err_dev:
> +       return NULL;
> +}
> +
>  static void *add_cxl_memdev(void *parent, int id, const char *cxlmem_base)
>  {
>         const char *devname = devpath_to_devname(cxlmem_base);
> @@ -271,6 +313,8 @@ static void *add_cxl_memdev(void *parent, int id, const char *cxlmem_base)
>                 goto err_read;
>         memdev->buf_len = strlen(cxlmem_base) + 50;
>
> +       sysfs_device_parse(ctx, cxlmem_base, "pmem", memdev, add_cxl_bridge);
> +
>         cxl_memdev_foreach(ctx, memdev_dup)
>                 if (memdev_dup->id == memdev->id) {
>                         free_memdev(memdev, NULL);
> @@ -362,6 +406,35 @@ CXL_EXPORT size_t cxl_memdev_get_label_size(struct cxl_memdev *memdev)
>         return memdev->lsa_size;
>  }
>
> +static int is_enabled(const char *drvpath)
> +{
> +       struct stat st;
> +
> +       if (lstat(drvpath, &st) < 0 || !S_ISLNK(st.st_mode))
> +               return 0;
> +       else
> +               return 1;
> +}
> +
> +CXL_EXPORT int cxl_memdev_nvdimm_bridge_active(struct cxl_memdev *memdev)
> +{
> +       struct cxl_ctx *ctx = cxl_memdev_get_ctx(memdev);
> +       struct cxl_nvdimm_br *bridge = memdev->bridge;
> +       char *path = memdev->dev_buf;

Should this be: bridge->dev_buf?

> +       int len = memdev->buf_len;

...and this should bridge->buf_len?

Not strictly a bug, but might as well use the 'bridge' version of
these attributes, right?

> +
> +       if (!bridge)
> +               return 0;
> +
> +       if (snprintf(path, len, "%s/driver", bridge->dev_path) >= len) {
> +               err(ctx, "%s: nvdimm bridge buffer too small!\n",
> +                               cxl_memdev_get_devname(memdev));
> +               return 0;
> +       }
> +
> +       return is_enabled(path);
> +}
> +
>  CXL_EXPORT void cxl_cmd_unref(struct cxl_cmd *cmd)
>  {
>         if (!cmd)
> diff --git a/cxl/libcxl.h b/cxl/libcxl.h
> index d3b97a1..535e349 100644
> --- a/cxl/libcxl.h
> +++ b/cxl/libcxl.h
> @@ -43,6 +43,7 @@ unsigned long long cxl_memdev_get_pmem_size(struct cxl_memdev *memdev);
>  unsigned long long cxl_memdev_get_ram_size(struct cxl_memdev *memdev);
>  const char *cxl_memdev_get_firmware_verison(struct cxl_memdev *memdev);
>  size_t cxl_memdev_get_label_size(struct cxl_memdev *memdev);
> +int cxl_memdev_nvdimm_bridge_active(struct cxl_memdev *memdev);
>
>  #define cxl_memdev_foreach(ctx, memdev) \
>          for (memdev = cxl_memdev_get_first(ctx); \
> diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
> index 858e953..f3b0c63 100644
> --- a/cxl/lib/libcxl.sym
> +++ b/cxl/lib/libcxl.sym
> @@ -65,6 +65,7 @@ global:
>         cxl_cmd_new_read_label;
>         cxl_cmd_read_label_get_payload;
>         cxl_memdev_get_label_size;
> +       cxl_memdev_nvdimm_bridge_active;
>  local:
>          *;
>  };
> --
> 2.31.1
>

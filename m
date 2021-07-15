Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C59BD168
	for <nvdimm@lists.linux.dev>; Thu, 15 Jul 2021 23:51:47 +0000 (UTC)
Received: by mail-pf1-f176.google.com with SMTP id m83so7225499pfd.0
        for <nvdimm@lists.linux.dev>; Thu, 15 Jul 2021 16:51:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AC6H/bYQ51Mx47FrqME4hLxCV2FqJ4qT1zFVZnMyepw=;
        b=TqRlFNWcs8eJZpad6iMZ4RzKjsyhRtOT6zQEWEhuL7A7LqSPYLJ4unp1jD/EPbJCUs
         A4Hx7nsB+Pm2wmxviqEUdSiEThFuDAKEoQDnrGJGDGRHGrnzvT7QiOO9yedYX8fttGgR
         K1wGgeYKeBkvAz3y2hlaxQD2Kmz1m7wk9/qkATAOC70722myJgDaGz31qcH8eLW17ahz
         iGvMWlNfnxVDcMdscaSfznyx/Be/MeEnNJDSLd4e6QmOi0TqqOXCzr0Bih0S0PkLaU+l
         daZDQSXI9CTpE9APHlfIhkCTy56n7bkjBQSwQPU4drEnb4GdncWh7WOyk+LlrfZSu8+f
         KPcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AC6H/bYQ51Mx47FrqME4hLxCV2FqJ4qT1zFVZnMyepw=;
        b=szkT0CYjtT1JqFbjEhfN91nJn1LYCyodweP3+ZFkTby114jSxawoSTvbTCQGbtDsCC
         je/3ifWIbkA18tmAbO/Q9Fg7dGtucHN8IdRzxD82KkJ0rW1z5keCKkNpp2I9BhbpPJq0
         KNXAKB3/kRb5mlQKgUCUkZiPTwgllD0fel/p8Yz3AxtGt8prZsE/9lSpNs0MseS5vZSd
         ixxt58L6/ZUXar5LeQBcki/Yp/nkne1PUGx13xuAsl1KVoHLrWAAn7i4O/g9raX15eyB
         x/d3jRdUGuOpoZArE0qnWaKVesjl8dpupkkpojCWZOtIjOCpEBNyQ0X/MROQBurredjP
         gUdA==
X-Gm-Message-State: AOAM532/EGuGvThZDvH2AifuXZUdgca6KKQc08X68snP/aAqNTf045r9
	7zxDmZjxKOZuFkI3+lH5z1gNq4utLxlS1Jt1InmxwQ==
X-Google-Smtp-Source: ABdhPJws7yUdJm3zbGWaTvOnf9Ry6+XgRitzzvRVIylGIdyoKqSNF8EKuFZoNbWaZYksilsOAXgAaYRKWxusQciwCQA=
X-Received: by 2002:a63:d54b:: with SMTP id v11mr6973133pgi.450.1626393106902;
 Thu, 15 Jul 2021 16:51:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210701201005.3065299-1-vishal.l.verma@intel.com> <20210701201005.3065299-8-vishal.l.verma@intel.com>
In-Reply-To: <20210701201005.3065299-8-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 15 Jul 2021 16:51:35 -0700
Message-ID: <CAPcyv4h78h21bPv2tA2DCRm1x-auL7gy2173Q2dCQUuP46yqgA@mail.gmail.com>
Subject: Re: [ndctl PATCH v3 07/21] test: rename 'ndctl_test_*' helpers to 'test_*'
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, linux-cxl@vger.kernel.org, 
	Ben Widawsky <ben.widawsky@intel.com>, Alison Schofield <alison.schofield@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, Jul 1, 2021 at 1:10 PM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> In preparation for using the test harness for libcxl, rename
> ndctl_test_* helpers to make them more generic.

Looks good,

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  test.h                        | 16 +++++------
>  ndctl/bat.c                   |  6 ++--
>  ndctl/test.c                  |  6 ++--
>  test/ack-shutdown-count-set.c | 10 +++----
>  test/blk_namespaces.c         | 10 +++----
>  test/core.c                   | 24 ++++++++--------
>  test/dax-dev.c                |  8 +++---
>  test/dax-pmd.c                |  6 ++--
>  test/dax-poison.c             |  2 +-
>  test/device-dax.c             | 18 ++++++------
>  test/dpa-alloc.c              | 10 +++----
>  test/dsm-fail.c               | 10 +++----
>  test/libndctl.c               | 52 +++++++++++++++++------------------
>  test/multi-pmem.c             | 16 +++++------
>  test/parent-uuid.c            | 10 +++----
>  test/pmem_namespaces.c        | 10 +++----
>  test/revoke-devmem.c          |  8 +++---
>  README.md                     |  2 +-
>  18 files changed, 112 insertions(+), 112 deletions(-)
>
> diff --git a/test.h b/test.h
> index c5b9d4a..a25f6c9 100644
> --- a/test.h
> +++ b/test.h
> @@ -6,15 +6,15 @@
>
>  struct test_ctx;
>  struct ndctl_ctx;
> -struct test_ctx *ndctl_test_new(unsigned int kver);
> -int ndctl_test_result(struct test_ctx *test, int rc);
> -int ndctl_test_get_skipped(struct test_ctx *test);
> -int ndctl_test_get_attempted(struct test_ctx *test);
> -int __ndctl_test_attempt(struct test_ctx *test, unsigned int kver,
> +struct test_ctx *test_new(unsigned int kver);
> +int test_result(struct test_ctx *test, int rc);
> +int test_get_skipped(struct test_ctx *test);
> +int test_get_attempted(struct test_ctx *test);
> +int __test_attempt(struct test_ctx *test, unsigned int kver,
>                 const char *caller, int line);
> -#define ndctl_test_attempt(t, v) __ndctl_test_attempt(t, v, __func__, __LINE__)
> -void __ndctl_test_skip(struct test_ctx *test, const char *caller, int line);
> -#define ndctl_test_skip(t) __ndctl_test_skip(t, __func__, __LINE__)
> +#define test_attempt(t, v) __test_attempt(t, v, __func__, __LINE__)
> +void __test_skip(struct test_ctx *test, const char *caller, int line);
> +#define test_skip(t) __test_skip(t, __func__, __LINE__)
>  struct ndctl_namespace *ndctl_get_test_dev(struct ndctl_ctx *ctx);
>  void builtin_xaction_namespace_reset(void);
>
> diff --git a/ndctl/bat.c b/ndctl/bat.c
> index 18773fd..a3452fa 100644
> --- a/ndctl/bat.c
> +++ b/ndctl/bat.c
> @@ -32,9 +32,9 @@ int cmd_bat(int argc, const char **argv, struct ndctl_ctx *ctx)
>                 usage_with_options(u, options);
>
>         if (force)
> -               test = ndctl_test_new(UINT_MAX);
> +               test = test_new(UINT_MAX);
>         else
> -               test = ndctl_test_new(0);
> +               test = test_new(0);
>
>         if (!test) {
>                 fprintf(stderr, "failed to initialize test\n");
> @@ -48,5 +48,5 @@ int cmd_bat(int argc, const char **argv, struct ndctl_ctx *ctx)
>
>         rc = test_pmem_namespaces(loglevel, test, ctx);
>         fprintf(stderr, "test_pmem_namespaces: %s\n", rc ? "FAIL" : "PASS");
> -       return ndctl_test_result(test, rc);
> +       return test_result(test, rc);
>  }
> diff --git a/ndctl/test.c b/ndctl/test.c
> index 7af3681..92713df 100644
> --- a/ndctl/test.c
> +++ b/ndctl/test.c
> @@ -42,9 +42,9 @@ int cmd_test(int argc, const char **argv, struct ndctl_ctx *ctx)
>                 usage_with_options(u, options);
>
>         if (force)
> -               test = ndctl_test_new(UINT_MAX);
> +               test = test_new(UINT_MAX);
>         else
> -               test = ndctl_test_new(0);
> +               test = test_new(0);
>         if (!test)
>                 return EXIT_FAILURE;
>
> @@ -69,5 +69,5 @@ int cmd_test(int argc, const char **argv, struct ndctl_ctx *ctx)
>         rc = test_multi_pmem(loglevel, test, ctx);
>         fprintf(stderr, "test-multi-pmem: %s\n", result(rc));
>
> -       return ndctl_test_result(test, rc);
> +       return test_result(test, rc);
>  }
> diff --git a/test/ack-shutdown-count-set.c b/test/ack-shutdown-count-set.c
> index d5c7bcb..92690f4 100644
> --- a/test/ack-shutdown-count-set.c
> +++ b/test/ack-shutdown-count-set.c
> @@ -62,7 +62,7 @@ static int do_test(struct ndctl_ctx *ctx, struct test_ctx *test)
>         struct log_ctx log_ctx;
>         int rc = 0;
>
> -       if (!ndctl_test_attempt(test, KERNEL_VERSION(4, 15, 0)))
> +       if (!test_attempt(test, KERNEL_VERSION(4, 15, 0)))
>                 return 77;
>
>         if (!bus)
> @@ -102,7 +102,7 @@ static int test_ack_shutdown_count_set(int loglevel, struct test_ctx *test,
>         err = ndctl_test_init(&kmod_ctx, &mod, NULL, loglevel, test);
>         if (err < 0) {
>                 result = 77;
> -               ndctl_test_skip(test);
> +               test_skip(test);
>                 fprintf(stderr, "%s unavailable skipping tests\n",
>                                 "nfit_test");
>                 return result;
> @@ -117,7 +117,7 @@ static int test_ack_shutdown_count_set(int loglevel, struct test_ctx *test,
>
>  int main(int argc, char *argv[])
>  {
> -       struct test_ctx *test = ndctl_test_new(0);
> +       struct test_ctx *test = test_new(0);
>         struct ndctl_ctx *ctx;
>         int rc;
>
> @@ -128,9 +128,9 @@ int main(int argc, char *argv[])
>
>         rc = ndctl_new(&ctx);
>         if (rc)
> -               return ndctl_test_result(test, rc);
> +               return test_result(test, rc);
>         rc = test_ack_shutdown_count_set(LOG_DEBUG, test, ctx);
>         ndctl_unref(ctx);
>
> -       return ndctl_test_result(test, rc);
> +       return test_result(test, rc);
>  }
> diff --git a/test/blk_namespaces.c b/test/blk_namespaces.c
> index 4919890..04eb600 100644
> --- a/test/blk_namespaces.c
> +++ b/test/blk_namespaces.c
> @@ -210,7 +210,7 @@ int test_blk_namespaces(int log_level, struct test_ctx *test,
>         struct ndctl_namespace *ndns[2];
>         struct ndctl_region *region, *blk_region = NULL;
>
> -       if (!ndctl_test_attempt(test, KERNEL_VERSION(4, 2, 0)))
> +       if (!test_attempt(test, KERNEL_VERSION(4, 2, 0)))
>                 return 77;
>
>         ndctl_set_log_priority(ctx, log_level);
> @@ -232,7 +232,7 @@ int test_blk_namespaces(int log_level, struct test_ctx *test,
>                 ndctl_invalidate(ctx);
>                 bus = ndctl_bus_get_by_provider(ctx, "nfit_test.0");
>                 if (rc < 0 || !bus) {
> -                       ndctl_test_skip(test);
> +                       test_skip(test);
>                         fprintf(stderr, "nfit_test unavailable skipping tests\n");
>                         return 77;
>                 }
> @@ -337,7 +337,7 @@ int test_blk_namespaces(int log_level, struct test_ctx *test,
>
>  int __attribute__((weak)) main(int argc, char *argv[])
>  {
> -       struct test_ctx *test = ndctl_test_new(0);
> +       struct test_ctx *test = test_new(0);
>         struct ndctl_ctx *ctx;
>         int rc;
>
> @@ -349,9 +349,9 @@ int __attribute__((weak)) main(int argc, char *argv[])
>
>         rc = ndctl_new(&ctx);
>         if (rc)
> -               return ndctl_test_result(test, rc);
> +               return test_result(test, rc);
>
>         rc = test_blk_namespaces(LOG_DEBUG, test, ctx);
>         ndctl_unref(ctx);
> -       return ndctl_test_result(test, rc);
> +       return test_result(test, rc);
>  }
> diff --git a/test/core.c b/test/core.c
> index 1ef0ac4..d143e89 100644
> --- a/test/core.c
> +++ b/test/core.c
> @@ -39,7 +39,7 @@ static unsigned int get_system_kver(void)
>         return KERNEL_VERSION(a,b,c);
>  }
>
> -struct test_ctx *ndctl_test_new(unsigned int kver)
> +struct test_ctx *test_new(unsigned int kver)
>  {
>         struct test_ctx *test = calloc(1, sizeof(*test));
>
> @@ -54,15 +54,15 @@ struct test_ctx *ndctl_test_new(unsigned int kver)
>         return test;
>  }
>
> -int ndctl_test_result(struct test_ctx *test, int rc)
> +int test_result(struct test_ctx *test, int rc)
>  {
> -       if (ndctl_test_get_skipped(test))
> +       if (test_get_skipped(test))
>                 fprintf(stderr, "attempted: %d skipped: %d\n",
> -                               ndctl_test_get_attempted(test),
> -                               ndctl_test_get_skipped(test));
> +                               test_get_attempted(test),
> +                               test_get_skipped(test));
>         if (rc && rc != 77)
>                 return rc;
> -       if (ndctl_test_get_skipped(test) >= ndctl_test_get_attempted(test))
> +       if (test_get_skipped(test) >= test_get_attempted(test))
>                 return 77;
>         /* return success if no failures and at least one test not skipped */
>         return 0;
> @@ -75,7 +75,7 @@ static char *kver_str(char *buf, unsigned int kver)
>         return buf;
>  }
>
> -int __ndctl_test_attempt(struct test_ctx *test, unsigned int kver,
> +int __test_attempt(struct test_ctx *test, unsigned int kver,
>                          const char *caller, int line)
>  {
>         char requires[KVER_STRLEN], current[KVER_STRLEN];
> @@ -90,19 +90,19 @@ int __ndctl_test_attempt(struct test_ctx *test, unsigned int kver,
>         return 0;
>  }
>
> -void __ndctl_test_skip(struct test_ctx *test, const char *caller, int line)
> +void __test_skip(struct test_ctx *test, const char *caller, int line)
>  {
>         test->skip++;
>         test->attempt = test->skip;
>         fprintf(stderr, "%s: explicit skip %s:%d\n", __func__, caller, line);
>  }
>
> -int ndctl_test_get_attempted(struct test_ctx *test)
> +int test_get_attempted(struct test_ctx *test)
>  {
>         return test->attempt;
>  }
>
> -int ndctl_test_get_skipped(struct test_ctx *test)
> +int test_get_skipped(struct test_ctx *test)
>  {
>         return test->skip;
>  }
> @@ -174,7 +174,7 @@ int ndctl_test_init(struct kmod_ctx **ctx, struct kmod_module **mod,
>                  * than 4.7.
>                  */
>                 if (strcmp(name, "dax") == 0
> -                               && !ndctl_test_attempt(test,
> +                               && !test_attempt(test,
>                                         KERNEL_VERSION(4, 7, 0)))
>                         continue;
>
> @@ -183,7 +183,7 @@ int ndctl_test_init(struct kmod_ctx **ctx, struct kmod_module **mod,
>                  */
>                 if ((strcmp(name, "dax_pmem_core") == 0
>                                 || strcmp(name, "dax_pmem_compat") == 0)
> -                               && !ndctl_test_attempt(test,
> +                               && !test_attempt(test,
>                                         KERNEL_VERSION(5, 1, 0)))
>                         continue;
>
> diff --git a/test/dax-dev.c b/test/dax-dev.c
> index 99eda26..d61104f 100644
> --- a/test/dax-dev.c
> +++ b/test/dax-dev.c
> @@ -93,7 +93,7 @@ static int emit_e820_device(int loglevel, struct test_ctx *test)
>         struct ndctl_ctx *ctx;
>         struct ndctl_namespace *ndns;
>
> -       if (!ndctl_test_attempt(test, KERNEL_VERSION(4, 3, 0)))
> +       if (!test_attempt(test, KERNEL_VERSION(4, 3, 0)))
>                 return 77;
>
>         err = ndctl_new(&ctx);
> @@ -106,7 +106,7 @@ static int emit_e820_device(int loglevel, struct test_ctx *test)
>         if (!ndns) {
>                 fprintf(stderr, "%s: failed to find usable victim device\n",
>                                 __func__);
> -               ndctl_test_skip(test);
> +               test_skip(test);
>                 err = 77;
>         } else {
>                 fprintf(stdout, "%s\n", ndctl_namespace_get_devname(ndns));
> @@ -118,7 +118,7 @@ static int emit_e820_device(int loglevel, struct test_ctx *test)
>
>  int __attribute__((weak)) main(int argc, char *argv[])
>  {
> -       struct test_ctx *test = ndctl_test_new(0);
> +       struct test_ctx *test = test_new(0);
>         int rc;
>
>         if (!test) {
> @@ -127,5 +127,5 @@ int __attribute__((weak)) main(int argc, char *argv[])
>         }
>
>         rc = emit_e820_device(LOG_DEBUG, test);
> -       return ndctl_test_result(test, rc);
> +       return test_result(test, rc);
>  }
> diff --git a/test/dax-pmd.c b/test/dax-pmd.c
> index e9dedb9..190a0fd 100644
> --- a/test/dax-pmd.c
> +++ b/test/dax-pmd.c
> @@ -45,7 +45,7 @@ int test_dax_remap(struct test_ctx *test, int dax_fd, unsigned long align,
>         struct sigaction act;
>         int rc, val;
>
> -       if ((fsdax || align == SZ_2M) && !ndctl_test_attempt(test, KERNEL_VERSION(5, 8, 0))) {
> +       if ((fsdax || align == SZ_2M) && !test_attempt(test, KERNEL_VERSION(5, 8, 0))) {
>                 /* kernel's prior to 5.8 may crash on this test */
>                 fprintf(stderr, "%s: SKIP mremap() test\n", __func__);
>                 return 0;
> @@ -352,7 +352,7 @@ err_mmap:
>
>  int __attribute__((weak)) main(int argc, char *argv[])
>  {
> -       struct test_ctx *test = ndctl_test_new(0);
> +       struct test_ctx *test = test_new(0);
>         int fd, rc;
>
>         if (!test) {
> @@ -367,5 +367,5 @@ int __attribute__((weak)) main(int argc, char *argv[])
>         rc = test_pmd(test, fd);
>         if (fd >= 0)
>                 close(fd);
> -       return ndctl_test_result(test, rc);
> +       return test_result(test, rc);
>  }
> diff --git a/test/dax-poison.c b/test/dax-poison.c
> index dc62742..e50ff8f 100644
> --- a/test/dax-poison.c
> +++ b/test/dax-poison.c
> @@ -54,7 +54,7 @@ int test_dax_poison(struct test_ctx *test, int dax_fd, unsigned long align,
>         void *buf;
>         int rc;
>
> -       if (!ndctl_test_attempt(test, KERNEL_VERSION(4, 19, 0)))
> +       if (!test_attempt(test, KERNEL_VERSION(4, 19, 0)))
>                 return 77;
>
>         /*
> diff --git a/test/device-dax.c b/test/device-dax.c
> index 1837b4d..80f0ef7 100644
> --- a/test/device-dax.c
> +++ b/test/device-dax.c
> @@ -95,7 +95,7 @@ static int verify_data(struct daxctl_dev *dev, char *dax_buf,
>         struct timeval tv1, tv2, tv_diff;
>         unsigned long i;
>
> -       if (!ndctl_test_attempt(test, KERNEL_VERSION(4, 9, 0)))
> +       if (!test_attempt(test, KERNEL_VERSION(4, 9, 0)))
>                 return 0;
>
>         /* verify data and cache mode */
> @@ -128,7 +128,7 @@ static int verify_data(struct daxctl_dev *dev, char *dax_buf,
>         return 0;
>  }
>
> -static int test_dax_soft_offline(struct ndctl_test *test, struct ndctl_namespace *ndns)
> +static int test_dax_soft_offline(struct test_ctx *test, struct ndctl_namespace *ndns)
>  {
>         unsigned long long resource = ndctl_namespace_get_resource(ndns);
>         int fd, rc;
> @@ -188,10 +188,10 @@ static int __test_device_dax(unsigned long align, int loglevel,
>                 return 77;
>         }
>
> -       if (align > SZ_2M && !ndctl_test_attempt(test, KERNEL_VERSION(4, 11, 0)))
> +       if (align > SZ_2M && !test_attempt(test, KERNEL_VERSION(4, 11, 0)))
>                 return 77;
>
> -       if (!ndctl_test_attempt(test, KERNEL_VERSION(4, 7, 0)))
> +       if (!test_attempt(test, KERNEL_VERSION(4, 7, 0)))
>                 return 77;
>
>         /* setup up fsdax mode pmem device and seed with verification data */
> @@ -279,7 +279,7 @@ static int __test_device_dax(unsigned long align, int loglevel,
>          * Prior to 4.8-final these tests cause crashes, or are
>          * otherwise not supported.
>          */
> -       if (ndctl_test_attempt(test, KERNEL_VERSION(4, 9, 0))) {
> +       if (test_attempt(test, KERNEL_VERSION(4, 9, 0))) {
>                 static const bool devdax = false;
>                 int fd2;
>
> @@ -394,7 +394,7 @@ static int __test_device_dax(unsigned long align, int loglevel,
>         rc = EXIT_SUCCESS;
>         p = (int *) (buf + align);
>         *p = 0xff;
> -       if (ndctl_test_attempt(test, KERNEL_VERSION(4, 9, 0))) {
> +       if (test_attempt(test, KERNEL_VERSION(4, 9, 0))) {
>                 /* after 4.9 this test will properly get sigbus above */
>                 rc = EXIT_FAILURE;
>                 fprintf(stderr, "%s: failed to unmap after reset\n",
> @@ -423,7 +423,7 @@ static int test_device_dax(int loglevel, struct test_ctx *test,
>
>  int __attribute__((weak)) main(int argc, char *argv[])
>  {
> -       struct test_ctx *test = ndctl_test_new(0);
> +       struct test_ctx *test = test_new(0);
>         struct ndctl_ctx *ctx;
>         int rc;
>
> @@ -434,9 +434,9 @@ int __attribute__((weak)) main(int argc, char *argv[])
>
>         rc = ndctl_new(&ctx);
>         if (rc < 0)
> -               return ndctl_test_result(test, rc);
> +               return test_result(test, rc);
>
>         rc = test_device_dax(LOG_DEBUG, test, ctx);
>         ndctl_unref(ctx);
> -       return ndctl_test_result(test, rc);
> +       return test_result(test, rc);
>  }
> diff --git a/test/dpa-alloc.c b/test/dpa-alloc.c
> index d0f5271..e530ed4 100644
> --- a/test/dpa-alloc.c
> +++ b/test/dpa-alloc.c
> @@ -286,13 +286,13 @@ int test_dpa_alloc(int loglevel, struct test_ctx *test, struct ndctl_ctx *ctx)
>         struct kmod_ctx *kmod_ctx;
>         int err, result = EXIT_FAILURE;
>
> -       if (!ndctl_test_attempt(test, KERNEL_VERSION(4, 2, 0)))
> +       if (!test_attempt(test, KERNEL_VERSION(4, 2, 0)))
>                 return 77;
>
>         ndctl_set_log_priority(ctx, loglevel);
>         err = ndctl_test_init(&kmod_ctx, &mod, NULL, loglevel, test);
>         if (err < 0) {
> -               ndctl_test_skip(test);
> +               test_skip(test);
>                 fprintf(stderr, "nfit_test unavailable skipping tests\n");
>                 return 77;
>         }
> @@ -307,7 +307,7 @@ int test_dpa_alloc(int loglevel, struct test_ctx *test, struct ndctl_ctx *ctx)
>
>  int __attribute__((weak)) main(int argc, char *argv[])
>  {
> -       struct test_ctx *test = ndctl_test_new(0);
> +       struct test_ctx *test = test_new(0);
>         struct ndctl_ctx *ctx;
>         int rc;
>
> @@ -318,9 +318,9 @@ int __attribute__((weak)) main(int argc, char *argv[])
>
>         rc = ndctl_new(&ctx);
>         if (rc)
> -               return ndctl_test_result(test, rc);
> +               return test_result(test, rc);
>
>         rc = test_dpa_alloc(LOG_DEBUG, test, ctx);
>         ndctl_unref(ctx);
> -       return ndctl_test_result(test, rc);
> +       return test_result(test, rc);
>  }
> diff --git a/test/dsm-fail.c b/test/dsm-fail.c
> index 74c56de..5559da2 100644
> --- a/test/dsm-fail.c
> +++ b/test/dsm-fail.c
> @@ -184,7 +184,7 @@ static int do_test(struct ndctl_ctx *ctx, struct test_ctx *test)
>         unsigned int handle;
>         int rc, err = 0;
>
> -       if (!ndctl_test_attempt(test, KERNEL_VERSION(4, 9, 0)))
> +       if (!test_attempt(test, KERNEL_VERSION(4, 9, 0)))
>                 return 77;
>
>         if (!bus)
> @@ -349,7 +349,7 @@ int test_dsm_fail(int loglevel, struct test_ctx *test, struct ndctl_ctx *ctx)
>         err = ndctl_test_init(&kmod_ctx, &mod, NULL, loglevel, test);
>         if (err < 0) {
>                 result = 77;
> -               ndctl_test_skip(test);
> +               test_skip(test);
>                 fprintf(stderr, "%s unavailable skipping tests\n",
>                                 "nfit_test");
>                 return result;
> @@ -364,7 +364,7 @@ int test_dsm_fail(int loglevel, struct test_ctx *test, struct ndctl_ctx *ctx)
>
>  int __attribute__((weak)) main(int argc, char *argv[])
>  {
> -       struct test_ctx *test = ndctl_test_new(0);
> +       struct test_ctx *test = test_new(0);
>         struct ndctl_ctx *ctx;
>         int rc;
>
> @@ -375,8 +375,8 @@ int __attribute__((weak)) main(int argc, char *argv[])
>
>         rc = ndctl_new(&ctx);
>         if (rc)
> -               return ndctl_test_result(test, rc);
> +               return test_result(test, rc);
>         rc = test_dsm_fail(LOG_DEBUG, test, ctx);
>         ndctl_unref(ctx);
> -       return ndctl_test_result(test, rc);
> +       return test_result(test, rc);
>  }
> diff --git a/test/libndctl.c b/test/libndctl.c
> index 30d19db..8aeaded 100644
> --- a/test/libndctl.c
> +++ b/test/libndctl.c
> @@ -639,7 +639,7 @@ static int validate_dax(struct ndctl_dax *dax)
>                 return -ENXIO;
>         }
>
> -       if (ndctl_test_attempt(test, KERNEL_VERSION(4, 10, 0))) {
> +       if (test_attempt(test, KERNEL_VERSION(4, 10, 0))) {
>                 if (daxctl_region_get_size(dax_region)
>                                 != ndctl_dax_get_size(dax)) {
>                         fprintf(stderr, "%s: expect size: %llu != %llu\n",
> @@ -745,7 +745,7 @@ static int __check_dax_create(struct ndctl_region *region,
>         ndctl_dax_set_align(dax, SZ_4K);
>
>         rc = ndctl_namespace_set_enforce_mode(ndns, NDCTL_NS_MODE_DAX);
> -       if (ndctl_test_attempt(test, KERNEL_VERSION(4, 13, 0)) && rc < 0) {
> +       if (test_attempt(test, KERNEL_VERSION(4, 13, 0)) && rc < 0) {
>                 fprintf(stderr, "%s: failed to enforce dax mode\n", devname);
>                 return rc;
>         }
> @@ -856,7 +856,7 @@ static int __check_pfn_create(struct ndctl_region *region,
>          */
>         ndctl_pfn_set_align(pfn, SZ_4K);
>         rc = ndctl_namespace_set_enforce_mode(ndns, NDCTL_NS_MODE_MEMORY);
> -       if (ndctl_test_attempt(test, KERNEL_VERSION(4, 13, 0)) && rc < 0) {
> +       if (test_attempt(test, KERNEL_VERSION(4, 13, 0)) && rc < 0) {
>                 fprintf(stderr, "%s: failed to enforce pfn mode\n", devname);
>                 return rc;
>         }
> @@ -1030,7 +1030,7 @@ static int check_btt_size(struct ndctl_btt *btt)
>         }
>
>         /* prior to 4.8 btt devices did not have a size attribute */
> -       if (!ndctl_test_attempt(test, KERNEL_VERSION(4, 8, 0)))
> +       if (!test_attempt(test, KERNEL_VERSION(4, 8, 0)))
>                 return 0;
>
>         expect = expect_table[size_select][sect_select];
> @@ -1077,7 +1077,7 @@ static int check_btt_create(struct ndctl_region *region, struct ndctl_namespace
>                 ndctl_btt_set_uuid(btt, btt_s->uuid);
>                 ndctl_btt_set_sector_size(btt, btt_s->sector_sizes[i]);
>                 rc = ndctl_namespace_set_enforce_mode(ndns, NDCTL_NS_MODE_SECTOR);
> -               if (ndctl_test_attempt(test, KERNEL_VERSION(4, 13, 0)) && rc < 0) {
> +               if (test_attempt(test, KERNEL_VERSION(4, 13, 0)) && rc < 0) {
>                         fprintf(stderr, "%s: failed to enforce btt mode\n", devname);
>                         goto err;
>                 }
> @@ -1094,7 +1094,7 @@ static int check_btt_create(struct ndctl_region *region, struct ndctl_namespace
>                 }
>
>                 /* prior to v4.5 the mode attribute did not exist */
> -               if (ndctl_test_attempt(test, KERNEL_VERSION(4, 5, 0))) {
> +               if (test_attempt(test, KERNEL_VERSION(4, 5, 0))) {
>                         mode = ndctl_namespace_get_mode(ndns);
>                         if (mode >= 0 && mode != NDCTL_NS_MODE_SECTOR)
>                                 fprintf(stderr, "%s: expected safe mode got: %d\n",
> @@ -1102,7 +1102,7 @@ static int check_btt_create(struct ndctl_region *region, struct ndctl_namespace
>                 }
>
>                 /* prior to v4.13 the expected sizes were different due to BTT1.1 */
> -               if (ndctl_test_attempt(test, KERNEL_VERSION(4, 13, 0))) {
> +               if (test_attempt(test, KERNEL_VERSION(4, 13, 0))) {
>                         rc = check_btt_size(btt);
>                         if (rc)
>                                 goto err;
> @@ -1287,7 +1287,7 @@ static int check_pfn_autodetect(struct ndctl_bus *bus,
>                 return -ENXIO;
>
>         mode = ndctl_namespace_get_enforce_mode(ndns);
> -       if (ndctl_test_attempt(test, KERNEL_VERSION(4, 13, 0))
> +       if (test_attempt(test, KERNEL_VERSION(4, 13, 0))
>                         && mode != NDCTL_NS_MODE_MEMORY) {
>                 fprintf(stderr, "%s expected enforce_mode pfn\n", devname);
>                 return -ENXIO;
> @@ -1384,7 +1384,7 @@ static int check_dax_autodetect(struct ndctl_bus *bus,
>                 return -ENXIO;
>
>         mode = ndctl_namespace_get_enforce_mode(ndns);
> -       if (ndctl_test_attempt(test, KERNEL_VERSION(4, 13, 0))
> +       if (test_attempt(test, KERNEL_VERSION(4, 13, 0))
>                         && mode != NDCTL_NS_MODE_DAX) {
>                 fprintf(stderr, "%s expected enforce_mode dax\n", devname);
>                 return -ENXIO;
> @@ -1469,7 +1469,7 @@ static int check_btt_autodetect(struct ndctl_bus *bus,
>                 return -ENXIO;
>
>         mode = ndctl_namespace_get_enforce_mode(ndns);
> -       if (ndctl_test_attempt(test, KERNEL_VERSION(4, 13, 0))
> +       if (test_attempt(test, KERNEL_VERSION(4, 13, 0))
>                         && mode != NDCTL_NS_MODE_SECTOR) {
>                 fprintf(stderr, "%s expected enforce_mode btt\n", devname);
>                 return -ENXIO;
> @@ -1714,7 +1714,7 @@ static int check_namespaces(struct ndctl_region *region,
>                 }
>
>                 if (ndctl_region_get_type(region) == ND_DEVICE_REGION_PMEM
> -                               && !ndctl_test_attempt(test, KERNEL_VERSION(4, 13, 0)))
> +                               && !test_attempt(test, KERNEL_VERSION(4, 13, 0)))
>                         /* pass, no sector_size support for pmem prior to 4.13 */;
>                 else {
>                         num_sector_sizes = namespace->num_sector_sizes;
> @@ -2321,7 +2321,7 @@ static int check_smart_threshold(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
>          * Starting with v4.9 smart threshold requests trigger the file
>          * descriptor returned by ndctl_dimm_get_health_eventfd().
>          */
> -       if (ndctl_test_attempt(check->test, KERNEL_VERSION(4, 9, 0))) {
> +       if (test_attempt(check->test, KERNEL_VERSION(4, 9, 0))) {
>                 int pid = fork();
>
>                 if (pid == 0) {
> @@ -2396,7 +2396,7 @@ static int check_smart_threshold(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
>                 ndctl_cmd_unref(cmd_set);
>         }
>
> -       if (ndctl_test_attempt(check->test, KERNEL_VERSION(4, 9, 0))) {
> +       if (test_attempt(check->test, KERNEL_VERSION(4, 9, 0))) {
>                 wait(&rc);
>                 if (WEXITSTATUS(rc) == EXIT_FAILURE) {
>                         fprintf(stderr, "%s: expect health event trigger\n",
> @@ -2439,7 +2439,7 @@ static int check_commands(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
>          * The kernel did not start emulating v1.2 namespace spec smart data
>          * until 4.9.
>          */
> -       if (!ndctl_test_attempt(test, KERNEL_VERSION(4, 9, 0)))
> +       if (!test_attempt(test, KERNEL_VERSION(4, 9, 0)))
>                 dimm_commands &= ~((1 << ND_CMD_SMART)
>                                 | (1 << ND_CMD_SMART_THRESHOLD));
>
> @@ -2474,7 +2474,7 @@ static int check_commands(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
>         if (rc)
>                 goto out;
>
> -       if (!ndctl_test_attempt(test, KERNEL_VERSION(4, 6, 0)))
> +       if (!test_attempt(test, KERNEL_VERSION(4, 6, 0)))
>                 goto out;
>
>   out:
> @@ -2530,7 +2530,7 @@ static int check_dimms(struct ndctl_bus *bus, struct dimm *dimms, int n,
>                         return -ENXIO;
>                 }
>
> -               if (ndctl_test_attempt(test, KERNEL_VERSION(4, 7, 0))) {
> +               if (test_attempt(test, KERNEL_VERSION(4, 7, 0))) {
>                         if (ndctl_dimm_get_formats(dimm) != dimms[i].formats) {
>                                 fprintf(stderr, "dimm%d expected formats: %d got: %d\n",
>                                                 i, dimms[i].formats,
> @@ -2548,7 +2548,7 @@ static int check_dimms(struct ndctl_bus *bus, struct dimm *dimms, int n,
>                         }
>                 }
>
> -               if (ndctl_test_attempt(test, KERNEL_VERSION(4, 7, 0))) {
> +               if (test_attempt(test, KERNEL_VERSION(4, 7, 0))) {
>                         if (ndctl_dimm_get_subsystem_vendor(dimm)
>                                         != dimms[i].subsystem_vendor) {
>                                 fprintf(stderr,
> @@ -2559,7 +2559,7 @@ static int check_dimms(struct ndctl_bus *bus, struct dimm *dimms, int n,
>                         }
>                 }
>
> -               if (ndctl_test_attempt(test, KERNEL_VERSION(4, 8, 0))) {
> +               if (test_attempt(test, KERNEL_VERSION(4, 8, 0))) {
>                         if (ndctl_dimm_get_manufacturing_date(dimm)
>                                         != dimms[i].manufacturing_date) {
>                                 fprintf(stderr,
> @@ -2645,14 +2645,14 @@ static int do_test0(struct ndctl_ctx *ctx, struct test_ctx *test)
>         }
>
>         /* pfn and dax tests require vmalloc-enabled nfit_test */
> -       if (ndctl_test_attempt(test, KERNEL_VERSION(4, 8, 0))) {
> +       if (test_attempt(test, KERNEL_VERSION(4, 8, 0))) {
>                 rc = check_regions(bus, regions0, ARRAY_SIZE(regions0), DAX);
>                 if (rc)
>                         return rc;
>                 reset_bus(bus);
>         }
>
> -       if (ndctl_test_attempt(test, KERNEL_VERSION(4, 8, 0))) {
> +       if (test_attempt(test, KERNEL_VERSION(4, 8, 0))) {
>                 rc = check_regions(bus, regions0, ARRAY_SIZE(regions0), PFN);
>                 if (rc)
>                         return rc;
> @@ -2676,7 +2676,7 @@ static int do_test1(struct ndctl_ctx *ctx, struct test_ctx *test)
>          * Starting with v4.10 the dimm on nfit_test.1 gets a unique
>          * handle.
>          */
> -       if (ndctl_test_attempt(test, KERNEL_VERSION(4, 10, 0)))
> +       if (test_attempt(test, KERNEL_VERSION(4, 10, 0)))
>                 dimms1[0].handle = DIMM_HANDLE(1, 0, 0, 0, 0);
>
>         rc = check_dimms(bus, dimms1, ARRAY_SIZE(dimms1), 0, 0, test);
> @@ -2700,7 +2700,7 @@ int test_libndctl(int loglevel, struct test_ctx *test, struct ndctl_ctx *ctx)
>         struct daxctl_ctx *daxctl_ctx;
>         int err, result = EXIT_FAILURE;
>
> -       if (!ndctl_test_attempt(test, KERNEL_VERSION(4, 2, 0)))
> +       if (!test_attempt(test, KERNEL_VERSION(4, 2, 0)))
>                 return 77;
>
>         ndctl_set_log_priority(ctx, loglevel);
> @@ -2710,7 +2710,7 @@ int test_libndctl(int loglevel, struct test_ctx *test, struct ndctl_ctx *ctx)
>
>         err = ndctl_test_init(&kmod_ctx, &mod, ctx, loglevel, test);
>         if (err < 0) {
> -               ndctl_test_skip(test);
> +               test_skip(test);
>                 fprintf(stderr, "nfit_test unavailable skipping tests\n");
>                 return 77;
>         }
> @@ -2732,7 +2732,7 @@ int test_libndctl(int loglevel, struct test_ctx *test, struct ndctl_ctx *ctx)
>
>  int __attribute__((weak)) main(int argc, char *argv[])
>  {
> -       struct test_ctx *test = ndctl_test_new(0);
> +       struct test_ctx *test = test_new(0);
>         struct ndctl_ctx *ctx;
>         int rc;
>
> @@ -2743,8 +2743,8 @@ int __attribute__((weak)) main(int argc, char *argv[])
>
>         rc = ndctl_new(&ctx);
>         if (rc)
> -               return ndctl_test_result(test, rc);
> +               return test_result(test, rc);
>         rc = test_libndctl(LOG_DEBUG, test, ctx);
>         ndctl_unref(ctx);
> -       return ndctl_test_result(test, rc);
> +       return test_result(test, rc);
>  }
> diff --git a/test/multi-pmem.c b/test/multi-pmem.c
> index e2f3bc5..f2eb381 100644
> --- a/test/multi-pmem.c
> +++ b/test/multi-pmem.c
> @@ -57,7 +57,7 @@ static int check_deleted(struct ndctl_region *region, const char *devname,
>  {
>         struct ndctl_namespace *ndns;
>
> -       if (!ndctl_test_attempt(test, KERNEL_VERSION(4, 10, 0)))
> +       if (!test_attempt(test, KERNEL_VERSION(4, 10, 0)))
>                 return 0;
>
>         ndctl_namespace_foreach(region, ndns) {
> @@ -85,8 +85,8 @@ static int do_multi_pmem(struct ndctl_ctx *ctx, struct test_ctx *test)
>         struct ndctl_namespace *namespaces[NUM_NAMESPACES];
>         unsigned long long blk_avail, blk_avail_orig, expect;
>
> -       if (!ndctl_test_attempt(test, KERNEL_VERSION(4, 9, 0))) {
> -               ndctl_test_skip(test);
> +       if (!test_attempt(test, KERNEL_VERSION(4, 9, 0))) {
> +               test_skip(test);
>                 return 77;
>         }
>
> @@ -245,7 +245,7 @@ int test_multi_pmem(int loglevel, struct test_ctx *test,
>         struct kmod_ctx *kmod_ctx;
>         int err, result = EXIT_FAILURE;
>
> -       if (!ndctl_test_attempt(test, KERNEL_VERSION(4, 2, 0)))
> +       if (!test_attempt(test, KERNEL_VERSION(4, 2, 0)))
>                 return 77;
>
>         ndctl_set_log_priority(ctx, loglevel);
> @@ -253,7 +253,7 @@ int test_multi_pmem(int loglevel, struct test_ctx *test,
>         err = ndctl_test_init(&kmod_ctx, &mod, NULL, loglevel, test);
>         if (err < 0) {
>                 result = 77;
> -               ndctl_test_skip(test);
> +               test_skip(test);
>                 fprintf(stderr, "%s unavailable skipping tests\n",
>                                 "nfit_test");
>                 return result;
> @@ -268,7 +268,7 @@ int test_multi_pmem(int loglevel, struct test_ctx *test,
>
>  int __attribute__((weak)) main(int argc, char *argv[])
>  {
> -       struct test_ctx *test = ndctl_test_new(0);
> +       struct test_ctx *test = test_new(0);
>         struct ndctl_ctx *ctx;
>         int rc;
>
> @@ -279,8 +279,8 @@ int __attribute__((weak)) main(int argc, char *argv[])
>
>         rc = ndctl_new(&ctx);
>         if (rc)
> -               return ndctl_test_result(test, rc);
> +               return test_result(test, rc);
>         rc = test_multi_pmem(LOG_DEBUG, test, ctx);
>         ndctl_unref(ctx);
> -       return ndctl_test_result(test, rc);
> +       return test_result(test, rc);
>  }
> diff --git a/test/parent-uuid.c b/test/parent-uuid.c
> index dd007c7..8da396f 100644
> --- a/test/parent-uuid.c
> +++ b/test/parent-uuid.c
> @@ -215,13 +215,13 @@ int test_parent_uuid(int loglevel, struct test_ctx *test,
>         struct kmod_ctx *kmod_ctx;
>         int err, result = EXIT_FAILURE;
>
> -       if (!ndctl_test_attempt(test, KERNEL_VERSION(4, 3, 0)))
> +       if (!test_attempt(test, KERNEL_VERSION(4, 3, 0)))
>                 return 77;
>
>         ndctl_set_log_priority(ctx, loglevel);
>         err = ndctl_test_init(&kmod_ctx, &mod, NULL, loglevel, test);
>         if (err < 0) {
> -               ndctl_test_skip(test);
> +               test_skip(test);
>                 fprintf(stderr, "nfit_test unavailable skipping tests\n");
>                 return 77;
>         }
> @@ -236,7 +236,7 @@ int test_parent_uuid(int loglevel, struct test_ctx *test,
>
>  int __attribute__((weak)) main(int argc, char *argv[])
>  {
> -       struct test_ctx *test = ndctl_test_new(0);
> +       struct test_ctx *test = test_new(0);
>         struct ndctl_ctx *ctx;
>         int rc;
>
> @@ -247,9 +247,9 @@ int __attribute__((weak)) main(int argc, char *argv[])
>
>         rc = ndctl_new(&ctx);
>         if (rc)
> -               return ndctl_test_result(test, rc);
> +               return test_result(test, rc);
>
>         rc = test_parent_uuid(LOG_DEBUG, test, ctx);
>         ndctl_unref(ctx);
> -       return ndctl_test_result(test, rc);
> +       return test_result(test, rc);
>  }
> diff --git a/test/pmem_namespaces.c b/test/pmem_namespaces.c
> index eddf32a..20f41fe 100644
> --- a/test/pmem_namespaces.c
> +++ b/test/pmem_namespaces.c
> @@ -173,7 +173,7 @@ int test_pmem_namespaces(int log_level, struct test_ctx *test,
>         int rc = -ENXIO;
>         char bdev[50];
>
> -       if (!ndctl_test_attempt(test, KERNEL_VERSION(4, 2, 0)))
> +       if (!test_attempt(test, KERNEL_VERSION(4, 2, 0)))
>                 return 77;
>
>         ndctl_set_log_priority(ctx, log_level);
> @@ -196,7 +196,7 @@ int test_pmem_namespaces(int log_level, struct test_ctx *test,
>                 bus = ndctl_bus_get_by_provider(ctx, "nfit_test.0");
>                 if (rc < 0 || !bus) {
>                         rc = 77;
> -                       ndctl_test_skip(test);
> +                       test_skip(test);
>                         fprintf(stderr, "nfit_test unavailable skipping tests\n");
>                         goto err_module;
>                 }
> @@ -262,7 +262,7 @@ int test_pmem_namespaces(int log_level, struct test_ctx *test,
>
>  int __attribute__((weak)) main(int argc, char *argv[])
>  {
> -       struct test_ctx *test = ndctl_test_new(0);
> +       struct test_ctx *test = test_new(0);
>         struct ndctl_ctx *ctx;
>         int rc;
>
> @@ -274,9 +274,9 @@ int __attribute__((weak)) main(int argc, char *argv[])
>
>         rc = ndctl_new(&ctx);
>         if (rc)
> -               return ndctl_test_result(test, rc);
> +               return test_result(test, rc);
>
>         rc = test_pmem_namespaces(LOG_DEBUG, test, ctx);
>         ndctl_unref(ctx);
> -       return ndctl_test_result(test, rc);
> +       return test_result(test, rc);
>  }
> diff --git a/test/revoke-devmem.c b/test/revoke-devmem.c
> index 0d67d93..ac8d81c 100644
> --- a/test/revoke-devmem.c
> +++ b/test/revoke-devmem.c
> @@ -44,7 +44,7 @@ static int test_devmem(int loglevel, struct test_ctx *test,
>         ndctl_set_log_priority(ctx, loglevel);
>
>         /* iostrict devmem started in kernel 4.5 */
> -       if (!ndctl_test_attempt(test, KERNEL_VERSION(4, 5, 0)))
> +       if (!test_attempt(test, KERNEL_VERSION(4, 5, 0)))
>                 return 77;
>
>         ndns = ndctl_get_test_dev(ctx);
> @@ -124,7 +124,7 @@ out_devmem:
>
>  int main(int argc, char *argv[])
>  {
> -       struct test_ctx *test = ndctl_test_new(0);
> +       struct test_ctx *test = test_new(0);
>         struct ndctl_ctx *ctx;
>         int rc;
>
> @@ -135,9 +135,9 @@ int main(int argc, char *argv[])
>
>         rc = ndctl_new(&ctx);
>         if (rc < 0)
> -               return ndctl_test_result(test, rc);
> +               return test_result(test, rc);
>
>         rc = test_devmem(LOG_DEBUG, test, ctx);
>         ndctl_unref(ctx);
> -       return ndctl_test_result(test, rc);
> +       return test_result(test, rc);
>  }
> diff --git a/README.md b/README.md
> index 89dfc87..7a687ac 100644
> --- a/README.md
> +++ b/README.md
> @@ -95,7 +95,7 @@ test/test-suite.log:
>  SKIP: libndctl
>  ==============
>  test/init: nfit_test_init: nfit.ko: appears to be production version: /lib/modules/4.8.8-200.fc24.x86_64/kernel/drivers/acpi/nfit/nfit.ko.xz
> -__ndctl_test_skip: explicit skip test_libndctl:2684
> +__test_skip: explicit skip test_libndctl:2684
>  nfit_test unavailable skipping tests
>  ```
>
> --
> 2.31.1
>

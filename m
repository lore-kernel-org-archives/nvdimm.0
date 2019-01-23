Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com
 [IPv6:2607:f8b0:4864:20::343])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E3F4A211B85C2
 for <linux-nvdimm@lists.01.org>; Wed, 23 Jan 2019 10:25:14 -0800 (PST)
Received: by mail-ot1-x343.google.com with SMTP id a11so2779760otr.10
 for <linux-nvdimm@lists.01.org>; Wed, 23 Jan 2019 10:25:14 -0800 (PST)
MIME-Version: 1.0
References: <154777861562.42557.12388414625709189905.stgit@djiang5-desk3.ch.intel.com>
 <154777914548.42557.12179051970472720250.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <154777914548.42557.12179051970472720250.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 23 Jan 2019 10:25:02 -0800
Message-ID: <CAPcyv4iDupjeRVt3wSxwmaNwShK4Tnzc1s6=st+ZdD+MhLFyaw@mail.gmail.com>
Subject: Re: [PATCH v9 08/13] ndctl: add modprobe conf file and load-keys
 ndctl command
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

On Thu, Jan 17, 2019 at 6:39 PM Dave Jiang <dave.jiang@intel.com> wrote:
>
> Add load-keys command to ndctl. This will attempt to load the master key
> and the related encrypted keys for nvdimms. Also add reference config file
> for modprobe.d in order to call ndctl load-keys and inject keys associated
> with the nvdimms into the kernel user ring for unlock.
>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  Documentation/ndctl/Makefile.am         |    3
>  Documentation/ndctl/ndctl-load-keys.txt |   43 +++++
>  Makefile.am                             |    4
>  contrib/nvdimm-security.conf            |    1
>  ndctl.spec.in                           |    1
>  ndctl/Makefile.am                       |    3
>  ndctl/builtin.h                         |    1
>  ndctl/lib/keys.c                        |   64 +++++---
>  ndctl/lib/libndctl.sym                  |    1
>  ndctl/libndctl.h                        |    2
>  ndctl/load-keys.c                       |  257 +++++++++++++++++++++++++++++++
>  ndctl/ndctl.c                           |    1
>  12 files changed, 357 insertions(+), 24 deletions(-)
>  create mode 100644 Documentation/ndctl/ndctl-load-keys.txt
>  create mode 100644 contrib/nvdimm-security.conf
>  create mode 100644 ndctl/load-keys.c
[..]
> -static char *load_key_blob(struct ndctl_ctx *ctx, const char *path, int *size)
> +NDCTL_EXPORT char *ndctl_load_key_blob(struct ndctl_ctx *ctx,
> +               const char *path, int *size, const char *postfix, int dirfd)

As another example of the comment in patch3 this api seems
particularly difficult to describe how a 3rd party could use it
without subscribing to all of the assumptions of the ndctl
implementation.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

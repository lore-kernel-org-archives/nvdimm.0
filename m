Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com
 [IPv6:2607:f8b0:4864:20::343])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E8C732115F505
 for <linux-nvdimm@lists.01.org>; Sat, 13 Oct 2018 10:57:25 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id l58so15296817otd.6
 for <linux-nvdimm@lists.01.org>; Sat, 13 Oct 2018 10:57:25 -0700 (PDT)
MIME-Version: 1.0
References: <153938316555.20740.14314691018876178251.stgit@djiang5-desk3.ch.intel.com>
 <153938332111.20740.843473636761171235.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <153938332111.20740.843473636761171235.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 13 Oct 2018 10:57:13 -0700
Message-ID: <CAPcyv4iZ79-Ht6Vi+kSvgUeiCcuL1m2=d9XOVAoS3HnPHb5Z8w@mail.gmail.com>
Subject: Re: [PATCH v4 1/7] ndctl: add support for display security state
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

On Fri, Oct 12, 2018 at 3:28 PM Dave Jiang <dave.jiang@intel.com> wrote:
>
> Adding libndctl API call for retrieving security state for a DIMM and also
> adding support to ndctl list for displaying security state.
>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  Documentation/ndctl/ndctl-list.txt |    8 ++++++++
>  ndctl/lib/dimm.c                   |   16 ++++++++++++++++
>  ndctl/lib/libndctl.sym             |    5 +++++
>  ndctl/libndctl.h                   |    1 +
>  util/json.c                        |    8 ++++++++
>  5 files changed, 38 insertions(+)
>
> diff --git a/Documentation/ndctl/ndctl-list.txt b/Documentation/ndctl/ndctl-list.txt
> index e24c8f40..a4a712a0 100644
> --- a/Documentation/ndctl/ndctl-list.txt
> +++ b/Documentation/ndctl/ndctl-list.txt
> @@ -98,6 +98,14 @@ include::xable-region-options.txt[]
>  -D::
>  --dimms::
>         Include dimm info in the listing
> +[verse]
> +{
> +  "dev":"nmem0",
> +  "id":"cdab-0a-07e0-ffffffff",
> +  "handle":0,
> +  "phys_id":0,
> +  "security_state:":"disabled"
> +}
>
>  -H::
>  --health::
> diff --git a/ndctl/lib/dimm.c b/ndctl/lib/dimm.c
> index 5e41734d..4470d5fe 100644
> --- a/ndctl/lib/dimm.c
> +++ b/ndctl/lib/dimm.c
> @@ -583,3 +583,19 @@ NDCTL_EXPORT unsigned long ndctl_dimm_get_available_labels(
>
>         return strtoul(buf, NULL, 0);
>  }
> +
> +NDCTL_EXPORT int ndctl_dimm_get_security_state(struct ndctl_dimm *dimm,
> +               char *state)
> +{
> +       struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
> +       char *path = dimm->dimm_buf;
> +       int len = dimm->buf_len;
> +
> +       if (snprintf(path, len, "%s/security", dimm->dimm_path) >= len) {
> +               err(ctx, "%s: buffer too small!\n",
> +                               ndctl_dimm_get_devname(dimm));
> +               return -ERANGE;
> +       }
> +
> +       return sysfs_read_attr(ctx, path, state);

This should return a security state enum value instead of a string.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

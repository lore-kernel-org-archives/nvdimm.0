Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com
 [IPv6:2607:f8b0:4864:20::343])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E5716211AF9D6
 for <linux-nvdimm@lists.01.org>; Tue, 22 Jan 2019 14:24:10 -0800 (PST)
Received: by mail-ot1-x343.google.com with SMTP id a11so131661otr.10
 for <linux-nvdimm@lists.01.org>; Tue, 22 Jan 2019 14:24:10 -0800 (PST)
MIME-Version: 1.0
References: <20190122220525.5211-1-elliott@hpe.com>
In-Reply-To: <20190122220525.5211-1-elliott@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 22 Jan 2019 14:23:58 -0800
Message-ID: <CAPcyv4gm8cP1gKddNuzQ_7jVW7sgfO=eMibR12ypnZ1qqQO1ZA@mail.gmail.com>
Subject: Re: [PATCH] libnvdimm: normalize dev_debug failed and succeeded
 wording
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
To: Robert Elliott <elliott@hpe.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Looks ok, just some formatting nits...

On Tue, Jan 22, 2019 at 2:14 PM Robert Elliott <elliott@hpe.com> wrote:
>
> Make dev_dbg prints use consistent wording for failed and succeeded, and
> include the return code when reporting something failed.
>
> Signed-off-by: Robert Elliott <elliott@hpe.com>
> ---
>  drivers/nvdimm/dimm.c     |  2 +-
>  drivers/nvdimm/label.c    |  7 ++++---
>  drivers/nvdimm/security.c | 53 ++++++++++++++++++++++++++++++++++-------------
>  3 files changed, 44 insertions(+), 18 deletions(-)

This insertions > 2x deletions is concerning, some suggestions below.

>
> diff --git a/drivers/nvdimm/dimm.c b/drivers/nvdimm/dimm.c
> index 0cf58cabc9ed..3ff104f7ccaa 100644
> --- a/drivers/nvdimm/dimm.c
> +++ b/drivers/nvdimm/dimm.c
> @@ -62,7 +62,7 @@ static int nvdimm_probe(struct device *dev)
>          */
>         rc = nvdimm_security_unlock(dev);
>         if (rc < 0)
> -               dev_dbg(dev, "failed to unlock dimm: %d\n", rc);
> +               dev_dbg(dev, "unlock failed: %d\n", rc);
>
>
>         /*
> diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
> index a11bf4e6b451..235833a4881b 100644
> --- a/drivers/nvdimm/label.c
> +++ b/drivers/nvdimm/label.c
> @@ -149,7 +149,7 @@ static int __nd_label_validate(struct nvdimm_drvdata *ndd)
>                         labelsize = 128;
>
>                 if (labelsize != sizeof_namespace_label(ndd)) {
> -                       dev_dbg(dev, "nsindex%d labelsize %d invalid\n",
> +                       dev_dbg(dev, "nsindex%d labelsize: %d invalid\n",
>                                         i, nsindex[i]->labelsize);
>                         continue;
>                 }
> @@ -373,7 +373,8 @@ static bool slot_valid(struct nvdimm_drvdata *ndd,
>                 sum = nd_fletcher64(nd_label, sizeof_namespace_label(ndd), 1);
>                 nd_label->checksum = __cpu_to_le64(sum_save);
>                 if (sum != sum_save) {
> -                       dev_dbg(ndd->dev, "fail checksum. slot: %d expect: %#llx\n",
> +                       dev_dbg(ndd->dev,
> +                               "checksum failed. slot: %d expected: %#llx\n",

It's ok to keep the format string on the same line as dev_dbg(), even
if it violates 80 columns. In general it helps grep'ability if the
format string is on the same line as print call.

>                                 slot, sum);
>                         return false;
>                 }
> @@ -535,7 +536,7 @@ int nd_label_data_init(struct nvdimm_drvdata *ndd)
>                 read_size += label_read_size;
>         }
>
> -       dev_dbg(ndd->dev, "len: %zu rc: %d\n", offset, rc);
> +       dev_dbg(ndd->dev, "init config data area len: %zu succeeded\n", offset);
>  out_err:
>         return rc;
>  }
> diff --git a/drivers/nvdimm/security.c b/drivers/nvdimm/security.c
> index f8bb746a549f..b7f86846015a 100644
> --- a/drivers/nvdimm/security.c
> +++ b/drivers/nvdimm/security.c
> @@ -58,7 +58,8 @@ static struct key *nvdimm_request_key(struct nvdimm *nvdimm)
>                 if (PTR_ERR(key) == -ENOKEY)
>                         dev_dbg(dev, "request_key() found no key\n");
>                 else
> -                       dev_dbg(dev, "request_key() upcall failed\n");
> +                       dev_dbg(dev, "request_key() upcall failed: %ld\n",
> +                               PTR_ERR(key));
>                 key = NULL;
>         } else {
>                 struct encrypted_key_payload *epayload;
> @@ -107,6 +108,7 @@ static struct key *nvdimm_lookup_user_key(struct nvdimm *nvdimm,
>
>  static struct key *nvdimm_key_revalidate(struct nvdimm *nvdimm)
>  {
> +       struct device *dev = &nvdimm->dev;
>         struct key *key;
>         int rc;
>
> @@ -126,7 +128,11 @@ static struct key *nvdimm_key_revalidate(struct nvdimm *nvdimm)
>         if (rc < 0) {
>                 nvdimm_put_key(key);
>                 key = NULL;
> -       }
> +               dev_dbg(dev, "key: %d revalidation failed: %d\n",
> +                       key_serial(key), rc);
> +       } else
> +               dev_dbg(dev, "key: %d revalidation succeeded\n",
> +                       key_serial(key));

For all of these success vs fail cases I would prefer to continue to
use a ternary:

    dev_dbg(dev, "key: %d revalidation %s: %d\n",
        key_serial(key), rc == 0 ? "succeeded" : "failed", rc);

...as to not clutter the code with extra debug statements.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

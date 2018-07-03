Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x244.google.com (mail-oi0-x244.google.com
 [IPv6:2607:f8b0:4003:c06::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9FFED2033736C
 for <linux-nvdimm@lists.01.org>; Tue,  3 Jul 2018 15:16:16 -0700 (PDT)
Received: by mail-oi0-x244.google.com with SMTP id v8-v6so6933071oie.5
 for <linux-nvdimm@lists.01.org>; Tue, 03 Jul 2018 15:16:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <153057475818.38125.11899134233158940470.stgit@djiang5-desk3.ch.intel.com>
References: <153057423804.38125.15912575101400055843.stgit@djiang5-desk3.ch.intel.com>
 <153057475818.38125.11899134233158940470.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 3 Jul 2018 15:16:15 -0700
Message-ID: <CAPcyv4hdx=3eukGaXu0YB3VJ93X9oOL20wzRvQgjUgXvCi3=WA@mail.gmail.com>
Subject: Re: [PATCH 02/11] libnvdimm: create keyring to store security keys
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
Cc: David Howells <dhowells@redhat.com>, "Schofield, Alison  <alison.schofield@intel.com>, keyrings@vger.kernel.org, Kees Cook" <keescook@chromium.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jul 2, 2018 at 4:39 PM, Dave Jiang <dave.jiang@intel.com> wrote:
> Prepping the libnvdimm to support security management by adding a keyring
> in order to provide passphrase management through the kernel key management
> APIs.
>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  drivers/nvdimm/dimm.c     |   90 +++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/libnvdimm.h |    5 +++
>  2 files changed, 95 insertions(+)
>
> diff --git a/drivers/nvdimm/dimm.c b/drivers/nvdimm/dimm.c
> index 6c8fb7590838..ee0c68efa82a 100644
> --- a/drivers/nvdimm/dimm.c
> +++ b/drivers/nvdimm/dimm.c
> @@ -18,9 +18,46 @@
>  #include <linux/slab.h>
>  #include <linux/mm.h>
>  #include <linux/nd.h>
> +#include <linux/cred.h>
> +#include <keys/user-type.h>
> +#include <linux/key-type.h>
> +#include <linux/keyctl.h>
>  #include "label.h"
>  #include "nd.h"
>
> +const struct cred *nvdimm_cred;

I assume this can be marked static?

> +static int nvdimm_key_instantiate(struct key *key,
> +               struct key_preparsed_payload *prep);
> +static void nvdimm_key_destroy(struct key *key);
> +
> +struct key_type nvdimm_key_type = {
> +       .name = "nvdimm",
> +       .instantiate = nvdimm_key_instantiate,
> +       .destroy = nvdimm_key_destroy,
> +       .describe = user_describe,
> +       .def_datalen = NVDIMM_DEFAULT_PASSPHRASE_LEN * 2,

Perhaps a comment on why the "* 2"?

> +};
> +
> +static int nvdimm_key_instantiate(struct key *key,
> +               struct key_preparsed_payload *prep)
> +{
> +       char *payload;
> +
> +       payload = kzalloc(nvdimm_key_type.def_datalen, GFP_KERNEL);
> +       if (!payload)
> +               return -ENOMEM;
> +
> +       key->datalen = min(nvdimm_key_type.def_datalen, prep->datalen);
> +       memcpy(payload, prep->data, key->datalen);
> +       key->payload.data[0] = payload;
> +       return 0;
> +}
> +
> +static void nvdimm_key_destroy(struct key *key)
> +{
> +       kfree(key->payload.data[0]);
> +}
> +

The above appears to be generic infrastructure less associated with
the dimm driver and more the libnvdimm core. I think it should live in
drivers/nvdimm/dimm_devs.c.

>  static int nvdimm_probe(struct device *dev)
>  {
>         struct nvdimm_drvdata *ndd;
> @@ -129,13 +166,66 @@ static struct nd_device_driver nvdimm_driver = {
>         .type = ND_DRIVER_DIMM,
>  };
>
> +static int nvdimm_register_keyring(void)
> +{
> +       struct cred *cred;
> +       struct key *keyring;
> +       int rc;
> +
> +       rc = register_key_type(&nvdimm_key_type);
> +       if (rc < 0)
> +               return rc;
> +
> +       cred = prepare_kernel_cred(NULL);
> +       if (!cred) {
> +               rc = -ENOMEM;
> +               goto failed_cred;
> +       }
> +
> +       keyring = keyring_alloc(".nvdimm",
> +                       GLOBAL_ROOT_UID, GLOBAL_ROOT_GID, cred,
> +                       (KEY_POS_ALL & ~KEY_POS_SETATTR) |
> +                       (KEY_USR_ALL & ~KEY_USR_SETATTR),
> +                       KEY_ALLOC_NOT_IN_QUOTA, NULL, NULL);
> +       if (IS_ERR(keyring)) {
> +               rc = PTR_ERR(keyring);
> +               goto failed_keyring;
> +       }
> +
> +       set_bit(KEY_FLAG_ROOT_CAN_CLEAR, &keyring->flags);
> +       cred->thread_keyring = keyring;
> +       cred->jit_keyring = KEY_REQKEY_DEFL_THREAD_KEYRING;
> +       nvdimm_cred = cred;
> +       return 0;
> +
> + failed_cred:
> +       unregister_key_type(&nvdimm_key_type);
> + failed_keyring:
> +       put_cred(cred);
> +       return rc;
> +}
> +
> +static void nvdimm_unregister_keyring(void)
> +{
> +       key_revoke(nvdimm_cred->thread_keyring);
> +       unregister_key_type(&nvdimm_key_type);
> +       put_cred(nvdimm_cred);
> +}
> +
>  int __init nvdimm_init(void)
>  {
> +       int rc;
> +
> +       rc = nvdimm_register_keyring();
> +       if (rc < 0)
> +               return rc;
> +
>         return nd_driver_register(&nvdimm_driver);
>  }
>
>  void nvdimm_exit(void)
>  {
> +       nvdimm_unregister_keyring();
>         driver_unregister(&nvdimm_driver.drv);
>  }

Yeah, the keyring registration infrastructure looks like details that
should be moved to drivers/nvdimm/dimm_devs.c. Would need to introduce
nvdimm_devs_init() and call it from libnvdimm_init(), but at least
nvdimm_devs_exit() already exists.

>
> diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
> index 472171af7f60..a250ff2a30df 100644
> --- a/include/linux/libnvdimm.h
> +++ b/include/linux/libnvdimm.h
> @@ -155,6 +155,11 @@ static inline struct nd_blk_region_desc *to_blk_region_desc(
>
>  }
>
> +extern struct key_type nvdimm_key_type;
> +
> +#define NVDIMM_DEFAULT_PASSPHRASE_LEN          32
> +#define NVDIMM_DEFAULT_DESC_LEN                        32

Why the "_DEFAULT" designation? I.e. just shorten to
NVDIMM_PASSPHRASE_LEN and NVDIMM_KEY_DESC_LEN.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

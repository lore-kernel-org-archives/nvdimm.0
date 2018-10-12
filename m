Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com
 [IPv6:2607:f8b0:4864:20::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1C8DF2116DF8A
 for <linux-nvdimm@lists.01.org>; Fri, 12 Oct 2018 12:26:45 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id e17-v6so10710399oib.4
 for <linux-nvdimm@lists.01.org>; Fri, 12 Oct 2018 12:26:45 -0700 (PDT)
MIME-Version: 1.0
References: <153936863308.55836.2972520178944977338.stgit@djiang5-desk3.ch.intel.com>
 <153936864924.55836.10713157239316653961.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <153936864924.55836.10713157239316653961.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 12 Oct 2018 12:26:33 -0700
Message-ID: <CAPcyv4h2J58vPCfiZURcdR_haKB41nnw=iMUF-H_MOpyQ1hERw@mail.gmail.com>
Subject: Re: [PATCH 4/5] libnvdimm: remove code to pull user key when there's
 no kernel key
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

On Fri, Oct 12, 2018 at 11:24 AM Dave Jiang <dave.jiang@intel.com> wrote:
>
> Remove extraneous code that used to expect nvdimm_get_and_verify_key() to
> return NULL when there's no kernel key. We want to enforce the behavior
> that when there is no kernel key we should fail security ops.
>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  drivers/nvdimm/security.c |   35 ++++-------------------------------
>  1 file changed, 4 insertions(+), 31 deletions(-)
>
> diff --git a/drivers/nvdimm/security.c b/drivers/nvdimm/security.c
> index f9ca1575012e..7b5d7c77514d 100644
> --- a/drivers/nvdimm/security.c
> +++ b/drivers/nvdimm/security.c
> @@ -135,7 +135,6 @@ int nvdimm_security_erase(struct nvdimm *nvdimm, unsigned int keyid)
>         struct key *key;
>         struct user_key_payload *payload;
>         struct device *dev = &nvdimm->dev;
> -       bool is_userkey = false;
>
>         if (!nvdimm->security_ops)
>                 return -EOPNOTSUPP;
> @@ -161,18 +160,6 @@ int nvdimm_security_erase(struct nvdimm *nvdimm, unsigned int keyid)
>                 rc = PTR_ERR(key);
>                 goto out;
>         }
> -       if (!key) {
> -               dev_dbg(dev, "No cached key found\n");
> -               /* get old user key */
> -               key = nvdimm_lookup_user_key(dev, keyid);
> -               if (!key) {
> -                       dev_dbg(dev, "Unable to retrieve user key: %#x\n",
> -                                       keyid);
> -                       rc = -ENOKEY;
> -                       goto out;
> -               }
> -               is_userkey = true;
> -       }
>
>         down_read(&key->sem);
>         payload = key->payload.data[0];
> @@ -181,10 +168,8 @@ int nvdimm_security_erase(struct nvdimm *nvdimm, unsigned int keyid)
>         up_read(&key->sem);
>
>         /* remove key since secure erase kills the passphrase */
> -       if (!is_userkey) {
> -               key_invalidate(key);
> -               nvdimm->key = NULL;
> -       }
> +       key_invalidate(key);
> +       nvdimm->key = NULL;
>         key_put(key);
>
>   out:
> @@ -218,7 +203,6 @@ int nvdimm_security_disable(struct nvdimm *nvdimm, unsigned int keyid)
>         struct key *key;
>         struct user_key_payload *payload;
>         struct device *dev = &nvdimm->dev;
> -       bool is_userkey = false;
>
>         if (!nvdimm->security_ops)
>                 return -EOPNOTSUPP;
> @@ -233,15 +217,6 @@ int nvdimm_security_disable(struct nvdimm *nvdimm, unsigned int keyid)
>                 mutex_unlock(&nvdimm->key_mutex);
>                 return PTR_ERR(key);
>         }
> -       if (!key) {
> -               /* get old user key */
> -               key = nvdimm_lookup_user_key(dev, keyid);
> -               if (!key) {
> -                       mutex_unlock(&nvdimm->key_mutex);
> -                       return -ENOKEY;
> -               }
> -               is_userkey = true;
> -       }
>
>         down_read(&key->sem);
>         payload = key->payload.data[0];
> @@ -255,10 +230,8 @@ int nvdimm_security_disable(struct nvdimm *nvdimm, unsigned int keyid)
>         }
>
>         /* If we succeed then remove the key */
> -       if (!is_userkey) {
> -               key_invalidate(key);
> -               nvdimm->key = NULL;
> -       }
> +       key_invalidate(key);
> +       nvdimm->key = NULL;
>         key_put(key);

Looks good, perhaps just use the key_destroy() helper here?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

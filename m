Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com
 [IPv6:2607:f8b0:4864:20::542])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7A3B42097F544
 for <linux-nvdimm@lists.01.org>; Tue, 17 Jul 2018 16:53:29 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id f1-v6so1114095pgq.12
 for <linux-nvdimm@lists.01.org>; Tue, 17 Jul 2018 16:53:29 -0700 (PDT)
Date: Tue, 17 Jul 2018 16:53:27 -0700
From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH v5 05/12] keys: add call key_put_sync() to flush
 key_gc_work when doing a key_put().
Message-ID: <20180717235327.GB176997@gmail.com>
References: <153186061802.27463.14539931103401173743.stgit@djiang5-desk3.ch.intel.com>
 <153186087257.27463.13382652631526471099.stgit@djiang5-desk3.ch.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <153186087257.27463.13382652631526471099.stgit@djiang5-desk3.ch.intel.com>
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
Cc: alison.schofield@intel.com, keescook@chromium.org, linux-nvdimm@lists.01.org, dhowells@redhat.com, keyrings@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jul 17, 2018 at 01:54:32PM -0700, Dave Jiang wrote:
> Adding key_put_sync() that calls flush_work on key_gc_work to ensure the
> key we want to remove is gone.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>

Why is this needed?  Isn't key_unlink() or key_invalidate() enough?

- Eric

> ---
>  include/linux/key.h |    1 +
>  security/keys/key.c |   35 +++++++++++++++++++++++++++++------
>  2 files changed, 30 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/key.h b/include/linux/key.h
> index e58ee10f6e58..4dffbd23d4e4 100644
> --- a/include/linux/key.h
> +++ b/include/linux/key.h
> @@ -253,6 +253,7 @@ extern struct key *key_alloc(struct key_type *type,
>  extern void key_revoke(struct key *key);
>  extern void key_invalidate(struct key *key);
>  extern void key_put(struct key *key);
> +extern void key_put_sync(struct key *key);
>  
>  static inline struct key *__key_get(struct key *key)
>  {
> diff --git a/security/keys/key.c b/security/keys/key.c
> index d97c9394b5dd..b6f3ec19ab0f 100644
> --- a/security/keys/key.c
> +++ b/security/keys/key.c
> @@ -622,6 +622,19 @@ int key_reject_and_link(struct key *key,
>  }
>  EXPORT_SYMBOL(key_reject_and_link);
>  
> +static void __key_put(struct key *key, bool sync)
> +{
> +	if (key) {
> +		key_check(key);
> +
> +		if (refcount_dec_and_test(&key->usage)) {
> +			schedule_work(&key_gc_work);
> +			if (sync)
> +				flush_work(&key_gc_work);
> +		}
> +	}
> +}
> +
>  /**
>   * key_put - Discard a reference to a key.
>   * @key: The key to discard a reference from.
> @@ -632,15 +645,25 @@ EXPORT_SYMBOL(key_reject_and_link);
>   */
>  void key_put(struct key *key)
>  {
> -	if (key) {
> -		key_check(key);
> -
> -		if (refcount_dec_and_test(&key->usage))
> -			schedule_work(&key_gc_work);
> -	}
> +	__key_put(key, false);
>  }
>  EXPORT_SYMBOL(key_put);
>  
> +/**
> + * key_put - Discard a reference to a key and flush the key gc work item.
> + * @key: The key to discard a reference from.
> + *
> + * Discard a reference to a key, and when all the references are gone, we
> + * schedule the cleanup task to come and pull it out of the tree in process
> + * context at some later time. This call flushes the clean up so we are sure
> + * that the key is gone.
> + */
> +void key_put_sync(struct key *key)
> +{
> +	__key_put(key, true);
> +}
> +EXPORT_SYMBOL(key_put_sync);
> +
>  /*
>   * Find a key by its serial number.
>   */
> 
> --
> To unsubscribe from this list: send the line "unsubscribe keyrings" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

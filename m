Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com
 [IPv6:2607:f8b0:4864:20::342])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 12C8121154701
 for <linux-nvdimm@lists.01.org>; Fri, 21 Sep 2018 14:59:45 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id c12-v6so14451401otl.6
 for <linux-nvdimm@lists.01.org>; Fri, 21 Sep 2018 14:59:45 -0700 (PDT)
MIME-Version: 1.0
References: <153549632073.4089.3609134467249378610.stgit@djiang5-desk3.ch.intel.com>
 <153549646033.4089.17866270311512341456.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <153549646033.4089.17866270311512341456.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 21 Sep 2018 14:59:34 -0700
Message-ID: <CAPcyv4jO9-OrBvDNxN6hB4X6bPKnerqkdh812_LjScwe44mX2A@mail.gmail.com>
Subject: Re: [PATCH v8 04/12] keys: export lookup_user_key to external users
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
Cc: "Schofield, Alison" <alison.schofield@intel.com>, Kees Cook <keescook@chromium.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, ebiggers3@gmail.com, David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Aug 28, 2018 at 3:47 PM Dave Jiang <dave.jiang@intel.com> wrote:
>
> Export lookup_user_key() symbol in order to allow nvdimm passphrase
> update to retrieve user injected keys.
>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> Cc: David Howells <dhowells@redhat.com>
> ---
>  include/linux/key.h          |    3 +++
>  security/keys/internal.h     |    2 --
>  security/keys/process_keys.c |    1 +
>  3 files changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/key.h b/include/linux/key.h
> index e58ee10f6e58..7099985e35a9 100644
> --- a/include/linux/key.h
> +++ b/include/linux/key.h
> @@ -346,6 +346,9 @@ static inline key_serial_t key_serial(const struct key *key)
>
>  extern void key_set_timeout(struct key *, unsigned);
>
> +extern key_ref_t lookup_user_key(key_serial_t id, unsigned long flags,
> +                                key_perm_t perm);
> +
>  /*
>   * The permissions required on a key that we're looking up.
>   */
> diff --git a/security/keys/internal.h b/security/keys/internal.h
> index 9f8208dc0e55..9968b21a76dd 100644
> --- a/security/keys/internal.h
> +++ b/security/keys/internal.h
> @@ -158,8 +158,6 @@ extern struct key *request_key_and_link(struct key_type *type,
>
>  extern bool lookup_user_key_possessed(const struct key *key,
>                                       const struct key_match_data *match_data);
> -extern key_ref_t lookup_user_key(key_serial_t id, unsigned long flags,
> -                                key_perm_t perm);
>  #define KEY_LOOKUP_CREATE      0x01
>  #define KEY_LOOKUP_PARTIAL     0x02
>  #define KEY_LOOKUP_FOR_UNLINK  0x04
> diff --git a/security/keys/process_keys.c b/security/keys/process_keys.c
> index d5b25e535d3a..ec4fd4531224 100644
> --- a/security/keys/process_keys.c
> +++ b/security/keys/process_keys.c
> @@ -755,6 +755,7 @@ key_ref_t lookup_user_key(key_serial_t id, unsigned long lflags,
>         put_cred(ctx.cred);
>         goto try_again;
>  }
> +EXPORT_SYMBOL(lookup_user_key);

This looks like a core api for affecting keyctl api internals, should
it be EXPORT_SYMBOL_GPL?

At a minimum this needs David's ack.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

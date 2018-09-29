Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com
 [IPv6:2607:f8b0:4864:20::342])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5030E2115C09D
 for <linux-nvdimm@lists.01.org>; Fri, 28 Sep 2018 17:41:16 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id o13-v6so7752886otl.4
 for <linux-nvdimm@lists.01.org>; Fri, 28 Sep 2018 17:41:16 -0700 (PDT)
MIME-Version: 1.0
References: <153817140052.17152.8594371908103118425.stgit@djiang5-desk3.ch.intel.com>
 <153817162922.17152.3222889638018212575.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <153817162922.17152.3222889638018212575.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 28 Sep 2018 17:41:04 -0700
Message-ID: <CAPcyv4irD-d=U9Y9hvyqg-6=8ST8dPnK1apviuOJ5bt2oX-Oew@mail.gmail.com>
Subject: Re: [PATCH v11 04/12] nfit/libnvdimm: add unlock of nvdimm support
 for Intel DIMMs
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
Cc: "Schofield, Alison" <alison.schofield@intel.com>, Kees Cook <keescook@chromium.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Eric Biggers <ebiggers3@gmail.com>, David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Sep 28, 2018 at 2:54 PM Dave Jiang <dave.jiang@intel.com> wrote:
>
> Add support to allow query the security status of the Intel nvdimms and
> also unlock the dimm via the kernel key management APIs. The passphrase is
> expected to be pulled from userspace through keyutils. Moving the Intel
> related bits to its own source file as well.
>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
[..]
> diff --git a/drivers/nvdimm/dimm.c b/drivers/nvdimm/dimm.c
> index 6c8fb7590838..b6381ddbd6c1 100644
> --- a/drivers/nvdimm/dimm.c
> +++ b/drivers/nvdimm/dimm.c
[..]
> @@ -25,6 +28,119 @@
>
>  static DEFINE_IDA(dimm_ida);
>
> +/*
> + * Find key that's cached with nvdimm
> + */
> +static struct key *nvdimm_get_key(struct device *dev)
> +{
> +       struct nvdimm *nvdimm = to_nvdimm(dev);
> +
> +       if (!nvdimm->key)
> +               return NULL;
> +
> +       if (key_validate(nvdimm->key) < 0)
> +               return NULL;
> +
> +       key_get(nvdimm->key);

I look at this and the double key_put() in nvdimm_release() and wonder
if this can be simplified by making the rule be that nvdimm->key, if
it is not NULL, is a valid key and the final put is done by
nvdimm_release(). Whenever the key becomes invalid that operation also
marks nvdimm->key NULL. This does mean we need some extra locking. but
we likely need that anyway because what's to stop the key going
invalid immediately after the key_validate() check above?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

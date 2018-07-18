Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com
 [IPv6:2607:f8b0:4864:20::543])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id ECA7120988747
 for <linux-nvdimm@lists.01.org>; Tue, 17 Jul 2018 17:00:53 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id f1-v6so1120970pgq.12
 for <linux-nvdimm@lists.01.org>; Tue, 17 Jul 2018 17:00:53 -0700 (PDT)
Date: Tue, 17 Jul 2018 17:00:50 -0700
From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH v5 04/12] nfit/libnvdimm: add unlock of nvdimm support
 for Intel DIMMs
Message-ID: <20180718000050.GD176997@gmail.com>
References: <153186061802.27463.14539931103401173743.stgit@djiang5-desk3.ch.intel.com>
 <153186086679.27463.8719157064779944587.stgit@djiang5-desk3.ch.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <153186086679.27463.8719157064779944587.stgit@djiang5-desk3.ch.intel.com>
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

Again, just a couple superficial comments:

On Tue, Jul 17, 2018 at 01:54:26PM -0700, Dave Jiang wrote:
> Add support to allow query the security status of the Intel nvdimms and
> also unlock the dimm via the kernel key management APIs. The passphrase is
> expected to be pulled from userspace through keyutils. Moving the Intel
> related bits to its own source file as well.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/acpi/nfit/Makefile |    1 
>  drivers/acpi/nfit/core.c   |    3 +
>  drivers/acpi/nfit/intel.c  |  151 ++++++++++++++++++++++++++++++++++++++++++++
>  drivers/acpi/nfit/intel.h  |   16 +++++
>  drivers/nvdimm/dimm.c      |    7 ++
>  drivers/nvdimm/dimm_devs.c |  108 +++++++++++++++++++++++++++++++
>  drivers/nvdimm/nd-core.h   |    2 +
>  drivers/nvdimm/nd.h        |    2 +
>  include/linux/libnvdimm.h  |   23 ++++++-
>  9 files changed, 310 insertions(+), 3 deletions(-)
>  create mode 100644 drivers/acpi/nfit/intel.c
[...]
> +
> +struct nvdimm_security_ops intel_security_ops = {
> +	.state = intel_dimm_security_state,
> +	.unlock = intel_dimm_security_unlock,
> +};

nvdimm_security_ops should be marked 'const'.

> +/*
> + * Find key in kernel keyring
> + */
> +static struct key *nvdimm_search_key(struct device *dev)
> +{
> +	struct nvdimm *nvdimm = to_nvdimm(dev);
> +	char *desc;
> +	key_ref_t keyref;
> +	struct key *key = NULL;
> +
> +	if (!nvdimm->security_ops)
> +		return NULL;
> +
> +	desc = kzalloc(NVDIMM_KEY_DESC_LEN, GFP_KERNEL);
> +	if (!desc)
> +		return NULL;
> +
> +	keyref = keyring_search(make_key_ref(nvdimm_cred->thread_keyring, 1),
> +			&nvdimm_key_type, nvdimm->dimm_id);
> +	if (IS_ERR(keyref))
> +		key = NULL;
> +	else
> +		key = key_ref_to_ptr(keyref);
> +
> +	kfree(desc);
> +	return key;
> +}

'desc' is allocated and never used.

And with that removed, NVDIMM_KEY_DESC_LEN isn't actually used either.

- Eric
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

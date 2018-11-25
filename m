Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com
 [IPv6:2607:f8b0:4864:20::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 89BF921B02822
 for <linux-nvdimm@lists.01.org>; Sun, 25 Nov 2018 13:24:39 -0800 (PST)
Received: by mail-oi1-x243.google.com with SMTP id u18so14037010oie.10
 for <linux-nvdimm@lists.01.org>; Sun, 25 Nov 2018 13:24:39 -0800 (PST)
MIME-Version: 1.0
References: <154180093865.70506.6858789591063128903.stgit@djiang5-desk3.ch.intel.com>
 <154180167436.70506.13449520468879463615.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <154180167436.70506.13449520468879463615.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 25 Nov 2018 13:24:27 -0800
Message-ID: <CAPcyv4ipo39Hvjfo3OvnBNMsOOsfiOmHbc-RBQM+Dor6a+B6gw@mail.gmail.com>
Subject: Re: [PATCH 09/11] acpi/nfit, libnvdimm/security: add Intel DSM 1.8
 master passphrase support
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
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Nov 9, 2018 at 2:14 PM Dave Jiang <dave.jiang@intel.com> wrote:
>
> With Intel DSM 1.8 [1] two new security DSMs are introduced. Enable/update
> master passphrase and master secure erase. The master passphrase allows
> a secure erase to be performed without the user passphrase that is set on
> the NVDIMM. The commands of master_update and master_erase are added to
> the sysfs knob in order to initiate the DSMs. They are similar in opeartion
> mechanism compare to update and erase.
>
> [1]: http://pmem.io/documents/NVDIMM_DSM_Interface-V1.8.pdf
>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  Documentation/nvdimm/security.txt |   23 ++++++
>  drivers/acpi/nfit/core.c          |    2 +
>  drivers/acpi/nfit/intel.c         |  132 ++++++++++++++++++++++++++++++++++++-
>  drivers/acpi/nfit/intel.h         |   18 +++++
>  drivers/acpi/nfit/nfit.h          |    6 +-
>  drivers/nvdimm/dimm_devs.c        |   16 ++++
>  drivers/nvdimm/nd-core.h          |    1
>  drivers/nvdimm/nd.h               |    5 +
>  drivers/nvdimm/security.c         |   34 ++++++++--
>  include/linux/libnvdimm.h         |   15 ++++
>  10 files changed, 236 insertions(+), 16 deletions(-)
>
[..]
>  static int intel_dimm_security_query_overwrite(struct nvdimm *nvdimm)
>  {
>         int cmd_rc, rc = 0;
> @@ -397,7 +514,8 @@ static int intel_dimm_security_unlock(struct nvdimm *nvdimm,
>  }
>
>  static int intel_dimm_security_state(struct nvdimm *nvdimm,
> -               enum nvdimm_security_state *state)
> +               enum nvdimm_security_state *state,
> +               enum nvdimm_security_extended_state *ext_state)

Rather than require 2 state pointers to be passed in, just have a
single state a flags parameter to indicate which state is being
retrieved.

>  {
>         int cmd_rc, rc = 0;
>         struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
> @@ -465,9 +583,17 @@ static int intel_dimm_security_state(struct nvdimm *nvdimm,
[..]
> diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
> index c3c5a1c6b1b7..3d14f73c7bca 100644
> --- a/include/linux/libnvdimm.h
> +++ b/include/linux/libnvdimm.h
> @@ -167,6 +167,13 @@ enum nvdimm_security_state {
>         NVDIMM_SECURITY_UNSUPPORTED,
>  };
>
> +enum nvdimm_security_extended_state {
> +       NVDIMM_SECURITY_MASTER_INVALID = 0,
> +       NVDIMM_SECURITY_MASTER_DISABLED,
> +       NVDIMM_SECURITY_MASTER_ENABLED,
> +       NVDIMM_SECURITY_MASTER_FROZEN,
> +};

I don't see a need for nvdimm_security_extended_state. Just have 2
instances of nvdimm_security_state one for master and one for the base
state.

>  struct nvdimm_security_ops {
>         int (*state)(struct nvdimm *nvdimm,
> -                       enum nvdimm_security_state *state);
> +                       enum nvdimm_security_state *state,
> +                       enum nvdimm_security_extended_state *ex_state);
>         int (*unlock)(struct nvdimm *nvdimm,
>                         const struct nvdimm_key_data *nkey);
>         int (*change_key)(struct nvdimm *nvdimm,
> @@ -190,6 +198,11 @@ struct nvdimm_security_ops {
>         int (*overwrite)(struct nvdimm *nvdimm,
>                         const struct nvdimm_key_data *nkey);
>         int (*query_overwrite)(struct nvdimm *nvdimm);
> +       int (*master_change_key)(struct nvdimm *nvdimm,
> +                       const struct nvdimm_key_data *old_key,
> +                       const struct nvdimm_key_data *new_key);
> +       int (*master_erase)(struct nvdimm *nvdimm,
> +                       const struct nvdimm_key_data *nkey);

Let's not add more operations for what is effectively a modified
version of the existing ops, just pass a 'flags' parameter to those
other ops.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

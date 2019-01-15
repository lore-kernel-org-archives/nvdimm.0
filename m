Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com
 [IPv6:2607:f8b0:4864:20::343])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 737EE211B5A43
 for <linux-nvdimm@lists.01.org>; Tue, 15 Jan 2019 10:30:50 -0800 (PST)
Received: by mail-ot1-x343.google.com with SMTP id f18so3388403otl.11
 for <linux-nvdimm@lists.01.org>; Tue, 15 Jan 2019 10:30:50 -0800 (PST)
MIME-Version: 1.0
References: <154757678148.35482.4492154450935271566.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <154757678148.35482.4492154450935271566.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 15 Jan 2019 10:30:38 -0800
Message-ID: <CAPcyv4hETYMqsuMjUd_LyHNd2w5R4Chftp_E-81gOKMfOj_OKg@mail.gmail.com>
Subject: Re: [PATCH] libnvdimm/security: fix nvdimm_security_state() state
 request selection
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

On Tue, Jan 15, 2019 at 10:26 AM Dave Jiang <dave.jiang@intel.com> wrote:
>
> The input parameter should be enum nvdimm_passphrase_type instead of bool
> for selection of master/user for selection of extended master passphrase
> state or the regular user passphrase state.
>
> Fixes: 89fa9d8ea7bdf ("acpi/nfit, libnvdimm/security: add Intel DSM 1.8 master passphrase support")
>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  drivers/nvdimm/nd-core.h |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/nvdimm/nd-core.h b/drivers/nvdimm/nd-core.h
> index 2b2cf4e554d3..e5ffd5733540 100644
> --- a/drivers/nvdimm/nd-core.h
> +++ b/drivers/nvdimm/nd-core.h
> @@ -54,12 +54,12 @@ struct nvdimm {
>  };
>
>  static inline enum nvdimm_security_state nvdimm_security_state(
> -               struct nvdimm *nvdimm, bool master)
> +               struct nvdimm *nvdimm, enum nvdimm_passphrase_type ptype)
>  {
>         if (!nvdimm->sec.ops)
>                 return -ENXIO;
>
> -       return nvdimm->sec.ops->state(nvdimm, master);
> +       return nvdimm->sec.ops->state(nvdimm, ptype);
>  }

Ok, applied.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

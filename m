Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com
 [IPv6:2607:f8b0:4864:20::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9D78F2116DF96
 for <linux-nvdimm@lists.01.org>; Fri, 12 Oct 2018 12:28:48 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id v69-v6so10722683oif.1
 for <linux-nvdimm@lists.01.org>; Fri, 12 Oct 2018 12:28:48 -0700 (PDT)
MIME-Version: 1.0
References: <153936863308.55836.2972520178944977338.stgit@djiang5-desk3.ch.intel.com>
 <153936865468.55836.4349279559484495728.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <153936865468.55836.4349279559484495728.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 12 Oct 2018 12:28:36 -0700
Message-ID: <CAPcyv4gg7O1AiAhNrsOXQQynGnEZedJxP7BaELbTONQQhhK62A@mail.gmail.com>
Subject: Re: [PATCH 5/5] libnvdimm: address state where dimm is unlocked in
 preOS
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
> When the nvdimm security state is unlocked during unlock, we skip the
> operation. In this state, we are not able to fetch a key for verification
> and at the same time the dimm is unlocked. This prevents us from doing
> any security operations. We will send the freeze security DSM to make the
> state consistent.
>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  drivers/nvdimm/security.c |   15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/nvdimm/security.c b/drivers/nvdimm/security.c
> index 7b5d7c77514d..6c5423228b31 100644
> --- a/drivers/nvdimm/security.c
> +++ b/drivers/nvdimm/security.c
> @@ -250,8 +250,19 @@ int nvdimm_security_unlock_dimm(struct nvdimm *nvdimm)
>         if (!nvdimm->security_ops)
>                 return 0;
>
> -       if (nvdimm->state == NVDIMM_SECURITY_UNLOCKED ||
> -                       nvdimm->state == NVDIMM_SECURITY_UNSUPPORTED ||
> +       /*
> +        * If the pre-OS has unlocked the DIMM, we will not be able to
> +        * verify the key against the hardware. Therefore we will not
> +        * retrieve the key and will freeze the security config. This will
> +        * prevent any other security operations.
> +        */

I think we should try to retrieve the key if the DIMM is unlocked and
verify it with a 'change-key-to-self' check. If either of those steps
fail then freeze the dimm.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

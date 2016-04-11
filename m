Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ob0-x231.google.com (mail-ob0-x231.google.com
 [IPv6:2607:f8b0:4003:c01::231])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C9A511A221D
 for <linux-nvdimm@lists.01.org>; Mon, 11 Apr 2016 11:25:05 -0700 (PDT)
Received: by mail-ob0-x231.google.com with SMTP id bg3so116106646obb.1
 for <linux-nvdimm@lists.01.org>; Mon, 11 Apr 2016 11:25:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <bf6777e246a73f3c3ee4f079a29ac25983e830e2.1458583367.git.jerry.hoemann@hpe.com>
References: <cover.1458583367.git.jerry.hoemann@hpe.com>
 <bf6777e246a73f3c3ee4f079a29ac25983e830e2.1458583367.git.jerry.hoemann@hpe.com>
Date: Mon, 11 Apr 2016 11:25:04 -0700
Message-ID: <CAPcyv4gtcA64LNMOh8Rv8rpUdF-CJeyu-69kDub-tJCEK2CwLQ@mail.gmail.com>
Subject: Re: [PATCH v8 04/10] nvdimm: Add UUIDs
From: Dan Williams <dan.j.williams@intel.com>
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
To: Jerry Hoemann <jerry.hoemann@hpe.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Mar 21, 2016 at 12:37 PM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
> Add UUID associated with HPE Type N NVDIMM.
>
> Signed-off-by: Jerry Hoemann <jerry.hoemann@hpe.com>
> ---
>  drivers/acpi/nfit.h | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/drivers/acpi/nfit.h b/drivers/acpi/nfit.h
> index c75576b..10dd0d3 100644
> --- a/drivers/acpi/nfit.h
> +++ b/drivers/acpi/nfit.h
> @@ -23,6 +23,8 @@
>
>  #define UUID_NFIT_BUS "2f10e7a4-9e91-11e4-89d3-123b93f75cba"
>  #define UUID_NFIT_DIMM "4309ac30-0d11-11e4-9191-0800200c9a66"
> +#define UUID_NFIT_DIMM_N_HPE1 "9002c334-acf3-4c0e-9642-a235f0d53bc6"
> +#define UUID_NFIT_DIMM_N_HPE2 "5008664B-B758-41A0-A03C-27C2F2D04F7E"

I'll lowercase this definition when applying the patch.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

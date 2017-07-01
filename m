Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-yw0-x22e.google.com (mail-yw0-x22e.google.com
 [IPv6:2607:f8b0:4002:c05::22e])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 062E721BADADB
 for <linux-nvdimm@lists.01.org>; Fri, 30 Jun 2017 20:48:17 -0700 (PDT)
Received: by mail-yw0-x22e.google.com with SMTP id j11so55750633ywa.2
 for <linux-nvdimm@lists.01.org>; Fri, 30 Jun 2017 20:49:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <660571c18986eb8c7025d4b68c0be5f7df48e569.1498810220.git.jerry.hoemann@hpe.com>
References: <cover.1498810220.git.jerry.hoemann@hpe.com>
 <660571c18986eb8c7025d4b68c0be5f7df48e569.1498810220.git.jerry.hoemann@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 30 Jun 2017 20:49:50 -0700
Message-ID: <CAPcyv4iR4T_umcF3H2aEGidmFMLUg4KSLmqMyoYvkOpbzn_YDQ@mail.gmail.com>
Subject: Re: [PATCH v4 6/6] nfit allow override of root dsm mask
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
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jun 30, 2017 at 9:09 AM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
> Have module parameter override_dsm_mask override the dsm_mask for
> root calls like it does for non-root dsm calls.
>
> Signed-off-by: Jerry Hoemann <jerry.hoemann@hpe.com>
> ---
>  drivers/acpi/nfit/core.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
> index 4e24d69..87acaf2 100644
> --- a/drivers/acpi/nfit/core.c
> +++ b/drivers/acpi/nfit/core.c
> @@ -1641,6 +1641,8 @@ static void acpi_nfit_init_dsms(struct acpi_nfit_desc *acpi_desc)
>         set_bit(ND_CMD_CALL, &nd_desc->cmd_mask);
>
>         dsm_mask = 0x3bf;
> +       if (override_dsm_mask)
> +               dsm_mask = override_dsm_mask;
>         for_each_set_bit(i, &dsm_mask, BITS_PER_LONG)
>                 if (acpi_check_dsm(adev->handle, uuid, 1, 1ULL << i))
>                         set_bit(i, &nd_desc->bus_dsm_mask);

Another reason not to apply this is to take a look at what happened
with the introduction of _LSI, _LSR, and _LSW. We should not expect
that _DSM will keep being used for future NVDIMM root bus methods.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

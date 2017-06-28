Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-yb0-x232.google.com (mail-yb0-x232.google.com
 [IPv6:2607:f8b0:4002:c09::232])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id ED7C721CB74AF
 for <linux-nvdimm@lists.01.org>; Wed, 28 Jun 2017 14:07:54 -0700 (PDT)
Received: by mail-yb0-x232.google.com with SMTP id s9so22997263ybe.3
 for <linux-nvdimm@lists.01.org>; Wed, 28 Jun 2017 14:09:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <d597b2ce2d394d9cae199d1b8209fbe66314c753.1497939166.git.jerry.hoemann@hpe.com>
References: <cover.1497939166.git.jerry.hoemann@hpe.com>
 <d597b2ce2d394d9cae199d1b8209fbe66314c753.1497939166.git.jerry.hoemann@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 28 Jun 2017 14:09:25 -0700
Message-ID: <CAPcyv4jLs8ogu2_=RFecgeFKO3prrF0SPhKm+rh5j2XKY+GhFQ@mail.gmail.com>
Subject: Re: [PATCH v2 4/7] acpi, nfit: Use bus_dsm_mask for passthru
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

On Tue, Jun 20, 2017 at 9:51 AM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
> Populate bus_dsm_mask and use it to filter dsm calls that user can
> make through the pass thru interface.
>
> Signed-off-by: Jerry Hoemann <jerry.hoemann@hpe.com>
> ---
>  drivers/acpi/nfit/core.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
> index b46fca2..9d281a4 100644
> --- a/drivers/acpi/nfit/core.c
> +++ b/drivers/acpi/nfit/core.c
> @@ -253,6 +253,7 @@ int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc, struct nvdimm *nvdimm,
>                 cmd_name = nvdimm_bus_cmd_name(cmd);
>                 cmd_mask = nd_desc->cmd_mask;
>                 dsm_mask = cmd_mask;
> +               if (cmd == ND_CMD_CALL) dsm_mask = nd_desc->bus_dsm_mask;

Checkpatch complains about this:

ERROR: trailing statements should be on next line
#118: FILE: drivers/acpi/nfit/core.c:256:
+ if (cmd == ND_CMD_CALL) dsm_mask = nd_desc->bus_dsm_mask;
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

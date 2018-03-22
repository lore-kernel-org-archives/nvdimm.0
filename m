Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x243.google.com (mail-oi0-x243.google.com
 [IPv6:2607:f8b0:4003:c06::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0F48E22551B9D
 for <linux-nvdimm@lists.01.org>; Thu, 22 Mar 2018 11:21:53 -0700 (PDT)
Received: by mail-oi0-x243.google.com with SMTP id e123-v6so5984126oih.13
 for <linux-nvdimm@lists.01.org>; Thu, 22 Mar 2018 11:28:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <152174316397.12504.9225022827981437244.stgit@djiang5-desk3.ch.intel.com>
References: <152174316397.12504.9225022827981437244.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 22 Mar 2018 11:28:25 -0700
Message-ID: <CAPcyv4jBZVQ22f5o-exWLTTkj6iefVTuwijtZK0QptCP02xnYQ@mail.gmail.com>
Subject: Re: [PATCH] ndctl: fix input/output size for Intel firmware update DSM
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

On Thu, Mar 22, 2018 at 11:26 AM, Dave Jiang <dave.jiang@intel.com> wrote:
> The FW_START DSM should have input/out of 0/8, the code incorrectly
> is passing in 4/4. This is causing failure with newer BIOS that check
> the input/output parameters more strictly.
>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  ndctl/lib/intel.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/ndctl/lib/intel.c b/ndctl/lib/intel.c
> index 3c4509e4..ba210e1c 100644
> --- a/ndctl/lib/intel.c
> +++ b/ndctl/lib/intel.c
> @@ -449,8 +449,8 @@ static struct ndctl_cmd *intel_dimm_cmd_new_fw_start(struct ndctl_dimm *dimm)
>
>         BUILD_ASSERT(sizeof(struct nd_intel_fw_start) == 8);
>
> -       cmd = alloc_intel_cmd(dimm, ND_INTEL_FW_START_UPDATE,
> -                       sizeof(cmd->intel->start) - 4, 4);
> +       cmd = alloc_intel_cmd(dimm, ND_INTEL_FW_START_UPDATE, 0,
> +                       sizeof(cmd->intel->start));

Looks good, applied.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

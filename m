Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x244.google.com (mail-oi0-x244.google.com
 [IPv6:2607:f8b0:4003:c06::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5BC0C20971757
 for <linux-nvdimm@lists.01.org>; Wed, 11 Jul 2018 14:38:15 -0700 (PDT)
Received: by mail-oi0-x244.google.com with SMTP id k81-v6so51987759oib.4
 for <linux-nvdimm@lists.01.org>; Wed, 11 Jul 2018 14:38:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180711211709.3007-1-vishal.l.verma@intel.com>
References: <20180711211709.3007-1-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 11 Jul 2018 14:38:13 -0700
Message-ID: <CAPcyv4hbe2rxPELdB2AmcfwcrzWSmdXDtW-tpn+dHKH7nmptHQ@mail.gmail.com>
Subject: Re: [ndctl PATCH] ndctl: add an API to check support for smart
 injection
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
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jul 11, 2018 at 2:17 PM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> Add an API to check whether smart injection is supported, and add an
> intel-dsm implementation for it. Use this check in the ndctl
> inject-smart command.
>
> Reported-by: Leszek Lugin <leszek.lugin@intel.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
[..]
> +static int intel_dimm_smart_inject_supported(struct ndctl_dimm *dimm)
> +{
> +       struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
> +
> +       if (!ndctl_dimm_is_cmd_supported(dimm, ND_CMD_CALL)) {
> +               dbg(ctx, "unsupported cmd: %d\n", ND_CMD_CALL);
> +               return -EOPNOTSUPP;
> +       }
> +
> +       if (test_dimm_dsm(dimm, ND_INTEL_SMART_INJECT_MTEMP) ==
> +                       DIMM_DSM_UNSUPPORTED ||
> +                       test_dimm_dsm(dimm, ND_INTEL_SMART_INJECT_SPARE) ==
> +                       DIMM_DSM_UNSUPPORTED ||
> +                       test_dimm_dsm(dimm, ND_INTEL_SMART_INJECT_FATAL) ==
> +                       DIMM_DSM_UNSUPPORTED ||
> +                       test_dimm_dsm(dimm, ND_INTEL_SMART_INJECT_SHUTDOWN) ==
> +                       DIMM_DSM_UNSUPPORTED) {
> +               dbg(ctx, "smart injection functions unsupported\n");
> +               return -EIO;

Just a nit on readability. I find it jarring to split the arguments to
"== "on 2 different lines, especially after Neil Brown made a similar
observation on my code. The natural read cadence is to grok the "=="
statement and then move to the next operator on the following line.
Also, we've thankfully defined DIMM_DSM_UNSUPPORTED as zero, so it
would be more readable to drop == and do the following with the ||
operators:

        if (!test_dimm_dsm(dimm, ND_INTEL_SMART_INJECT_MTEMP)
                        || !test_dimm_dsm(dimm, ND_INTEL_SMART_INJECT_SPARE)
                        || !test_dimm_dsm(dimm, ND_INTEL_SMART_INJECT_FATAL)
                        || !test_dimm_dsm(dimm,
ND_INTEL_SMART_INJECT_SHUTDOWN)) {
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

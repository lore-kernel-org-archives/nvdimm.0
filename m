Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com
 [IPv6:2607:f8b0:4864:20::342])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3DC942194D3AE
 for <linux-nvdimm@lists.01.org>; Fri, 11 Jan 2019 16:20:11 -0800 (PST)
Received: by mail-ot1-x342.google.com with SMTP id k98so14722816otk.3
 for <linux-nvdimm@lists.01.org>; Fri, 11 Jan 2019 16:20:11 -0800 (PST)
MIME-Version: 1.0
References: <20190111225339.6939-1-vishal.l.verma@intel.com>
 <20190111225339.6939-2-vishal.l.verma@intel.com>
In-Reply-To: <20190111225339.6939-2-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 11 Jan 2019 16:19:59 -0800
Message-ID: <CAPcyv4gjeu-Zd8PGC=yKyxjqF62_Pic9Df1ayGeShwexbiKNQQ@mail.gmail.com>
Subject: Re: [ndctl PATCH 1/3] libndctl, intel: Add infrastructure for
 firmware_status translation
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
Cc: Ami Pathak <ami.g.pathak@intel.com>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jan 11, 2019 at 2:53 PM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> Add a new routine to ndctl_dimm_ops that allows a DSM family to provide
> a translation routine that will translate the status codes of the result
> of a DSM to generic errno style error codes. To use this routine
> effectively, add a new wrapper around ndctl_cmd_submit (called
> ndctl_cmd_submit_xlat) that submits the command, and also runs it
> through the above translator dimm_op (if one is is defined).
>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
[..]
> +NDCTL_EXPORT int ndctl_cmd_submit_xlat(struct ndctl_cmd *cmd)
> +{
> +       int rc;
> +
> +       rc = ndctl_cmd_submit(cmd);
> +       if (rc < 0)
> +               return rc;
> +
> +       /*
> +        * NOTE: This loses a positive rc which happens in the case of a
> +        * buffer underrun. If the caller cares about that (usually not very
> +        * useful), then the xlat function is available separately as well.
> +        */

Hmm, yes not very useful in general but if
ndctl_cmd_xlat_firmware_status() returns 0, why not preserve the
positive value if available? Just to keep the 2 interfaces more
closely aligned.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

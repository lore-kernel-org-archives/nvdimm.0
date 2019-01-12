Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com
 [IPv6:2607:f8b0:4864:20::333])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F0CE0211A7565
 for <linux-nvdimm@lists.01.org>; Fri, 11 Jan 2019 17:53:18 -0800 (PST)
Received: by mail-ot1-x333.google.com with SMTP id n8so14841674otl.6
 for <linux-nvdimm@lists.01.org>; Fri, 11 Jan 2019 17:53:18 -0800 (PST)
MIME-Version: 1.0
References: <20190112013035.32087-1-vishal.l.verma@intel.com>
 <20190112013035.32087-2-vishal.l.verma@intel.com>
In-Reply-To: <20190112013035.32087-2-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 11 Jan 2019 17:53:06 -0800
Message-ID: <CAPcyv4hnFp+9edGpF6qo-ickBfTHHxH+nQc8qohUKOffyVCwEw@mail.gmail.com>
Subject: Re: [ndctl PATCH v2 1/4] libndctl, intel: Add infrastructure for
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

On Fri, Jan 11, 2019 at 5:31 PM Vishal Verma <vishal.l.verma@intel.com> wrote:
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

Looks good,

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com
 [IPv6:2607:f8b0:4864:20::329])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4A460211C64BD
 for <linux-nvdimm@lists.01.org>; Fri,  1 Feb 2019 17:59:46 -0800 (PST)
Received: by mail-ot1-x329.google.com with SMTP id 81so7766315otj.2
 for <linux-nvdimm@lists.01.org>; Fri, 01 Feb 2019 17:59:46 -0800 (PST)
MIME-Version: 1.0
References: <20190202015253.20051-1-vishal.l.verma@intel.com>
 <20190202015253.20051-3-vishal.l.verma@intel.com>
In-Reply-To: <20190202015253.20051-3-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 1 Feb 2019 17:59:35 -0800
Message-ID: <CAPcyv4hT9x-pnsowyBB93Pn853QRUA02EaZaa+s35g7QuCGfmg@mail.gmail.com>
Subject: Re: [ndctl PATCH 3/4] libndctl: fix a couple of theoretical buffer
 overruns
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

On Fri, Feb 1, 2019 at 5:53 PM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> Static analysis reports that the ndctl_dimm_get_security() function can
> overflow 'buf'. Just above it, ndctl_dimm_get_available_labels() seems
> to make the same mistake. Fix both of these by allocating a buffer of
> the correct size.
>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Looks good,

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

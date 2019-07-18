Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com
 [IPv6:2607:f8b0:4864:20::344])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 88B8B212C01DB
 for <linux-nvdimm@lists.01.org>; Wed, 17 Jul 2019 18:35:13 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id o101so27206537ota.8
 for <linux-nvdimm@lists.01.org>; Wed, 17 Jul 2019 18:32:45 -0700 (PDT)
MIME-Version: 1.0
References: <20190717225400.9494-1-vishal.l.verma@intel.com>
 <20190717225400.9494-2-vishal.l.verma@intel.com>
In-Reply-To: <20190717225400.9494-2-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 17 Jul 2019 18:32:32 -0700
Message-ID: <CAPcyv4h333C36=G4F_yGwPi1mpvzH3rtwO15iffkWBr2yMNjVg@mail.gmail.com>
Subject: Re: [ndctl PATCH v6 01/13] libdaxctl: add interfaces to get ctx and
 check device state
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
Cc: Dave Hansen <dave.hansen@linux.intel.com>, Pavel Tatashin <pasha.tatashin@soleen.com>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jul 17, 2019 at 3:54 PM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> In preparation for libdaxctl and daxctl to grow operational modes for
> DAX devices, add the following supporting APIs:
>
>   daxctl_dev_get_ctx
>   daxctl_dev_is_enabled
>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Looks good,

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com
 [IPv6:2607:f8b0:4864:20::343])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6888D212D277B
 for <linux-nvdimm@lists.01.org>; Thu, 25 Jul 2019 19:58:01 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id j19so15430158otq.2
 for <linux-nvdimm@lists.01.org>; Thu, 25 Jul 2019 19:55:34 -0700 (PDT)
MIME-Version: 1.0
References: <20190724215741.18556-1-vishal.l.verma@intel.com>
 <20190724215741.18556-12-vishal.l.verma@intel.com>
In-Reply-To: <20190724215741.18556-12-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 25 Jul 2019 19:55:23 -0700
Message-ID: <CAPcyv4g82poaqSNZh+Q_QpdWVqjmz3C=BM74Guoe_Wj7bv6kwQ@mail.gmail.com>
Subject: Re: [ndctl PATCH v7 11/13] contrib/ndctl: fix region-id completions
 for daxctl
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

On Wed, Jul 24, 2019 at 2:58 PM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> The completion helpers for daxctl assumed the region arguments for
> specifying daxctl regions were the same as ndctl regions, i.e.
> "regionX". This is not true - daxctl region arguments are a simple
> numeric 'id'.

Oh, that's an unfortunate difference, but too late to change now I
think, good find.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

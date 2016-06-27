Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x233.google.com (mail-oi0-x233.google.com
 [IPv6:2607:f8b0:4003:c06::233])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 65DCA1A1E01
 for <linux-nvdimm@lists.01.org>; Mon, 27 Jun 2016 14:14:10 -0700 (PDT)
Received: by mail-oi0-x233.google.com with SMTP id r2so218171185oih.2
 for <linux-nvdimm@lists.01.org>; Mon, 27 Jun 2016 14:13:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1467060218-20256-1-git-send-email-vishal.l.verma@intel.com>
References: <1467060218-20256-1-git-send-email-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 27 Jun 2016 14:13:34 -0700
Message-ID: <CAPcyv4jpikCiOGyhoZZ70cWr9BAZibriGtNPJbQ1BeedXjJM2g@mail.gmail.com>
Subject: Re: [ndctl PATCH] ndctl: make completion smarter wrt mode/type/idle
 options
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
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jun 27, 2016 at 1:43 PM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> Add three new 'filters' for mode, type, and idle.
>
> 'mode' and 'type' work with each other to prevent a blk namespace from
> showing modes like 'dax' or 'memory', or if those modes are specified,
> then limiting 'type' to 'pmem'.
>
> Also show completions for --map= only if mode is 'memory'.

--map= is also valid when the mode is 'dax'.

There's also an assumption in the --reconfig= case for
'create-namespace' that parameters are inherited from the target
namespace.  For example, it might be surprising that completions are
not provided for --map= when the mode is implied by the provided
namespace.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

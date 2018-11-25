Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com
 [IPv6:2607:f8b0:4864:20::344])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 13AF721A07A92
 for <linux-nvdimm@lists.01.org>; Sun, 25 Nov 2018 12:14:35 -0800 (PST)
Received: by mail-ot1-x344.google.com with SMTP id t5so14787252otk.1
 for <linux-nvdimm@lists.01.org>; Sun, 25 Nov 2018 12:14:34 -0800 (PST)
MIME-Version: 1.0
References: <20181119080056.13386-1-oohall@gmail.com>
 <20181119080056.13386-3-oohall@gmail.com>
In-Reply-To: <20181119080056.13386-3-oohall@gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 25 Nov 2018 12:14:23 -0800
Message-ID: <CAPcyv4gWW5XWX+NHeaaG0s2tz30tYgzYf8icRNqE0k4jCSKGqQ@mail.gmail.com>
Subject: Re: [PATCH 3/4] ndctl/namespace: Use seed alignment as the default
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
To: Oliver O'Halloran <oohall@gmail.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Nov 19, 2018 at 12:11 AM Oliver O'Halloran <oohall@gmail.com> wrote:
>
> When creating a pfn or dax namespace ndctl uses a default alignment of 2MB
> when the user does not explicitly supply one. This works on most systems
> (x86, ARM, PPC64 with radix MMU), but it fails when the kernel does not
> support a 2MB page size (PPC64 with hash MMU).
>
> This patch makes ndctl use the alignment of the relevant seed namespace as
> the default instead. The kernel will always pick a valid default alignment
> so this should be a bit more portable.

Looks ok, but I'd want to try it with the unit test suite after my
comment on patch-2 is resolved.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

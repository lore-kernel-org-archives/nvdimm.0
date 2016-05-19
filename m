Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x236.google.com (mail-oi0-x236.google.com
 [IPv6:2607:f8b0:4003:c06::236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8938C1A1FC2
 for <linux-nvdimm@lists.01.org>; Wed, 18 May 2016 17:07:50 -0700 (PDT)
Received: by mail-oi0-x236.google.com with SMTP id x201so103557153oif.3
 for <linux-nvdimm@lists.01.org>; Wed, 18 May 2016 17:07:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <146352716208.1711.15183238430520498418.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <146352716208.1711.15183238430520498418.stgit@dwillia2-desk3.amr.corp.intel.com>
Date: Wed, 18 May 2016 17:07:43 -0700
Message-ID: <CAPcyv4h40yYc0++7bPfWwHu76i-1yk8qMTC5oYf3TjT1nESSnw@mail.gmail.com>
Subject: Re: [ndctl PATCH] ndctl: reorganize file structure, use per
 sub-directory makefiles
From: Dan Williams <dan.j.williams@intel.com>
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
To: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, May 17, 2016 at 4:19 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> In preparation for daxctl / libdaxctl move the ndctl infrastructure to
> its own sub-directory.
>
> This also moves tests to have their own Makefile rather than continuing
> to clutter up one top-level Makefile.am.
>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
[..]
>  rename lib/ndctl/libndctl.h.in => ndctl/lib/libndctl.h.in (100%)

This needs to be:

 {lib/ndctl => ndctl}/libndctl.h.in

...otherwise the build breaks because "#include <ndctl/libndctl.h>"
breaks.  This failure is hidden if /usr/include/linux/ndctl/libndctl.h
exists.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

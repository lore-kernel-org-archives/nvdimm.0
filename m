Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x242.google.com (mail-oi0-x242.google.com
 [IPv6:2607:f8b0:4003:c06::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5AAF92095DE5F
 for <linux-nvdimm@lists.01.org>; Thu, 10 Aug 2017 03:56:27 -0700 (PDT)
Received: by mail-oi0-x242.google.com with SMTP id e124so302313oig.0
 for <linux-nvdimm@lists.01.org>; Thu, 10 Aug 2017 03:58:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <a82a48f72b8099c1ef6a32a63819619637797ef8.1500397441.git.robin.murphy@arm.com>
References: <cover.1500397441.git.robin.murphy@arm.com>
 <a82a48f72b8099c1ef6a32a63819619637797ef8.1500397441.git.robin.murphy@arm.com>
From: Arnd Bergmann <arnd@arndb.de>
Date: Thu, 10 Aug 2017 12:58:45 +0200
Message-ID: <CAK8P3a1emRA_e_K+M-jRiXZD02nD38Vgn+V7R8NbSq0Wg=56Uw@mail.gmail.com>
Subject: Re: [PATCH 6/6] arm64: uaccess: Implement *_flushcache variants
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
To: Robin Murphy <robin.murphy@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>, linux-nvdimm@lists.01.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Linux ARM <linux-arm-kernel@lists.infradead.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jul 25, 2017 at 12:55 PM, Robin Murphy <robin.murphy@arm.com> wrote:
> Implement the set of copy functions with guarantees of a clean cache
> upon completion necessary to support the pmem driver.
>
> Signed-off-by: Robin Murphy <robin.murphy@arm.com>
> ---
>  arch/arm64/Kconfig                  |  1 +
>  arch/arm64/include/asm/string.h     |  4 ++++
>  arch/arm64/include/asm/uaccess.h    | 12 ++++++++++
>  arch/arm64/lib/Makefile             |  2 ++
>  arch/arm64/lib/uaccess_flushcache.c | 47 +++++++++++++++++++++++++++++++++++++
>  5 files changed, 66 insertions(+)
>  create mode 100644 arch/arm64/lib/uaccess_flushcache.c

It looks like Catalin applied part of this patch but forgot to add
arch/arm64/lib/uaccess_flushcache.c

      Arnd
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

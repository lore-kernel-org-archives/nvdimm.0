Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by ml01.01.org (Postfix) with ESMTP id DC3B121B06E9B
 for <linux-nvdimm@lists.01.org>; Thu, 10 Aug 2017 07:10:23 -0700 (PDT)
Date: Thu, 10 Aug 2017 15:12:38 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 6/6] arm64: uaccess: Implement *_flushcache variants
Message-ID: <20170810141238.oin7hfzi2vtyhjh4@armageddon.cambridge.arm.com>
References: <cover.1500397441.git.robin.murphy@arm.com>
 <a82a48f72b8099c1ef6a32a63819619637797ef8.1500397441.git.robin.murphy@arm.com>
 <CAK8P3a1emRA_e_K+M-jRiXZD02nD38Vgn+V7R8NbSq0Wg=56Uw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAK8P3a1emRA_e_K+M-jRiXZD02nD38Vgn+V7R8NbSq0Wg=56Uw@mail.gmail.com>
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
To: Arnd Bergmann <arnd@arndb.de>
Cc: Mark Rutland <mark.rutland@arm.com>, linux-nvdimm@lists.01.org, Will Deacon <will.deacon@arm.com>, Robin Murphy <robin.murphy@arm.com>, Linux ARM <linux-arm-kernel@lists.infradead.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Aug 10, 2017 at 12:58:45PM +0200, Arnd Bergmann wrote:
> On Tue, Jul 25, 2017 at 12:55 PM, Robin Murphy <robin.murphy@arm.com> wrote:
> > Implement the set of copy functions with guarantees of a clean cache
> > upon completion necessary to support the pmem driver.
> >
> > Signed-off-by: Robin Murphy <robin.murphy@arm.com>
> > ---
> >  arch/arm64/Kconfig                  |  1 +
> >  arch/arm64/include/asm/string.h     |  4 ++++
> >  arch/arm64/include/asm/uaccess.h    | 12 ++++++++++
> >  arch/arm64/lib/Makefile             |  2 ++
> >  arch/arm64/lib/uaccess_flushcache.c | 47 +++++++++++++++++++++++++++++++++++++
> >  5 files changed, 66 insertions(+)
> >  create mode 100644 arch/arm64/lib/uaccess_flushcache.c
> 
> It looks like Catalin applied part of this patch but forgot to add
> arch/arm64/lib/uaccess_flushcache.c

Added it now, thanks.

-- 
Catalin
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

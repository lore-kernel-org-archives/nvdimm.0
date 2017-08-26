Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A3A9A21D1E2DA
 for <linux-nvdimm@lists.01.org>; Sat, 26 Aug 2017 00:38:32 -0700 (PDT)
Date: Sat, 26 Aug 2017 09:40:47 +0200
From: Helge Deller <deller@gmx.de>
Subject: Re: [PATCH v6 3/5] mm: introduce mmap3 for safely defining new mmap
 flags
Message-ID: <20170826074047.GA6292@ls3530.fritz.box>
References: <150353211413.5039.5228914877418362329.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150353213097.5039.6729469069608762658.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170824165546.GA3121@infradead.org>
 <CAPcyv4iN0QpUSgOUvisnNQsiV1Pp=4dh7CwAV8FFj=_rFU=aug@mail.gmail.com>
 <20170825130011.GA30072@infradead.org>
 <20170825155803.4km7wttzadfqw2vb@node.shutemov.name>
 <20170825160236.GA2561@infradead.org>
 <20170825161607.6v6beg4zjktllt2z@node.shutemov.name>
 <4de21e8d-5e10-ec40-c731-0c079953cf48@gmx.de>
 <CAPcyv4jeZc8P+E0aHNChzy-wfNpOx3GehKck1nXqJ1b9JdydFA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4jeZc8P+E0aHNChzy-wfNpOx3GehKck1nXqJ1b9JdydFA@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-xfs@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-parisc@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Linux API <linux-api@vger.kernel.org>, Helge Deller <deller@gmx.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Linux MM <linux-mm@kvack.org>, Andy Lutomirski <luto@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, "Kirill A. Shutemov" <kirill@shutemov.name>, Andrew Morton <akpm@linux-foundation.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

* Dan Williams <dan.j.williams@intel.com>:
> On Fri, Aug 25, 2017 at 9:19 AM, Helge Deller <deller@gmx.de> wrote:
> > On 25.08.2017 18:16, Kirill A. Shutemov wrote:
> >> On Fri, Aug 25, 2017 at 09:02:36AM -0700, Christoph Hellwig wrote:
> >>> On Fri, Aug 25, 2017 at 06:58:03PM +0300, Kirill A. Shutemov wrote:
> >>>> Not all archs are ready for this:
> >>>>
> >>>> arch/parisc/include/uapi/asm/mman.h:#define MAP_TYPE    0x03            /* Mask for type of mapping */
> >>>> arch/parisc/include/uapi/asm/mman.h:#define MAP_FIXED   0x04            /* Interpret addr exactly */
> >>>
> >>> I'd be happy to say that we should not care about parisc for
> >>> persistent memory.  We'll just have to find a way to exclude
> >>> parisc without making life too ugly.
> >>
> >> I don't think creapling mmap() interface for one arch is the right way to
> >> go. I think the interface should be universal.
> >>
> >> I may imagine MAP_DIRECT can be useful not only for persistent memory.
> >> For tmpfs instead of mlock()?
> >
> > On parisc we have
> > #define MAP_SHARED      0x01            /* Share changes */
> > #define MAP_PRIVATE     0x02            /* Changes are private */
> > #define MAP_TYPE        0x03            /* Mask for type of mapping */
> > #define MAP_FIXED       0x04            /* Interpret addr exactly */
> > #define MAP_ANONYMOUS   0x10            /* don't use a file */
> >
> > So, if you need a MAP_DIRECT, wouldn't e.g.
> > #define MAP_DIRECT      0x08
> > be possible (for parisc, and others 0x04).
> > And if MAP_TYPE needs to include this flag on parisc:
> > #define MAP_TYPE        (0x03 | 0x08)  /* Mask for type of mapping */
> 
> The problem here is that to support new the mmap flags the arch needs
> to find a flag that is guaranteed to fail on older kernels. Defining
> MAP_DIRECT to 0x8 on parisc doesn't work because it will simply be
> ignored on older parisc kernels.
> 
> However, it's already the case that several archs have their own
> sys_mmap entry points. Those archs that can't follow the common scheme
> (only parsic it seems) will need to add a new mmap syscall. I think
> that's a reasonable tradeoff to allow every other architecture to add
> this support with their existing mmap syscall paths.

I don't want other architectures to suffer just because of parisc.
But adding a new syscall just for usage on parisc won't work either,
because nobody will add code to call it then.
 
> That means MAP_DIRECT should be defined to MAP_TYPE on parisc until it
> later defines an opt-in mechanism to a new syscall that honors
> MAP_DIRECT as a valid flag.

I'd instead propose to to introduce an ABI breakage for parisc users
(which aren't many). Most parisc users update their kernel regularily
anyway, because we fixed so many bugs in the latest kernel.

With the following patch pushed down to the stable kernel series,
MAP_DIRECT will fail as expected on those kernels, while we can
keep parisc up with current developments regarding MAP_DIRECT.

diff --git a/arch/parisc/include/uapi/asm/mman.h b/arch/parisc/include/uapi/asm/mman.h
index 9a9c2fe..43b9a1e 100644
--- a/arch/parisc/include/uapi/asm/mman.h
+++ b/arch/parisc/include/uapi/asm/mman.h
@@ -13,6 +13,7 @@
 #define MAP_PRIVATE	0x02		/* Changes are private */
 #define MAP_TYPE	0x03		/* Mask for type of mapping */
 #define MAP_FIXED	0x04		/* Interpret addr exactly */
+#define MAP_DIRECT	0x08		/* Interpret addr exactly */
 #define MAP_ANONYMOUS	0x10		/* don't use a file */
 
 #define MAP_DENYWRITE	0x0800		/* ETXTBSY */
diff --git a/arch/parisc/kernel/sys_parisc.c b/arch/parisc/kernel/sys_parisc.c
index 378a754..0499f87 100644
--- a/arch/parisc/kernel/sys_parisc.c
+++ b/arch/parisc/kernel/sys_parisc.c
@@ -270,6 +270,10 @@ asmlinkage unsigned long sys_mmap2(unsigned long addr, unsigned long len,
 {
 	/* Make sure the shift for mmap2 is constant (12), no matter what PAGE_SIZE
 	   we have. */
+#if !defined(CONFIG_HAVE_MAP_DIRECT_SUPPORT)
+	if (flags & MAP_DIRECT)
+		return -EINVAL;
+#endif
 	return sys_mmap_pgoff(addr, len, prot, flags, fd,
 			      pgoff >> (PAGE_SHIFT - 12));
 }
@@ -278,6 +282,10 @@ asmlinkage unsigned long sys_mmap(unsigned long addr, unsigned long len,
 		unsigned long prot, unsigned long flags, unsigned long fd,
 		unsigned long offset)
 {
+#if !defined(CONFIG_HAVE_MAP_DIRECT_SUPPORT)
+	if (flags & MAP_DIRECT)
+		return -EINVAL;
+#endif
 	if (!(offset & ~PAGE_MASK)) {
 		return sys_mmap_pgoff(addr, len, prot, flags, fd,
 					offset >> PAGE_SHIFT);


Helge
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

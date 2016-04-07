Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 by ml01.01.org (Postfix) with ESMTP id 92B7D1A1E0B
 for <linux-nvdimm@lists.01.org>; Thu,  7 Apr 2016 10:41:13 -0700 (PDT)
Date: Thu, 7 Apr 2016 13:41:11 -0400
From: Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH] x86 get_unmapped_area: Add PMD alignment for DAX PMD mmap
Message-ID: <20160407174111.GG2781@linux.intel.com>
References: <1459951089-14911-1-git-send-email-toshi.kani@hpe.com>
 <20160406165027.GA2781@linux.intel.com>
 <1459964672.20338.41.camel@hpe.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1459964672.20338.41.camel@hpe.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Toshi Kani <toshi.kani@hpe.com>
Cc: linux-nvdimm@lists.01.org, x86@kernel.org, linux-kernel@vger.kernel.org, mingo@kernel.org, linux-mm@kvack.org, hpa@zytor.com, tglx@linutronix.de, bp@suse.de, kirill.shutemov@linux.intel.com
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Apr 06, 2016 at 11:44:32AM -0600, Toshi Kani wrote:
> > The NVML chooses appropriate addresses and gets a properly aligned
> > address without any kernel code.
> =

> An application like NVML can continue to specify a specific address to
> mmap(). =A0Most existing applications, however, do not specify an address=
 to
> mmap(). =A0With this patch, specifying an address will remain optional.

The point is that this *can* be done in userspace.  You need to sell us
on the advantages of doing it in the kernel.

> > I think this is the wrong place for it, if we decide that this is the
> > right thing to do.=A0=A0The filesystem has a get_unmapped_area() which
> > should be used instead.
> =

> Yes, I considered adding a filesystem entry point, but decided going this
> way because:
> =A0-=A0arch_get_unmapped_area() and=A0arch_get_unmapped_area_topdown() ar=
e arch-
> specific code. =A0Therefore, this filesystem entry point will need arch-
> specific implementation.=A0
> =A0- There is nothing filesystem specific about requesting PMD alignment.

See http://article.gmane.org/gmane.linux.kernel.mm/149227 for Hugh's
approach for shmem.  I strongly believe that if we're going to do this
i the kernel, we should build on this approach, and not hack something
into each architecture's generic get_unmapped_area.

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

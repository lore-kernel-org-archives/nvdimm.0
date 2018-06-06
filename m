Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AA3AD21144CF4
 for <linux-nvdimm@lists.01.org>; Wed,  6 Jun 2018 00:39:13 -0700 (PDT)
Date: Wed, 6 Jun 2018 09:39:10 +0200
From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH v2 00/11] mm: Teach memory_failure() about ZONE_DEVICE
 pages
Message-ID: <20180606073910.GB32433@dhcp22.suse.cz>
References: <152800336321.17112.3300876636370683279.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180604124031.GP19202@dhcp22.suse.cz>
 <CAPcyv4gLxz7Ke6ApXoATDN31PSGwTgNRLTX-u1dtT3d+6jmzjw@mail.gmail.com>
 <20180605141104.GF19202@dhcp22.suse.cz>
 <CAPcyv4iGd56kc2NG5GDYMqW740RNr7NZr9DRft==fPxPyieq7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4iGd56kc2NG5GDYMqW740RNr7NZr9DRft==fPxPyieq7Q@mail.gmail.com>
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
Cc: Tony Luck <tony.luck@intel.com>, Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, X86 ML <x86@kernel.org>, Linux MM <linux-mm@kvack.org>, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Souptick Joarder <jrdr.linux@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, linux-edac@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue 05-06-18 07:33:17, Dan Williams wrote:
> On Tue, Jun 5, 2018 at 7:11 AM, Michal Hocko <mhocko@kernel.org> wrote:
> > On Mon 04-06-18 07:31:25, Dan Williams wrote:
> > [...]
> >> I'm trying to solve this real world problem when real poison is
> >> consumed through a dax mapping:
> >>
> >>         mce: Uncorrected hardware memory error in user-access at af34214200
> >>         {1}[Hardware Error]: It has been corrected by h/w and requires
> >> no further action
> >>         mce: [Hardware Error]: Machine check events logged
> >>         {1}[Hardware Error]: event severity: corrected
> >>         Memory failure: 0xaf34214: reserved kernel page still
> >> referenced by 1 users
> >>         [..]
> >>         Memory failure: 0xaf34214: recovery action for reserved kernel
> >> page: Failed
> >>         mce: Memory error not recovered
> >>
> >> ...i.e. currently all poison consumed through dax mappings is
> >> needlessly system fatal.
> >
> > Thanks. That should be a part of the changelog.
> 
> ...added for v3:
> https://lists.01.org/pipermail/linux-nvdimm/2018-June/016153.html
> 
> > It would be great to
> > describe why this cannot be simply handled by hwpoison code without any
> > ZONE_DEVICE specific hacks? The error is recoverable so why does
> > hwpoison code even care?
> >
> 
> Up until we started testing hardware poison recovery for persistent
> memory I assumed that the kernel did not need any new enabling to get
> basic support for recovering userspace consumed poison.
> 
> However, the recovery code has a dedicated path for many different
> page states (see: action_page_types). Without any changes it
> incorrectly assumes that a dax mapped page is a page cache page
> undergoing dma, or some other pinned operation. It also assumes that
> the page must be offlined which is not correct / possible for dax
> mapped pages. There is a possibility to repair poison to dax mapped
> persistent memory pages, and the pages can't otherwise be offlined
> because they 1:1 correspond with a physical storage block, i.e.
> offlining pmem would be equivalent to punching a hole in the physical
> address space.
> 
> There's also the entanglement of device-dax which guarantees a given
> mapping size (4K, 2M, 1G). This requires determining the size of the
> mapping encompassing a given pfn to know how much to unmap. Since dax
> mapped pfns don't come from the page allocator we need to read the
> page size from the page tables, not compound_order(page).

OK, but my question is still. Do we really want to do more on top of the
existing code and add even more special casing or it is time to rethink
the whole hwpoison design?
-- 
Michal Hocko
SUSE Labs
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

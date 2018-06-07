Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x243.google.com (mail-oi0-x243.google.com
 [IPv6:2607:f8b0:4003:c06::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5F5572110938E
 for <linux-nvdimm@lists.01.org>; Thu,  7 Jun 2018 09:52:24 -0700 (PDT)
Received: by mail-oi0-x243.google.com with SMTP id h79-v6so9222284oig.13
 for <linux-nvdimm@lists.01.org>; Thu, 07 Jun 2018 09:52:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180607143724.GS32433@dhcp22.suse.cz>
References: <152800336321.17112.3300876636370683279.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180604124031.GP19202@dhcp22.suse.cz>
 <CAPcyv4gLxz7Ke6ApXoATDN31PSGwTgNRLTX-u1dtT3d+6jmzjw@mail.gmail.com>
 <20180605141104.GF19202@dhcp22.suse.cz>
 <CAPcyv4iGd56kc2NG5GDYMqW740RNr7NZr9DRft==fPxPyieq7Q@mail.gmail.com>
 <20180606073910.GB32433@dhcp22.suse.cz>
 <CAPcyv4hA2Na7wyuyLZSWG5s_4+pEv6aMApk23d2iO1vhFx92XQ@mail.gmail.com>
 <20180607143724.GS32433@dhcp22.suse.cz>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 7 Jun 2018 09:52:22 -0700
Message-ID: <CAPcyv4jnyuC-yjuSgu4qKtzB0h9yYMZDsg5Rqqa=HTCY9KM_gw@mail.gmail.com>
Subject: Re: [PATCH v2 00/11] mm: Teach memory_failure() about ZONE_DEVICE
 pages
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
To: Michal Hocko <mhocko@kernel.org>
Cc: Tony Luck <tony.luck@intel.com>, Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, X86 ML <x86@kernel.org>, Linux MM <linux-mm@kvack.org>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Souptick Joarder <jrdr.linux@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, linux-edac@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jun 7, 2018 at 7:37 AM, Michal Hocko <mhocko@kernel.org> wrote:
> On Wed 06-06-18 06:44:45, Dan Williams wrote:
>> On Wed, Jun 6, 2018 at 12:39 AM, Michal Hocko <mhocko@kernel.org> wrote:
>> > On Tue 05-06-18 07:33:17, Dan Williams wrote:
>> >> On Tue, Jun 5, 2018 at 7:11 AM, Michal Hocko <mhocko@kernel.org> wrote:
>> >> > On Mon 04-06-18 07:31:25, Dan Williams wrote:
>> >> > [...]
>> >> >> I'm trying to solve this real world problem when real poison is
>> >> >> consumed through a dax mapping:
>> >> >>
>> >> >>         mce: Uncorrected hardware memory error in user-access at af34214200
>> >> >>         {1}[Hardware Error]: It has been corrected by h/w and requires
>> >> >> no further action
>> >> >>         mce: [Hardware Error]: Machine check events logged
>> >> >>         {1}[Hardware Error]: event severity: corrected
>> >> >>         Memory failure: 0xaf34214: reserved kernel page still
>> >> >> referenced by 1 users
>> >> >>         [..]
>> >> >>         Memory failure: 0xaf34214: recovery action for reserved kernel
>> >> >> page: Failed
>> >> >>         mce: Memory error not recovered
>> >> >>
>> >> >> ...i.e. currently all poison consumed through dax mappings is
>> >> >> needlessly system fatal.
>> >> >
>> >> > Thanks. That should be a part of the changelog.
>> >>
>> >> ...added for v3:
>> >> https://lists.01.org/pipermail/linux-nvdimm/2018-June/016153.html
>> >>
>> >> > It would be great to
>> >> > describe why this cannot be simply handled by hwpoison code without any
>> >> > ZONE_DEVICE specific hacks? The error is recoverable so why does
>> >> > hwpoison code even care?
>> >> >
>> >>
>> >> Up until we started testing hardware poison recovery for persistent
>> >> memory I assumed that the kernel did not need any new enabling to get
>> >> basic support for recovering userspace consumed poison.
>> >>
>> >> However, the recovery code has a dedicated path for many different
>> >> page states (see: action_page_types). Without any changes it
>> >> incorrectly assumes that a dax mapped page is a page cache page
>> >> undergoing dma, or some other pinned operation. It also assumes that
>> >> the page must be offlined which is not correct / possible for dax
>> >> mapped pages. There is a possibility to repair poison to dax mapped
>> >> persistent memory pages, and the pages can't otherwise be offlined
>> >> because they 1:1 correspond with a physical storage block, i.e.
>> >> offlining pmem would be equivalent to punching a hole in the physical
>> >> address space.
>> >>
>> >> There's also the entanglement of device-dax which guarantees a given
>> >> mapping size (4K, 2M, 1G). This requires determining the size of the
>> >> mapping encompassing a given pfn to know how much to unmap. Since dax
>> >> mapped pfns don't come from the page allocator we need to read the
>> >> page size from the page tables, not compound_order(page).
>> >
>> > OK, but my question is still. Do we really want to do more on top of the
>> > existing code and add even more special casing or it is time to rethink
>> > the whole hwpoison design?
>>
>> Well, there's the immediate problem that the current implementation is
>> broken for dax and then the longer term problem that the current
>> design appears to be too literal with a lot of custom marshaling.
>>
>> At least for dax in the long term we want to offer an alternative
>> error handling model and get the filesystem much more involved. That
>> filesystem redesign work has been waiting for the reverse-block-map
>> effort to settle in xfs. However, that's more custom work for dax and
>> not a redesign that helps the core-mm more generically.
>>
>> I think the unmap and SIGBUS portion of poison handling is relatively
>> straightforward. It's the handling of the page HWPoison page flag that
>> seems a bit ad hoc. The current implementation certainly was not
>> prepared for the concept that memory can be repaired. set_mce_nospec()
>> is a step in the direction of generic memory error handling.
>
> Agreed! Moreover random checks for HWPoison pages is just a maintenance
> hell.
>
>> Thoughts on other pain points in the design that are on your mind, Michal?
>
> we have discussed those at LSFMM this year https://lwn.net/Articles/753261/
> The main problem is that there is besically no design description so the
> whole feature is very easy to break. Yours is another good example of
> that. We need to get back to the drawing board and think about how to
> make this more robust.

I saw that article, but to be honest I did not glean any direct
suggestions that read on these current patches. I'm interested in
discussing a redesign, but I'm not interested in leaving poison
unhandled for DAX while we figure it out. Developers are actively
testing media error handling for persistent memory applications, and
expect the current SIGBUS + BUS_MCEERR_AR kernel ABI to work for
memory errors in userspace mappings.

The article mentioned that PUD poison does not work. That may be the
case for THP, but it does work for DAX. Here's the simple test [1],
yes, more test driven design of poison handling as you lamented.

[1]: https://patchwork.kernel.org/patch/10451131/
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

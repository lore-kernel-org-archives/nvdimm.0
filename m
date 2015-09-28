Return-Path: <linux-fsdevel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20150928005904.GY19114@dastard>
References: <1443040800-5460-1-git-send-email-ross.zwisler@linux.intel.com>
	<20150924025225.GT3902@dastard>
	<20150924155029.GA6008@linux.intel.com>
	<20150925025357.GU3902@dastard>
	<20150926031745.GA560@linux.intel.com>
	<20150928005904.GY19114@dastard>
Date: Mon, 28 Sep 2015 05:13:50 -0700
Message-ID: <CAPcyv4jfT2fvYPGFBgxynNAvJ4KoKX=_TZbpB4ieTQV25mmFkQ@mail.gmail.com>
Subject: Re: [PATCH] dax: fix deadlock in __dax_fault
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Matthew Wilcox <willy@linux.intel.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Jan Kara <jack@suse.cz>
List-ID: <linux-nvdimm@lists.01.org>

On Sun, Sep 27, 2015 at 5:59 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Fri, Sep 25, 2015 at 09:17:45PM -0600, Ross Zwisler wrote:
>> On Fri, Sep 25, 2015 at 12:53:57PM +1000, Dave Chinner wrote:
[..]
>> Does this sound like a reasonable path forward for v4.3?  Dave, and Jan, can
>> you guys can provide guidance and code reviews for the XFS and ext4 bits?
>
> IMO, it's way too much to get into 4.3. I'd much prefer we revert
> the bad changes in 4.3, and then work towards fixing this for the
> 4.4 merge window. If someone needs this for 4.3, then they can
> backport the 4.4 code to 4.3-stable.
>

If the proposal is to step back and get a running start at these fixes
for 4.4, then it is worth considering what the state of allocating
pages for DAX mappings will be in 4.4.  It's already that case that
allocating struct page for DAX mappings is the only solution on the
horizon for enabling a get_user_pages() solution for persistent
memory.  We of course need to get the page-less DAX path fixed up, but
the near-term path to full functionality and safety is when struct
page is available to enable the typical synchronization mechanics.

That said, it's not clear that saves us any work given the axonram and
dcssblk DAX drivers do not currently allocate struct page, and pmem
optionally allocates struct page.

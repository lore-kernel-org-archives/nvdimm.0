Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20150523141209.GA19414@lst.de>
References: <20150512042629.11521.70356.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150512043001.11521.3526.stgit@dwillia2-desk3.amr.corp.intel.com>
	<1431542149.31415.10.camel@intel.com>
	<20150523141209.GA19414@lst.de>
Date: Sat, 23 May 2015 09:41:45 -0700
Message-ID: <CAA9_cmeD0245sggWkKnK9ur2q3fAYH3+Cr_ddQgKWfcKo1OtEQ@mail.gmail.com>
Subject: Re: [PATCH v3 06/11] scatterlist: support "page-less" (__pfn_t only) entries
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: "hch@lst.de" <hch@lst.de>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>, "riel@redhat.com" <riel@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "david@fromorbit.com" <david@fromorbit.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "mingo@kernel.org" <mingo@kernel.org>, "axboe@fb.com" <axboe@fb.com>, "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>, "mgorman@suse.de" <mgorman@suse.de>, "j.glisse@gmail.com" <j.glisse@gmail.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sat, May 23, 2015 at 7:12 AM, hch@lst.de <hch@lst.de> wrote:
> On Wed, May 13, 2015 at 06:35:55PM +0000, Williams, Dan J wrote:
>> Jens, I'm wondering if you want to take this series(.) as patches or
>> prepare a git branch to pull?
>
> Honestly I don't think it should go anyway.  It makes a big mess of
> a structure without providing a real user for it.  Given how we are
> using the bio_vec for in-kernel page based I/O these days it seems
> like a very dangerous idea.

There's nothing dangerous about the __pfn_t conversion of the block
layer in the !CONFIG_DEV_PFN case a __pfn_t based bio_vec is
bit-for-bit identical to a struct page based bio_vec.  However, you're
right, I can't make the same claim about a scatterlist before and
after the change.

Hmm, we're missing a pfn-only block I/O user and we're missing the
second half of the implementation that provides __pfn_t_to_page() for
persistent memory.  I'm looking to have a solution __pfn_t_to_page()
shortly, maybe that will allow the scatterlist changes to be
skipped...  we'll see.

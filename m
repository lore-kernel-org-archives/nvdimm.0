Return-Path: <linux-fsdevel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <550957B9.5050803@gmail.com>
References: <20150316201640.33102.33761.stgit@dwillia2-desk3.amr.corp.intel.com>
	<550957B9.5050803@gmail.com>
Date: Wed, 18 Mar 2015 08:35:38 -0700
Message-ID: <CAPcyv4jmO+1xErV0bJEtM4sirTCK5XoWCT923Wgp14KcL=qO2A@mail.gmail.com>
Subject: Re: [RFC PATCH 0/7] evacuate struct page from the block layer
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-fsdevel-owner@vger.kernel.org
To: Boaz Harrosh <openosd@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@osdl.org>, linux-arch@vger.kernel.org, riel@redhat.com, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Dave Hansen <dave.hansen@linux.intel.com>, linux-raid <linux-raid@vger.kernel.org>, mgorman@suse.de, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Matthew Wilcox <willy@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Mar 18, 2015 at 3:47 AM, Boaz Harrosh <openosd@gmail.com> wrote:
> On 03/16/2015 10:25 PM, Dan Williams wrote:
>> Avoid the impending disaster of requiring struct page coverage for what
>> is expected to be ever increasing capacities of persistent memory.
>
> If you are saying "disaster", than we need to believe you. Or is there
> a scientific proof for this.

The same Moore's Law based extrapolation that Dave Chinner did to
determine that major feature development on XFS may cease in 5 - 7
years.  In Dave's words we're looking ahead to "lots and fast".  Given
the time scale of getting kernel changes out to end users in an
enterprise kernel update the "dynamic page struct allocation" approach
is already insufficient.

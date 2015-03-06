Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <1425667392.32009.8.camel@theros.lm.intel.com>
Subject: Re: [PATCH 5/8] mm: Let sparse_{add,remove}_one_section receive a
 node_id
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Date: Fri, 06 Mar 2015 11:43:12 -0700
In-Reply-To: <54F844E5.5090500@plexistor.com>
References: <54F82CE0.4040502@plexistor.com>
	 <54F830D4.7030205@plexistor.com> <54F844E5.5090500@plexistor.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Boaz Harrosh <boaz@plexistor.com>
Cc: Ingo Molnar <mingo@redhat.com>, x86@kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, "Roger C. Pao" <rcpao.enmotus@gmail.com>, Dan Williams <dan.j.williams@intel.com>, Thomas Gleixner <tglx@linutronix.de>, linux-nvdimm <linux-nvdimm@lists.01.org>, "H. Peter Anvin" <hpa@zytor.com>, Matthew Wilcox <willy@linux.intel.com>, Andy Lutomirski <luto@amacapital.net>, Christoph Hellwig <hch@infradead.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, 2015-03-05 at 13:58 +0200, Boaz Harrosh wrote:
> From: Yigal Korman <yigal@plexistor.com>
> 
> Refactored the arguments of sparse_add_one_section / sparse_remove_one_section
> to use node id instead of struct zone * - A memory section has no direct
> connection to zones, all that was needed from zone was the node id.
> 
> This is for add_persistent_memory that will want a section of pages
> allocated but without any zone associated. This is because belonging
> to a zone will give the memory to the page allocators, but
> persistent_memory belongs to a block device, and is not available for
> regular volatile usage.
> 
> Signed-off-by: Yigal Korman <yigal@plexistor.com>
> Signed-off-by: Boaz Harrosh <boaz@plexistor.com>
> ---
>  include/linux/memory_hotplug.h | 4 ++--
>  mm/memory_hotplug.c            | 4 ++--
>  mm/sparse.c                    | 9 +++++----
>  3 files changed, 9 insertions(+), 8 deletions(-)

For both of the MM patches in this series (this one, 5/8, and the next one,
6/8), please be sure and CC the MM folks.  I know that Dave Hansen had
feedback on an earlier version of this patch:

https://lkml.org/lkml/2014/9/9/742

We need to make sure that feedback is addressed.

Thanks,
- Ross



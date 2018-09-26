Return-Path: <owner-linux-mm@kvack.org>
Subject: Re: [PATCH v5 2/4] mm: Provide kernel parameter to allow disabling
 page init poisoning
References: <20180925200551.3576.18755.stgit@localhost.localdomain>
 <20180925201921.3576.84239.stgit@localhost.localdomain>
 <20180926073831.GC6278@dhcp22.suse.cz>
From: Dave Hansen <dave.hansen@intel.com>
Message-ID: <f5648747-642f-763e-80b9-24fb203c85e9@intel.com>
Date: Wed, 26 Sep 2018 08:36:47 -0700
MIME-Version: 1.0
In-Reply-To: <20180926073831.GC6278@dhcp22.suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: owner-linux-mm@kvack.org
To: Michal Hocko <mhocko@kernel.org>, Alexander Duyck <alexander.h.duyck@linux.intel.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, pavel.tatashin@microsoft.com, dave.jiang@intel.com, jglisse@redhat.com, rppt@linux.vnet.ibm.com, dan.j.williams@intel.com, logang@deltatee.com, mingo@kernel.org, kirill.shutemov@linux.intel.com
List-ID: <linux-nvdimm@lists.01.org>

On 09/26/2018 12:38 AM, Michal Hocko wrote:
> Why cannot you simply go with [no]vm_page_poison[=on/off]?

I was trying to look to the future a bit, if we end up with five or six
more other options we want to allow folks to enable/disable.  I don't
want to end up in a situation where we have a bunch of different knobs
to turn all this stuff off at runtime.

I'd really like to have one stop shopping so that folks who have a
system that's behaving well and don't need any debugging can get some of
their performance back.

But, the *primary* thing we want here is a nice, quick way to turn as
much debugging off as we can.  A nice-to-have is a future-proof,
slub-style option that will centralize things.

Alex's patch fails at the primary goal, IMNHO because "vm_debug=-" is so
weird.  I'd much rather have "vm_debug=off" (the primary goal) and throw
away the nice-to-have (future-proof fine-grained on/off).

I think we can have both, but I guess the onus is on me to go and add a
strcmp(..., "off"). :)

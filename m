Return-Path: <owner-linux-mm@kvack.org>
Date: Mon, 17 Jun 2019 06:14:59 -0700
From: 'Christoph Hellwig' <hch@infradead.org>
Subject: Re: [PATCH 5/5] mm/hotplug: export try_online_node
Message-ID: <20190617131459.GA639@infradead.org>
References: <20190617043635.13201-1-alastair@au1.ibm.com>
 <20190617043635.13201-6-alastair@au1.ibm.com>
 <20190617065921.GV3436@hirez.programming.kicks-ass.net>
 <f1bad6f784efdd26508b858db46f0192a349c7a1.camel@d-silva.org>
 <20190617071527.GA14003@infradead.org>
 <068d01d524e2$aa6f3000$ff4d9000$@d-silva.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <068d01d524e2$aa6f3000$ff4d9000$@d-silva.org>
Sender: owner-linux-mm@kvack.org
To: Alastair D'Silva <alastair@d-silva.org>
Cc: 'Christoph Hellwig' <hch@infradead.org>, 'Peter Zijlstra' <peterz@infradead.org>, 'Andrew Morton' <akpm@linux-foundation.org>, 'David Hildenbrand' <david@redhat.com>, 'Oscar Salvador' <osalvador@suse.com>, 'Michal Hocko' <mhocko@suse.com>, 'Pavel Tatashin' <pasha.tatashin@soleen.com>, 'Wei Yang' <richard.weiyang@gmail.com>, 'Arun KS' <arunks@codeaurora.org>, 'Qian Cai' <cai@lca.pw>, 'Thomas Gleixner' <tglx@linutronix.de>, 'Ingo Molnar' <mingo@kernel.org>, 'Josh Poimboeuf' <jpoimboe@redhat.com>, 'Jiri Kosina' <jkosina@suse.cz>, 'Mukesh Ojha' <mojha@codeaurora.org>, 'Mike Rapoport' <rppt@linux.vnet.ibm.com>, 'Baoquan He' <bhe@redhat.com>, 'Logan Gunthorpe' <logang@deltatee.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jun 17, 2019 at 06:00:00PM +1000, Alastair D'Silva wrote:
> > And all that should go through our pmem APIs, not not directly poke into
> mm
> > internals.  And if you still need core patches send them along with the
> actual
> > driver.
> 
> I tried that, but I was getting crashes as the NUMA data structures for that
> node were not initialised.
> 
> Calling this was required to prevent uninitialized accesses in the pmem
> library.

Please send your driver to the linux-nvdimm and linux-mm lists so that
it can be carefully reviewed.

Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ushosting.nmnhosting.com (ushosting.nmnhosting.com
 [66.55.73.32]) by ml01.01.org (Postfix) with ESMTP id A3A152128D6A4
 for <linux-nvdimm@lists.01.org>; Mon, 17 Jun 2019 01:00:05 -0700 (PDT)
From: "Alastair D'Silva" <alastair@d-silva.org>
References: <20190617043635.13201-1-alastair@au1.ibm.com>
 <20190617043635.13201-6-alastair@au1.ibm.com>
 <20190617065921.GV3436@hirez.programming.kicks-ass.net>
 <f1bad6f784efdd26508b858db46f0192a349c7a1.camel@d-silva.org>
 <20190617071527.GA14003@infradead.org>
In-Reply-To: <20190617071527.GA14003@infradead.org>
Subject: RE: [PATCH 5/5] mm/hotplug: export try_online_node
Date: Mon, 17 Jun 2019 18:00:00 +1000
Message-ID: <068d01d524e2$aa6f3000$ff4d9000$@d-silva.org>
MIME-Version: 1.0
Content-Language: en-au
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
To: 'Christoph Hellwig' <hch@infradead.org>
Cc: 'Oscar Salvador' <osalvador@suse.com>, 'Michal Hocko' <mhocko@suse.com>, 'Pavel Tatashin' <pasha.tatashin@soleen.com>, 'Baoquan He' <bhe@redhat.com>, 'David Hildenbrand' <david@redhat.com>, 'Peter Zijlstra' <peterz@infradead.org>, 'Jiri Kosina' <jkosina@suse.cz>, 'Mukesh Ojha' <mojha@codeaurora.org>, 'Ingo Molnar' <mingo@kernel.org>, linux-kernel@vger.kernel.org, 'Wei Yang' <richard.weiyang@gmail.com>, linux-mm@kvack.org, 'Mike Rapoport' <rppt@linux.vnet.ibm.com>, 'Arun KS' <arunks@codeaurora.org>, 'Josh Poimboeuf' <jpoimboe@redhat.com>, 'Qian Cai' <cai@lca.pw>, 'Andrew Morton' <akpm@linux-foundation.org>, 'Thomas Gleixner' <tglx@linutronix.de>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

> -----Original Message-----
> From: Christoph Hellwig <hch@infradead.org>
> Sent: Monday, 17 June 2019 5:15 PM
> To: Alastair D'Silva <alastair@d-silva.org>
> Cc: Peter Zijlstra <peterz@infradead.org>; Andrew Morton <akpm@linux-
> foundation.org>; David Hildenbrand <david@redhat.com>; Oscar Salvador
> <osalvador@suse.com>; Michal Hocko <mhocko@suse.com>; Pavel Tatashin
> <pasha.tatashin@soleen.com>; Wei Yang <richard.weiyang@gmail.com>;
> Arun KS <arunks@codeaurora.org>; Qian Cai <cai@lca.pw>; Thomas Gleixner
> <tglx@linutronix.de>; Ingo Molnar <mingo@kernel.org>; Josh Poimboeuf
> <jpoimboe@redhat.com>; Jiri Kosina <jkosina@suse.cz>; Mukesh Ojha
> <mojha@codeaurora.org>; Mike Rapoport <rppt@linux.vnet.ibm.com>;
> Baoquan He <bhe@redhat.com>; Logan Gunthorpe
> <logang@deltatee.com>; linux-mm@kvack.org; linux-
> kernel@vger.kernel.org; linux-nvdimm@lists.01.org
> Subject: Re: [PATCH 5/5] mm/hotplug: export try_online_node
> 
> On Mon, Jun 17, 2019 at 05:05:30PM +1000, Alastair D'Silva wrote:
> > On Mon, 2019-06-17 at 08:59 +0200, Peter Zijlstra wrote:
> > > On Mon, Jun 17, 2019 at 02:36:31PM +1000, Alastair D'Silva wrote:
> > > > From: Alastair D'Silva <alastair@d-silva.org>
> > > >
> > > > If an external driver module supplies physical memory and needs to
> > > > expose
> > >
> > > Why would you ever want to allow a module to do such a thing?
> > >
> >
> > I'm working on a driver for Storage Class Memory, connected via an
> > OpenCAPI link.
> >
> > The memory is only usable once the card says it's OK to access it.
> 
> And all that should go through our pmem APIs, not not directly poke into
mm
> internals.  And if you still need core patches send them along with the
actual
> driver.

I tried that, but I was getting crashes as the NUMA data structures for that
node were not initialised.

Calling this was required to prevent uninitialized accesses in the pmem
library.

-- 
Alastair D'Silva           mob: 0423 762 819
skype: alastair_dsilva     msn: alastair@d-silva.org
blog: http://alastair.d-silva.org    Twitter: @EvilDeece



_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 01/21] mm: Join struct fault_env and vm_fault
Date: Wed, 16 Nov 2016 18:21:08 +0100
Message-ID: <20161116172108.GV3142@twins.programming.kicks-ass.net>
References: <1478233517-3571-1-git-send-email-jack@suse.cz>
 <1478233517-3571-2-git-send-email-jack@suse.cz>
 <20161115215021.GA23021@node>
 <20161116105132.GR3142@twins.programming.kicks-ass.net>
 <20161116110101.GE21785@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161116110101.GE21785-4I4JzKEfoa/jFM9bn6wA6Q@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Cc: linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

On Wed, Nov 16, 2016 at 12:01:01PM +0100, Jan Kara wrote:
> On Wed 16-11-16 11:51:32, Peter Zijlstra wrote:

> > Now, I'm entirely out of touch wrt DAX, so I've not idea what that
> > needs/wants.
> 
> Yeah, DAX does not have 'struct page' for its pages so it directly installs
> PFNs in the page tables. As a result it needs to know about page tables and
> stuff.

Not convinced, a physical address should then be the equivalent of a
struct page. You still don't need access to the actual pages tables. The
VM core can then convert the physical address to a PFN and stuff it in
the PTE entry.

> Now I've abstracted knowledge about that into helper functions back
> in mm/ but still we need to pass the information through the ->fault handler
> into those helpers and vm_fault structure is simply natural for that.
> So far we have tried to avoid that but the result was not pretty (special
> return codes from DAX ->fault handlers essentially leaking information
> about DAX internal locking into mm/ code to direct generic mm code to do
> the right thing for DAX).

Its probably the DAX locking bit I'm missing, because I cannot see why
VM_FAULT_DAX_LOCKED is 'broken' -- also, I'd have called that
VM_FAULT_PFN or similar and not have used the full entry but only the
PFN bits from it.

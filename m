Return-Path: <linux-nvdimm-bounces@lists.01.org>
Date: Tue, 13 Sep 2016 11:31:28 +1000
From: Nicholas Piggin <npiggin@gmail.com>
Subject: Re: DAX mapping detection (was: Re: [PATCH] Fix region lost in
 /proc/self/smaps)
Message-ID: <20160913113128.4eae792e@roar.ozlabs.ibm.com>
In-Reply-To: <20160912150148.GA10039@infradead.org>
References: <CAPcyv4iDra+mRqEejfGqapKEAFZmUtUcg0dsJ8nt7mOhcT-Qpw@mail.gmail.com>
 <20160908225636.GB15167@linux.intel.com>
 <20160912052703.GA1897@infradead.org>
 <CAOSf1CHaW=szD+YEjV6vcUG0KKr=aXv8RXomw9xAgknh_9NBFQ@mail.gmail.com>
 <20160912075128.GB21474@infradead.org>
 <20160912180507.533b3549@roar.ozlabs.ibm.com>
 <20160912150148.GA10039@infradead.org>
MIME-Version: 1.0
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Yumei Huang <yuhuang@redhat.com>, Michal Hocko <mhocko@suse.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>, KVM list <kvm@vger.kernel.org>, Dave Hansen <dave.hansen@intel.com>, Gleb Natapov <gleb@kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, mtosatti@redhat.com, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Stefan Hajnoczi <stefanha@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, 12 Sep 2016 08:01:48 -0700
Christoph Hellwig <hch@infradead.org> wrote:

> On Mon, Sep 12, 2016 at 06:05:07PM +1000, Nicholas Piggin wrote:
> > It's not fundamentally broken, it just doesn't fit well existing
> > filesystems.  
> 
> Or the existing file system architecture for that matter.  Which makes
> it a fundamentally broken model.

Not really. A few reasonable changes can be made to improve things.
Until just now you thought it was fundamentally impossible to make a
reasonable implementation due to Dave's "constraints".

> 
> > Dave's post of requirements is also wrong. A filesystem does not have
> > to guarantee all that, it only has to guarantee that is the case for
> > a given block after it has a mapping and page fault returns, other
> > operations can be supported by invalidating mappings, etc.  
> 
> Which doesn't really matter if your use case is manipulating
> fully mapped files.

Nothing that says you have to use them fully mapped always and not
use other APIs on them.


> But back to the point: if you want to use a full blown Linux or Unix
> filesystem you will always have to fsync (or variants of it like msync),
> period.

That's circular logic. First you said that should not be done
because of your imagined constraints.

In fact, it's not unreasonable to describe some additional semantics
of the storage that is unavailable with traditional filesystems.

That said, a noop system call is on the order of 100 cycles nowadays,
so rushing to implement these APIs without seeing good numbers and
actual users ready to go seems premature. *This* is the real reason
not to implement new APIs yet.


> If you want a volume manager on stereoids that hands out large chunks
> of storage memory that can't ever be moved, truncated, shared, allocated
> on demand, etc - implement it in your library on top of a device file.

Those constraints don't exist either. I've written a filesystem
that avoids them. It isn't rocket science.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

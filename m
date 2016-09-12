Return-Path: <linux-nvdimm-bounces@lists.01.org>
Date: Mon, 12 Sep 2016 08:01:48 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: DAX mapping detection (was: Re: [PATCH] Fix region lost in
 /proc/self/smaps)
Message-ID: <20160912150148.GA10039@infradead.org>
References: <CAPcyv4iDra+mRqEejfGqapKEAFZmUtUcg0dsJ8nt7mOhcT-Qpw@mail.gmail.com>
 <20160908225636.GB15167@linux.intel.com>
 <20160912052703.GA1897@infradead.org>
 <CAOSf1CHaW=szD+YEjV6vcUG0KKr=aXv8RXomw9xAgknh_9NBFQ@mail.gmail.com>
 <20160912075128.GB21474@infradead.org>
 <20160912180507.533b3549@roar.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160912180507.533b3549@roar.ozlabs.ibm.com>
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
To: Nicholas Piggin <npiggin@gmail.com>
Cc: Yumei Huang <yuhuang@redhat.com>, Michal Hocko <mhocko@suse.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>, KVM list <kvm@vger.kernel.org>, Dave Hansen <dave.hansen@intel.com>, Gleb Natapov <gleb@kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, mtosatti@redhat.com, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Linux MM <linux-mm@kvack.org>, Stefan Hajnoczi <stefanha@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Sep 12, 2016 at 06:05:07PM +1000, Nicholas Piggin wrote:
> It's not fundamentally broken, it just doesn't fit well existing
> filesystems.

Or the existing file system architecture for that matter.  Which makes
it a fundamentally broken model.

> Dave's post of requirements is also wrong. A filesystem does not have
> to guarantee all that, it only has to guarantee that is the case for
> a given block after it has a mapping and page fault returns, other
> operations can be supported by invalidating mappings, etc.

Which doesn't really matter if your use case is manipulating
fully mapped files.

But back to the point: if you want to use a full blown Linux or Unix
filesystem you will always have to fsync (or variants of it like msync),
period.

If you want a volume manager on stereoids that hands out large chunks
of storage memory that can't ever be moved, truncated, shared, allocated
on demand, etc - implement it in your library on top of a device file.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

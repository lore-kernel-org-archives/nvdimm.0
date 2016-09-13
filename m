Return-Path: <linux-nvdimm-bounces@lists.01.org>
Date: Tue, 13 Sep 2016 15:40:48 +1000
From: Nicholas Piggin <npiggin@gmail.com>
Subject: Re: DAX mapping detection (was: Re: [PATCH] Fix region lost in
 /proc/self/smaps)
Message-ID: <20160913154048.76b0e0bc@roar.ozlabs.ibm.com>
In-Reply-To: <CAPcyv4iPh2io4S4LpyFvgn9NcoOUEHU25uBz3aSZPJaxbZJZoA@mail.gmail.com>
References: <CAPcyv4iDra+mRqEejfGqapKEAFZmUtUcg0dsJ8nt7mOhcT-Qpw@mail.gmail.com>
 <20160908225636.GB15167@linux.intel.com>
 <20160912052703.GA1897@infradead.org>
 <CAOSf1CHaW=szD+YEjV6vcUG0KKr=aXv8RXomw9xAgknh_9NBFQ@mail.gmail.com>
 <20160912075128.GB21474@infradead.org>
 <20160912180507.533b3549@roar.ozlabs.ibm.com>
 <20160912150148.GA10039@infradead.org>
 <20160913113128.4eae792e@roar.ozlabs.ibm.com>
 <CAPcyv4iPh2io4S4LpyFvgn9NcoOUEHU25uBz3aSZPJaxbZJZoA@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Yumei Huang <yuhuang@redhat.com>, Michal Hocko <mhocko@suse.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>, KVM list <kvm@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Gleb Natapov <gleb@kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, mtosatti@redhat.com, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Dave Hansen <dave.hansen@intel.com>, Stefan Hajnoczi <stefanha@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, 12 Sep 2016 21:06:49 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> On Mon, Sep 12, 2016 at 6:31 PM, Nicholas Piggin <npiggin@gmail.com> wrote:
> > On Mon, 12 Sep 2016 08:01:48 -0700  
> [..]
> > That said, a noop system call is on the order of 100 cycles nowadays,
> > so rushing to implement these APIs without seeing good numbers and
> > actual users ready to go seems premature. *This* is the real reason
> > not to implement new APIs yet.  
> 
> Yes, and harvesting the current crop of low hanging performance fruit
> in the filesystem-DAX I/O path remains on the todo list.
> 
> In the meantime we're pursuing this mm api, mincore+ or whatever we
> end up with, to allow userspace to distinguish memory address ranges
> that are backed by a filesystem requiring coordination of metadata
> updates + flushes for updates, vs something like device-dax that does
> not.

Yes, that's reasonable.

Do you need page/block granularity? Do you need a way to advise/request
the fs for a particular capability? Is it enough to request and check
success? Would the capability be likely to change, and if so, how would
you notify the app asynchronously?

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

Return-Path: <linux-nvdimm-bounces@lists.01.org>
MIME-Version: 1.0
In-Reply-To: <20160912052703.GA1897@infradead.org>
References: <CAPcyv4iDra+mRqEejfGqapKEAFZmUtUcg0dsJ8nt7mOhcT-Qpw@mail.gmail.com>
 <20160908225636.GB15167@linux.intel.com> <20160912052703.GA1897@infradead.org>
From: "Oliver O'Halloran" <oohall@gmail.com>
Date: Mon, 12 Sep 2016 17:25:15 +1000
Message-ID: <CAOSf1CHaW=szD+YEjV6vcUG0KKr=aXv8RXomw9xAgknh_9NBFQ@mail.gmail.com>
Subject: Re: DAX mapping detection (was: Re: [PATCH] Fix region lost in
 /proc/self/smaps)
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
Cc: Yumei Huang <yuhuang@redhat.com>, Michal Hocko <mhocko@suse.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, KVM list <kvm@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Gleb Natapov <gleb@kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, mtosatti@redhat.com, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Dave Hansen <dave.hansen@intel.com>, Stefan Hajnoczi <stefanha@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Sep 12, 2016 at 3:27 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Thu, Sep 08, 2016 at 04:56:36PM -0600, Ross Zwisler wrote:
>> I think this goes back to our previous discussion about support for the PMEM
>> programming model.  Really I think what NVML needs isn't a way to tell if it
>> is getting a DAX mapping, but whether it is getting a DAX mapping on a
>> filesystem that fully supports the PMEM programming model.  This of course is
>> defined to be a filesystem where it can do all of its flushes from userspace
>> safely and never call fsync/msync, and that allocations that happen in page
>> faults will be synchronized to media before the page fault completes.
>
> That's a an easy way to flag:  you will never get that from a Linux
> filesystem, period.
>
> NVML folks really need to stop taking crack and dreaming this could
> happen.

Well, that's a bummer.

What are the problems here? Is this a matter of existing filesystems
being unable/unwilling to support this or is it just fundamentally
broken? The end goal is to let applications manage the persistence of
their own data without having to involve the kernel in every IOP, but
if we can't do that then what would a 90% solution look like? I think
most people would be OK with having to do an fsync() occasionally, but
not after ever write to pmem.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

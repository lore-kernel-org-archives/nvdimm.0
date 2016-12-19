Return-Path: <linux-nvdimm-bounces@lists.01.org>
Date: Mon, 19 Dec 2016 14:11:49 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: DAX mapping detection (was: Re: [PATCH] Fix region lost in
 /proc/self/smaps)
Message-ID: <20161219211149.GA12822@linux.intel.com>
References: <20160912213435.GD30497@dastard>
 <20160913115311.509101b0@roar.ozlabs.ibm.com>
 <20160914073902.GQ22388@dastard>
 <20160914201936.08315277@roar.ozlabs.ibm.com>
 <20160915023133.GR22388@dastard>
 <20160915134945.0aaa4f5a@roar.ozlabs.ibm.com>
 <20160915103210.GT22388@dastard>
 <20160915214222.505f4888@roar.ozlabs.ibm.com>
 <20160915223350.GU22388@dastard>
 <20160916155405.6b634bbc@roar.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160916155405.6b634bbc@roar.ozlabs.ibm.com>
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
To: Nicholas Piggin <npiggin@gmail.com>, Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>, Jeff Moyer <jmoyer@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Yumei Huang <yuhuang@redhat.com>, Michal Hocko <mhocko@suse.com>, Xiaof Guangrong <guangrong.xiao@linux.intel.com>, KVM list <kvm@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Gleb Natapov <gleb@kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, mtosatti@redhat.com, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Dave Hansen <dave.hansen@intel.com>, Stefan Hajnoczi <stefanha@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Sep 16, 2016 at 03:54:05PM +1000, Nicholas Piggin wrote:
<>
> Definitely the first step would be your simple preallocated per
> inode approach until it is shown to be insufficient.

Reviving this thread a few months later...

Dave, we're interested in taking a serious look at what it would take to get
PMEM_IMMUTABLE working.  Do you still hold the opinion that this is (or could
become, with some amount of work) a workable solution?

We're happy to do the grunt work for this feature, but we will probably need
guidance from someone with more XFS experience.  With you out on extended leave
the first half of 2017, who would be the best person to ask for this guidance?
Darrick?

Thanks,
- Ross
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

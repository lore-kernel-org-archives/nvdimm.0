Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 94CCD1A1E60
 for <linux-nvdimm@lists.01.org>; Thu,  8 Sep 2016 15:56:37 -0700 (PDT)
Date: Thu, 8 Sep 2016 16:56:36 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: DAX mapping detection (was: Re: [PATCH] Fix region lost in
 /proc/self/smaps)
Message-ID: <20160908225636.GB15167@linux.intel.com>
References: <CAPcyv4iDra+mRqEejfGqapKEAFZmUtUcg0dsJ8nt7mOhcT-Qpw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4iDra+mRqEejfGqapKEAFZmUtUcg0dsJ8nt7mOhcT-Qpw@mail.gmail.com>
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
Cc: Yumei Huang <yuhuang@redhat.com>, Michal Hocko <mhocko@suse.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>, KVM list <kvm@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Gleb Natapov <gleb@kernel.org>, mtosatti@redhat.com, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Dave Hansen <dave.hansen@intel.com>, Stefan Hajnoczi <stefanha@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Sep 07, 2016 at 09:32:36PM -0700, Dan Williams wrote:
> [ adding linux-fsdevel and linux-nvdimm ]
> 
> On Wed, Sep 7, 2016 at 8:36 PM, Xiao Guangrong
> <guangrong.xiao@linux.intel.com> wrote:
> [..]
> > However, it is not easy to handle the case that the new VMA overlays with
> > the old VMA
> > already got by userspace. I think we have some choices:
> > 1: One way is completely skipping the new VMA region as current kernel code
> > does but i
> >    do not think this is good as the later VMAs will be dropped.
> >
> > 2: show the un-overlayed portion of new VMA. In your case, we just show the
> > region
> >    (0x2000 -> 0x3000), however, it can not work well if the VMA is a new
> > created
> >    region with different attributions.
> >
> > 3: completely show the new VMA as this patch does.
> >
> > Which one do you prefer?
> >
> 
> I don't have a preference, but perhaps this breakage and uncertainty
> is a good opportunity to propose a more reliable interface for NVML to
> get the information it needs?
> 
> My understanding is that it is looking for the VM_MIXEDMAP flag which
> is already ambiguous for determining if DAX is enabled even if this
> dynamic listing issue is fixed.  XFS has arranged for DAX to be a
> per-inode capability and has an XFS-specific inode flag.  We can make
> that a common inode flag, but it seems we should have a way to
> interrogate the mapping itself in the case where the inode is unknown
> or unavailable.  I'm thinking extensions to mincore to have flags for
> DAX and possibly whether the page is part of a pte, pmd, or pud
> mapping.  Just floating that idea before starting to look into the
> implementation, comments or other ideas welcome...

I think this goes back to our previous discussion about support for the PMEM
programming model.  Really I think what NVML needs isn't a way to tell if it
is getting a DAX mapping, but whether it is getting a DAX mapping on a
filesystem that fully supports the PMEM programming model.  This of course is
defined to be a filesystem where it can do all of its flushes from userspace
safely and never call fsync/msync, and that allocations that happen in page
faults will be synchronized to media before the page fault completes.

IIUC this is what NVML needs - a way to decide "do I use fsync/msync for
everything or can I rely fully on flushes from userspace?" 

For all existing implementations, I think the answer is "you need to use
fsync/msync" because we don't yet have proper support for the PMEM programming
model.

My best idea of how to support this was a per-inode flag similar to the one
supported by XFS that says "you have a PMEM capable DAX mapping", which NVML
would then interpret to mean "you can do flushes from userspace and be fully
safe".  I think we really want this interface to be common over XFS and ext4.

If we can figure out a better way of doing this interface, say via mincore,
that's fine, but I don't think we can detangle this from the PMEM API
discussion.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

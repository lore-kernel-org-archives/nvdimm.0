Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
 [150.101.137.143]) by ml01.01.org (Postfix) with ESMTP id 530B11A1F09
 for <linux-nvdimm@lists.01.org>; Thu, 15 Sep 2016 18:25:02 -0700 (PDT)
Date: Fri, 16 Sep 2016 11:24:59 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 2/3] mm, dax: add VM_DAX flag for DAX VMAs
Message-ID: <20160916012458.GW22388@dastard>
References: <147392246509.9873.17750323049785100997.stgit@dwillia2-desk3.amr.corp.intel.com>
 <147392247875.9873.4205533916442000884.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20160915082615.GA9772@lst.de>
 <CAPcyv4jTw3cXpmmJRh7t16Xy2uYofDe+fJ+X_jnz+Q=o0uGneg@mail.gmail.com>
 <20160915230748.GS30497@dastard>
 <CAPcyv4jvcWEc2TkRh6-MoKb_-1VbFoiKUJEB=svQO+BVN8s-Sg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4jvcWEc2TkRh6-MoKb_-1VbFoiKUJEB=svQO+BVN8s-Sg@mail.gmail.com>
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
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Nicholas Piggin <npiggin@gmail.com>, XFS Developers <xfs@oss.sgi.com>, Linux MM <linux-mm@kvack.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Sep 15, 2016 at 05:16:42PM -0700, Dan Williams wrote:
> On Thu, Sep 15, 2016 at 4:07 PM, Dave Chinner <david@fromorbit.com> wrote:
> > On Thu, Sep 15, 2016 at 10:01:03AM -0700, Dan Williams wrote:
> >> On Thu, Sep 15, 2016 at 1:26 AM, Christoph Hellwig <hch@lst.de> wrote:
> >> > On Wed, Sep 14, 2016 at 11:54:38PM -0700, Dan Williams wrote:
> >> >> The DAX property, page cache bypass, of a VMA is only detectable via the
> >> >> vma_is_dax() helper to check the S_DAX inode flag.  However, this is
> >> >> only available internal to the kernel and is a property that userspace
> >> >> applications would like to interrogate.
> >> >
> >> > They have absolutely no business knowing such an implementation detail.
> >>
> >> Hasn't that train already left the station with FS_XFLAG_DAX?
> >
> > No, that's an admin flag, not a runtime hint for applications. Just
> > because that flag is set on an inode, it does not mean that DAX is
> > actually in use - it will be ignored if the backing dev is not dax
> > capable.
> 
> What's the point of an admin flag if an admin can't do cat /proc/<pid
> of interest>/smaps, or some other mechanism, to validate that the
> setting the admin cares about is in effect?

Sorry, I don't follow - why would you be looking at mapping file
regions in /proc to determine if some file somewhere in a filesystem
has a specific flag set on it or not?

FS_XFLAG_DAX is an inode attribute flag, not something you can
query or administrate through mmap:

I.e.
# xfs_io -c "lsattr" -c "chattr +x" -c lsattr -c "chattr -x" -c "lsattr" foo
 --------------- foo
 --------------x foo
 --------------- foo
#

What happens when that flag is set on an inode is determined by a
whole bunch of other things that are completely separate to the
management of the inode flag itself.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

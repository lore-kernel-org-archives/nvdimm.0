Return-Path: <linux-nvdimm-bounces@lists.01.org>
Date: Thu, 15 Sep 2016 10:09:42 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 2/3] mm, dax: add VM_DAX flag for DAX VMAs
Message-ID: <20160915170942.GJ9314@birch.djwong.org>
References: <147392246509.9873.17750323049785100997.stgit@dwillia2-desk3.amr.corp.intel.com>
 <147392247875.9873.4205533916442000884.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20160915082615.GA9772@lst.de>
 <CAPcyv4jTw3cXpmmJRh7t16Xy2uYofDe+fJ+X_jnz+Q=o0uGneg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4jTw3cXpmmJRh7t16Xy2uYofDe+fJ+X_jnz+Q=o0uGneg@mail.gmail.com>
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
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Nicholas Piggin <npiggin@gmail.com>, XFS Developers <xfs@oss.sgi.com>, Linux MM <linux-mm@kvack.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Sep 15, 2016 at 10:01:03AM -0700, Dan Williams wrote:
> On Thu, Sep 15, 2016 at 1:26 AM, Christoph Hellwig <hch@lst.de> wrote:
> > On Wed, Sep 14, 2016 at 11:54:38PM -0700, Dan Williams wrote:
> >> The DAX property, page cache bypass, of a VMA is only detectable via the
> >> vma_is_dax() helper to check the S_DAX inode flag.  However, this is
> >> only available internal to the kernel and is a property that userspace
> >> applications would like to interrogate.
> >
> > They have absolutely no business knowing such an implementation detail.
> 
> Hasn't that train already left the station with FS_XFLAG_DAX?

Seeing as FS_IOC_FSGETXATTR is a "generic" ioctl now, why not just
implement it for all the DAX fses and block devices?  Aside from xflags,
the other fields are probably all zero for non-xfs (aside from project
quota id I guess).

(Yeah, sort of awkward, I know...)

--D

> The other problem with hiding the DAX property is that it turns out to
> not be a transparent acceleration feature.  See xfs/086 xfs/088
> xfs/089 xfs/091 which fail with DAX and, as far as I understand, it is
> due to the fact that DAX disallows delayed allocation behavior.
> 
> If behavior changes I think we should indicate that to userspace and
> VM_DAX is certainly more useful to userspace than some of the other vm
> internals we already export in those flags.
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9F45A81F1C
 for <linux-nvdimm@lists.01.org>; Thu,  1 Dec 2016 07:44:33 -0800 (PST)
Date: Thu, 1 Dec 2016 08:44:32 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v2 6/6] dax: add tracepoints to dax_pmd_insert_mapping()
Message-ID: <20161201154432.GD5160@linux.intel.com>
References: <1480549533-29038-1-git-send-email-ross.zwisler@linux.intel.com>
 <1480549533-29038-7-git-send-email-ross.zwisler@linux.intel.com>
 <20161201091930.2084d32c@gandalf.local.home>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20161201091930.2084d32c@gandalf.local.home>
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
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <mawilcox@microsoft.com>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Dec 01, 2016 at 09:19:30AM -0500, Steven Rostedt wrote:
> On Wed, 30 Nov 2016 16:45:33 -0700
> Ross Zwisler <ross.zwisler@linux.intel.com> wrote:
> 
> > diff --git a/include/linux/pfn_t.h b/include/linux/pfn_t.h
> > index a3d90b9..033fc7b 100644
> > --- a/include/linux/pfn_t.h
> > +++ b/include/linux/pfn_t.h
> > @@ -15,6 +15,12 @@
> >  #define PFN_DEV (1ULL << (BITS_PER_LONG_LONG - 3))
> >  #define PFN_MAP (1ULL << (BITS_PER_LONG_LONG - 4))
> >  
> > +#define PFN_FLAGS_TRACE \
> > +	{ PFN_SG_CHAIN,	"SG_CHAIN" }, \
> > +	{ PFN_SG_LAST,	"SG_LAST" }, \
> > +	{ PFN_DEV,	"DEV" }, \
> > +	{ PFN_MAP,	"MAP" }
> > +
> >  static inline pfn_t __pfn_to_pfn_t(unsigned long pfn, u64 flags)
> >  {
> >  	pfn_t pfn_t = { .val = pfn | (flags & PFN_FLAGS_MASK), };
> > diff --git a/include/trace/events/fs_dax.h b/include/trace/events/fs_dax.h
> > index 9f0a455..7d0ea33 100644
> > --- a/include/trace/events/fs_dax.h
> > +++ b/include/trace/events/fs_dax.h
> > @@ -104,6 +104,57 @@ DEFINE_EVENT(dax_pmd_load_hole_class, name, \
> >  DEFINE_PMD_LOAD_HOLE_EVENT(dax_pmd_load_hole);
> >  DEFINE_PMD_LOAD_HOLE_EVENT(dax_pmd_load_hole_fallback);
> >  
> > +DECLARE_EVENT_CLASS(dax_pmd_insert_mapping_class,
> > +	TP_PROTO(struct inode *inode, struct vm_area_struct *vma,
> > +		unsigned long address, int write, long length, pfn_t pfn,
> > +		void *radix_entry),
> > +	TP_ARGS(inode, vma, address, write, length, pfn, radix_entry),
> > +	TP_STRUCT__entry(
> > +		__field(dev_t, dev)
> > +		__field(unsigned long, ino)
> > +		__field(unsigned long, vm_flags)
> > +		__field(unsigned long, address)
> > +		__field(int, write)
> 
> Place "write" at the end. The ring buffer is 4 byte aligned, so on
> archs that can access 8 bytes on 4 byte alignment, this will be packed
> tighter. Otherwise, you'll get 4 empty bytes after "write".

Actually I think it may be ideal to stick it as the 2nd entry after 'dev'.
dev_t is:

typedef __u32 __kernel_dev_t;
typedef __kernel_dev_t		dev_t;

So those two 32 bit values should combine into a single 64 bit space.

Thanks for the help, I obviously wasn't considering packing when ordering the
elements.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

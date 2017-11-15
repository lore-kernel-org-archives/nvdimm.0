Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 613DE20356884
 for <linux-nvdimm@lists.01.org>; Wed, 15 Nov 2017 11:12:30 -0800 (PST)
Date: Wed, 15 Nov 2017 12:16:37 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [patch] dax: fix PMD faults on zero-length files
Message-ID: <20171115191637.GA30208@linux.intel.com>
References: <x49y3n8s4o8.fsf@segfault.boston.devel.redhat.com>
 <CAPcyv4gnqfBs9MyZtW0hq9Ffv8N5XXfpDYGP8GzCHnDGXe-EVA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4gnqfBs9MyZtW0hq9Ffv8N5XXfpDYGP8GzCHnDGXe-EVA@mail.gmail.com>
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
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, "Zwisler, Ross  <ross.zwisler@intel.com>, linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Nov 14, 2017 at 05:47:51PM -0800, Dan Williams wrote:
> On Tue, Nov 14, 2017 at 5:37 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
> > PMD faults on a zero length file on a file system mounted with -o dax
> > will not generate SIGBUS as expected.
> >
> >         fd = open(...O_TRUNC);
> >         addr = mmap(NULL, 2*1024*1024, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
> >         *addr = 'a';
> >         <expect SIGBUS>
> >
> > The problem is this code in dax_iomap_pmd_fault:
> >
> >         max_pgoff = (i_size_read(inode) - 1) >> PAGE_SHIFT;
> >
> > If the inode size is zero, we end up with a max_pgoff that is way larger
> > than 0.  :)  Fix it by using DIV_ROUND_UP, as is done elsewhere in the
> > kernel.
> >
> > I tested this with some simple test code that ensured that SIGBUS was
> > received where expected.
> >
> 
> I assume this needs:
> 
>    Fixes: 642261ac995e ("dax: add struct iomap based DAX PMD support")
>    Cc: <stable@vger.kernel.org>
> 
> ...otherwise looks good to me.

Yep, this fix looks good, thanks.  You can add:

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com
 [148.163.158.5])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B0190207DF2BF
 for <linux-nvdimm@lists.01.org>; Fri,  1 Jun 2018 08:01:14 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
 by mx0b-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id
 w51EwkgT123305
 for <linux-nvdimm@lists.01.org>; Fri, 1 Jun 2018 11:01:12 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
 by mx0b-001b2d01.pphosted.com with ESMTP id 2jb678xeam-1
 (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
 for <linux-nvdimm@lists.01.org>; Fri, 01 Jun 2018 11:01:11 -0400
Received: from localhost
 by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
 Violators will be prosecuted
 for <linux-nvdimm@lists.01.org> from <gerald.schaefer@de.ibm.com>;
 Fri, 1 Jun 2018 16:01:08 +0100
Date: Fri, 1 Jun 2018 17:01:00 +0200
From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Subject: Re: [PATCH v10] mm: introduce MEMORY_DEVICE_FS_DAX and
 CONFIG_DEV_PAGEMAP_OPS
In-Reply-To: <CAPcyv4gRvG=yT==SPgF940F7v9FqGqG-dQ8Vjcm0LPch86i1RA@mail.gmail.com>
References: <152658753673.26786.16458605771414761966.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180518094616.GA25838@lst.de>
 <CAPcyv4iO1yss0sfBzHVDy3qja_wc+JT2Zi1zwtApDckTeuG2wQ@mail.gmail.com>
 <20180521090410.7ygosxzjfhceqrq4@quack2.suse.cz>
 <20180522062806.GD7816@lst.de> <20180523205017.0f2bc83e@thinkpad>
 <CAPcyv4gRvG=yT==SPgF940F7v9FqGqG-dQ8Vjcm0LPch86i1RA@mail.gmail.com>
MIME-Version: 1.0
Message-Id: <20180601170100.0a8e5567@thinkpad>
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
Cc: Michal Hocko <mhocko@suse.com>, Jan Kara <jack@suse.cz>, kbuild test robot <lkp@intel.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, Linux MM <linux-mm@kvack.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, =?UTF-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Christoph Hellwig <hch@lst.de>, Thomas Meyer <thomas@m3y3r.de>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, 29 May 2018 13:26:33 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> On Wed, May 23, 2018 at 11:50 AM, Gerald Schaefer
> <gerald.schaefer@de.ibm.com> wrote:
> > On Tue, 22 May 2018 08:28:06 +0200
> > Christoph Hellwig <hch@lst.de> wrote:
> >  
> >> On Mon, May 21, 2018 at 11:04:10AM +0200, Jan Kara wrote:  
> >> > We definitely do have customers using "execute in place" on s390x from
> >> > dcssblk. I've got about two bug reports for it when customers were updating
> >> > from old kernels using original XIP to kernels using DAX. So we need to
> >> > keep that working.  
> >>
> >> That is all good an fine, but I think time has come where s390 needs
> >> to migrate to provide the pmem API so that we can get rid of these
> >> special cases.  Especially given that the old XIP/legacy DAX has all
> >> kinds of known bugs at this point in time.  
> >
> > I haven't yet looked at this patch series, but I can feel that this
> > FS_DAX_LIMITED workaround is beginning to cause some headaches, apart
> > from being quite ugly of course.
> >
> > Just to make sure I still understand the basic problem, which I thought
> > was missing struct pages for the dcssblk memory, what exactly do you
> > mean with "provide the pmem API", is there more to do?  
> 
> No, just 'struct page' is needed.
> 
> What used to be the pmem API is now pushed down into to dax_operations
> provided by the device driver. dcssblk is free to just redirect to the
> generic implementations for copy_from_iter() and copy_to_iter(), and
> be done. I.e. we've removed the "pmem API" requirement.
> 
> > I do have a prototype patch lying around that adds struct pages, but
> > didn't yet have time to fully test/complete it. Of course we initially
> > introduced XIP as a mechanism to reduce memory consumption, and that
> > is probably the use case for the remaining customer(s). Adding struct
> > pages would somehow reduce that benefit, but as long as we can still
> > "execute in place", I guess it will be OK.  
> 
> The pmem driver has the option to allocate the 'struct page' map out
> of pmem directly. If the overhead of having the map in System RAM is
> too high it could borrow the same approach, but that adds another
> degree of configuration complexity freedom.
> 

Thanks for clarifying, and mentioning the pmem altmap support, that
looks interesting. I also noticed that I probably should enable
CONFIG_ZONE_DEVICE for s390, and use devm_memremap_pages() to get
the struct pages, rather than my homegrown solution so far. This will
take some time however, so I hope you can live with the FS_DAX_LIMITED
a little longer.

Regards,
Gerald

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

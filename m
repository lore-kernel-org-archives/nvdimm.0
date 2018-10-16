Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DA3FB211799CF
 for <linux-nvdimm@lists.01.org>; Tue, 16 Oct 2018 01:25:42 -0700 (PDT)
Date: Tue, 16 Oct 2018 10:25:40 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: Problems with VM_MIXEDMAP removal from /proc/<pid>/smaps
Message-ID: <20181016082540.GA18918@quack2.suse.cz>
References: <20181002100531.GC4135@quack2.suse.cz>
 <x49woqqykgi.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <x49woqqykgi.fsf@segfault.boston.devel.redhat.com>
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
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-nvdimm@lists.01.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>
List-ID: <linux-nvdimm@lists.01.org>

Hi Jeff,

On Tue 09-10-18 15:43:41, Jeff Moyer wrote:
> Jan Kara <jack@suse.cz> writes:
> > commit e1fb4a086495 "dax: remove VM_MIXEDMAP for fsdax and device dax" has
> > removed VM_MIXEDMAP flag from DAX VMAs. Now our testing shows that in the
> > mean time certain customer of ours started poking into /proc/<pid>/smaps
> > and looks at VMA flags there and if VM_MIXEDMAP is missing among the VMA
> > flags, the application just fails to start complaining that DAX support is
> > missing in the kernel. The question now is how do we go about this?
> >
> > Strictly speaking, this is a userspace visible regression (as much as I
> > think that application poking into VMA flags at this level is just too
> > bold). Is there any precedens in handling similar issues with smaps which
> > really exposes a lot of information that is dependent on kernel
> > implementation details?
> >
> > I have attached a patch that is an obvious "fix" for the issue - just fake
> > VM_MIXEDMAP flag in smaps. But I'm open to other suggestions...
> 
> I'm intrigued by the use case.  Do I understand you correctly that the
> database in question does not intend to make data persistent from
> userspace?  In other words, fsync/msync system calls are being issued by
> the database?

Yes, at least at the initial stage, they use fsync / msync to persist data.

> I guess what I'm really after is a statement of requirements or
> expectations.  It would be great if you could convince the database
> developer to engage in this discussion directly.

So I talked to them and what they really look after is the control over the
amount of memory needed by the kernel. And they are right that if your
storage needs page cache, the amount of memory you need to set aside for the
kernel is larger.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6020021959CB2
 for <linux-nvdimm@lists.01.org>; Tue,  2 Oct 2018 08:31:02 -0700 (PDT)
Date: Tue, 2 Oct 2018 17:31:00 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: Problems with VM_MIXEDMAP removal from /proc/<pid>/smaps
Message-ID: <20181002153100.GG9127@quack2.suse.cz>
References: <20181002100531.GC4135@quack2.suse.cz>
 <20181002121039.GA3274@linux-x5ow.site>
 <20181002142959.GD9127@quack2.suse.cz>
 <20181002143713.GA19845@infradead.org>
 <20181002144412.GC4963@linux-x5ow.site>
 <20181002145206.GA10903@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20181002145206.GA10903@infradead.org>
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
Cc: linux-nvdimm@lists.01.org, linux-api@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue 02-10-18 07:52:06, Christoph Hellwig wrote:
> On Tue, Oct 02, 2018 at 04:44:13PM +0200, Johannes Thumshirn wrote:
> > On Tue, Oct 02, 2018 at 07:37:13AM -0700, Christoph Hellwig wrote:
> > > No, it should not.  DAX is an implementation detail thay may change
> > > or go away at any time.
> > 
> > Well we had an issue with an application checking for dax, this is how
> > we landed here in the first place.
> 
> So what exacty is that "DAX" they are querying about (and no, I'm not
> joking, nor being philosophical).

I believe the application we are speaking about is mostly concerned about
the memory overhead of the page cache. Think of a machine that has ~ 1TB of
DRAM, the database running on it is about that size as well and they want
database state stored somewhere persistently - which they may want to do by
modifying mmaped database files if they do small updates... So they really
want to be able to use close to all DRAM for the DB and not leave slack
space for the kernel page cache to cache 1TB of database files.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

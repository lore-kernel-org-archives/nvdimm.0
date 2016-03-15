Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AFC251A1DF1
 for <linux-nvdimm@lists.01.org>; Tue, 15 Mar 2016 02:50:51 -0700 (PDT)
Date: Tue, 15 Mar 2016 10:50:56 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 05/12] dax: Remove synchronization using i_mmap_lock
Message-ID: <20160315095056.GE17942@quack.suse.cz>
References: <1457637535-21633-1-git-send-email-jack@suse.cz>
 <1457637535-21633-6-git-send-email-jack@suse.cz>
 <100D68C7BA14664A8938383216E40DE0422079E9@FMSMSX114.amr.corp.intel.com>
 <20160310200501.GA23203@quack.suse.cz>
 <100D68C7BA14664A8938383216E40DE042207AA9@FMSMSX114.amr.corp.intel.com>
 <20160314100128.GB6801@quack.suse.cz>
 <100D68C7BA14664A8938383216E40DE0422086AA@FMSMSX114.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <100D68C7BA14664A8938383216E40DE0422086AA@FMSMSX114.amr.corp.intel.com>
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
To: "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>
Cc: Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, NeilBrown <neilb@suse.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon 14-03-16 14:51:26, Wilcox, Matthew R wrote:
> I think the ultimate goal here has to be to have the truncate code lock
> the DAX entry in the radix tree and delete it.  Then we can have
> do_cow_fault() unlock the radix tree entry instead of the i_mmap_lock.
> So we'll need another element in struct vm_fault where we can pass back a
> pointer into the radix tree instead of a pointer to struct page (or add
> another bit to VM_FAULT_ that indicates that 'page' is not actually a
> page, but a pointer to an exceptional entry ... or have the MM code
> understand the exceptional bit ... there's a few ways we can go here).

Yes, with my last patch truncate already waits for lock in radix tree. And
I was looking into various ways how to cleanly handle cow faults using
the radix tree lock instead of i_mmap_lock. So far it's a bit hacky to my
taste but I agree we want to fix the race that way.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

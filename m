Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B5B3D1A1F2F
 for <linux-nvdimm@lists.01.org>; Thu, 31 Mar 2016 01:54:50 -0700 (PDT)
Date: Thu, 31 Mar 2016 10:54:49 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 12/12] dax: New fault locking
Message-ID: <20160331085449.GB11041@quack.suse.cz>
References: <1457637535-21633-1-git-send-email-jack@suse.cz>
 <1457637535-21633-13-git-send-email-jack@suse.cz>
 <87h9gdj3dt.fsf@notabene.neil.brown.name>
 <87egbbh1cr.fsf@notabene.neil.brown.name>
 <20160318141618.GF7152@quack.suse.cz>
 <20160318153919.GG7152@quack.suse.cz>
 <87h9fycj71.fsf@notabene.neil.brown.name>
 <20160323110011.GD4512@quack.suse.cz>
 <87oa9vs2hb.fsf@notabene.neil.brown.name>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87oa9vs2hb.fsf@notabene.neil.brown.name>
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
To: NeilBrown <neilb@suse.com>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, Wilcox,
List-ID: <linux-nvdimm@lists.01.org>

On Thu 31-03-16 15:20:00, NeilBrown wrote:
> On Wed, Mar 23 2016, Jan Kara wrote:
> 
> > On Wed 23-03-16 08:10:42, NeilBrown wrote:
> >> On Sat, Mar 19 2016, Jan Kara wrote:
> >> >
> >> > Actually, after some thought I don't think the wakeup is needed except for
> >> > dax_pfn_mkwrite(). In the other cases we know there is no radix tree
> >> > exceptional entry and thus there can be no waiters for its lock...
> >> >
> >> 
> >> I think that is fragile logic - though it may be correct at present.
> >> 
> >> A radix tree slot can transition from "Locked exception" to "unlocked
> >> exception" to "deleted" to "struct page".
> >
> > Yes.
> >  
> >> So it is absolutely certain that a thread cannot go to sleep after
> >> finding a "locked exception" and wake up to find a "struct page" ??
> >
> > With current implementation this should not happen but I agree entry
> > locking code should not rely on this.
> >
> >> How about a much simpler change.
> >>  - new local variable "slept" in lookup_unlocked_mapping_entry() which
> >>    is set if prepare_to_wait_exclusive() gets called.
> >>  - if after __radix_tree_lookup() returns:
> >>         (ret==NULL || !radix_tree_exceptional_entry(ret)) && slept
> >>    then it calls wakeup immediately - because if it was waiting,
> >>    something else might be to.
> >> 
> >> That would cover all vaguely possible cases except dax_pfn_mkwrite()
> >
> > But how does this really help? If lookup_unlocked_mapping_entry() finds
> > there is no entry (and it was there before), the process deleting the entry
> > (or replacing it with something else) is responsible for waking up
> > everybody.
> 
> "everybody" - yes.  But it doesn't wake everybody does it?  It just
> wakes one.
> 
> +		__wake_up(wq, TASK_NORMAL, 1, &key);
>                                            ^one!
> 
> Or am I misunderstanding how exclusive waiting works?

Ah, OK. I have already fixed that in my local version of the patches so
that we wake-up everybody after deleting the entry but forgot to tell you.
So I have there now:

		__wake_up(wq, TASK_NORMAL, 0, &key);

Are you OK with the code now?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

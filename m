Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4669A7B
	for <nvdimm@lists.linux.dev>; Thu, 14 Apr 2022 10:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=FagVOCAdPGA+381Kj/Nm3Sxk6Ckgd4+fNuRTxmXiy0w=; b=HsggkXdqaaPxCcyrEuhB66VTjT
	Ot+3AWOP0xNbxTF0Dowad3c5+R6GvWUIR0moxrUOzmdsd6zG3FtvEKVHKiGsaiVau/LLxaQLle5TP
	u+Hoi17jLg1VuejYnadsmrcbHVFmlnDLJpW7UAX+LAeYBk7wASvWnGIVPveQA3krWso31min5A9/r
	G75adrVnpqTdwv4QQ5K666Vh6NAmhV73Rg6Mr5Dk4Rj3UmtqeKZFB7WXUfwllCI7eRucBXCIvUVr3
	fZs3TTFUKb6952Y+5khghwXRdVaKYq+mMXqF7G9yEPB2eOKeEtjn7MddosKsY97e86W9Gn9PoQKJQ
	J4IF57fA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1newWV-00F23q-OW; Thu, 14 Apr 2022 10:16:23 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id C7FC930027B;
	Thu, 14 Apr 2022 12:16:21 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
	id A83E92B347F3C; Thu, 14 Apr 2022 12:16:21 +0200 (CEST)
Date: Thu, 14 Apr 2022 12:16:21 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-cxl@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Dave Jiang <dave.jiang@intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Vishal L Verma <vishal.l.verma@intel.com>,
	"Schofield, Alison" <alison.schofield@intel.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux NVDIMM <nvdimm@lists.linux.dev>
Subject: Re: [PATCH v2 02/12] device-core: Add dev->lock_class to enable
 device_lock() lockdep validation
Message-ID: <Ylf0dewci8myLvoW@hirez.programming.kicks-ass.net>
References: <164982968798.684294.15817853329823976469.stgit@dwillia2-desk3.amr.corp.intel.com>
 <164982969858.684294.17819743973041389492.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20220413084309.GV2731@worktop.programming.kicks-ass.net>
 <CAPcyv4huZVNkxa7-rQ_J=nVN77+5F1AJg5vi6kLHp8t5khcwHA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4huZVNkxa7-rQ_J=nVN77+5F1AJg5vi6kLHp8t5khcwHA@mail.gmail.com>

On Wed, Apr 13, 2022 at 03:01:21PM -0700, Dan Williams wrote:

> > That's not an obvious conclusion; lockdep has lots of funny annotations,
> > subclasses is just one.
> >
> > I think the big new development in lockdep since that time with Alan
> > Stern is that lockdep now has support for dynamic keys; that is lock
> > keys in heap memory (as opposed to static storage).
> 
> Ah, I was not aware of that, that should allow for deep cleanups of
> this proposal.

> > If you want lockdep validation for one (or more) dev->mutex instances,
> > why not pull them out of the no_validate class and use the normal
> > locking?
> 
> Sounds perfect, just didn't know how to do that with my current
> understanding of how to communicate this to lockdep.
> 
> >
> > This is all quite insane.
> 
> Yes, certainly in comparison to your suggestion on the next patch.
> That looks much more sane, and even better I think it allows for
> optional lockdep validation without even needing to touch
> include/linux/device.h.

Right, so lockdep has:

 - classes, based off of lock_class_key address;

   * lock_class_key should be static storage; except now we also have:

       lockdep_{,un}register_key()

     which allows dynamic memory (aka. heap) to be used for classes,
     important to note that lockdep memory usage is still static storage
     because the memory allocators use locks too. So if you register too
     many dynamic keys, you'll run out of lockdep memory etc.. so be
     careful.

   * things like mutex_init() have a static lock_class_key per site
     and hence every lock initialized by the same code ends up in the
     same class by default.

   * can be trivially changed at any time, assuming the lock isn't held,
     using lockdep_set_class*() family.

     (extensively used all over the kernel, for example by the vfs to
      give each filesystem type their own locking order rules)

   * lockdep_set_no_validate_class() is a magical variant of
     lockdep_set_class() that sets a magical lock_class_key.

   * can be changed while held using lock_set_class()

     ( from a lockdep pov it unlocks the held stack,
       changes the class of your lock, and re-locks the
       held stack, now with a different class nesting ).

     Be carefule! It doesn't forget the old nesting order, so you
     can trivally generate cycles.

 - subclasses, basically distinct addresses inside above mentioned
   lock_class_key object, limited to 8. Normally used with
   *lock_nested() family of functions. Typically used to lock multiple
   instances of a single lock class where there is defined order between
   instances (see for instance: double_rq_lock()).

 - nest_lock; eg. mutex_lock_nest_lock(), which allows expressing things
   like: multiple locks of class A can be taken in any order, provided
   we hold lock B.

With many of these, it's possible to get it wrong and annotate real
deadlocks away, so be careful :-)

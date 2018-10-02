Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A95DF21161211
 for <linux-nvdimm@lists.01.org>; Tue,  2 Oct 2018 08:01:31 -0700 (PDT)
Date: Tue, 2 Oct 2018 17:01:24 +0200
From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: Problems with VM_MIXEDMAP removal from /proc/<pid>/smaps
Message-ID: <20181002150123.GD4963@linux-x5ow.site>
References: <20181002100531.GC4135@quack2.suse.cz>
 <20181002121039.GA3274@linux-x5ow.site>
 <20181002142010.GB4963@linux-x5ow.site>
 <20181002144547.GA26735@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20181002144547.GA26735@infradead.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, mhocko@suse.cz, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Oct 02, 2018 at 07:45:47AM -0700, Christoph Hellwig wrote:
> How does an application "make use of DAX"?  What actual user visible
> semantics are associated with a file that has this flag set?

There may not be any user visible semantics of DAX, but there are
promises we gave to application developers praising DAX as _the_
method to map data on persistent memory and get around "the penalty of
the page cache" (however big this is).

As I said in another mail to this thread, applications have started to
poke in procfs to see whether they can use DAX or not.

Party A has promised party B something and they started checking for
it, then commit e1fb4a086495 "dax: remove VM_MIXEDMAP for fsdax and
device dax" removed the way they checked if the kernel can keep up
with this promise.

So technically e1fb4a086495 is a user visible regression and in the
past we have reverted patches introducing these, even if the patch is
generally correct and poking in /proc/self/smaps is a bad idea.

I just wanted to give them a documented way to check for this
promise. Being neutral if this promise is right or wrong, good or bad,
or whatever. That's not my call, but I prefer not having angry users,
yelling at me because of broken applications.

Byte,
	Johannes
-- =

Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

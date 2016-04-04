Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1D6C01A1F75
 for <linux-nvdimm@lists.01.org>; Mon,  4 Apr 2016 05:09:16 -0700 (PDT)
Date: Mon, 4 Apr 2016 14:09:49 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 4/5] dax: use sb_issue_zerout instead of calling
 dax_clear_sectors
Message-ID: <20160404120949.GH8372@quack.suse.cz>
References: <1458861450-17705-1-git-send-email-vishal.l.verma@intel.com>
 <1458861450-17705-5-git-send-email-vishal.l.verma@intel.com>
 <CAPcyv4iKK=1Nhz4QqEkhc4gum+UvUS4a=+Sza2zSa1Kyrth41w@mail.gmail.com>
 <1458939796.5501.8.camel@intel.com>
 <CAPcyv4jWqVcav7dQPh7WHpqB6QDrCezO5jbd9QW9xH3zsU4C1w@mail.gmail.com>
 <1459195288.15523.3.camel@intel.com>
 <CAPcyv4jFwh679arTNoUzLZpJCSoR+KhMdEmwqddCU1RWOrjD=Q@mail.gmail.com>
 <1459277829.6412.3.camel@intel.com>
 <20160330074926.GC12776@quack.suse.cz>
 <1459538265.23200.8.camel@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1459538265.23200.8.camel@intel.com>
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
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc: "axboe@fb.com" <axboe@fb.com>, "jack@suse.cz" <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "david@fromorbit.com" <david@fromorbit.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, Wilcox,
List-ID: <linux-nvdimm@lists.01.org>

On Fri 01-04-16 19:17:52, Verma, Vishal L wrote:
> On Wed, 2016-03-30 at 09:49 +0200, Jan Kara wrote:
> > On Tue 29-03-16 18:57:16, Verma, Vishal L wrote:
> > > =

> > > On Mon, 2016-03-28 at 16:34 -0700, Dan Williams wrote:
> > > =

> > > <>
> > > =

> > > > =

> > > > Seems kind of sad to fail the fault due to a bad block when we
> > > > were
> > > > going to zero it anyway, right?=A0=A0I'm not seeing a compelling
> > > > reason to
> > > > keep any zeroing in fs/dax.c.
> > > Agreed - but how do we do this? clear_pmem needs to be able to clear
> > > an
> > > arbitrary number of bytes, but to go through the driver, we'd need
> > > to
> > > send down a bio? If only the driver had an rw_bytes like interface
> > > that
> > > could be used by anyone... :)
> > Actually, my patches for page fault locking remove zeroing from
> > dax_insert_mapping() and __dax_pmd_fault() - the zeroing now happens
> > from
> > the filesystem only and the zeroing in those two functions is just a
> > dead
> > code...
> =

> That should make things easier! Do you have a tree I could merge in to
> get this? (WIP is ok as we know that my series will depend on yours..)
> or, if you can distill out that patch on a 4.6-rc1 base, I could carry
> it in my series too (your v2's 3/10 doesn't apply on 4.6-rc1..)

I'll CC you on the next posting of the series which I want to do this week.

								Honza

-- =

Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

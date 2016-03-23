Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8A5871A1E69
 for <linux-nvdimm@lists.01.org>; Wed, 23 Mar 2016 02:45:50 -0700 (PDT)
Date: Wed, 23 Mar 2016 10:45:51 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC v2] [PATCH 0/10] DAX page fault locking
Message-ID: <20160323094551.GA4512@quack.suse.cz>
References: <1458566575-28063-1-git-send-email-jack@suse.cz>
 <20160322193212.GA11164@linux.intel.com>
 <1458680853.6393.592.camel@hpe.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1458680853.6393.592.camel@hpe.com>
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
To: Toshi Kani <toshi.kani@hpe.com>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, NeilBrown <neilb@suse.com>, brian.boylston@hpe.com, Wilcox,
List-ID: <linux-nvdimm@lists.01.org>

On Tue 22-03-16 15:07:33, Toshi Kani wrote:
> On Tue, 2016-03-22 at 13:32 -0600, Ross Zwisler wrote:
> > On Mon, Mar 21, 2016 at 02:22:45PM +0100, Jan Kara wrote:
> > > [Sorry for repost but I accidentally sent initial email without
> > > patches]
> > > =

> > > Hello,
> > > =

> > > this is my second attempt at DAX page fault locking rewrite. Things n=
ow
> > > work reasonably well, it has survived full xfstests run on ext4. I
> > > guess I need to do more mmap targetted tests to unveil issues. Guys
> > > what do you used for DAX testing?
> > =

> > I typically use xfstests for regression testing.=A0=A0If we can come up=
 with
> > new generally useful regression tests, especially ones concerning mmap
> > races, that would be awesome.=A0=A0I guess it's just a choice between a=
dding
> > them somewhere in xfstests or somewhere else like with the unit tests in
> > ndctl.
> =

> Brian Boylston wrote a test for mmap race conditions and posted it before.
> =A0This test was very useful to fix the data corruption issue we had befo=
re.
> http://www.spinics.net/lists/linux-ext4/msg49876.html
> =

> If there is anything we can do to make this test useful as regression
> tests?

Thanks for the pointer, I forgot about this useful test. As Dave said the
best way for this to not get lost is to include it in xfstests. Since I
want to run the test regularly anyway, I can integrate it myself.

								Honza
-- =

Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

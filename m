Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CA1711A1DEF
 for <linux-nvdimm@lists.01.org>; Thu, 27 Oct 2016 21:13:01 -0700 (PDT)
Date: Thu, 27 Oct 2016 22:13:00 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: Infinite loop with DAX PMD faults
Message-ID: <20161028041300.GA12061@linux.intel.com>
References: <20161027190750.GA28888@quack2.suse.cz>
 <CAPcyv4gS3LwAq77t31aRCxuHu9UeC4axJbQmxS-JQJzBVV=GmQ@mail.gmail.com>
 <20161027210343.GA12217@linux.intel.com>
 <1477604810.20881.104.camel@hpe.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1477604810.20881.104.camel@hpe.com>
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
To: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "jack@suse.cz" <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Oct 27, 2016 at 09:48:41PM +0000, Kani, Toshimitsu wrote:
> On Thu, 2016-10-27 at 15:03 -0600, Ross Zwisler wrote:
> > On Thu, Oct 27, 2016 at 12:46:32PM -0700, Dan Williams wrote:
> > > =

> > > On Thu, Oct 27, 2016 at 12:07 PM, Jan Kara <jack@suse.cz> wrote:
> > > > =

> > > > Hello,
> > > > =

> > > > When testing my DAX patches rebased on top of Ross' DAX PMD
> > > > series, I've come across the following issue with generic/344
> > > > test from xfstests. The test ends in an infinite fault loop when
> > > > we fault index 0 over and over again never finishing the fault.
> > > > The problem is that we do a write fault
> > > > for index 0 when there is PMD for that index. So we enter
> > > > wp_huge_pmd(). For whatever reason that returns VM_FAULT_FALLBACK
> > > > so we continue to handle_pte_fault(). There we do
> > > > =

> > > > =A0=A0=A0=A0=A0=A0=A0=A0if (pmd_trans_unstable(vmf->pmd) || pmd_dev=
map(*vmf-
> > > > >pmd))
> > > > =

> > > > check which is true - the PMD we have is pmd_trans_huge() - so we
> > > > 'return 0' and that results in retrying the fault and all happens
> > > > from the beginning again.
> > > > =

> > > > It isn't quite obvious how to break that cycle to me. The comment
> > > > before pmd_none_or_trans_huge_or_clear_bad() goes to great
> > > > lengths explaining possible races when PMD is pmd_trans_huge() so
> > > > it needs careful evaluation what needs to be done for DAX. Ross,
> > > > any idea?
> > > =

> > > Can you bisect it with CONFIG_BROKEN removed from older kernels?
> > > =

> > > I remember tracking down something like this when initially doing
> > > the pmd support.=A0=A0It ended up being a missed pmd_devmap() check in
> > > the fault path, so it may not be the same issue.=A0=A0It would at lea=
st
> > > be interesting to see if 4.6 fails in a similar manner with this
> > > test and FS_DAX_PMD enabled.
> > =

> > I've been able to reproduce this with my v4.9-rc2 branch, but it
> > doesn't reproduce with the old v4.6 kernel.
> =

> Not sure if it's relevant, but as FYI I fixed a similar issue before.
> =

> commit 59bf4fb9d386601cbaa70a9b00159abb846dedaa
> dax: Split pmd map when fallback on COW
> =

> -Toshi

Thanks!  Applying a similar patch solves this deadlock.  Unfortunately I do=
n't
(yet?) understand this well enough to say whether this is the correct
solution, but it makes generic/344 + PMDs pass. :)

Does anyone with more mm knowledge have time to review?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

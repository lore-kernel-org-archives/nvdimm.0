Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-wr0-x241.google.com (mail-wr0-x241.google.com
 [IPv6:2a00:1450:400c:c0c::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0787E21DF969E
 for <linux-nvdimm@lists.01.org>; Thu, 27 Jul 2017 01:48:44 -0700 (PDT)
Received: by mail-wr0-x241.google.com with SMTP id y67so23045487wrb.3
 for <linux-nvdimm@lists.01.org>; Thu, 27 Jul 2017 01:50:47 -0700 (PDT)
Date: Thu, 27 Jul 2017 10:50:43 +0200
From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 3/4] ndctl: switch to tools/include/linux/{kernel, list,
 bitmap}.h
Message-ID: <20170727085043.74b4jpgv2yhzzhee@gmail.com>
References: <150102217021.2258.1380624380896006.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150102218643.2258.15362632812220627446.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170725235512.GC23846@kernel.org>
 <CAPcyv4g1V=1E-cOzHabZswwVGmJGQUNSYxnSyOtwxo79eRYyNw@mail.gmail.com>
 <20170726112935.a4ztsb6yke7bhsvo@gmail.com>
 <CAPcyv4gjMWz814BSdmmM=MEJAuJ3bkJhM9pcdgVK+XW0hMJ9ng@mail.gmail.com>
 <20170726171952.frohvqpekfx4iefn@gmail.com>
 <CAPcyv4jr4cvs9DSQctrbKo61AxBkGe-S=bUS9+_ce_PbXXpCYw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4jr4cvs9DSQctrbKo61AxBkGe-S=bUS9+_ce_PbXXpCYw@mail.gmail.com>
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
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Peter Zijlstra <peterz@infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>


* Dan Williams <dan.j.williams@intel.com> wrote:

> On Wed, Jul 26, 2017 at 10:19 AM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > * Dan Williams <dan.j.williams@intel.com> wrote:
> >
> >> On Wed, Jul 26, 2017 at 4:29 AM, Ingo Molnar <mingo@kernel.org> wrote:
> >> >
> >> > * Dan Williams <dan.j.williams@intel.com> wrote:
> >> >
> >> >> On Tue, Jul 25, 2017 at 4:55 PM, Arnaldo Carvalho de Melo
> >> >> <acme@kernel.org> wrote:
> >> >> > Em Tue, Jul 25, 2017 at 03:36:26PM -0700, Dan Williams escreveu:
> >> >> >> Replace the ccan implementation of list primitives, bitmap helpers and
> >> >> >> small utility macros with the common definitions available in
> >> >> >> tool/include/linux.
> >> >> >
> >> >> > You should first add what you need in separate patches, paving the way
> >> >> > to then use it, and some stuff are already there, see below:
> >> >>
> >> >> Ok, I'll break out those changes separately.
> >> >
> >> > BTW., another general observation I have is that ndctl uses autotools - while perf
> >> > uses its own build system, some of which is abstracted out into tools/build/ and
> >> > reused by other tooling projects as well.
> >> >
> >> > I despise autotools with a passion, it's slow, bloated, and encourages all sorts
> >> > of bad API/ABI practices that plagues many OSS projects. I know that Linus
> >> > explicitly did a Makefile based build system for Git for (I think) similar
> >> > reasons.
> >> >
> >> > It might be a good idea to not let autotools into the kernel tooling tree, not
> >> > because ndctl's use of autotools is bad in any fashion (it appears to be a fairly
> >> > straightforward use), but to generally encourage good API/ABI practices in our
> >> > tooling space, and to encourage enhancements to the tools/build/ infrastructure.
> >>
> >> That's a fair point. Regardless, autotools will be in the git history,
> >> but if you'd like to see the final merge product eliminate its use, I
> >> can't really argue otherwise. I was originally not concerned because
> >> tools/usb/usbip/ was an existing in tree autotools user. In any event
> >> if you want the autotools removal to be done out-of-tree I'll need to
> >> put this effort on the back burner until 4.15.
> >
> > So that was another thing I wanted to suggest: why not import the current ndctl
> > version as a single commit?
> >
> > I had a quick look, and there's quite a few of commits in the ndctl history that
> > don't conform to kernel standards, such as:
> >
> >   ce881c1e78f6: ndctl: seed tracking
> >
> > which doesn't have any Signed-off-by tags.
> >
> > There's also commits with ambiguous titles that would be confusing in the kernel
> > context - for example:
> >
> >   796b6f373dec: clarify copyright and license information
> >
> > ... which on the surface could be misunderstood as something talking about the
> > kernel copyright ...
> >
> > Or:
> >
> >   e38bd36e5d0a: completion: updates for file name completion
> >
> > which I could initially mistake for a commit about scheduler completions ;-)
> >
> > Or:
> >
> >   2ad6a39c9ae9: Fix attribute sizes to match NFIT 0.8s2
> >   cc7cb44385d3: Import initial infrastructure
> >
> > etc.
> >
> > I suppose all that could be corrected, SOBs added, titles clarified and prefixed
> > with tools/ndctl, but then it wouldn't really be unmodified history anymore,
> > right?
> >
> > At that point we might as well do a clean start - and not import ~500 extra
> > commits into the kernel tree?
> 
> I think keeping the history is worth it, similar reasoning to why we
> kept the btrfs history.

Well, there's two key differences:

 - btrfs _is_ kernel code and as such was developed as a kernel module,
   albeit out of tree. ndctl is a standalone tooling project.

 - all the old btrfs commit titles are either prefixed with 'btrfs:', or have it
   as a string in the title, which made the merge unproblematic and unambiguous.

> [...] Also, since the history is linear and already rewritten by 'git 
> filter-branch' to move everything to tools/ndctl/ it wouldn't be that much more 
> work to go clean up these few commits that are problematic.

So I think that's where to draw the line - grafting two kernel tree commit 
histories like for btrfs might be OK (just the repositories were incompatible), 
but if commit logs need to be rewritten manually then that's essentially 
whitewashing of history - which is a big no-no in Git flows.

Anyway, it's up to Linus I guess.

Thanks,

	Ingo
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

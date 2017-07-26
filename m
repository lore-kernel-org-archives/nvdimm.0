Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C266A21D091AF
 for <linux-nvdimm@lists.01.org>; Wed, 26 Jul 2017 10:55:46 -0700 (PDT)
Date: Wed, 26 Jul 2017 14:57:39 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: Re: [PATCH 3/4] ndctl: switch to tools/include/linux/{kernel, list,
 bitmap}.h
Message-ID: <20170726175739.GF23846@kernel.org>
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
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Peter Zijlstra <peterz@infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, Ingo Molnar <mingo@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

Em Wed, Jul 26, 2017 at 10:31:48AM -0700, Dan Williams escreveu:
> On Wed, Jul 26, 2017 at 10:19 AM, Ingo Molnar <mingo@kernel.org> wrote:
> > * Dan Williams <dan.j.williams@intel.com> wrote:
> >> On Wed, Jul 26, 2017 at 4:29 AM, Ingo Molnar <mingo@kernel.org> wrote:
> > which I could initially mistake for a commit about scheduler completions ;-)
> >
> > Or:

> >   2ad6a39c9ae9: Fix attribute sizes to match NFIT 0.8s2
> >   cc7cb44385d3: Import initial infrastructure

> > etc.

> > I suppose all that could be corrected, SOBs added, titles clarified and prefixed
> > with tools/ndctl, but then it wouldn't really be unmodified history anymore,
> > right?

> > At that point we might as well do a clean start - and not import ~500 extra
> > commits into the kernel tree?
 
> I think keeping the history is worth it, similar reasoning to why we
> kept the btrfs history. Also, since the history is linear and already
> rewritten by 'git filter-branch' to move everything to tools/ndctl/ it
> wouldn't be that much more work to go clean up these few commits that
> are problematic.

Hey, but we can have something like:

https://git.kernel.org/pub/scm/linux/kernel/git/history/history.git/

It goes all the way to the 0.12 kernel.

If someone wants to go that far, just clone that tree, merge it, etc.

Could that be the solution for this case as well?

I.e. the kernel history prior to what we have in linux.git can be
accessed via that other tree, history.git, can we have ndctl-history.git
and linux.git + ndctl from now on?

If you prefer to go full merge, then I think prefixing + SOB'ing should
be done, right?

- Arnaldo
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-wm0-x244.google.com (mail-wm0-x244.google.com
 [IPv6:2a00:1450:400c:c09::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E67B921D09192
 for <linux-nvdimm@lists.01.org>; Wed, 26 Jul 2017 10:17:53 -0700 (PDT)
Received: by mail-wm0-x244.google.com with SMTP id 184so20677820wmo.3
 for <linux-nvdimm@lists.01.org>; Wed, 26 Jul 2017 10:19:56 -0700 (PDT)
Date: Wed, 26 Jul 2017 19:19:52 +0200
From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 3/4] ndctl: switch to tools/include/linux/{kernel, list,
 bitmap}.h
Message-ID: <20170726171952.frohvqpekfx4iefn@gmail.com>
References: <150102217021.2258.1380624380896006.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150102218643.2258.15362632812220627446.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170725235512.GC23846@kernel.org>
 <CAPcyv4g1V=1E-cOzHabZswwVGmJGQUNSYxnSyOtwxo79eRYyNw@mail.gmail.com>
 <20170726112935.a4ztsb6yke7bhsvo@gmail.com>
 <CAPcyv4gjMWz814BSdmmM=MEJAuJ3bkJhM9pcdgVK+XW0hMJ9ng@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4gjMWz814BSdmmM=MEJAuJ3bkJhM9pcdgVK+XW0hMJ9ng@mail.gmail.com>
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
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Peter Zijlstra <peterz@infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Ingo Molnar <mingo@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>


* Dan Williams <dan.j.williams@intel.com> wrote:

> On Wed, Jul 26, 2017 at 4:29 AM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > * Dan Williams <dan.j.williams@intel.com> wrote:
> >
> >> On Tue, Jul 25, 2017 at 4:55 PM, Arnaldo Carvalho de Melo
> >> <acme@kernel.org> wrote:
> >> > Em Tue, Jul 25, 2017 at 03:36:26PM -0700, Dan Williams escreveu:
> >> >> Replace the ccan implementation of list primitives, bitmap helpers and
> >> >> small utility macros with the common definitions available in
> >> >> tool/include/linux.
> >> >
> >> > You should first add what you need in separate patches, paving the way
> >> > to then use it, and some stuff are already there, see below:
> >>
> >> Ok, I'll break out those changes separately.
> >
> > BTW., another general observation I have is that ndctl uses autotools - while perf
> > uses its own build system, some of which is abstracted out into tools/build/ and
> > reused by other tooling projects as well.
> >
> > I despise autotools with a passion, it's slow, bloated, and encourages all sorts
> > of bad API/ABI practices that plagues many OSS projects. I know that Linus
> > explicitly did a Makefile based build system for Git for (I think) similar
> > reasons.
> >
> > It might be a good idea to not let autotools into the kernel tooling tree, not
> > because ndctl's use of autotools is bad in any fashion (it appears to be a fairly
> > straightforward use), but to generally encourage good API/ABI practices in our
> > tooling space, and to encourage enhancements to the tools/build/ infrastructure.
> 
> That's a fair point. Regardless, autotools will be in the git history,
> but if you'd like to see the final merge product eliminate its use, I
> can't really argue otherwise. I was originally not concerned because
> tools/usb/usbip/ was an existing in tree autotools user. In any event
> if you want the autotools removal to be done out-of-tree I'll need to
> put this effort on the back burner until 4.15.

So that was another thing I wanted to suggest: why not import the current ndctl 
version as a single commit?

I had a quick look, and there's quite a few of commits in the ndctl history that 
don't conform to kernel standards, such as:

  ce881c1e78f6: ndctl: seed tracking

which doesn't have any Signed-off-by tags.

There's also commits with ambiguous titles that would be confusing in the kernel 
context - for example:

  796b6f373dec: clarify copyright and license information

... which on the surface could be misunderstood as something talking about the 
kernel copyright ...

Or:

  e38bd36e5d0a: completion: updates for file name completion

which I could initially mistake for a commit about scheduler completions ;-)

Or:

  2ad6a39c9ae9: Fix attribute sizes to match NFIT 0.8s2
  cc7cb44385d3: Import initial infrastructure

etc.

I suppose all that could be corrected, SOBs added, titles clarified and prefixed 
with tools/ndctl, but then it wouldn't really be unmodified history anymore, 
right?

At that point we might as well do a clean start - and not import ~500 extra 
commits into the kernel tree?

Thanks,

	Ingo
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

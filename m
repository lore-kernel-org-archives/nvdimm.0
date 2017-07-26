Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-yw0-x230.google.com (mail-yw0-x230.google.com
 [IPv6:2607:f8b0:4002:c05::230])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CADC921D091A3
 for <linux-nvdimm@lists.01.org>; Wed, 26 Jul 2017 11:12:59 -0700 (PDT)
Received: by mail-yw0-x230.google.com with SMTP id i6so58887441ywb.1
 for <linux-nvdimm@lists.01.org>; Wed, 26 Jul 2017 11:15:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170726175739.GF23846@kernel.org>
References: <150102217021.2258.1380624380896006.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150102218643.2258.15362632812220627446.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170725235512.GC23846@kernel.org>
 <CAPcyv4g1V=1E-cOzHabZswwVGmJGQUNSYxnSyOtwxo79eRYyNw@mail.gmail.com>
 <20170726112935.a4ztsb6yke7bhsvo@gmail.com>
 <CAPcyv4gjMWz814BSdmmM=MEJAuJ3bkJhM9pcdgVK+XW0hMJ9ng@mail.gmail.com>
 <20170726171952.frohvqpekfx4iefn@gmail.com>
 <CAPcyv4jr4cvs9DSQctrbKo61AxBkGe-S=bUS9+_ce_PbXXpCYw@mail.gmail.com>
 <20170726175739.GF23846@kernel.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 26 Jul 2017 11:15:01 -0700
Message-ID: <CAPcyv4iwPpjAb3Gbuz-D6YArFkytzkjOC85J4egWPYKG+fW1uw@mail.gmail.com>
Subject: Re: [PATCH 3/4] ndctl: switch to tools/include/linux/{kernel, list,
 bitmap}.h
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
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Peter Zijlstra <peterz@infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, Ingo Molnar <mingo@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jul 26, 2017 at 10:57 AM, Arnaldo Carvalho de Melo
<acme@kernel.org> wrote:
> Em Wed, Jul 26, 2017 at 10:31:48AM -0700, Dan Williams escreveu:
>> On Wed, Jul 26, 2017 at 10:19 AM, Ingo Molnar <mingo@kernel.org> wrote:
>> > * Dan Williams <dan.j.williams@intel.com> wrote:
>> >> On Wed, Jul 26, 2017 at 4:29 AM, Ingo Molnar <mingo@kernel.org> wrote:
>> > which I could initially mistake for a commit about scheduler completions ;-)
>> >
>> > Or:
>
>> >   2ad6a39c9ae9: Fix attribute sizes to match NFIT 0.8s2
>> >   cc7cb44385d3: Import initial infrastructure
>
>> > etc.
>
>> > I suppose all that could be corrected, SOBs added, titles clarified and prefixed
>> > with tools/ndctl, but then it wouldn't really be unmodified history anymore,
>> > right?
>
>> > At that point we might as well do a clean start - and not import ~500 extra
>> > commits into the kernel tree?
>
>> I think keeping the history is worth it, similar reasoning to why we
>> kept the btrfs history. Also, since the history is linear and already
>> rewritten by 'git filter-branch' to move everything to tools/ndctl/ it
>> wouldn't be that much more work to go clean up these few commits that
>> are problematic.
>
> Hey, but we can have something like:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/history/history.git/
>
> It goes all the way to the 0.12 kernel.
>
> If someone wants to go that far, just clone that tree, merge it, etc.
>
> Could that be the solution for this case as well?
>
> I.e. the kernel history prior to what we have in linux.git can be
> accessed via that other tree, history.git, can we have ndctl-history.git
> and linux.git + ndctl from now on?

That will have to be the option if Linus finds the history
unpalatable, but reading the comedi inclusion thread [1] I came away
with this, quoting Linus:

---

I'd _like_ for old history to be merged, but quite frankly, bisectability
is a fairly big deal, and while we often have cases where a _few_ commits
don't build and make bisecting hard, if you import the past development
history badly, you can easily end up with _hundreds_ of commits that
simply don't build as a kernel at all.

And at some point the "nice to have" history is suddenly "more pain than
it is worth".

---

So, the bigger reason to not include the full history is the potential
for 'git bisect' confusion where you end up in the ndctl history and
the rest of the kernel tree disappears.

> If you prefer to go full merge, then I think prefixing + SOB'ing should
> be done, right?

Yes, definitely, and it's otherwise simple enough to switch to the
forklift import at the last moment if it comes to that.

[1]: https://lkml.org/lkml/2008/10/30/356
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

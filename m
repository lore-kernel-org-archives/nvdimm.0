Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-io0-x242.google.com (mail-io0-x242.google.com
 [IPv6:2607:f8b0:4001:c06::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AD46A81F5B
 for <linux-nvdimm@lists.01.org>; Fri, 25 Nov 2016 11:51:27 -0800 (PST)
Received: by mail-io0-x242.google.com with SMTP id r94so11251073ioe.1
 for <linux-nvdimm@lists.01.org>; Fri, 25 Nov 2016 11:51:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20161125073747.GU1555@ZenIV.linux.org.uk>
References: <1479926662-21718-1-git-send-email-ross.zwisler@linux.intel.com>
 <1479926662-21718-4-git-send-email-ross.zwisler@linux.intel.com>
 <20161124173220.GR1555@ZenIV.linux.org.uk> <20161125024918.GX31101@dastard>
 <20161125041419.GT1555@ZenIV.linux.org.uk> <20161125070642.GZ31101@dastard>
 <20161125073747.GU1555@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 25 Nov 2016 11:51:26 -0800
Message-ID: <CA+55aFy5=74ad4tByQJYnkyX079z59yn02koJ_G8kfxamjvPDw@mail.gmail.com>
Subject: Re: [PATCH 3/6] dax: add tracepoint infrastructure, PMD tracing
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
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <mawilcox@microsoft.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Dave Chinner <david@fromorbit.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>, Christoph Hellwig <hch@lst.de>, linux-mm <linux-mm@kvack.org>, Ingo Molnar <mingo@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Nov 24, 2016 at 11:37 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> My impression is that nobody (at least kernel-side) wants them to be
> a stable ABI, so long as nobody in userland screams about their code
> being broken, everything is fine.  As usual, if nobody notices an ABI
> change, it hasn't happened.  The question is what happens when somebody
> does.

Right. There is basically _no_ "stable API" for the kernel anywhere,
it's just an issue of "you can't break workflow for normal people".

And if somebody writes his own trace scripts, and some random trace
point goes away (or changes semantics), that's easy: he can just fix
his script. Tracepoints aren't ever going to be stable in that sense.

But when then somebody writes a trace script that is so useful that
distros pick it up, and people start using it and depending on it,
then _that_ trace point may well have become effectively locked in
stone.

That's happened once already with the whole powertop thing. It didn't
get all that widely spread, and the fix was largely to improve on
powertop to the point where it wasn't a problem any more, but we've
clearly had one case of this happening.

But I suspect that something like powertop is fairly unusual. There is
certainly room for similar things in the VFS layer (think "better
vmstat that uses tracepoints"), but I suspect the bulk of tracepoints
are going to be for random debugging (so that developers can say
"please run this script") rather than for an actual user application
kind of situation.

So I don't think we should be _too_ afraid of tracepoints either. When
being too anti-tracepoint is a bigger practical problem than the
possible problems down the line, the balance is wrong.

As long as tracepoints make sense from a higher standpoint (ie not
just random implementation detail of the day), and they aren't
everywhere, they are unlikely to cause much problem.

We do have filesystem code that is just disgusting. As an example:
fs/afs/ tends to have these crazy "_enter()/_exit()" macros in every
single function. If you want that, use the function tracer. That seems
to be just debugging code that has been left around for others to
stumble over. I do *not* believe that we should encourage that kind of
"machine gun spray" use of tracepoints.

But tracing actual high-level things like IO and faults? I think that
makes perfect sense, as long as the data that is collected is also the
actual event data, and not so much a random implementation issue of
the day.

             Linus
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

Return-Path: <linux-nvdimm-bounces@lists.01.org>
Date: Fri, 25 Nov 2016 16:48:40 -0500
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/6] dax: add tracepoint infrastructure, PMD tracing
Message-ID: <20161125214840.kexe5mj2yn4jtazi@thunk.org>
References: <1479926662-21718-1-git-send-email-ross.zwisler@linux.intel.com>
 <1479926662-21718-4-git-send-email-ross.zwisler@linux.intel.com>
 <20161124173220.GR1555@ZenIV.linux.org.uk>
 <20161125024918.GX31101@dastard>
 <20161125041419.GT1555@ZenIV.linux.org.uk>
 <20161125070642.GZ31101@dastard>
 <20161125073747.GU1555@ZenIV.linux.org.uk>
 <CA+55aFy5=74ad4tByQJYnkyX079z59yn02koJ_G8kfxamjvPDw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CA+55aFy5=74ad4tByQJYnkyX079z59yn02koJ_G8kfxamjvPDw@mail.gmail.com>
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
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <mawilcox@microsoft.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, Dave Chinner <david@fromorbit.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>, linux-mm <linux-mm@kvack.org>, Ingo Molnar <mingo@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Nov 25, 2016 at 11:51:26AM -0800, Linus Torvalds wrote:
> We do have filesystem code that is just disgusting. As an example:
> fs/afs/ tends to have these crazy "_enter()/_exit()" macros in every
> single function. If you want that, use the function tracer. That seems
> to be just debugging code that has been left around for others to
> stumble over. I do *not* believe that we should encourage that kind of
> "machine gun spray" use of tracepoints.

There is a reason why people want to be able to do that, and that's
because kprobes doesn't give you access to the arguments and return
codes to the functions.  Maybe there could be a way to do this more
easily using DWARF information and EBPF magic, perhaps?  It won't help
for inlined functions, of course, but most of the functions where
people want to do this aren't generally functions which are going to
be inlined, but rather things like write_begin, writepages, which are
called via a struct ops table and so will never be inlined to begin
with.

And it *is* handy to be able to do this when you don't know ahead of
time that you might need to debug a production system that is
malfunctioning for some reason.  This is the "S" in RAS (Reliability,
Availability, Serviceability).  This is why it's nice if there were a
way to be clear that it is intended for debugging purposes only ---
and maybe kprobes with EBPF and DWARF would be the answer.

After all, we need *some* way of saying this can never be considered
stable --- what would we do if some userspace program like powertop
started depending on a function name via ktrace and that function
disappeared --- would the userspace application really be intended to
demand that we revert the recatoring, because eliminating a function
name that they were depending on via ktrace point broke them?

						- Ted
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

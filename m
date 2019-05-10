Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 971C6212657B5
 for <linux-nvdimm@lists.01.org>; Fri, 10 May 2019 03:44:41 -0700 (PDT)
Date: Fri, 10 May 2019 06:43:38 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH v2 00/17] kunit: introduce KUnit, the Linux kernel unit
 testing framework
Message-ID: <20190510104338.GB6889@mit.edu>
References: <20190501230126.229218-1-brendanhiggins@google.com>
 <54940124-50df-16ec-1a32-ad794ee05da7@gmail.com>
 <20190507080119.GB28121@kroah.com>
 <a09a7e0e-9894-8c1a-34eb-fc482b1759d0@gmail.com>
 <20190509015856.GB7031@mit.edu>
 <580e092f-fa4e-eedc-9e9a-a57dd085f0a6@gmail.com>
 <78e4d46e-6212-9871-51d6-dd2126f39d45@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <78e4d46e-6212-9871-51d6-dd2126f39d45@gmail.com>
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
To: Frank Rowand <frowand.list@gmail.com>
Cc: pmladek@suse.com, linux-doc@vger.kernel.org, amir73il@gmail.com, Brendan Higgins <brendanhiggins@google.com>, dri-devel@lists.freedesktop.org, Alexander.Levin@microsoft.com, mpe@ellerman.id.au, linux-kselftest@vger.kernel.org, shuah@kernel.org, robh@kernel.org, linux-nvdimm@lists.01.org, khilman@baylibre.com, knut.omang@oracle.com, kieran.bingham@ideasonboard.com, wfg@linux.intel.com, joel@jms.id.au, rientjes@google.com, jdike@addtoit.com, dan.carpenter@oracle.com, devicetree@vger.kernel.org, linux-kbuild@vger.kernel.org, Tim.Bird@sony.com, linux-um@lists.infradead.org, rostedt@goodmis.org, julia.lawall@lip6.fr, kunit-dev@googlegroups.com, richard@nod.at, sboyd@kernel.org, Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org, mcgrof@kernel.org, daniel@ffwll.ch, keescook@google.com, linux-fsdevel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, May 09, 2019 at 10:11:01PM -0700, Frank Rowand wrote:
> >> You *can* run in-kernel test using modules; but there is no framework
> >> for the in-kernel code found in the test modules, which means each of
> >> the in-kernel code has to create their own in-kernel test
> >> infrastructure.
> 
> The kselftest in-kernel tests follow a common pattern.  As such, there
> is a framework.

So we may have different definitions of "framework".  In my book, code
reuse by "cut and paste" does not make a framework.  Could they be
rewritten to *use* a framework, whether it be KTF or KUnit?  Sure!
But they are not using a framework *today*.

> This next two paragraphs you ignored entirely in your reply:
> 
> > Why create an entire new subsystem (KUnit) when you can add a header
> > file (and .c code as appropriate) that outputs the proper TAP formatted
> > results from kselftest kernel test modules?

And you keep ignoring my main observation, which is that spinning up a
VM, letting systemd start, mounting a root file system, etc., is all
unnecessary overhead which takes time.  This is important to me,
because developer velocity is extremely important if you are doing
test driven development.

Yes, you can manually unload a module, recompile the module, somehow
get the module back into the VM (perhaps by using virtio-9p), and then
reloading the module with the in-kernel test code, and the restart the
test.  BUT: (a) even if it is faster, it requires a lot of manual
steps, and would be very hard to automate, and (b) if the test code
ever OOPS or triggers a lockdep warning, you will need to restart the
VM, and so this involves all of the VM restart overhead, plus trying
to automate determining when you actually do need to restart the VM
versus unloading and reloading the module.   It's clunky.

Being able to do the equivalent of "make && make check" is a really
big deal.  And "make check" needs to go fast.

You keep ignore this point, perhaps because you don't care about this
issue?  Which is fine, and why we may just need to agree to disagree.

Cheers,

						- Ted

P.S.  Running scripts is Turing-equivalent, so it's self-evident that
*anything* you can do with other test frameworks you can somehow do in
kselftests.  That argument doesn't impress me, and why I do consider
it quite flippant.  (Heck, /bin/vi is Turing equivalent so we could
use vi to as a kernel test framework.  Or we could use emacs.  Let's
not.  :-)

The question is whether it is the most best and most efficient way to
do that testing.  And developer velocity is a really big part of my
evaluation function when judging whether or a test framework is fit
for that purpose.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

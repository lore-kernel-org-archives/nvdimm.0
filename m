Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6BFD02118F77F
 for <linux-nvdimm@lists.01.org>; Mon,  3 Dec 2018 02:55:22 -0800 (PST)
Date: Mon, 3 Dec 2018 11:55:17 +0100
From: Petr Mladek <pmladek@suse.com>
Subject: Re: [RFC v3 03/19] kunit: test: add string_stream a std::stream like
 string builder
Message-ID: <20181203105517.vbedwygttxxbdtan@pathway.suse.cz>
References: <20181128193636.254378-1-brendanhiggins@google.com>
 <20181128193636.254378-4-brendanhiggins@google.com>
 <20181130032924.GH18410@garbanzo.do-not-panic.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20181130032924.GH18410@garbanzo.do-not-panic.com>
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
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: brakmo@fb.com, Brendan Higgins <brendanhiggins@google.com>, dri-devel@lists.freedesktop.org, linux-kselftest@vger.kernel.org, shuah@kernel.org, robh@kernel.org, frowand.list@gmail.com, linux-nvdimm@lists.01.org, richard@nod.at, knut.omang@oracle.com, kieran.bingham@ideasonboard.com, joel@jms.id.au, Tim.Bird@sony.com, jdike@addtoit.com, keescook@google.com, linux-um@lists.infradead.org, rostedt@goodmis.org, julia.lawall@lip6.fr, kunit-dev@googlegroups.com, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, daniel@ffwll.ch, mpe@ellerman.id.au, joe@perches.com, khilman@baylibre.com
List-ID: <linux-nvdimm@lists.01.org>

On Thu 2018-11-29 19:29:24, Luis Chamberlain wrote:
> On Wed, Nov 28, 2018 at 11:36:20AM -0800, Brendan Higgins wrote:
> > A number of test features need to do pretty complicated string printing
> > where it may not be possible to rely on a single preallocated string
> > with parameters.
> > 
> > So provide a library for constructing the string as you go similar to
> > C++'s std::string.
> 
> Hrm, what's the potential for such thing actually being eventually
> generically useful for printk folks, I wonder? Petr?

printk() is a bit tricky:

   + It should work in any context. Any additional lock adds risk of a
     deadlock. Especially the NMI and scheduler contexts are problematic.
     There are problems with any other code that might be called
     from console drivers and calls printk() under a lock.

   + It should work also when the system is out of memory. Especially
     atomic context is problematic because we could not wait for
     memory reclaim or swap.

   + We also do to the best effort to get the message out on the
     console. It is important when the system is about to die.
     Any extra buffering layer might cause delay and avoid seeing the
     message.

>From this point of views, this API is not generally usable with printk().

Now, the question is how many of the above fits also for unit testing.
At least, you might need to be careful when allocating memory in
atomic context.

BTW: There are more existing printk APIs: Well, I admit the they are
not easily reusable in unit testing:

   + printk() is old, crappy code, complicated with all the
     cornercases and consoles.

   + include/linux/seq_buf.h is simple buffering. It is used primary
     for sysfs output. It might be usable if you add support for
     loglevel and use big enough buffer. I quess that you should
     flush the buffer regularly anyway.

   + trace_printk() uses lockless per-CPU buffers. It currently does not
     support loglevels. But it might be pretty interesting choice as well.


I do not say that you have to use one of the existing API. But you
might consider them if you encouter any problems and maintaining
your variant gets complicated.

Best Regards,
Petr
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

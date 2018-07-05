Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5CB7520988771
 for <linux-nvdimm@lists.01.org>; Thu,  5 Jul 2018 09:57:41 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [BUG] Injecting bad blocks in the nfit_test module does not
 work with kernel v4.17.4 + ndctl v61.1
Date: Thu, 5 Jul 2018 16:57:32 +0000
Message-ID: <1530809850.7574.31.camel@intel.com>
References: <D9FFE20C522965449E182ACE73889AEBF4F2E02E@IRSMSX101.ger.corp.intel.com>
 <CAPcyv4gw12anx4tFqG1zeFjS-Be8kxVgXDqNHE5U4eES-=UOBQ@mail.gmail.com>
 <D9FFE20C522965449E182ACE73889AEBF4F2E6E9@IRSMSX101.ger.corp.intel.com>
In-Reply-To: <D9FFE20C522965449E182ACE73889AEBF4F2E6E9@IRSMSX101.ger.corp.intel.com>
Content-Language: en-US
Content-ID: <D35CCE9A92AE244099FF54017A313189@intel.com>
MIME-Version: 1.0
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
To: "Williams, Dan J" <dan.j.williams@intel.com>, "Dorau, Lukasz" <lukasz.dorau@intel.com>
Cc: "Li, ZhijianX" <zhijianx.li@intel.com>, Slusarz,, "Piotr  <piotr.balcer@intel.com>, linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>


On Thu, 2018-07-05 at 08:29 +0000, Dorau, Lukasz wrote:
> On Thu, July 5, 2018 9:51 AM, Dorau, Lukasz <lukasz.dorau@intel.com>
> wrote:
> > 
> > I tested the workaround (ndctl start-scrub ; ndctl wait-scrub) but
> > it does not work
> > for me (with kernel v4.17.4 and ndctl v61.1):
> > 
> > # ndctl inject-error --block=16838 --count=512 namespace4.0
> > # ndctl start-scrub
> > # ndctl wait-scrub      #       <---       I waited 30 minutes for
> > 'ndctl wait-scrub', but it did
> > not finish...
> > 
> 
> It is polling forever in ndctl_bus_wait_for_scrub_completion() at
> libndctl.c:1239:

I've seen this happen sometimes on my test setup, but not frequently
enough to be able to debug reliably..
Can you try inserting a sleep 5 after the start-scrub?

I'll also try injecting a large number of blocks and see if I can
reproduce it.

> 
> Program received signal SIGINT, Interrupt.
> 0x00007ffff72d2a40 in __poll_nocancel () at ../sysdeps/unix/syscall-
> template.S:84
> 84	T_PSEUDO (SYSCALL_SYMBOL, SYSCALL_NAME, SYSCALL_NARGS)
> (gdb) bt
> #0  0x00007ffff72d2a40 in __poll_nocancel () at
> ../sysdeps/unix/syscall-template.S:84
> #1  0x00007ffff7bc5e96 in poll (__timeout=-1, __nfds=1,
> __fds=0x7fffffffde38) at /usr/include/bits/poll2.h:46
> #2  ndctl_bus_wait_for_scrub_completion (bus=bus@entry=0x62c6d0) at
> libndctl.c:1239
> #3  0x00000000004075c2 in scrub_action (action=ACTION_WAIT,
> bus=0x62c6d0) at bus.c:30
> #4  bus_action (argc=<optimized out>, argv=<optimized out>, usage=usa
> ge@entry=0x4161c8 "ndctl wait-scrub [<bus-id> <bus-id2> ... <bus-
> idN>] [<options>]", action=action@entry=ACTION_WAIT, ctx=0x621340, 
>     options=0x416260 <bus_options>) at bus.c:77
> #5  0x0000000000407735 in cmd_wait_scrub (argc=<optimized out>,
> argv=<optimized out>, ctx=<optimized out>) at bus.c:119
> #6  0x0000000000414590 in run_builtin (p=0x61faf0 <commands+304>,
> ctx=0x621340, argv=0x7fffffffe4f0, argc=1) at util/main.c:90
> #7  main_handle_internal_command (argc=1, argv=0x7fffffffe4f0,
> ctx=0x621340, cmds=cmds@entry=0x61f9c0 <commands>, num_cmds=num_cmds@
> entry=23) at util/main.c:137
> #8  0x00000000004071fd in main (argc=<optimized out>, argv=<optimized
> out>) at ndctl.c:125
> 
> --
> Lukasz
> 
> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm@lists.01.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

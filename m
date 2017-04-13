Return-Path: <linux-nvdimm-bounces@lists.01.org>
Date: Thu, 13 Apr 2017 07:34:01 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH] x86, mce: change the mce notifier to 'blocking' from
 'atomic'
References: <20170411224457.24777-1-vishal.l.verma@intel.com>
 <20170412091442.dwonfr4dwyta7nvx@pd.tnic>
 <20170412195903.GA29506@omniknight.lm.intel.com>
 <20170412202238.5d327vmwjqvbzzop@pd.tnic>
 <1492028744.2738.14.camel@intel.com>
 <20170412211302.3d2cxe34sgiu3dag@pd.tnic>
 <alpine.DEB.2.20.1704122342130.2548@nanos>
 <20170412224232.GM3956@linux.vnet.ibm.com>
 <20170412234559.GA31667@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170412234559.GA31667@linux.vnet.ibm.com>
Message-Id: <20170413143401.GA19357@linux.vnet.ibm.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Reply-To: paulmck@linux.vnet.ibm.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "Luck, Tony" <tony.luck@intel.com>, Peter Zijlstra <peterz@infradead.org>, "x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, Borislav Petkov <bp@suse.de>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Apr 12, 2017 at 04:45:59PM -0700, Paul E. McKenney wrote:
> On Wed, Apr 12, 2017 at 03:42:32PM -0700, Paul E. McKenney wrote:
> > On Wed, Apr 12, 2017 at 11:50:45PM +0200, Thomas Gleixner wrote:
> > > On Wed, 12 Apr 2017, Borislav Petkov wrote:
> > > 
> > > > On Wed, Apr 12, 2017 at 08:27:05PM +0000, Verma, Vishal L wrote:
> > > > > But isn't the atomic notifier call chain always called in atomic
> > > > > context?
> > > > 
> > > > No, it isn't. We're calling it in normal process context in
> > > > mce_gen_pool_process() too.
> > > > 
> > > > So this early exit will avoid any sleeping in atomic context. And since
> > > > there's nothing you can do about the errors reported in atomic context,
> > > > we can actually use that fact.
> > > 
> > > No, you can't.
> > > 
> > > CONFIG_RCU_PREEMPT=n + CONFIG_PREEMPT_COUNT will disable preemption from
> > > within __atomic_notifier_call_chain() via rcu_read_lock(). Ergo you wont
> > > ever enter the handler.
> > > 
> > > The behaviour in the RCU code is inconsistent. CONFIG_RCU_PREEMPT=y does
> > > obviouly not disable preemption, but it should still trigger the
> > > might_sleep() check when a blocking function is called from within a rcu
> > > read side critical section.
> > 
> > Maybe something like the (untested) patch below.  Please note that this
> > would need some help to work correctly in -rt.  This applies only against
> > -rcu tip, but in that case you can just get it directly from -rcu.
> 
> So I injected a schedule_timeout_interruptible() into rcutorture's RCU
> read-side critical section, and the patch complained as expected.  But is
> also got a "scheduling while atomic" and a "DEBUG_LOCKS_WARN_ON(val >
> preempt_count())" and a warning at "kernel/time/timer.c:1275", which
> is this:
> 
> 	if (count != preempt_count()) {
> 		WARN_ONCE(1, "timer: %pF preempt leak: %08x -> %08x\n",
> 			  fn, count, preempt_count());
> 		/*
> 		 * Restore the preempt count. That gives us a decent
> 		 * chance to survive and extract information. If the
> 		 * callback kept a lock held, bad luck, but not worse
> 		 * than the BUG() we had.
> 		 */
> 		preempt_count_set(count);
> 	}
> 
> So you are saying that you are seeing blocking in RCU-preempt read-side
> critical sections being ignored?
> 
> Here is the Kconfig fragment used by this test:
> 
> 	CONFIG_SMP=y
> 	CONFIG_NR_CPUS=8
> 	CONFIG_PREEMPT_NONE=n
> 	CONFIG_PREEMPT_VOLUNTARY=n
> 	CONFIG_PREEMPT=y
> 	#CHECK#CONFIG_PREEMPT_RCU=y
> 	CONFIG_HZ_PERIODIC=n
> 	CONFIG_NO_HZ_IDLE=y
> 	CONFIG_NO_HZ_FULL=n
> 	CONFIG_RCU_FAST_NO_HZ=n
> 	CONFIG_RCU_TRACE=n
> 	CONFIG_HOTPLUG_CPU=n
> 	CONFIG_SUSPEND=n
> 	CONFIG_HIBERNATION=n
> 	CONFIG_RCU_FANOUT=3
> 	CONFIG_RCU_FANOUT_LEAF=3
> 	CONFIG_RCU_NOCB_CPU=n
> 	CONFIG_DEBUG_LOCK_ALLOC=y
> 	CONFIG_PROVE_LOCKING=n
> 	CONFIG_RCU_BOOST=n
> 	CONFIG_RCU_EXPERT=y
> 	CONFIG_RCU_TORTURE_TEST_SLOW_CLEANUP=y
> 	CONFIG_RCU_TORTURE_TEST_SLOW_INIT=y
> 	CONFIG_RCU_TORTURE_TEST_SLOW_PREINIT=y
> 	CONFIG_DEBUG_OBJECTS=y
> 	CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
> 
> I will run other scenarios overnight.

Well, that was an extremely poor choice of scenario to test.  Yes, it
has CONFIG_PREEMPT_RCU=y, but it tests RCU-bh because the TREE01.boot
file contains "rcutorture.torture_type=rcu_bh maxcpus=8".  Hence all the
"scheduling while atomic" and other complaints.  :-/

Without the patch, RCU-preempt does not complain, as reported, as
shown below.  Other RCU flavors always give "scheduling while atomic".
With the patch, all flavors always complain, including RCU-preempt.

TREE01 ------- 18589 grace periods (103.272 per second)
BUG: 2028 Reader Batch close calls in 3 minute run: /home/git/linux-2.6-tip/tools/testing/selftests/rcutorture/res/2017.04.12-17:51:14/TREE01
BUG: FAILURE, 1982 instances
WARNING: Assertion failure in /home/git/linux-2.6-tip/tools/testing/selftests/rcutorture/res/2017.04.12-17:51:14/TREE01/console.log
WARNING: Summary: Warnings: 2 Bugs: 2033 Call Traces: 2034
----> Lots of:
	"scheduling while atomic"
	"DEBUG_LOCKS_WARN_ON(val > preempt_count())"
----> Preemptible, but testing RCU-bh, thus blocking makes too-short GP.
      Failures are thus expected behavior.
      CONFIG_HOTPLUG_CPU=y, CONFIG_MAXSMP=y, CONFIG_CPUMASK_OFFSTACK=y,
      CONFIG_RCU_NOCB_CPU_ZERO=y.

TREE02 ------- 3270 grace periods (18.1667 per second)
----> Preemptible, CONFIG_HOTPLUG_CPU=n, CONFIG_DEBUG_LOCK_ALLOC=y,
      CONFIG_PROVE_LOCKING=n.  No complaints.

TREE03 ------- 2963 grace periods (16.4611 per second)
CPU count limited from 16 to 8  (Yeah, yeah, wimpy laptop.)
----> Preemptible, CONFIG_HOTPLUG_CPU=y, CONFIG_RCU_BOOST=y,
      CONFIG_RCU_KTHREAD_PRIO=2.  Again, no complaints.

TREE04 ------- 272 grace periods (1.51111 per second)
BUG: 33 Reader Batch close calls in 3 minute run: /home/git/linux-2.6-tip/tools/testing/selftests/rcutorture/res/2017.04.12-17:51:14/TREE04
BUG: FAILURE, 72 instances
WARNING: Assertion failure in /home/git/linux-2.6-tip/tools/testing/selftests/rcutorture/res/2017.04.12-17:51:14/TREE04/console.log
WARNING: Summary: Warnings: 1 Bugs: 30 Call Traces: 31 Stalls: 1
!!! PID 29727 hung at 360 vs. 180 seconds
----> Nonpreemptible, so failures are expected behavior, especially given that
      this is testing RCU-bh.
      "scheduling while atomic"

TREE05 ------- 4520 grace periods (25.1111 per second)
BUG: 1770 Reader Batch close calls in 3 minute run: /home/git/linux-2.6-tip/tools/testing/selftests/rcutorture/res/2017.04.12-17:51:14/TREE05
BUG: FAILURE, 1358 instances
WARNING: Assertion failure in /home/git/linux-2.6-tip/tools/testing/selftests/rcutorture/res/2017.04.12-17:51:14/TREE05/console.log
WARNING: Summary: Warnings: 1 Bugs: 2 Call Traces: 37 Stalls: 14 Starves: 2
!!! PID 13911 hung at 370 vs. 180 seconds
----> Nonpreemptible, so failures are expected behavior.  Also testing RCU-sched.
      "scheduling while atomic"

TREE06 ------- 4012 grace periods (22.2889 per second)
BUG: 2314 Reader Batch close calls in 3 minute run: /home/git/linux-2.6-tip/tools/testing/selftests/rcutorture/res/2017.04.12-17:51:14/TREE06
BUG: FAILURE, 1783 instances
WARNING: Assertion failure in /home/git/linux-2.6-tip/tools/testing/selftests/rcutorture/res/2017.04.12-17:51:14/TREE06/console.log
WARNING: Summary: Warnings: 3 Bugs: 1 Call Traces: 4
----> Nonpreemptible, so failures are expected behavior.
      CONFIG_PROVE_RCU=y, hence:
      "Illegal context switch in RCU read-side critical section!"
      Also:
      "scheduling while atomic"

TREE07 ------- 1853 grace periods (10.2944 per second)
BUG: 278 Reader Batch close calls in 3 minute run: /home/git/linux-2.6-tip/tools/testing/selftests/rcutorture/res/2017.04.12-17:51:14/TREE07
BUG: FAILURE, 621 instances
WARNING: Assertion failure in /home/git/linux-2.6-tip/tools/testing/selftests/rcutorture/res/2017.04.12-17:51:14/TREE07/console.log
WARNING: Summary: Warnings: 1 Call Traces: 1
CPU count limited from 16 to 8
----> Nonpreemptible, so failures are expected behavior.
      But no complaints other than from rcutorture.

TREE08 ------- 2725 grace periods (15.1389 per second)
BUG: 2265 Reader Batch close calls in 3 minute run: /home/git/linux-2.6-tip/tools/testing/selftests/rcutorture/res/2017.04.12-17:51:14/TREE08
BUG: FAILURE, 1152 instances
WARNING: Assertion failure in /home/git/linux-2.6-tip/tools/testing/selftests/rcutorture/res/2017.04.12-17:51:14/TREE08/console.log
WARNING: Summary: Warnings: 3 Bugs: 4290 Call Traces: 4292
----> Lots of:
	"scheduling while atomic"
	"DEBUG_LOCKS_WARN_ON(val > preempt_count())"
----> Preemptible, but testing RCU-bh, so failures are expected behavior.
      CONFIG_HOTPLUG_CPU=n, CONFIG_PROVE_LOCKING=n, CONFIG_RCU_EQS_DEBUG=y.

TREE09 ------- 12148 grace periods (67.4889 per second)
----> Preemptible.  Also !SMP.  No complaints.

------------------------------------------------------------------------

Now with the patch, we always get a splat no matter what:

TREE01 ------- 12418 grace periods (68.9889 per second)
BUG: 2768 Reader Batch close calls in 3 minute run: /home/git/linux-2.6-tip/tools/testing/selftests/rcutorture/res/2017.04.12-21:13:30/TREE01
BUG: FAILURE, 2692 instances
WARNING: Assertion failure in /home/git/linux-2.6-tip/tools/testing/selftests/rcutorture/res/2017.04.12-21:13:30/TREE01/console.log
WARNING: Summary: Warnings: 2 Bugs: 2786 Call Traces: 2787

TREE02 ------- 3221 grace periods (17.8944 per second)
WARNING: Assertion failure in /home/git/linux-2.6-tip/tools/testing/selftests/rcutorture/res/2017.04.12-21:13:30/TREE02/console.log
WARNING: Summary: Warnings: 1 Call Traces: 1

TREE03 ------- 3129 grace periods (17.3833 per second)
WARNING: Assertion failure in /home/git/linux-2.6-tip/tools/testing/selftests/rcutorture/res/2017.04.12-21:13:30/TREE03/console.log
WARNING: Summary: Warnings: 1 Call Traces: 1
CPU count limited from 16 to 8

TREE04 ------- 497 grace periods (2.76111 per second)
BUG: 38 Reader Batch close calls in 3 minute run: /home/git/linux-2.6-tip/tools/testing/selftests/rcutorture/res/2017.04.12-21:13:30/TREE04
BUG: FAILURE, 99 instances
WARNING: Assertion failure in /home/git/linux-2.6-tip/tools/testing/selftests/rcutorture/res/2017.04.12-21:13:30/TREE04/console.log
WARNING: Summary: Warnings: 1 Bugs: 34 Call Traces: 35 Stalls: 1
!!! PID 12749 hung at 360 vs. 180 seconds

TREE05 ------- 5793 grace periods (32.1833 per second)
BUG: 2138 Reader Batch close calls in 3 minute run: /home/git/linux-2.6-tip/tools/testing/selftests/rcutorture/res/2017.04.12-21:13:30/TREE05
BUG: FAILURE, 1672 instances
WARNING: Assertion failure in /home/git/linux-2.6-tip/tools/testing/selftests/rcutorture/res/2017.04.12-21:13:30/TREE05/console.log
WARNING: Summary: Warnings: 1 Call Traces: 1

TREE06 ------- 4072 grace periods (22.6222 per second)
BUG: 2339 Reader Batch close calls in 3 minute run: /home/git/linux-2.6-tip/tools/testing/selftests/rcutorture/res/2017.04.12-21:13:30/TREE06
BUG: FAILURE, 1762 instances
WARNING: Assertion failure in /home/git/linux-2.6-tip/tools/testing/selftests/rcutorture/res/2017.04.12-21:13:30/TREE06/console.log
WARNING: Summary: Warnings: 2 Call Traces: 2

TREE07 ------- 1863 grace periods (10.35 per second)
BUG: 288 Reader Batch close calls in 3 minute run: /home/git/linux-2.6-tip/tools/testing/selftests/rcutorture/res/2017.04.12-21:13:30/TREE07
BUG: FAILURE, 590 instances
WARNING: Assertion failure in /home/git/linux-2.6-tip/tools/testing/selftests/rcutorture/res/2017.04.12-21:13:30/TREE07/console.log
WARNING: Summary: Warnings: 1 Call Traces: 1
CPU count limited from 16 to 8

TREE08 ------- 2628 grace periods (14.6 per second)
BUG: 2203 Reader Batch close calls in 3 minute run: /home/git/linux-2.6-tip/tools/testing/selftests/rcutorture/res/2017.04.12-21:13:30/TREE08
BUG: FAILURE, 1086 instances
   
WARNING: Assertion failure in /home/git/linux-2.6-tip/tools/testing/selftests/rcutorture/res/2017.04.12-21:13:30/TREE08/console.log
WARNING: Summary: Warnings: 2 Bugs: 4265 Call Traces: 4266

TREE09 ------- 12109 grace periods (67.2722 per second)
WARNING: Assertion failure in /home/git/linux-2.6-tip/tools/testing/selftests/rcutorture/res/2017.04.12-21:13:30/TREE09/console.log
WARNING: Summary: Warnings: 1 Call Traces: 1

------------------------------------------------------------------------

So I have the patch queued for 4.13.

							Thanx, Paul

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

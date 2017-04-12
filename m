Return-Path: <linux-nvdimm-bounces@lists.01.org>
Date: Wed, 12 Apr 2017 16:45:59 -0700
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
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170412224232.GM3956@linux.vnet.ibm.com>
Message-Id: <20170412234559.GA31667@linux.vnet.ibm.com>
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

On Wed, Apr 12, 2017 at 03:42:32PM -0700, Paul E. McKenney wrote:
> On Wed, Apr 12, 2017 at 11:50:45PM +0200, Thomas Gleixner wrote:
> > On Wed, 12 Apr 2017, Borislav Petkov wrote:
> > 
> > > On Wed, Apr 12, 2017 at 08:27:05PM +0000, Verma, Vishal L wrote:
> > > > But isn't the atomic notifier call chain always called in atomic
> > > > context?
> > > 
> > > No, it isn't. We're calling it in normal process context in
> > > mce_gen_pool_process() too.
> > > 
> > > So this early exit will avoid any sleeping in atomic context. And since
> > > there's nothing you can do about the errors reported in atomic context,
> > > we can actually use that fact.
> > 
> > No, you can't.
> > 
> > CONFIG_RCU_PREEMPT=n + CONFIG_PREEMPT_COUNT will disable preemption from
> > within __atomic_notifier_call_chain() via rcu_read_lock(). Ergo you wont
> > ever enter the handler.
> > 
> > The behaviour in the RCU code is inconsistent. CONFIG_RCU_PREEMPT=y does
> > obviouly not disable preemption, but it should still trigger the
> > might_sleep() check when a blocking function is called from within a rcu
> > read side critical section.
> 
> Maybe something like the (untested) patch below.  Please note that this
> would need some help to work correctly in -rt.  This applies only against
> -rcu tip, but in that case you can just get it directly from -rcu.

So I injected a schedule_timeout_interruptible() into rcutorture's RCU
read-side critical section, and the patch complained as expected.  But is
also got a "scheduling while atomic" and a "DEBUG_LOCKS_WARN_ON(val >
preempt_count())" and a warning at "kernel/time/timer.c:1275", which
is this:

	if (count != preempt_count()) {
		WARN_ONCE(1, "timer: %pF preempt leak: %08x -> %08x\n",
			  fn, count, preempt_count());
		/*
		 * Restore the preempt count. That gives us a decent
		 * chance to survive and extract information. If the
		 * callback kept a lock held, bad luck, but not worse
		 * than the BUG() we had.
		 */
		preempt_count_set(count);
	}

So you are saying that you are seeing blocking in RCU-preempt read-side
critical sections being ignored?

Here is the Kconfig fragment used by this test:

	CONFIG_SMP=y
	CONFIG_NR_CPUS=8
	CONFIG_PREEMPT_NONE=n
	CONFIG_PREEMPT_VOLUNTARY=n
	CONFIG_PREEMPT=y
	#CHECK#CONFIG_PREEMPT_RCU=y
	CONFIG_HZ_PERIODIC=n
	CONFIG_NO_HZ_IDLE=y
	CONFIG_NO_HZ_FULL=n
	CONFIG_RCU_FAST_NO_HZ=n
	CONFIG_RCU_TRACE=n
	CONFIG_HOTPLUG_CPU=n
	CONFIG_SUSPEND=n
	CONFIG_HIBERNATION=n
	CONFIG_RCU_FANOUT=3
	CONFIG_RCU_FANOUT_LEAF=3
	CONFIG_RCU_NOCB_CPU=n
	CONFIG_DEBUG_LOCK_ALLOC=y
	CONFIG_PROVE_LOCKING=n
	CONFIG_RCU_BOOST=n
	CONFIG_RCU_EXPERT=y
	CONFIG_RCU_TORTURE_TEST_SLOW_CLEANUP=y
	CONFIG_RCU_TORTURE_TEST_SLOW_INIT=y
	CONFIG_RCU_TORTURE_TEST_SLOW_PREINIT=y
	CONFIG_DEBUG_OBJECTS=y
	CONFIG_DEBUG_OBJECTS_RCU_HEAD=y

I will run other scenarios overnight.

							Thanx, Paul

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

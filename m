Return-Path: <linux-nvdimm-bounces@lists.01.org>
Date: Wed, 12 Apr 2017 23:50:45 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH] x86, mce: change the mce notifier to 'blocking' from
 'atomic'
In-Reply-To: <20170412211302.3d2cxe34sgiu3dag@pd.tnic>
Message-ID: <alpine.DEB.2.20.1704122342130.2548@nanos>
References: <20170411224457.24777-1-vishal.l.verma@intel.com>
 <20170412091442.dwonfr4dwyta7nvx@pd.tnic>
 <20170412195903.GA29506@omniknight.lm.intel.com>
 <20170412202238.5d327vmwjqvbzzop@pd.tnic>
 <1492028744.2738.14.camel@intel.com>
 <20170412211302.3d2cxe34sgiu3dag@pd.tnic>
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
To: Borislav Petkov <bp@suse.de>
Cc: "Luck, Tony" <tony.luck@intel.com>, Peter Zijlstra <peterz@infradead.org>, "x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, 12 Apr 2017, Borislav Petkov wrote:

> On Wed, Apr 12, 2017 at 08:27:05PM +0000, Verma, Vishal L wrote:
> > But isn't the atomic notifier call chain always called in atomic
> > context?
> 
> No, it isn't. We're calling it in normal process context in
> mce_gen_pool_process() too.
> 
> So this early exit will avoid any sleeping in atomic context. And since
> there's nothing you can do about the errors reported in atomic context,
> we can actually use that fact.

No, you can't.

CONFIG_RCU_PREEMPT=n + CONFIG_PREEMPT_COUNT will disable preemption from
within __atomic_notifier_call_chain() via rcu_read_lock(). Ergo you wont
ever enter the handler.

The behaviour in the RCU code is inconsistent. CONFIG_RCU_PREEMPT=y does
obviouly not disable preemption, but it should still trigger the
might_sleep() check when a blocking function is called from within a rcu
read side critical section.

Thanks,

	tglx





_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

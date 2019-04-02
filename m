From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH RFC tip/core/rcu 0/4] Forbid static SRCU use in modules
Date: Tue, 2 Apr 2019 11:14:40 -0400 (EDT)
Message-ID: <886051277.1395.1554218080591.JavaMail.zimbra@efficios.com>
References: <20190402142816.GA13084@linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190402142816.GA13084@linux.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: paulmck <paulmck@linux.ibm.com>
Cc: rcu@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>, dipankar <dipankar@in.ibm.com>, Andrew Morton <akpm@linux-foundation.org>, Josh Triplett <josh@joshtriplett.org>, Thomas Gleixner <tglx@linutronix.de>, Peter Zijlstra <peterz@infradead.org>, rostedt <rostedt@goodmis.org>, David Howells <dhowells@redhat.com>, Eric Dumazet <edumazet@google.com>, fweisbec <fweisbec@gmail.com>, Oleg Nesterov <oleg@redhat.com>, "Joel Fernandes, Google" <joel@joelfernandes.org>, linux-nvdimm@lists.01.org, dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org
List-Id: linux-nvdimm@lists.01.org

----- On Apr 2, 2019, at 10:28 AM, paulmck paulmck@linux.ibm.com wrote:

> Hello!
> 
> This series prohibits use of DEFINE_SRCU() and DEFINE_STATIC_SRCU()
> by loadable modules.  The reason for this prohibition is the fact
> that using these two macros within modules requires that the size of
> the reserved region be increased, which is not something we want to
> be doing all that often.  Instead, loadable modules should define an
> srcu_struct and invoke init_srcu_struct() from their module_init function
> and cleanup_srcu_struct() from their module_exit function.  Note that
> modules using call_srcu() will also need to invoke srcu_barrier() from
> their module_exit function.

This arbitrary API limitation seems weird.

Isn't there a way to allow modules to use DEFINE_SRCU and DEFINE_STATIC_SRCU
while implementing them with dynamic allocation under the hood ?

Thanks,

Mathieu


> 
> This series consist of the following:
> 
> 1.	Dynamically allocate dax_srcu.
> 
> 2.	Dynamically allocate drm_unplug_srcu.
> 
> 3.	Dynamically allocate kfd_processes_srcu.
> 
> These build and have been subjected to 0day testing, but might also need
> testing by someone having the requisite hardware.
> 
>							Thanx, Paul
> 
> ------------------------------------------------------------------------
> 
> drivers/dax/super.c                        |   10 +++++-
> drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c |    5 +++
> drivers/gpu/drm/amd/amdkfd/kfd_process.c   |    2 -
> drivers/gpu/drm/drm_drv.c                  |    8 ++++
> include/linux/srcutree.h                   |   19 +++++++++--
> kernel/rcu/rcuperf.c                       |   40 +++++++++++++++++++-----
> kernel/rcu/rcutorture.c                    |   48 +++++++++++++++++++++--------
>  7 files changed, 105 insertions(+), 27 deletions(-)

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com

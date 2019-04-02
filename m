From: "Paul E. McKenney" <paulmck@linux.ibm.com>
Subject: [PATCH RFC tip/core/rcu 0/4] Forbid static SRCU use in modules
Date: Tue, 2 Apr 2019 07:28:16 -0700
Message-ID: <20190402142816.GA13084@linux.ibm.com>
Reply-To: paulmck@linux.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: rcu@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, jiangshanlai@gmail.com, dipankar@in.ibm.com, akpm@linux-foundation.org, mathieu.desnoyers@efficios.com, josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com, fweisbec@gmail.com, oleg@redhat.com, joel@joelfernandes.org, linux-nvdimm@lists.01.org, dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org
List-Id: linux-nvdimm@lists.01.org

Hello!

This series prohibits use of DEFINE_SRCU() and DEFINE_STATIC_SRCU()
by loadable modules.  The reason for this prohibition is the fact
that using these two macros within modules requires that the size of
the reserved region be increased, which is not something we want to
be doing all that often.  Instead, loadable modules should define an
srcu_struct and invoke init_srcu_struct() from their module_init function
and cleanup_srcu_struct() from their module_exit function.  Note that
modules using call_srcu() will also need to invoke srcu_barrier() from
their module_exit function.

This series consist of the following:

1.	Dynamically allocate dax_srcu.

2.	Dynamically allocate drm_unplug_srcu.

3.	Dynamically allocate kfd_processes_srcu.

These build and have been subjected to 0day testing, but might also need
testing by someone having the requisite hardware.

							Thanx, Paul

------------------------------------------------------------------------

 drivers/dax/super.c                        |   10 +++++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c |    5 +++
 drivers/gpu/drm/amd/amdkfd/kfd_process.c   |    2 -
 drivers/gpu/drm/drm_drv.c                  |    8 ++++
 include/linux/srcutree.h                   |   19 +++++++++--
 kernel/rcu/rcuperf.c                       |   40 +++++++++++++++++++-----
 kernel/rcu/rcutorture.c                    |   48 +++++++++++++++++++++--------
 7 files changed, 105 insertions(+), 27 deletions(-)

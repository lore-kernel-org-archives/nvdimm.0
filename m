From: Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [RFC v3 08/19] arch: um: add shim to trap to allow installing a fault
 catcher for tests
Date: Wed, 28 Nov 2018 11:36:25 -0800
Message-ID: <20181128193636.254378-9-brendanhiggins@google.com>
References: <20181128193636.254378-1-brendanhiggins@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20181128193636.254378-1-brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, keescook-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: brakmo-b10kYP2dOMg@public.gmane.org, jdike-OPE4K8JWMJJBDgjK7y7TUQ@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, kieran.bingham-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org, joel-U3u1mxZcP9KHXe+LvDLADg@public.gmane.org, khilman-rdvid1DuHRBWk0Htik3J/w@public.gmane.org, Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tim.Bird-7U/KSKJipcs@public.gmane.org, linux-um-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, julia.lawall-L2FTfq7BK8M@public.gmane.org, kunit-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, daniel-/w4YWyX8dFk@public.gmane.org, mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org, joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

Add context to current thread that allows a test to specify that it
wants to skip the normal checks to run an installed fault catcher.

Signed-off-by: Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 arch/um/include/asm/processor-generic.h |  4 +++-
 arch/um/kernel/trap.c                   | 15 +++++++++++----
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/arch/um/include/asm/processor-generic.h b/arch/um/include/asm/processor-generic.h
index b58b746d3f2ca..d566cd416ff02 100644
--- a/arch/um/include/asm/processor-generic.h
+++ b/arch/um/include/asm/processor-generic.h
@@ -27,6 +27,7 @@ struct thread_struct {
 	struct task_struct *prev_sched;
 	struct arch_thread arch;
 	jmp_buf switch_buf;
+	bool is_running_test;
 	struct {
 		int op;
 		union {
@@ -51,7 +52,8 @@ struct thread_struct {
 	.fault_addr		= NULL, \
 	.prev_sched		= NULL, \
 	.arch			= INIT_ARCH_THREAD, \
-	.request		= { 0 } \
+	.request		= { 0 }, \
+	.is_running_test	= false, \
 }
 
 static inline void release_thread(struct task_struct *task)
diff --git a/arch/um/kernel/trap.c b/arch/um/kernel/trap.c
index cced829460427..bf90e678b3d71 100644
--- a/arch/um/kernel/trap.c
+++ b/arch/um/kernel/trap.c
@@ -201,6 +201,12 @@ void segv_handler(int sig, struct siginfo *unused_si, struct uml_pt_regs *regs)
 	segv(*fi, UPT_IP(regs), UPT_IS_USER(regs), regs);
 }
 
+static void segv_run_catcher(jmp_buf *catcher, void *fault_addr)
+{
+	current->thread.fault_addr = fault_addr;
+	UML_LONGJMP(catcher, 1);
+}
+
 /*
  * We give a *copy* of the faultinfo in the regs to segv.
  * This must be done, since nesting SEGVs could overwrite
@@ -219,7 +225,10 @@ unsigned long segv(struct faultinfo fi, unsigned long ip, int is_user,
 	if (!is_user && regs)
 		current->thread.segv_regs = container_of(regs, struct pt_regs, regs);
 
-	if (!is_user && (address >= start_vm) && (address < end_vm)) {
+	catcher = current->thread.fault_catcher;
+	if (catcher && current->thread.is_running_test)
+		segv_run_catcher(catcher, (void *) address);
+	else if (!is_user && (address >= start_vm) && (address < end_vm)) {
 		flush_tlb_kernel_vm();
 		goto out;
 	}
@@ -246,12 +255,10 @@ unsigned long segv(struct faultinfo fi, unsigned long ip, int is_user,
 		address = 0;
 	}
 
-	catcher = current->thread.fault_catcher;
 	if (!err)
 		goto out;
 	else if (catcher != NULL) {
-		current->thread.fault_addr = (void *) address;
-		UML_LONGJMP(catcher, 1);
+		segv_run_catcher(catcher, (void *) address);
 	}
 	else if (current->thread.fault_addr != NULL)
 		panic("fault_addr set but no fault catcher");
-- 
2.20.0.rc0.387.gc7a69e6b6c-goog

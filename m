Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B96C2C81
	for <nvdimm@lists.linux.dev>; Thu, 25 Nov 2021 14:12:50 +0000 (UTC)
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1637849568;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oGlOADoDQzTJJEUJWNX2CKw9fqVkgomvj7S9qxwFn50=;
	b=YmU2IX512oZMOv+S0bEfd42DroU8cvUHyI2YJnNxFAJ2neds0zKyxmhFwDTA5lfv4VToOU
	le040zozWQPhMoUTcPG84pHLJHeBoS9K+xeK9igHG38RiJ1y8OO1TVKn8NblofX9sSwmsT
	l5WEYU1PgFOE1MJ2nEBOUzEXrhQO5jJY6sXE5NJsKALFem1Qbt+o/vAV0gxgVRSV7Ojme7
	3ch59gBoT2MT3g8fI1Stvx2DV3QT4EzAbxc65hktpxQCB1xGXCbJ/h3orWNepMd2d/h8TB
	4GMgHeBWgrrikd8Qhi1wkYxIFCUHpW3TQQfJQ+f94hq88MFHI/dqyugPOrW/2w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1637849568;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oGlOADoDQzTJJEUJWNX2CKw9fqVkgomvj7S9qxwFn50=;
	b=yo79CI88yawGNEw8EdWvLqbO7VEkvbC6wxynf5jW90ckIEvog/f/zSREBuU2hMk80DTuOD
	fW4BGRM6ERd5RKCg==
To: ira.weiny@intel.com, Dave Hansen <dave.hansen@linux.intel.com>, Dan
 Williams <dan.j.williams@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>, Peter Zijlstra <peterz@infradead.org>,
 Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, Fenghua
 Yu <fenghua.yu@intel.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>,
 x86@kernel.org, linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-mm@kvack.org
Subject: Re: [PATCH V7 08/18] x86/entry: Preserve PKRS MSR across exceptions
In-Reply-To: <20210804043231.2655537-9-ira.weiny@intel.com>
References: <20210804043231.2655537-1-ira.weiny@intel.com>
 <20210804043231.2655537-9-ira.weiny@intel.com>
Date: Thu, 25 Nov 2021 15:12:47 +0100
Message-ID: <87r1b4l3xc.ffs@tglx>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Ira,

On Tue, Aug 03 2021 at 21:32, ira weiny wrote:
> +/*
> + * __call_ext_ptregs - Helper macro to call into C with extended pt_regs
> + * @cfunc:		C function to be called
> + *
> + * This will ensure that extended_ptregs is added and removed as needed during
> + * a call into C code.
> + */
> +.macro __call_ext_ptregs cfunc annotate_retpoline_safe:req
> +#ifdef CONFIG_ARCH_ENABLE_SUPERVISOR_PKEYS
> +	/* add space for extended_pt_regs */
> +	subq    $EXTENDED_PT_REGS_SIZE, %rsp
> +#endif
> +	.if \annotate_retpoline_safe == 1
> +		ANNOTATE_RETPOLINE_SAFE
> +	.endif

This annotation is new and nowhere mentioned why it is part of this
patch.

Can you please do _ONE_ functional change per patch and not a
unreviewable pile of changes in one go? Same applies for the ASM and the
C code changes. The ASM change has to go first and then the C code can
build upon it.

> +	call	\cfunc
> +#ifdef CONFIG_ARCH_ENABLE_SUPERVISOR_PKEYS
> +	/* remove space for extended_pt_regs */
> +	addq    $EXTENDED_PT_REGS_SIZE, %rsp
> +#endif

I really have to ask the question whether this #ifdeffery has any value
at all. 8 bytes extra stack usage is not going to be the end of the
world and distro kernels will enable that config anyway.

If we really want to save the space then certainly not by sprinkling
CONFIG_ARCH_ENABLE_SUPERVISOR_PKEYS all over the place and hiding the
extra sized ptregs in the pkrs header.

You are changing generic architecture code so you better think about
making such a change generic and extensible. Can folks please start
thinking beyond the brim of their teacup and not pretend that the
feature they are working on is the unicorn which requires unique magic
brandnamed after the unicorn of the day.

If the next feature comes around which needs to save something in that
extended area then we are going to change the world again, right?
Certainly not.

This wants to go into asm/ptrace.h:

struct pt_regs_aux {
	u32	pkrs;
};

struct pt_regs_extended {
	struct pt_regs_aux	aux;
        struct pt_regs		regs __attribute__((aligned(8)));
};

and then have in asm-offset:

   DEFINE(PT_REGS_AUX_SIZE, sizeof(struct pt_regs_extended) - sizeof(struct pt_regs));

which does the right thing whatever the size of pt_regs_aux is. So for
the above it will have:

 #define PT_REGS_AUX_SIZE 8 /* sizeof(struct pt_regs_extended) - sizeof(struct pt_regs) */

Even, if you do

struct pt_regs_aux {
#ifdef CONFIG_ARCH_ENABLE_SUPERVISOR_PKEYS
	u32	pkrs;
#endif        
};

and the config switch is disabled. It's still correct:

 #define PT_REGS_AUX_SIZE 0 /* sizeof(struct pt_regs_extended) - sizeof(struct pt_regs) */

See? No magic hardcoded constant, no build time error checking for that
constant. Nothing, it just works.

That's one part, but let me come back to this:

> +#ifdef CONFIG_ARCH_ENABLE_SUPERVISOR_PKEYS
> +	/* add space for extended_pt_regs */
> +	subq    $EXTENDED_PT_REGS_SIZE, %rsp

What guarantees that RSP points to pt_regs at this point?  Nothing at
all. It's just pure luck and a question of time until this explodes in
hard to diagnose ways.

Because between

        movq	%rsp, %rdi
and
        call    ....

can legitimately be other code which causes the stack pointer to
change. It's not the case today, but nothing prevents this in the
future.

The correct thing to do is:

        movq	%rsp, %rdi
        RSP_MAKE_PT_REGS_AUX_SPACE
        call	...
        RSP_REMOVE_PT_REGS_AUX_SPACE

The few extra macro lines in the actual code are way better as they make
it completely obvious what's going on and any misuse can be spotted
easily.

> +#ifdef CONFIG_ARCH_ENABLE_SUPERVISOR_PKEYS
> +/*
> + * PKRS is a per-logical-processor MSR which overlays additional protection for
> + * pages which have been mapped with a protection key.
> + *
> + * Context switches save the MSR in the task struct thus taking that value to
> + * other processors if necessary.
> + *
> + * To protect against exceptions having access to this memory save the current
> + * thread value and set the PKRS value to be used during the exception.
> + */
> +void pkrs_save_irq(struct pt_regs *regs)

That's a misnomer as this is invoked for _any_ exception not just
interrupts.

>  #ifdef CONFIG_XEN_PV
>  #ifndef CONFIG_PREEMPTION
>  /*
> @@ -309,6 +361,8 @@ __visible noinstr void xen_pv_evtchn_do_upcall(struct pt_regs *regs)
>  
>  	inhcall = get_and_clear_inhcall();
>  	if (inhcall && !WARN_ON_ONCE(state.exit_rcu)) {
> +		/* Normally called by irqentry_exit, restore pkrs here */
> +		pkrs_restore_irq(regs);
> 		irqentry_exit_cond_resched();

Sigh. Consistency is overrated....

> +
>  void setup_pks(void);
>  void pkrs_write_current(void);
>  void pks_init_task(struct task_struct *task);
> +void write_pkrs(u32 new_pkrs);

So we have pkrs_write_current() and write_pkrs() now. Can you please
stick to a common prefix, i.e. pkrs_ ?

> diff --git a/kernel/entry/common.c b/kernel/entry/common.c
> index bf16395b9e13..aa0b1e8dd742 100644
> --- a/kernel/entry/common.c
> +++ b/kernel/entry/common.c
> @@ -6,6 +6,7 @@
>  #include <linux/livepatch.h>
>  #include <linux/audit.h>
>  #include <linux/tick.h>
> +#include <linux/pkeys.h>
>  
>  #include "common.h"
>  
> @@ -364,7 +365,7 @@ noinstr irqentry_state_t irqentry_enter(struct pt_regs *regs)
>  		instrumentation_end();
>  
>  		ret.exit_rcu = true;
> -		return ret;
> +		goto done;
>  	}
>  
>  	/*
> @@ -379,6 +380,8 @@ noinstr irqentry_state_t irqentry_enter(struct pt_regs *regs)
>  	trace_hardirqs_off_finish();
>  	instrumentation_end();
>  
> +done:
> +	pkrs_save_irq(regs);

This still calls out into instrumentable code. I explained you before
why this is wrong. Also objtool emits warnings to that effect if you do a
proper verified build.

>  	return ret;
>  }
>  
> @@ -404,7 +407,12 @@ noinstr void irqentry_exit(struct pt_regs *regs, irqentry_state_t state)
>  	/* Check whether this returns to user mode */
>  	if (user_mode(regs)) {
>  		irqentry_exit_to_user_mode(regs);
> -	} else if (!regs_irqs_disabled(regs)) {
> +		return;
> +	}
> +
> +	pkrs_restore_irq(regs);

At least you are now putting it consistently at the wrong place
vs. noinstr.

Though, if you look at the xen_pv_evtchn_do_upcall() part where you
added this extra invocation you might figure out that adding
pkrs_restore_irq() to irqentry_exit_cond_resched() and explicitely to
the 'else' path in irqentry_exit() makes it magically consistent for
both use cases.

Thanks,

        tglx

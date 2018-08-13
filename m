Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com
 [148.163.156.1])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 02310210D97A9
 for <linux-nvdimm@lists.01.org>; Mon, 13 Aug 2018 08:49:18 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
 by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id
 w7DFlDaV085487
 for <linux-nvdimm@lists.01.org>; Mon, 13 Aug 2018 11:49:17 -0400
Received: from e32.co.us.ibm.com (e32.co.us.ibm.com [32.97.110.150])
 by mx0a-001b2d01.pphosted.com with ESMTP id 2kua5q01dh-1
 (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
 for <linux-nvdimm@lists.01.org>; Mon, 13 Aug 2018 11:49:17 -0400
Received: from localhost
 by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
 Violators will be prosecuted
 for <linux-nvdimm@lists.01.org> from <arbab@linux.ibm.com>;
 Mon, 13 Aug 2018 09:49:16 -0600
Date: Mon, 13 Aug 2018 10:49:10 -0500
From: Reza Arbab <arbab@linux.ibm.com>
Subject: Re: [PATCH v2 3/3] powerpc/mce: Handle memcpy_mcsafe
References: <20180405071500.22320-1-bsingharora@gmail.com>
 <20180405071500.22320-4-bsingharora@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180405071500.22320-4-bsingharora@gmail.com>
Message-Id: <20180813154910.lzrkd2ivdorge3ro@arbab-laptop.localdomain>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Balbir Singh <bsingharora@gmail.com>
Cc: linuxppc-dev@lists.ozlabs.org, npiggin@gmail.com, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Apr 05, 2018 at 05:15:00PM +1000, Balbir Singh wrote:
>Add a blocking notifier callback to be called in real-mode
>on machine check exceptions for UE (ld/st) errors only.

It's been a while, but is this patchset still being pursued?

This patch in particular (callbacks for MCE handling) has other device 
memory use cases and I'd like to move it along.

>The patch registers a callback on boot to be notified
>of machine check exceptions and returns a NOTIFY_STOP when
>a page of interest is seen as the source of the machine
>check exception. This page of interest is a ZONE_DEVICE
>page and hence for now, for memcpy_mcsafe to work, the page
>needs to belong to ZONE_DEVICE and memcpy_mcsafe should be
>used to access the memory.
>
>The patch also modifies the NIP of the exception context
>to go back to the fixup handler (in memcpy_mcsafe) and does
>not print any error message as the error is treated as
>returned via a return value and handled.
>
>Signed-off-by: Balbir Singh <bsingharora@gmail.com>
>---
> arch/powerpc/include/asm/mce.h |  3 +-
> arch/powerpc/kernel/mce.c      | 77 ++++++++++++++++++++++++++++++++++++++++--
> 2 files changed, 77 insertions(+), 3 deletions(-)
>
>diff --git a/arch/powerpc/include/asm/mce.h b/arch/powerpc/include/asm/mce.h
>index 3a1226e9b465..a76638e3e47e 100644
>--- a/arch/powerpc/include/asm/mce.h
>+++ b/arch/powerpc/include/asm/mce.h
>@@ -125,7 +125,8 @@ struct machine_check_event {
> 			enum MCE_UeErrorType ue_error_type:8;
> 			uint8_t		effective_address_provided;
> 			uint8_t		physical_address_provided;
>-			uint8_t		reserved_1[5];
>+			uint8_t		error_return;
>+			uint8_t		reserved_1[4];
> 			uint64_t	effective_address;
> 			uint64_t	physical_address;
> 			uint8_t		reserved_2[8];
>diff --git a/arch/powerpc/kernel/mce.c b/arch/powerpc/kernel/mce.c
>index efdd16a79075..b9e4881fa8c5 100644
>--- a/arch/powerpc/kernel/mce.c
>+++ b/arch/powerpc/kernel/mce.c
>@@ -28,7 +28,9 @@
> #include <linux/percpu.h>
> #include <linux/export.h>
> #include <linux/irq_work.h>
>+#include <linux/extable.h>
>
>+#include <asm/extable.h>
> #include <asm/machdep.h>
> #include <asm/mce.h>
>
>@@ -54,6 +56,52 @@ static struct irq_work mce_event_process_work = {
>
> DECLARE_WORK(mce_ue_event_work, machine_process_ue_event);
>
>+static BLOCKING_NOTIFIER_HEAD(mce_notifier_list);
>+
>+int register_mce_notifier(struct notifier_block *nb)
>+{
>+	return blocking_notifier_chain_register(&mce_notifier_list, nb);
>+}
>+EXPORT_SYMBOL_GPL(register_mce_notifier);
>+
>+int unregister_mce_notifier(struct notifier_block *nb)
>+{
>+	return blocking_notifier_chain_unregister(&mce_notifier_list, nb);
>+}
>+EXPORT_SYMBOL_GPL(unregister_mce_notifier);
>+
>+
>+static int check_memcpy_mcsafe(struct notifier_block *nb,
>+			unsigned long val, void *data)
>+{
>+	/*
>+	 * val contains the physical_address of the bad address
>+	 */
>+	unsigned long pfn = val >> PAGE_SHIFT;
>+	struct page *page = realmode_pfn_to_page(pfn);
>+	int rc = NOTIFY_DONE;
>+
>+	if (!page)
>+		goto out;
>+
>+	if (is_zone_device_page(page))	/* for HMM and PMEM */
>+		rc = NOTIFY_STOP;
>+out:
>+	return rc;
>+}
>+
>+struct notifier_block memcpy_mcsafe_nb = {
>+	.priority = 0,
>+	.notifier_call = check_memcpy_mcsafe,
>+};
>+
>+int  mce_mcsafe_register(void)
>+{
>+	register_mce_notifier(&memcpy_mcsafe_nb);
>+	return 0;
>+}
>+arch_initcall(mce_mcsafe_register);
>+
> static void mce_set_error_info(struct machine_check_event *mce,
> 			       struct mce_error_info *mce_err)
> {
>@@ -151,9 +199,31 @@ void save_mce_event(struct pt_regs *regs, long handled,
> 		mce->u.ue_error.effective_address_provided = true;
> 		mce->u.ue_error.effective_address = addr;
> 		if (phys_addr != ULONG_MAX) {
>+			int rc;
>+			const struct exception_table_entry *entry;
>+
>+			/*
>+			 * Once we have the physical address, we check to
>+			 * see if the current nip has a fixup entry.
>+			 * Having a fixup entry plus the notifier stating
>+			 * that it can handle the exception is an indication
>+			 * that we should return to the fixup entry and
>+			 * return an error from there
>+			 */
> 			mce->u.ue_error.physical_address_provided = true;
> 			mce->u.ue_error.physical_address = phys_addr;
>-			machine_check_ue_event(mce);
>+
>+			rc = blocking_notifier_call_chain(&mce_notifier_list,
>+							phys_addr, NULL);

Could we pass mce entirely here instead of just phys_addr? It would 
allow the callback itself to set error_return if needed.

>+			if (rc & NOTIFY_STOP_MASK) {
>+				entry = search_exception_tables(regs->nip);
>+				if (entry != NULL) {
>+					mce->u.ue_error.error_return = 1;
>+					regs->nip = extable_fixup(entry);
>+				} else
>+					machine_check_ue_event(mce);
>+			} else
>+				machine_check_ue_event(mce);
> 		}
> 	}
> 	return;

With the above, this logic would be simplified. So,

	rc = blocking_notifier_call_chain(&mce_notifier_list,
				(unsigned long)mce, NULL);
	if (rc & NOTIFY_STOP_MASK) {
		entry = search_exception_tables(regs->nip);
		if (entry != NULL) {
			mce->u.ue_error.error_return = 1;
			regs->nip = extable_fixup(entry);
		}
	}

	if (!mce->u.ue_error.error_return)
		machine_check_ue_event(mce);

>@@ -208,7 +278,6 @@ void release_mce_event(void)
> 	get_mce_event(NULL, true);
> }
>
>-
> /*
>  * Queue up the MCE event which then can be handled later.
>  */
>@@ -239,6 +308,10 @@ void machine_check_queue_event(void)
> 	if (!get_mce_event(&evt, MCE_EVENT_RELEASE))
> 		return;
>
>+	if (evt.error_type == MCE_ERROR_TYPE_UE &&
>+			evt.u.ue_error.error_return == 1)
>+		return;
>+
> 	index = __this_cpu_inc_return(mce_queue_count) - 1;
> 	/* If queue is full, just return for now. */
> 	if (index >= MAX_MC_EVT) {
>-- 
>2.13.6
>

-- 
Reza Arbab

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

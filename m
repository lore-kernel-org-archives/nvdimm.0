Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 by ml01.01.org (Postfix) with ESMTP id 5DE001A1E9C
 for <linux-nvdimm@lists.01.org>; Sat,  9 Jul 2016 20:28:43 -0700 (PDT)
Subject: [PATCH v2 15/17] Revert "KVM: x86: add pcommit support"
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 09 Jul 2016 20:25:49 -0700
Message-ID: <146812114910.32932.3209362338012516482.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <146812106839.32932.2870621200867047059.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <146812106839.32932.2870621200867047059.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: linux-nvdimm@lists.01.org
Cc: Xiao Guangrong <guangrong.xiao@linux.intel.com>, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, linux-fsdevel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

This reverts commit 8b3e34e46aca9b6d349b331cd9cf71ccbdc91b2e.

Given the deprecation of the pcommit instruction, revert its usage as a
vm exit source in kvm.

Cc: Xiao Guangrong <guangrong.xiao@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/x86/include/asm/vmx.h      |    1 -
 arch/x86/include/uapi/asm/vmx.h |    4 +---
 arch/x86/kvm/cpuid.c            |    2 +-
 arch/x86/kvm/cpuid.h            |    8 --------
 arch/x86/kvm/vmx.c              |   32 ++++----------------------------
 5 files changed, 6 insertions(+), 41 deletions(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 14c63c7e8337..a002b07a7099 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -72,7 +72,6 @@
 #define SECONDARY_EXEC_SHADOW_VMCS              0x00004000
 #define SECONDARY_EXEC_ENABLE_PML               0x00020000
 #define SECONDARY_EXEC_XSAVES			0x00100000
-#define SECONDARY_EXEC_PCOMMIT			0x00200000
 #define SECONDARY_EXEC_TSC_SCALING              0x02000000
 
 #define PIN_BASED_EXT_INTR_MASK                 0x00000001
diff --git a/arch/x86/include/uapi/asm/vmx.h b/arch/x86/include/uapi/asm/vmx.h
index 5b15d94a33f8..37fee272618f 100644
--- a/arch/x86/include/uapi/asm/vmx.h
+++ b/arch/x86/include/uapi/asm/vmx.h
@@ -78,7 +78,6 @@
 #define EXIT_REASON_PML_FULL            62
 #define EXIT_REASON_XSAVES              63
 #define EXIT_REASON_XRSTORS             64
-#define EXIT_REASON_PCOMMIT             65
 
 #define VMX_EXIT_REASONS \
 	{ EXIT_REASON_EXCEPTION_NMI,         "EXCEPTION_NMI" }, \
@@ -127,8 +126,7 @@
 	{ EXIT_REASON_INVVPID,               "INVVPID" }, \
 	{ EXIT_REASON_INVPCID,               "INVPCID" }, \
 	{ EXIT_REASON_XSAVES,                "XSAVES" }, \
-	{ EXIT_REASON_XRSTORS,               "XRSTORS" }, \
-	{ EXIT_REASON_PCOMMIT,               "PCOMMIT" }
+	{ EXIT_REASON_XRSTORS,               "XRSTORS" }
 
 #define VMX_ABORT_SAVE_GUEST_MSR_FAIL        1
 #define VMX_ABORT_LOAD_HOST_MSR_FAIL         4
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 7597b42a8a88..643565364497 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -366,7 +366,7 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 		F(FSGSBASE) | F(BMI1) | F(HLE) | F(AVX2) | F(SMEP) |
 		F(BMI2) | F(ERMS) | f_invpcid | F(RTM) | f_mpx | F(RDSEED) |
 		F(ADX) | F(SMAP) | F(AVX512F) | F(AVX512PF) | F(AVX512ER) |
-		F(AVX512CD) | F(CLFLUSHOPT) | F(CLWB) | F(PCOMMIT);
+		F(AVX512CD) | F(CLFLUSHOPT) | F(CLWB);
 
 	/* cpuid 0xD.1.eax */
 	const u32 kvm_cpuid_D_1_eax_x86_features =
diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index e17a74b1d852..35058c2c0eea 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -144,14 +144,6 @@ static inline bool guest_cpuid_has_rtm(struct kvm_vcpu *vcpu)
 	return best && (best->ebx & bit(X86_FEATURE_RTM));
 }
 
-static inline bool guest_cpuid_has_pcommit(struct kvm_vcpu *vcpu)
-{
-	struct kvm_cpuid_entry2 *best;
-
-	best = kvm_find_cpuid_entry(vcpu, 7, 0);
-	return best && (best->ebx & bit(X86_FEATURE_PCOMMIT));
-}
-
 static inline bool guest_cpuid_has_rdtscp(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpuid_entry2 *best;
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index fb93010beaa4..2e2685424fdc 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2705,8 +2705,7 @@ static void nested_vmx_setup_ctls_msrs(struct vcpu_vmx *vmx)
 		SECONDARY_EXEC_APIC_REGISTER_VIRT |
 		SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY |
 		SECONDARY_EXEC_WBINVD_EXITING |
-		SECONDARY_EXEC_XSAVES |
-		SECONDARY_EXEC_PCOMMIT;
+		SECONDARY_EXEC_XSAVES;
 
 	if (enable_ept) {
 		/* nested EPT: emulate EPT also to L1 */
@@ -3268,7 +3267,6 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf)
 			SECONDARY_EXEC_SHADOW_VMCS |
 			SECONDARY_EXEC_XSAVES |
 			SECONDARY_EXEC_ENABLE_PML |
-			SECONDARY_EXEC_PCOMMIT |
 			SECONDARY_EXEC_TSC_SCALING;
 		if (adjust_vmx_controls(min2, opt2,
 					MSR_IA32_VMX_PROCBASED_CTLS2,
@@ -4856,9 +4854,6 @@ static u32 vmx_secondary_exec_control(struct vcpu_vmx *vmx)
 	if (!enable_pml)
 		exec_control &= ~SECONDARY_EXEC_ENABLE_PML;
 
-	/* Currently, we allow L1 guest to directly run pcommit instruction. */
-	exec_control &= ~SECONDARY_EXEC_PCOMMIT;
-
 	return exec_control;
 }
 
@@ -4902,9 +4897,10 @@ static int vmx_vcpu_setup(struct vcpu_vmx *vmx)
 
 	vmcs_write32(CPU_BASED_VM_EXEC_CONTROL, vmx_exec_control(vmx));
 
-	if (cpu_has_secondary_exec_ctrls())
+	if (cpu_has_secondary_exec_ctrls()) {
 		vmcs_write32(SECONDARY_VM_EXEC_CONTROL,
 				vmx_secondary_exec_control(vmx));
+	}
 
 	if (kvm_vcpu_apicv_active(&vmx->vcpu)) {
 		vmcs_write64(EOI_EXIT_BITMAP0, 0);
@@ -7557,13 +7553,6 @@ static int handle_pml_full(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
-static int handle_pcommit(struct kvm_vcpu *vcpu)
-{
-	/* we never catch pcommit instruct for L1 guest. */
-	WARN_ON(1);
-	return 1;
-}
-
 /*
  * The exit handlers return 1 if the exit was handled fully and guest execution
  * may resume.  Otherwise they set the kvm_run parameter to indicate what needs
@@ -7614,7 +7603,6 @@ static int (*const kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu) = {
 	[EXIT_REASON_XSAVES]                  = handle_xsaves,
 	[EXIT_REASON_XRSTORS]                 = handle_xrstors,
 	[EXIT_REASON_PML_FULL]		      = handle_pml_full,
-	[EXIT_REASON_PCOMMIT]                 = handle_pcommit,
 };
 
 static const int kvm_vmx_max_exit_handlers =
@@ -7923,8 +7911,6 @@ static bool nested_vmx_exit_handled(struct kvm_vcpu *vcpu)
 		 * the XSS exit bitmap in vmcs12.
 		 */
 		return nested_cpu_has2(vmcs12, SECONDARY_EXEC_XSAVES);
-	case EXIT_REASON_PCOMMIT:
-		return nested_cpu_has2(vmcs12, SECONDARY_EXEC_PCOMMIT);
 	default:
 		return true;
 	}
@@ -9085,15 +9071,6 @@ static void vmx_cpuid_update(struct kvm_vcpu *vcpu)
 
 	if (cpu_has_secondary_exec_ctrls())
 		vmcs_set_secondary_exec_control(secondary_exec_ctl);
-
-	if (static_cpu_has(X86_FEATURE_PCOMMIT) && nested) {
-		if (guest_cpuid_has_pcommit(vcpu))
-			vmx->nested.nested_vmx_secondary_ctls_high |=
-				SECONDARY_EXEC_PCOMMIT;
-		else
-			vmx->nested.nested_vmx_secondary_ctls_high &=
-				~SECONDARY_EXEC_PCOMMIT;
-	}
 }
 
 static void vmx_set_supported_cpuid(u32 func, struct kvm_cpuid_entry2 *entry)
@@ -9706,8 +9683,7 @@ static void prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
 		exec_control &= ~(SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES |
 				  SECONDARY_EXEC_RDTSCP |
 				  SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY |
-				  SECONDARY_EXEC_APIC_REGISTER_VIRT |
-				  SECONDARY_EXEC_PCOMMIT);
+				  SECONDARY_EXEC_APIC_REGISTER_VIRT);
 		if (nested_cpu_has(vmcs12,
 				CPU_BASED_ACTIVATE_SECONDARY_CONTROLS))
 			exec_control |= vmcs12->secondary_vm_exec_control;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

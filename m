From: Larry Bassel <larry.bassel@oracle.com>
Subject: [PATCH, RFC 1/2] Add config option to enable FS/DAX PMD sharing
Date: Thu,  9 May 2019 09:05:32 -0700
Message-ID: <1557417933-15701-2-git-send-email-larry.bassel@oracle.com>
References: <1557417933-15701-1-git-send-email-larry.bassel@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1557417933-15701-1-git-send-email-larry.bassel@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: mike.kravetz@oracle.com, willy@infradead.org, dan.j.williams@intel.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
Cc: Larry Bassel <larry.bassel@oracle.com>
List-Id: linux-nvdimm@lists.01.org

If enabled, sharing of FS/DAX PMDs will be attempted.

Signed-off-by: Larry Bassel <larry.bassel@oracle.com>
---
 arch/x86/Kconfig | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index e721273..e11702e 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -297,6 +297,9 @@ config ARCH_SUSPEND_POSSIBLE
 config ARCH_WANT_HUGE_PMD_SHARE
 	def_bool y
 
+config MAY_SHARE_FSDAX_PMD
+	def_bool y
+
 config ARCH_WANT_GENERAL_HUGETLB
 	def_bool y
 
-- 
1.8.3.1

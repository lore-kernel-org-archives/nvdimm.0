Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1419129CA
	for <nvdimm@lists.linux.dev>; Wed,  4 Aug 2021 04:32:38 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10065"; a="299433050"
X-IronPort-AV: E=Sophos;i="5.84,293,1620716400"; 
   d="scan'208";a="299433050"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2021 21:32:35 -0700
X-IronPort-AV: E=Sophos;i="5.84,293,1620716400"; 
   d="scan'208";a="511702663"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.147])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2021 21:32:35 -0700
From: ira.weiny@intel.com
To: Dave Hansen <dave.hansen@linux.intel.com>,
	Dan Williams <dan.j.williams@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Andy Lutomirski <luto@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Fenghua Yu <fenghua.yu@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-mm@kvack.org
Subject: [PATCH V7 03/18] x86/pks: Add additional PKEY helper macros
Date: Tue,  3 Aug 2021 21:32:16 -0700
Message-Id: <20210804043231.2655537-4-ira.weiny@intel.com>
X-Mailer: git-send-email 2.28.0.rc0.12.gb6a658bd00c9
In-Reply-To: <20210804043231.2655537-1-ira.weiny@intel.com>
References: <20210804043231.2655537-1-ira.weiny@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ira Weiny <ira.weiny@intel.com>

Avoid open coding shift and mask operations by defining and using helper
macros for PKey operations.

Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 arch/x86/include/asm/pkeys_common.h | 6 +++++-
 arch/x86/include/asm/pkru.h         | 6 ++----
 arch/x86/mm/pkeys.c                 | 8 +++-----
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/pkeys_common.h b/arch/x86/include/asm/pkeys_common.h
index f3277717faeb..8a3c6d2e6a8a 100644
--- a/arch/x86/include/asm/pkeys_common.h
+++ b/arch/x86/include/asm/pkeys_common.h
@@ -6,6 +6,10 @@
 #define PKR_WD_BIT 0x2
 #define PKR_BITS_PER_PKEY 2
 
-#define PKR_AD_KEY(pkey)	(PKR_AD_BIT << ((pkey) * PKR_BITS_PER_PKEY))
+#define PKR_PKEY_SHIFT(pkey) (pkey * PKR_BITS_PER_PKEY)
+#define PKR_PKEY_MASK(pkey)  (((1 << PKR_BITS_PER_PKEY) - 1) << PKR_PKEY_SHIFT(pkey))
+
+#define PKR_AD_KEY(pkey)     (PKR_AD_BIT << PKR_PKEY_SHIFT(pkey))
+#define PKR_WD_KEY(pkey)     (PKR_WD_BIT << PKR_PKEY_SHIFT(pkey))
 
 #endif /*_ASM_X86_PKEYS_COMMON_H */
diff --git a/arch/x86/include/asm/pkru.h b/arch/x86/include/asm/pkru.h
index a74325b0d1df..fb44ff542028 100644
--- a/arch/x86/include/asm/pkru.h
+++ b/arch/x86/include/asm/pkru.h
@@ -15,15 +15,13 @@ extern u32 init_pkru_value;
 
 static inline bool __pkru_allows_read(u32 pkru, u16 pkey)
 {
-	int pkru_pkey_bits = pkey * PKR_BITS_PER_PKEY;
-	return !(pkru & (PKR_AD_BIT << pkru_pkey_bits));
+	return !(pkru & PKR_AD_KEY(pkey));
 }
 
 static inline bool __pkru_allows_write(u32 pkru, u16 pkey)
 {
-	int pkru_pkey_bits = pkey * PKR_BITS_PER_PKEY;
 	/* Access-disable disables writes too so check both bits here. */
-	return !(pkru & ((PKR_AD_BIT|PKR_WD_BIT) << pkru_pkey_bits));
+	return !(pkru & (PKR_AD_KEY(pkey) | PKR_WD_KEY(pkey)));
 }
 
 static inline u32 read_pkru(void)
diff --git a/arch/x86/mm/pkeys.c b/arch/x86/mm/pkeys.c
index ca2e20b18645..75437aa8fc56 100644
--- a/arch/x86/mm/pkeys.c
+++ b/arch/x86/mm/pkeys.c
@@ -200,16 +200,14 @@ __setup("init_pkru=", setup_init_pkru);
  */
 u32 update_pkey_val(u32 pk_reg, int pkey, unsigned int flags)
 {
-	int pkey_shift = pkey * PKR_BITS_PER_PKEY;
-
 	/*  Mask out old bit values */
-	pk_reg &= ~(((1 << PKR_BITS_PER_PKEY) - 1) << pkey_shift);
+	pk_reg &= ~PKR_PKEY_MASK(pkey);
 
 	/*  Or in new values */
 	if (flags & PKEY_DISABLE_ACCESS)
-		pk_reg |= PKR_AD_BIT << pkey_shift;
+		pk_reg |= PKR_AD_KEY(pkey);
 	if (flags & PKEY_DISABLE_WRITE)
-		pk_reg |= PKR_WD_BIT << pkey_shift;
+		pk_reg |= PKR_WD_KEY(pkey);
 
 	return pk_reg;
 }
-- 
2.28.0.rc0.12.gb6a658bd00c9


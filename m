Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1161421F0D;
	Mon, 29 Jun 2026 12:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782735925; cv=none; b=s2wBdpDlEQsFnN8GyuArHTQin2zMb6Df4ZoUJuuLJ4o19CRY6JNO/hal5MDGGdLmlyKH8hi7ATTKkbww+Wblh7nwQd5Gh0vnskR/p4wy5U0VXZfoSAQR5vlL4XbVYc42//BYcwwxP6zgnTExItr7v1gLdmRgh0OMRkqmxESE3rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782735925; c=relaxed/simple;
	bh=t+8gFzSgortJ9Yri19Qk2JIjo2XNvjKtlYrTb45fUok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nv6jSK84k7RaAS/+jTMW6eyPByv2eF2AOzfLRjnNaU8+kMbL+/cvUXIi6rmByf4aS5ZgbVv+d1PrgxBSMgc+I3ah4toLOoiO9p2OKjAFNj08RePa14FPk14YsEFBcPpI9egxOOBNLGX5sXkw2OIxHobSHu3OHT5BPmiVhgz+9SA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c2fdxPuJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c2fdxPuJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1F691F00AC4;
	Mon, 29 Jun 2026 12:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782735924;
	bh=U1jtLkA6UuZsfpQiwXDViZ4TbQirP1iCEgORsJjMVIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c2fdxPuJZracea4THiWagUGG3qtjKlYQLO8kI5qBAOAmNyUqU+Cz2tE0LZcZK/+x6
	 6Xk6iEoGktAUHyeB9cblz74jdddGkwaBjm0aSRvDSQySW3n0Fr3QzWtICG5O83ECq+
	 CpGzQfZJaEmCid2LM+2XsU2ThNJ23kEbysH1NlUtWxqEIESKzs4x6d5f0OSVrFyJfm
	 j3TScuQr22512dqslB4Ah+zgS28CuS/F239kYvXoA+o5vDrfUPnKKgS1tQAkh4mNti
	 ITFv6t9aZ5OoDpmTegOvjzsXL8lUZRPNTyuRby3AAe3GvKu9tkUXabe/jqKUOVL1Ww
	 sDInYPPHhFcHQ==
From: Lorenzo Stoakes <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Russell King <linux@armlinux.org.uk>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Simon Schuster <schuster.simon@siemens-energy.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Helge Deller <deller@gmx.de>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	Ian Abbott <abbotti@mev.co.uk>,
	H Hartley Sweeten <hsweeten@visionengravers.com>,
	Lucas Stach <l.stach@pengutronix.de>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Dmitry Baryshkov <lumag@kernel.org>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Thierry Reding <thierry.reding@kernel.org>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	Christian Koenig <christian.koenig@amd.com>,
	Huang Rui <ray.huang@amd.com>,
	Ankit Agrawal <ankita@nvidia.com>,
	Alex Williamson <alex@shazbot.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Dan Williams <djbw@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Matthew Wilcox <willy@infradead.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	SeongJae Park <sj@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Hugh Dickins <hughd@google.com>,
	Mike Rapoport <rppt@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-parisc@vger.kernel.org,
	linux-sgx@vger.kernel.org,
	etnaviv@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-arm-msm@vger.kernel.org,
	freedreno@lists.freedesktop.org,
	linux-tegra@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-mm@kvack.org,
	iommu@lists.linux.dev,
	linux-perf-users@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	damon@lists.linux.dev,
	Pedro Falcato <pfalcato@suse.de>,
	Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry@kernel.org>,
	Jann Horn <jannh@google.com>
Subject: [PATCH 30/30] tools/testing/vma: output compared expression on ASSERT_[EQ, NE]()
Date: Mon, 29 Jun 2026 13:23:41 +0100
Message-ID: <432444fa4c12ae1c4047550e2b205d3e9bab458f.1782735110.git.ljs@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1782735110.git.ljs@kernel.org>
References: <cover.1782735110.git.ljs@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update the macros to output the compared values at hex for easier debugging
when test asserts fail.

Also remove unused IS_SET() macro.

Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 tools/testing/vma/shared.h | 31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff --git a/tools/testing/vma/shared.h b/tools/testing/vma/shared.h
index ca4f1238f1c7..216be4cda369 100644
--- a/tools/testing/vma/shared.h
+++ b/tools/testing/vma/shared.h
@@ -21,19 +21,28 @@
 		}							\
 	} while (0)

-#define ASSERT_TRUE(_expr)						\
-	do {								\
-		if (!(_expr)) {						\
-			fprintf(stderr,					\
-				"Assert FAILED at %s:%d:%s(): %s is FALSE.\n", \
-				__FILE__, __LINE__, __FUNCTION__, #_expr); \
-			return false;					\
-		}							\
+#define __ASSERT_TRUE(_expr, _fmt, ...)					   \
+	do {								   \
+		if (!(_expr)) {						   \
+			fprintf(stderr,					   \
+				"Assert FAILED at %s:%d:%s(): %s is FALSE" \
+				_fmt ".\n",				   \
+				__FILE__, __LINE__, __FUNCTION__, #_expr   \
+				__VA_OPT__(,) __VA_ARGS__);		   \
+			return false;					   \
+		}							   \
 	} while (0)

+#define __TO_SCALAR(x)	((unsigned long long)(uintptr_t)(x))
+
+#define ASSERT_TRUE(_expr) __ASSERT_TRUE(_expr, "")
 #define ASSERT_FALSE(_expr) ASSERT_TRUE(!(_expr))
-#define ASSERT_EQ(_val1, _val2) ASSERT_TRUE((_val1) == (_val2))
-#define ASSERT_NE(_val1, _val2) ASSERT_TRUE((_val1) != (_val2))
+#define ASSERT_EQ(_val1, _val2)						\
+	__ASSERT_TRUE((_val1) == (_val2), " (0x%llx != 0x%llx)",	\
+		      __TO_SCALAR(_val1), __TO_SCALAR(_val2))
+#define ASSERT_NE(_val1, _val2) \
+	__ASSERT_TRUE((_val1) != (_val2), " (0x%llx == 0x%llx)", \
+		       __TO_SCALAR(_val1), __TO_SCALAR(_val2))

 #define ASSERT_FLAGS_SAME_MASK(_flags, _flags_other) \
 	ASSERT_TRUE(vma_flags_same_mask((_flags), (_flags_other)))
@@ -53,8 +62,6 @@
 #define ASSERT_FLAGS_NONEMPTY(_flags) \
 	ASSERT_FALSE(vma_flags_empty(_flags))

-#define IS_SET(_val, _flags) ((_val & _flags) == _flags)
-
 extern bool fail_prealloc;

 /* Override vma_iter_prealloc() so we can choose to fail it. */
--
2.54.0

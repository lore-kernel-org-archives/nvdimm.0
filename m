Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE1267B;
	Thu, 30 Jun 2022 16:35:35 +0000 (UTC)
Received: by mail-wm1-f46.google.com with SMTP id l68so6660147wml.3;
        Thu, 30 Jun 2022 09:35:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lZIrTmlOnvUkLrFbSOhPtwGibISpt/RODIchaEd1CDY=;
        b=gvOxH2z87z7QsFkRgTQuNhQyyz+dHV1+8rh1sM7GpDupM74IOa6Ym2zyVx4Y0mEnkA
         xFy3h+4BLgQAGQb7kHWwxfMcgIUz4Tef84LuOZORClSobvlsqYZZA4JRBDfKNY3iS9A8
         W3vDemOPYtYp6bt4LA+muwinmH5c50oo9YbK3ghNa7sz/mzg54ZgVTtrFKX2Cgzw+P3N
         ELSRjvVF4ivQ1YmTMe+MNMmYKoyNYpV+LtXu6h2BXUafKGQrVOGF0X6LVvrsdTzc/XfD
         EcDDOVPqA+9w2kvc7GCTWMKYCQjY0KUvF3eMQA1meIaibaLIqLPbyUm6YJoKiAbmsj+a
         uGnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lZIrTmlOnvUkLrFbSOhPtwGibISpt/RODIchaEd1CDY=;
        b=W2jsSNnaYrLwpbKkLNqdtIJ/60IEKxIa64JCsfIbRcdE0xySu0gK+9zk3d11scG9Yg
         aHqXorx5i/PTfcWANKkCVWoYQsuE/CUWpvxoO7MkuYrRxOsJTugiM4LEBSS0vXm+8oQR
         QukFmvgDE/aH96kVh+9c25tivstLE9+tjfmiEl2oGx4tG/Uf0Gdbdrk6Q+nk04deFxXE
         at47ywlb4dw3j21urQWF7m9r45XWkNTJBN1gwQ1qAiLB7eiNoj3NhHgq6x34ziJ6Nq39
         BJuMGzGHT02s0WUWdszkDqn+Tf5Xky5nmYL6xd56ZM4f6FwEwz72n/IkOq0VghbRPjLM
         +cQA==
X-Gm-Message-State: AJIora+Lj42/DZGfM1op+MCbd+wvn3gbSTVP1CcPdOlC1/unGX4SAGLf
	vqx7muzU93ax17EWTVj1cFo=
X-Google-Smtp-Source: AGRyM1sQNe4+WIPmqW10XET/JjOyzodgMYKlJLfdcugPO9fE6FCvfEevPFPhlgS/sBSR469fLSNDFQ==
X-Received: by 2002:a1c:4b11:0:b0:3a0:4270:fcfa with SMTP id y17-20020a1c4b11000000b003a04270fcfamr12974836wma.53.1656606933805;
        Thu, 30 Jun 2022 09:35:33 -0700 (PDT)
Received: from localhost.localdomain (host-87-6-98-182.retail.telecomitalia.it. [87.6.98.182])
        by smtp.gmail.com with ESMTPSA id u3-20020a05600c210300b003a044fe7fe7sm7112303wml.9.2022.06.30.09.35.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jun 2022 09:35:32 -0700 (PDT)
From: "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
To: Benjamin LaHaise <bcrl@kvack.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Eric Biederman <ebiederm@xmission.com>,
	Kees Cook <keescook@chromium.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Tom Rix <trix@redhat.com>,
	linux-aio@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	nvdimm@lists.linux.dev,
	io-uring@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	llvm@lists.linux.dev
Cc: "Fabio M. De Francesco" <fmdefrancesco@gmail.com>,
	Ira Weiny <ira.weiny@intel.com>
Subject: [PATCH] fs: Replace kmap{,_atomic}() with kmap_local_page()
Date: Thu, 30 Jun 2022 18:35:27 +0200
Message-Id: <20220630163527.9776-1-fmdefrancesco@gmail.com>
X-Mailer: git-send-email 2.36.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The use of kmap() and kmap_atomic() are being deprecated in favor of
kmap_local_page().

With kmap_local_page(), the mappings are per thread, CPU local and not
globally visible. Furthermore, the mappings can be acquired from any
context (including interrupts).

Therefore, use kmap_local_page() in exec.c because these mappings are per
thread, CPU local, and not globally visible.

Tested with xfstests on a QEMU + KVM 32-bits VM booting a kernel with
HIGHMEM64GB enabled.

Suggested-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>
---
 fs/exec.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 0989fb8472a1..4a2129c0d422 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -583,11 +583,11 @@ static int copy_strings(int argc, struct user_arg_ptr argv,
 
 				if (kmapped_page) {
 					flush_dcache_page(kmapped_page);
-					kunmap(kmapped_page);
+					kunmap_local(kaddr);
 					put_arg_page(kmapped_page);
 				}
 				kmapped_page = page;
-				kaddr = kmap(kmapped_page);
+				kaddr = kmap_local_page(kmapped_page);
 				kpos = pos & PAGE_MASK;
 				flush_arg_page(bprm, kpos, kmapped_page);
 			}
@@ -601,7 +601,7 @@ static int copy_strings(int argc, struct user_arg_ptr argv,
 out:
 	if (kmapped_page) {
 		flush_dcache_page(kmapped_page);
-		kunmap(kmapped_page);
+		kunmap_local(kaddr);
 		put_arg_page(kmapped_page);
 	}
 	return ret;
@@ -883,11 +883,11 @@ int transfer_args_to_stack(struct linux_binprm *bprm,
 
 	for (index = MAX_ARG_PAGES - 1; index >= stop; index--) {
 		unsigned int offset = index == stop ? bprm->p & ~PAGE_MASK : 0;
-		char *src = kmap(bprm->page[index]) + offset;
+		char *src = kmap_local_page(bprm->page[index]) + offset;
 		sp -= PAGE_SIZE - offset;
 		if (copy_to_user((void *) sp, src, PAGE_SIZE - offset) != 0)
 			ret = -EFAULT;
-		kunmap(bprm->page[index]);
+		kunmap_local(src);
 		if (ret)
 			goto out;
 	}
@@ -1680,13 +1680,13 @@ int remove_arg_zero(struct linux_binprm *bprm)
 			ret = -EFAULT;
 			goto out;
 		}
-		kaddr = kmap_atomic(page);
+		kaddr = kmap_local_page(page);
 
 		for (; offset < PAGE_SIZE && kaddr[offset];
 				offset++, bprm->p++)
 			;
 
-		kunmap_atomic(kaddr);
+		kunmap_local(kaddr);
 		put_arg_page(page);
 	} while (offset == PAGE_SIZE);
 
-- 
2.36.1


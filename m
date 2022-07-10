Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D20CD1104;
	Sun, 10 Jul 2022 10:01:45 +0000 (UTC)
Received: by mail-wr1-f45.google.com with SMTP id z12so3581895wrq.7;
        Sun, 10 Jul 2022 03:01:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=81hvwpBlfxQBH7APOHFnmGU6Oy26r79hMsY7b8ngUnA=;
        b=LaBR8No6eDA8e9Rql/Q8hpGkLLfuSD5/EMXQepcthh8cGp7UjbSFP1k9BsyzXUHnNy
         /Tpq4atRiIOMgSMJhXBMpDbldJ1g4b5k0jQCcLGn8jfGRoB7x/q/8CTNYecJfV/bu4Bo
         MERWiqyGTdkZFrXjwSPTS3Z7Yn+KmnzXcWrJiE8YusI2QP2MhVEHWCSDIj8F43mtTiYZ
         TEX0Th1RPImvZ0IVeKx1UMGztnYZGsQwur0HjBXDJzClOHfTYfzZhOg8rixDdLobrGug
         oZU4dhUGGW50vkkWM5cZ8x/txINWUWLWL80giRRZdFN9hqvwmfL00pFxL7khmpX45EwE
         onMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=81hvwpBlfxQBH7APOHFnmGU6Oy26r79hMsY7b8ngUnA=;
        b=aT4dH0nQHQ/YQqMV/yimR6oRj9g5/XpVlLD7sa9mjyuuGDPaZzmCfX2cJZgdC5bHi+
         DhYlLTjNUOBTw7hXFoToKoLbmWD1e0Atr841pAnez67e/nMP8Cv5jvQ0dIDQIdq3OGi1
         D6C2Yw07ZkfFxc3MQByvOnlG/6K+L8rGPBL+BHJDwn3WU52e9nYHI7gv3pbgIw7UlqFA
         wspgCXimZ4LdvXcBtDjAJLMKOtCWSjTmAovEgdY8/P6pi0stCbk+bze2ipUGmmK0QRWA
         KeXc/h+48OJ2UXTzvOiZY4Uign60LkhmEJ/Ra641zwUMdfCd1IkXwUQ3q46pjOuFApxf
         hhHg==
X-Gm-Message-State: AJIora/8PeYzobQ3vjAJgoIn9TM7XA6xtsyri6rzzJ7bNCRMqWtH3cig
	ySBU/mZTXyJtDt5Anm36mxo=
X-Google-Smtp-Source: AGRyM1t1D8hDiyos2lkhzHSCdCKBxQy3yBejjsdGsbA5T1lQgpocurWl0ACdlPHS4JNTO6vo74nRPw==
X-Received: by 2002:a05:6000:54f:b0:21b:944c:c70b with SMTP id b15-20020a056000054f00b0021b944cc70bmr12117283wrf.572.1657447303959;
        Sun, 10 Jul 2022 03:01:43 -0700 (PDT)
Received: from localhost.localdomain (host-95-235-102-55.retail.telecomitalia.it. [95.235.102.55])
        by smtp.gmail.com with ESMTPSA id r7-20020a05600c434700b003a2da6b2cbesm3502026wme.33.2022.07.10.03.01.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Jul 2022 03:01:42 -0700 (PDT)
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
Subject: [PATCH] fs: Call kmap_local_page() in copy_string_kernel()
Date: Sun, 10 Jul 2022 12:01:36 +0200
Message-Id: <20220710100136.25496-1-fmdefrancesco@gmail.com>
X-Mailer: git-send-email 2.36.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The use of kmap_atomic() is being deprecated in favor of kmap_local_page().

With kmap_local_page(), the mappings are per thread, CPU local, not
globally visible and can take page faults. Furthermore, the mappings can be
acquired from any context (including interrupts).

Therefore, use kmap_local_page() in copy_string_kernel() instead of
kmap_atomic().

Tested with xfstests on a QEMU + KVM 32-bits VM booting a kernel with
HIGHMEM64GB enabled.

Suggested-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>
---

I sent a first patch to fs/exec.c for converting kmap() and kmap_atomic()
to kmap_local_page():
https://lore.kernel.org/lkml/20220630163527.9776-1-fmdefrancesco@gmail.com/

Some days ago, Ira Weiny, while he was reviewing that patch, made me notice
that I had overlooked a second kmap_atomic() in the same file (thanks):
https://lore.kernel.org/lkml/YsiQptk19txHrG4c@iweiny-desk3/

I've been asked to send this as an additional change. This is why there will
not be any second version of that previous patch.

 fs/exec.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 4a2129c0d422..5fa652ca5823 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -639,11 +639,11 @@ int copy_string_kernel(const char *arg, struct linux_binprm *bprm)
 		page = get_arg_page(bprm, pos, 1);
 		if (!page)
 			return -E2BIG;
-		kaddr = kmap_atomic(page);
+		kaddr = kmap_local_page(page);
 		flush_arg_page(bprm, pos & PAGE_MASK, page);
 		memcpy(kaddr + offset_in_page(pos), arg, bytes_to_copy);
 		flush_dcache_page(page);
-		kunmap_atomic(kaddr);
+		kunmap_local(kaddr);
 		put_arg_page(page);
 	}
 
-- 
2.36.1


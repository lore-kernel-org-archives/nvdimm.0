Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81D182FA0C6;
	Sat, 19 Sep 2026 00:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789777642; cv=none; b=QY6Eq8z24s5XP5EZL7mEdpmkOGOUHWJWoXl9rfGlu2bSmS8kTSSglyYRSmLasRN8wvZqYAjruK/m20kXeT/E32AUNioJfxQNvQLNwbxS7jbdVwgf28dte0xd6FWuN5lfx2GR304rYRwE5Qy7KrbEPC11w60WtU5SRyZJp7srl2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789777642; c=relaxed/simple;
	bh=RrnZl1rRNO0P6CbEXl0y0T0bYtGLvcfjTXHiHq9pwKE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PQ7qddQHNhwxvFjEpFaxYdIai3uhbUyI6mQutajI8544aZuzomMAS++7vBhHPuzFCGW+Efyf1MQuRsh6pPGYi9SSOGE4+pbyJPZrh8oHO+S7zBH0inlOsmK1i1vWL12JV+41EGwlMvwejBJKLFFg870AOEcAm1cxD7vKdbc+W3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BIFLOLJ+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BIFLOLJ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE97C1F008A1;
	Sat, 19 Sep 2026 00:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789777634;
	bh=h9mGH20M5Bjep7ay96qxR5rLVMrKdFFEuXs8xVeKA0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BIFLOLJ+yGbuUWH1j4NGjLCY2l4Pz8cVfBn0MdZxF+zvbhZdbnFgogJc3KvZ8IZ4o
	 giuMAP8Q/7YZzrPkPt1jb4Nxheu/pEZYrJVZz0S9y35tOOwQKZzNszduVG9JHL/ZbD
	 S+fQvza+CY8yMKVpbpuJ5xsiAKzzqmUqtvhuY6WJj+pJUmrubbPnn7AYpy++v/yl4p
	 vG95NPKsZdNLCWPNXiLN3MUw/5CFXP4vFOiDMZUZrT1XWwoFbjDIarP1ABR5Kqd7+w
	 qZaIOs0rUI/p1th2D8Rxe/2P0TnG5dOJEIFZJfqgkz+6KpdzgnfAwjTr/CvdbqxINW
	 q7aiCoPx7N+Fw==
From: Kees Cook <kees@kernel.org>
To: Bill Wendling <morbo@google.com>
Cc: Kees Cook <kees@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	nvdimm@lists.linux.dev,
	Alison Schofield <alison.schofield@intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Ira Weiny <iweiny@kernel.org>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	nikitash.mariiaw@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: [PATCH v2 8/9] nvdimm: ndtest: Return the string length from flags_show()
Date: Fri, 18 Sep 2026 17:27:06 -0700
Message-Id: <20260919002714.4060307-8-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260919002658.stay.929-kees@kernel.org>
References: <20260919002658.stay.929-kees@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1505; i=kees@kernel.org; h=from:subject; bh=RrnZl1rRNO0P6CbEXl0y0T0bYtGLvcfjTXHiHq9pwKE=; b=owGbwMvMwCVmps19z/KJym7G02pJDFlrr93KXqEn1Scf3tN1J8qguX3iuqhfybvu/TJ3faBQu rswJa+io5SFQYyLQVZMkSXIzj3OxeNte7j7XEWYOaxMIEMYuDgFYCJJXAx/JSPvPpr8z/dhRISm nK2z4JV7etIPNzKbmBm8ytlX+XeJJMP/9Hofiemy+dYde5UONVl0C/AW67kvTp7tOOHY+g1M1kd 4AA==
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit

flags_show() build their output with a seq_buf and return seq_buf_used(),
which may include the trailing NUL byte when the seq_buf has
overflowed. Use seq_buf_strlen() instead.

The flag names are far shorter than the PAGE_SIZE buffer sysfs
provides, so this cannot overflow today.

Build tested ARCH=x86_64 with GCC 16.2.0, built out of tree with
make M=tools/testing/nvdimm:
tools/testing/nvdimm/test/ndtest.o

Assisted-by: LLM
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Kees Cook <kees@kernel.org>
---
Cc: <nvdimm@lists.linux.dev>
Cc: Alison Schofield <alison.schofield@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Guangshuo Li <lgs201920130244@gmail.com>
Cc: Ira Weiny <iweiny@kernel.org>
Cc: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Vishal Verma <vishal.l.verma@intel.com>
---
 tools/testing/nvdimm/test/ndtest.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/nvdimm/test/ndtest.c b/tools/testing/nvdimm/test/ndtest.c
index 2051ad5d4882..f097f2992966 100644
--- a/tools/testing/nvdimm/test/ndtest.c
+++ b/tools/testing/nvdimm/test/ndtest.c
@@ -693,7 +693,7 @@ static ssize_t flags_show(struct device *dev,
 	if (seq_buf_used(&s))
 		seq_buf_printf(&s, "\n");
 
-	return seq_buf_used(&s);
+	return seq_buf_strlen(&s);
 }
 static DEVICE_ATTR_RO(flags);
 
-- 
2.34.1

